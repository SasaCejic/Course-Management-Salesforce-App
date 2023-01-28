public with sharing class TutorsNotifier {
    
    public static boolean findAndNotify(){
        
        List<Course__c> coursesWithoutAttendees = [SELECT Tutor__r.Email__c, Name  FROM Course__c WHERE Attendees_Count__c = 0 ORDER BY Tutor__r.Email__c];

        if(!coursesWithoutAttendees.isEmpty()){

            Map<String,List<String>> emailsWithCourses = new Map<String,List<String>>();

            for(Course__c course : coursesWithoutAttendees){
                if(emailsWithCourses.containsKey(course.Tutor__r.Email__c)){
                    emailsWithCourses.get(course.Tutor__r.Email__c).add(course.Name);
                }else{
                    emailsWithCourses.put(course.Tutor__r.Email__c, new List<String>{course.Name});
                }
            }

            for(String key : emailsWithCourses.keySet()){

                EmailService.sendEmail(key, emailsWithCourses.get(key));
                
            }

            return true;
        }

        return false;
    }
}