@isTest
public with sharing class PhoneFieldNamesPicklistTest {

    @isTest
    static void getDefaultValue_shouldReturnPhoneValueDataRow(){
        Test.startTest();
        PhoneFieldNamesPicklist picklist = new PhoneFieldNamesPicklist();
        VisualEditor.DataRow actual = picklist.getDefaultValue();
        Test.stopTest();

        VisualEditor.DataRow expected = new VisualEditor.DataRow('Phone__c', 'Phone__c');

        System.assertEquals(expected.getLabel(), actual.getLabel());
        System.assertEquals(expected.getValue(), actual.getValue());
    }

    @isTest
    static void getValues_shouldReturnPicklistWithAllPhoneFieldNamesFromPerson(){
        Test.startTest();
        PhoneFieldNamesPicklist picklist = new PhoneFieldNamesPicklist();
        VisualEditor.DynamicPickListRows actual = picklist.getValues();
        Test.stopTest();

        VisualEditor.DynamicPickListRows  expected = new VisualEditor.DynamicPickListRows();
        for(Schema.SObjectField field :Schema.getGlobalDescribe().get('Person__c').getDescribe().fields.getMap().Values()) {
            if(String.valueOf(field.getDescribe().getType()).equals('PHONE')){
                expected.addRow(new VisualEditor.DataRow(field.getDescribe().getName(), field.getDescribe().getName()));
            }
        }

        System.assertEquals(expected.size(), actual.size());
    }
}