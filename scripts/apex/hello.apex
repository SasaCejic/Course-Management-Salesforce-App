// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

Map<String, Schema.SObjectType> detail = Schema.getGlobalDescribe();
for(Schema.SObjectField fields :detail.get('Person__c').getDescribe().fields.getMap().Values()) {
    if(String.valueOf(fields.getDescribe().getType()).equals('PHONE')){
        System.debug('Field:  '+ fields.getDescribe().getName());
    }
}