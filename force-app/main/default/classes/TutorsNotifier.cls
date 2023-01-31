public with sharing class TutorsNotifier {

    public static boolean called = false;
    
    public static List<Messaging.SendEmailResult> findAndNotify(){
        
        List<Course__c> coursesWithoutAttendees = [SELECT Tutor__r.Email__c, Name  FROM Course__c WHERE Attendees_Count__c = 0 ORDER BY Tutor__r.Email__c];


            Map<String,List<String>> courseNamesByTutorEmail = new Map<String,List<String>>();

            for(Course__c course : coursesWithoutAttendees){
                if(courseNamesByTutorEmail.containsKey(course.Tutor__r.Email__c)){
                    courseNamesByTutorEmail.get(course.Tutor__r.Email__c).add(course.Name);
                }else{
                    courseNamesByTutorEmail.put(course.Tutor__r.Email__c, new List<String>{course.Name});
                }
            }

            List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();

            for(String key : courseNamesByTutorEmail.keySet()){

                emailList.add(EmailService.createSingleEmailMessage(key, courseNamesByTutorEmail.get(key)));
                
            }

            called = true;

            return Messaging.sendEmail(emailList);

    }
}