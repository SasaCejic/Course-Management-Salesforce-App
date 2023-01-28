@isTest
public with sharing class TestEmailService {

    @isTest
    static void sendEmail_ShouldSendEmailNotification_IfValidEmailAddressAndCourseNameProvided(){
        
        String address = 'cejicsasa17@gmail.com';
        List<String> courseNames = new List<String> {'My course without attendees'};
        
        Test.startTest();

        List<Messaging.SendEmailResult> results = EmailService.sendEmail(address, courseNames);

        Test.stopTest();

        System.assert(results[0] != null);
        System.assert(results[0].isSuccess());
    }

    @isTest
    static void sendEmail_ShouldNotSendEmail_IfInvalidEmailAddressProvided(){
        
        String address = 'invlaidemail';
        List<String> courseNames = new List<String> {'My course without attendees'};

        List<Messaging.SendEmailResult> results = new List<Messaging.SendEmailResult>();
        
        Test.startTest();

        try {
            results = EmailService.sendEmail(address, courseNames);
        } catch (System.EmailException ex) {
            System.assertEquals('SendEmail failed. First exception on row 0; first error: INVALID_EMAIL_ADDRESS, Email address is invalid: invlaidemail: [toAddresses, invlaidemail]', ex.getMessage());
        }

        Test.stopTest();

        System.assert(results.isEmpty());
    }
    
}