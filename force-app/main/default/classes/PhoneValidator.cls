public with sharing class PhoneValidator {

    @future (callout = true)
    public static void sendRequest(String personId, String personName, String phoneNumber, String validatedFieldName, String personCountry){


        String country = '';
        
        if(!String.isBlank(personCountry)){
            country = personCountry;
        }else if(!String.isBlank(Default_Country__mdt.getInstance('Default_Country_RS').Default_Country_Field__c)){
            country = Default_Country__mdt.getInstance('Default_Country_RS').Default_Country_Field__c;
        }

            Http http = new Http();
            HttpRequest request = new HttpRequest();


            String template = 'https://api.addressy.com/PhoneNumberValidation/Interactive/Validate/v2.20/json3.ws?Key={0}&Phone={1}&Country={2}';

            List<Object> parameters = new List<Object>{Number_Validation_API_Key__mdt.getInstance('Validation_Key').Key__c, phoneNumber, country};

            String endpointUrl = String.format(template, parameters);
        
            request.setEndpoint(endpointUrl);
            request.setMethod('GET');
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Accept','application/json');
            HttpResponse response = http.send(request);

            //create the Phone_Validation_Result__c object and populate appropriate fields;

            Phone_Validation_Result__c pvr = new Phone_Validation_Result__c(Name = personName + phoneNumber, Validated_Field_Name__c = validatedFieldName, Phone_Value__c = phoneNumber);
            pvr.Person__c = personId;

            if(response.getStatusCode() == 200){

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

              }else{

                 pvr.Wrong_Response_Code_Body__c = response.getBody();

            }

        //insert Phone Validation Result records

        Database.insert(pvr, false);

    }

}
