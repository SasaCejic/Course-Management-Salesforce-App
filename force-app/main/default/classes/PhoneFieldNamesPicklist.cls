global class PhoneFieldNamesPicklist extends VisualEditor.DynamicPickList{

    global override VisualEditor.DataRow getDefaultValue(){
        VisualEditor.DataRow defaultValue = new VisualEditor.DataRow('Phone__c', 'Phone__c');
        return defaultValue;
    }

    global override VisualEditor.DynamicPickListRows getValues() {
        Map<String, Schema.SObjectType> detail = Schema.getGlobalDescribe();
        VisualEditor.DynamicPickListRows  picklistValues = new VisualEditor.DynamicPickListRows();

        for(Schema.SObjectField field :detail.get('Person__c').getDescribe().fields.getMap().Values()) {
            if(String.valueOf(field.getDescribe().getType()).equals('PHONE')){
                picklistValues.addRow(new VisualEditor.DataRow(field.getDescribe().getName(), field.getDescribe().getName()));
            }
        }
        return picklistValues;
    }
}