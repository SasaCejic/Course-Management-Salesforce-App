public with sharing class PersonHelper {

    public static Map<String, Object> initializeFields(String recordId){

            Map<String, Object> fields = new Map<String, Object>();
    
            String recordTypeName = [SELECT RecordType.Name FROM Person__c WHERE Id = :recordId LIMIT 1].RecordType.Name;
    
            fields = PersonHelper.getFieldsByLayout(recordTypeName);

            return fields;
    
    }

    public static Map<String, Object> populateFieldValues(Map<String, Object> fields, Person__c person){
        
        for(String key : fields.keySet()){
    
            if(person.get(key) != null){
                fields.put(key, person.get(key));
            }

        }
        return fields;
    }

    public static Person__c initializePerson(Map<String, Object> fields, String recordId){

        Person__c person = new Person__c();

        String fieldsToRetrieve = 'Name, ';
    
        Integer counter = 1;
    
        for(String key : fields.keySet()){
            fieldsToRetrieve += key;
    
            if(counter < fields.keySet().size()){
                fieldsToRetrieve += ', ';
            }
    
            counter++;
        }
    
        String query = 'SELECT ' + fieldsToRetrieve + ' FROM Person__c WHERE Id = :recordId LIMIT 1';
    
        person = Database.query(query);
    
        return person;
    }

    public static Map<String, Object> getFieldsByLayout(String recordTypeName){

        String layoutName = (recordTypeName == 'Student') ? 'Person__c-Student Layout' : 'Person__c-Tutor Layout';
        
        Map<String, Object> fields = new Map<String, Object>();

        List<Metadata.Metadata> layouts = 
        Metadata.Operations.retrieve(Metadata.MetadataType.Layout, 
                                 new List<String> {layoutName});

        Metadata.Layout layoutMd = (Metadata.Layout)layouts.get(0);
        for (Metadata.LayoutSection section : layoutMd.layoutSections) {
            for (Metadata.LayoutColumn column : section.layoutColumns) {
                if (column.layoutItems != null) {
                    for (Metadata.LayoutItem item : column.layoutItems) {
                        if(!(item.field.equals('Name') 
                            || item.field.equals('RecordTypeId')
                            || item.field.equals('OwnerId') || item.field.equals('CreatedById') || item.field.equals('LastModifiedById')
                            || item.field.equals('Outstanding_Credits__c') || item.field.equals('Outstanding_Score__c')
                            || item.field.equals('All_Time_Course_Count__c') || item.field.equals('Course_Credits__c')
                            || item.field.equals('Assignment_Score__c'))){

                                if(item.field.equals('Passing_Credit_Threshold__c')){

                                    fields.put(item.field, String.valueOf(Integer.valueOf(Threshold__mdt.getInstance('Threshold_Record').Credit_Threshold__c)));

                                }else if(item.field.equals('Passing_Score_Threshold__c')){

                                    fields.put(item.field, String.valueOf(Integer.valueOf(Threshold__mdt.getInstance('Threshold_Record').Score_Threshold__c)));
                                }else{
                                    fields.put(item.field, '');
                                }

                            }
                        
                    }
                }
            }
        }

        return fields;

    }

    public static Map<String, Object> setFieldTypes(Map<String, Object> fields){

        for(String key: fields.keySet()){
            if(((String)fields.get(key)).isNumeric()){
                fields.put(key, Integer.valueOf(fields.get(key)));
            }else{
                fields.put(key, String.valueOf(fields.get(key)));
            }

        }

        return fields;

    }

    public static PageReference redirect(String url){
        PageReference pr = new PageReference(url);

        pr.setRedirect(true);

        return pr;
    }

    public static ApexPages.message validateFields(Map<String, Object> fields){
        for(String key : fields.keySet()){

            switch on key {
                when 'First_Name__c', 'Last_Name__c' {		
                    if(String.isBlank(String.valueOf(fields.get(key)))){
                        return new ApexPages.message(ApexPages.severity.ERROR,'Field ' + key + ' is required.');
                    }
                }	
                when 'Email__c' {		
                    if(String.isBlank(String.valueOf(fields.get(key)))){
                        return new ApexPages.message(ApexPages.severity.ERROR,'Field ' + key + ' is required.');
                    }
                    if(!PersonHelper.isValidEmail(String.valueOf(fields.get(key)))){
                        return new ApexPages.message(ApexPages.severity.ERROR,'Field ' + key + ' is not a valid email value');
                    }
                }when 'Years_of_Experience__c', 'Passing_Credit_Threshold__c', 'Passing_Score_Threshold__c'{

                    if(String.isBlank(String.valueOf(fields.get(key)))){
                        fields.put(key, null);
                    }else if(!(String.valueOf(fields.get(key))).isNumeric()){
                        return new ApexPages.message(ApexPages.severity.ERROR,'Field ' + key + ' needs to be a number');
                    }
                }
               
            }
        }
        return null;
    }

    public static Boolean isValidEmail(String email){
        String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$';
    
        Pattern MyPattern = Pattern.compile(emailRegex);
	    Matcher MyMatcher = MyPattern.matcher(email);

        return (!MyMatcher.matches()) ? false : true;
    }

    public static Map<String, Object> addPhoneNumberPrefix(String prefix, Map<String, Object> fields, Person__c person){
        for(String key : fields.keySet()){
            if((key.equals('Phone__c') || key.equals('Work_Phone__c')) && String.isNotBlank(String.valueOf(fields.get(key))) && String.isBlank(String.valueOf(person.get(key)))){
                fields.put(key, prefix + fields.get(key));
            }
        }

        return fields;
    }

    public static Map<String, Object> addPhoneNumberPrefix(String prefix, Map<String, Object> fields){
        for(String key : fields.keySet()){
            if((key.equals('Phone__c') || key.equals('Work_Phone__c')) && String.isNotBlank(String.valueOf(fields.get(key)))){
                fields.put(key, prefix + fields.get(key));
            }
        }

        return fields;
    }

    public static ApexPages.Message updatePerson(Map<String, Object> fields, Person__c person){

        for(String key : fields.keySet()){

            person.put(key, fields.get(key));

        }

        try{
            update person;
        }catch(Exception e){
            return new ApexPages.message(ApexPages.severity.ERROR,e.getMessage());
        }

        return null;
    }

    public static Person__c insertPerson(Map<String, Object> fields, String recordType){

        Person__c person = new Person__c();

        person.recordTypeId = PersonController.getRecordTypeIdByName(recordType);

        for(String key : fields.keySet()){

            String fieldName = key;
            person.put(fieldName, fields.get(key));

        }

        try{
            insert person;
        }catch(Exception e){
            return null;
        }

        return person;
    }

    public static ApexPages.Message deletePerson(Person__c person){

        try{
            delete person;
        }catch(Exception e){
            return new ApexPages.message(ApexPages.severity.ERROR,e.getMessage());
        }

        return null;
    }


}