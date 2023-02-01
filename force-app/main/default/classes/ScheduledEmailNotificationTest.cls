@isTest
public with sharing class ScheduledEmailNotificationTest {
    
    @isTest
    static void execute_ShouldExecuteTheScheduledEMailNotification_IfCalled(){

        Test.startTest();

        ScheduledEmailNotification sn = new ScheduledEmailNotification();

        sn.execute(null);

        System.assert(TutorsNotifier.called);

        Test.stopTest();
        

    }

}