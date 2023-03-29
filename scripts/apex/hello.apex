// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

// Boolean hasPermission = FeatureManagement.checkPermission('Access_Phone_Validation_Component');
// System.debug(hasPermission);

PermissionSet ps = [SELECT Id, Name FROM PermissionSet WHERE Name = 'Access_Phone_Validation_Component_PS' LIMIT 1];

// system.debug(ps.Id);

PermissionSetAssignment psa = [SELECT Id FROM PermissionSetAssignment WHERE PermissionSetId = :ps.Id AND AssigneeId = :UserInfo.getUserId() LIMIT 1];
system.debug(psa.Id);
