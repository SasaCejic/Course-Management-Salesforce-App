public with sharing class CreatePersonController {

    public String recordType {get; set;}

    public Map<String, Object> fields {get; set;}

    public Set<String> keys {get; set;}


    public CreatePersonController() {
        
        this.recordType = System.currentPagereference().getParameters().get('recordType');

        this.fields = this.getFieldsByLayout(this.recordType);

        this.keys = this.fields.keySet();


    }

    public Map<String, Object> getFieldsByLayout(String recordTypeName){

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

    public PageReference save(){

        for(String key: this.fields.keySet()){
            if(((String)this.fields.get(key)).isNumeric()){
                this.fields.put(key, Integer.valueOf(this.fields.get(key)));
            }else{
                this.fields.put(key, String.valueOf(this.fields.get(key)));
            }

        }

        if(this.validateFields()){

            this.addPhoneNumberPrefix('+381 ');

            Person__c person  = this.insertPerson();

            if(person != null){
                return this.openRecordPage('/apex/vfPersonDetailView?id=' + person.Id);
            }
        }

        return null;
        
    }

    public void addPhoneNumberPrefix(String prefix){
        for(String key : this.fields.keySet()){
            if((key.equals('Phone__c') || key.equals('Work_Phone__c')) && String.isNotBlank(String.valueOf(this.fields.get(key)))){
                this.fields.put(key, prefix + this.fields.get(key));
            }
        }
    }

    public Boolean validateFields(){
        for(String key : this.fields.keySet()){

            switch on key {
                when 'First_Name__c', 'Last_Name__c' {		
                    if(this.isBlank(key)){
                        return false;
                    }
                }	
                when 'Email__c' {		
                    if(this.isBlank(key)){
                        return false;
                    }
                    if(!this.isValidEmail(String.valueOf(this.fields.get(key)))){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Field ' + key + ' is not a valid email value'));
                        return false;
                    }
                }when 'Years_of_Experience__c', 'Passing_Credit_Threshold__c', 'Passing_Score_Threshold__c'{

                    if(String.isBlank(String.valueOf(this.fields.get(key)))){
                        this.fields.put(key, null);
                    }else if(!(String.valueOf(this.fields.get(key))).isNumeric()){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Field ' + key + ' needs to be a number'));
                        return false;
                    }
                }
               
            }
        }
        return true;
    }

    public Boolean isValidEmail(String email){
        String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$';
    
        Pattern MyPattern = Pattern.compile(emailRegex);
	    Matcher MyMatcher = MyPattern.matcher(email);

        return (!MyMatcher.matches()) ? false : true;
    }

    public Boolean isBlank(String key){
        if(String.isBlank(String.valueOf((this.fields.get(key))))){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Field ' + key + ' is required.'));
            return true;
        }
        return false;
    }

    public Person__c insertPerson(){

        Person__c person = new Person__c();

        person.recordTypeId = PersonController.getRecordTypeIdByName(this.recordType);

        for(String key : this.fields.keySet()){

            String fieldName = key;
            person.put(fieldName, this.fields.get(key));

        }

        insert person;

        if(person.Id != null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM, 'Person has been created successfully'));
            return person;
        }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error inserting the person record!'));
            return null;
        }
    }

    public PageReference openRecordPage(String url){
        PageReference pr = new PageReference(url);

        pr.setRedirect(true);

        return pr;
    }
}