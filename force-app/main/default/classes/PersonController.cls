public with sharing class PersonController {
    @AuraEnabled(cacheable = true)
    public static List<Person__c> getPersons(){
        
        return [
            SELECT Name, Record_Type_Name__c, Phone__c, Email__c
            FROM Person__c
            WITH SECURITY_ENFORCED
            ORDER BY Name
        ];

    }

    @AuraEnabled(cacheable = true)
    public static List<String> getFieldsFromStudentLayout(){

        List<String> fields = new List<String>();

        List<Metadata.Metadata> layouts = 
        Metadata.Operations.retrieve(Metadata.MetadataType.Layout, 
                                 new List<String> {'Person__c-Student Layout'});

        Metadata.Layout layoutMd = (Metadata.Layout)layouts.get(0);
        for (Metadata.LayoutSection section : layoutMd.layoutSections) {
            for (Metadata.LayoutColumn column : section.layoutColumns) {
                if (column.layoutItems != null) {
                    for (Metadata.LayoutItem item : column.layoutItems) {
                        if(!(item.field.equals('Name') || item.field.equals('Outstanding_Credits__c') || item.field.equals('Outstanding_Score__c')
                        || item.field.equals('RecordTypeId') || item.field.equals('All_Time_Course_Count__c')
                            || item.field.equals('OwnerId') || item.field.equals('CreatedById') || item.field.equals('LastModifiedById')
                            || item.field.equals('Course_Credits__c') || item.field.equals('Assignment_Score__c'))){
                                fields.add(item.field);
                            }
                                
                    }
                }
            }
        }

        return fields;

    }

    @AuraEnabled(cacheable = true)
    public static List<String> getFieldsFromTutorLayout(){

        List<String> fields = new List<String>();

        List<Metadata.Metadata> layouts = 
        Metadata.Operations.retrieve(Metadata.MetadataType.Layout, 
                                 new List<String> {'Person__c-Tutor Layout'});

        Metadata.Layout layoutMd = (Metadata.Layout)layouts.get(0);
        for (Metadata.LayoutSection section : layoutMd.layoutSections) {
            for (Metadata.LayoutColumn column : section.layoutColumns) {
                if (column.layoutItems != null) {
                    for (Metadata.LayoutItem item : column.layoutItems) {
                        if(!(item.field.equals('Name') 
                            || item.field.equals('RecordTypeId')
                            || item.field.equals('OwnerId') || item.field.equals('CreatedById') || item.field.equals('LastModifiedById'))){
                                fields.add(item.field);
                            }
                        
                    }
                }
            }
        }

        return fields;

    }

    @AuraEnabled(cacheable = true)
    public static String getStudentRecordTypeId(){
        return Schema.SObjectType.Person__c.getRecordTypeInfosByName().get('Student').getRecordTypeId();
    }

    @AuraEnabled(cacheable = true)
    public static String getTutorRecordTypeId(){
        return Schema.SObjectType.Person__c.getRecordTypeInfosByName().get('Tutor').getRecordTypeId();
    }



}