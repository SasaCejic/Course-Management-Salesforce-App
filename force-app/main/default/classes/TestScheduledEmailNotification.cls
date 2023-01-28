@isTest
public with sharing class TestScheduledEmailNotification {
    
    @isTest
    static void schedule_ShouldScheduleTheRun_IfCalled(){

        Test.startTest();

        ScheduledEmailNotification sn = new ScheduledEmailNotification();

        String chron = '0 0 0 3 9 ? 2042';
        String jobId = system.schedule('Test Sched', chron, sn);

        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
         NextFireTime
         FROM CronTrigger WHERE id = :jobId];

         System.assertEquals(chron, 
         ct.CronExpression);
         System.assertEquals(0, ct.TimesTriggered);

         System.assertEquals('2042-09-03 00:00:00', 
         String.valueOf(ct.NextFireTime));

        Test.stopTest();
        

    }

}