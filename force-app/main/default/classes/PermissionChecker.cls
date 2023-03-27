public with sharing class PermissionChecker {
    @AuraEnabled(cacheable = true)
    public static Boolean hasPermission(String permission){
        return String.isNotBlank(permission) ? FeatureManagement.checkPermission(permission) : false;
    }
}