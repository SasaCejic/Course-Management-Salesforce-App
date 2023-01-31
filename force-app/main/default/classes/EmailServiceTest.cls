@isTest
public with sharing class EmailServiceTest {

    @isTest
    static void createSingleEmailMessage_ShouldCreateSingleEmailMessage_IfEmailAndCoursesProvided(){
        
        String address = 'cejicsasa17@gmail.com';
        List<String> courseNames = new List<String> {'Course 1', 'Course 2'};
        
        Test.startTest();

        Messaging.SingleEmailMessage result = EmailService.createSingleEmailMessage(address, courseNames);

        Test.stopTest();

        System.assertEquals('Hello. Here are your courses that have no attendees yet: \n\nCourse 1\n\nCourse 2\n\n', result.getPlainTextBody());
        System.assertEquals(address, result.getToAddresses()[0]);
    }

    
}