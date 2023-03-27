@isTest
public with sharing class PermissionCheckerTest {
    @isTest
    static void hasPermission_shouldReturnTrue_ifCurrentUserHasPermission(){
        PermissionSet ps = [SELECT Id, Name FROM PermissionSet WHERE Name = 'Access_Phone_Validation_Component_PS' LIMIT 1];
        Id currentUserId = UserInfo.getUserId();
        PermissionSetAssignment psa = [SELECT Id FROM PermissionSetAssignment WHERE PermissionSetId = :ps.Id AND AssigneeId = :currentUserId LIMIT 1];
        if(psa == null){
            psa = new PermissionSetAssignment(PermissionSetId = ps.Id, AssigneeId = currentUserId);
            insert psa; 
        }

        Test.startTest();
        Boolean actual = PermissionChecker.hasPermission('Access_Phone_Validation_Component');
        Test.stopTest();

        System.assertEquals(true, actual);
    }

    @isTest
    static void hasPermission_shouldReturnFalse_ifCurrentUserDoesntHavePermission(){

        PermissionSet permSet = new PermissionSet(Label='My Permission Set',Name='MyPermissionSet');
        insert permSet;

        Test.startTest();
        Boolean actual = PermissionChecker.hasPermission('MyPermissionSet');
        Test.stopTest();

        System.assertEquals(false, actual);
    }

    @isTest
    static void hasPermission_shouldReturnFalse_ifBlankParameterPassed(){
        Test.startTest();
        Boolean actual = PermissionChecker.hasPermission('');
        Test.stopTest();

        System.assertEquals(false, actual);
    }

    @isTest
    static void hasPermission_shouldReturnFalse_ifNonExistentPermissionSetNamePassed(){
        Test.startTest();
        Boolean actual = PermissionChecker.hasPermission('Non_Existent_Permission_Set');
        Test.stopTest();

        System.assertEquals(false, actual);
    }
}