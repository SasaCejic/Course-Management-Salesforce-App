public with sharing class PhoneValidator {

    @future (callout = true)
    public static void sendRequest(String personId){

        List<Person__c> persons = new List<Person__c>();

        if (Schema.sObjectType.Person__c.isAccessible()){
            persons = [SELECT Id, Name, Phone__c FROM Person__c WHERE Id = :personId];
        }


        if(!persons.isEmpty()){
            Person__c p = persons[0];

            Http http = new Http();
            HttpRequest request = new HttpRequest();

            String endpointUrl = p.Phone__c != null ? 'https://api.addressy.com/PhoneNumberValidation/Interactive/Validate/v2.20/json3.ws?Key=' + Number_Validation_API_Key__mdt.getInstance('Validation_Key').Key__c + '&Phone=' + p.Phone__c : 'https://api.addressy.com/PhoneNumberValidation/Interactive/Validate/v2.20/json3.ws?Key=' + Number_Validation_API_Key__mdt.getInstance('Validation_Key').Key__c;
        

            request.setEndpoint(endpointUrl);
            request.setMethod('GET');
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Accept','application/json');
            HttpResponse response = http.send(request);


            if(response.getStatusCode() == 200 && response != null){
                
                //create the Phone_Validation_Result__c object and populate appropriate fields;

                Phone_Validation_Result__c pvr = new Phone_Validation_Result__c(Name = p.Name + p.Phone__c, Validated_Field_Name__c = 'Phone__c', Phone_Value__c = p.Phone__c);
                pvr.Person__c = p.Id;

                JSON2Apex obj = JSON2Apex.parse(response.getBody());    

                if(obj.items[0].error != null){
                    //Populate Phone Validation Result with error related fields
                    pvr.ErrorId__c = obj.items[0].error;
                    pvr.Error_Description__c = obj.items[0].description;
                    pvr.Error_Cause__c = obj.items[0].cause;
                    pvr.Error_Resolution__c = obj.items[0].resolution;

                }else if(obj.items[0].phoneNumber != null){
                    //Populate Phone Validation Result with successfull call related fields
                    pvr.Phone_Number__c = obj.items[0].phoneNumber;
                    pvr.Request_Processed__c = obj.items[0].requestProcessed;
                    pvr.Is_Valid__c = obj.items[0].isValid;
                    pvr.Network_Code__c = obj.items[0].networkCode;
                    pvr.Network_Name__c = obj.items[0].networkName;
                    pvr.Network_Country__c = obj.items[0].networkCountry;
                    pvr.National_Format__c = obj.items[0].nationalFormat;
                    pvr.Country_Prefix__c = obj.items[0].countryPrefix;
                    pvr.Number_Type__c = obj.items[0].numberType;

                }

                //insert Phone Validation Result record

                if(Schema.sObjectType.Phone_Validation_Result__c.isCreateable()){
                    Database.insert(pvr, false);
                }

            }

            
   
        }
        
    }

}
