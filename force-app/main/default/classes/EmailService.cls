public with sharing class EmailService {
    
    public static Messaging.SingleEmailMessage createSingleEmailMessage(String address, List<String> courseNames){
        
        List<String> addresses = new List<String>{address};
            
       	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setSubject('Your Courses Without Attendees');

        String body = 'Hello. Here are your courses that have no attendees yet: \n\n';

        for(String courseName : courseNames){
            body += courseName + '\n\n';
        }
        

        mail.setplaintextbody(body);
        mail.setToAddresses(addresses);
        
        return mail;   

    }
}