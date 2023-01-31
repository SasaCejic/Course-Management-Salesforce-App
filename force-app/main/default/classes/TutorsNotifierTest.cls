@isTest
public with sharing class TutorsNotifierTest {

    @TestSetup
    static void deleteEmptyCourses(){
        List<Course__c> coursesWithoutAttendees = [SELECT ID FROM Course__c WHERE Attendees_Count__c = 0];

        if(!coursesWithoutAttendees.isEmpty()){
            delete coursesWithoutAttendees;
        }
    }
    
    
   @isTest
   static void findAndNotify_ShouldSendAnEmail_IfThereIsTutorThatHasOneCourseWithoutAttendees(){

    Test.startTest();

    Person__c person = new Person__c(Name = 'FirstName LastName', First_Name__c = 'FirstName', Last_Name__c = 'LastName', Email__c = 'cejicsasa17@gmail.com');
    insert person;
    Course__c course = new Course__c(Name = 'Course Name', Name__c = 'Course Name', Tutor__c = person.Id, Attendees_Quota__c = 10, Credit__c = 50, Description__c = 'My course description', Start_Date__c = System.today() + 1, End_Date__c = System.today() + 10);
    insert course;

    List<Messaging.SendEmailResult> results = TutorsNotifier.findAndNotify();

    Test.stopTest();

    System.assertEquals(1, results.size());
    System.assert(results[0].isSuccess());

   }

   @isTest
   static void findAndNotify_ShouldSendAnEmail_IfThereIsTutorThatHasMoreThanOneCoursesWithoutAttendees(){

    Test.startTest();

    Person__c person = new Person__c(Name = 'FirstName LastName', First_Name__c = 'FirstName', Last_Name__c = 'LastName', Email__c = 'cejicsasa17@gmail.com');
    insert person;
    Course__c course1 = new Course__c(Name = 'Course 1 Name', Name__c = 'Course 1 Name', Tutor__c = person.Id, Attendees_Quota__c = 10, Credit__c = 50, Description__c = 'My course description', Start_Date__c = System.today() + 1, End_Date__c = System.today() + 10);
    insert course1;

    Course__c course2 = new Course__c(Name = 'Course 2 Name', Name__c = 'Course 2 Name', Tutor__c = person.Id, Attendees_Quota__c = 10, Credit__c = 50, Description__c = 'My course description', Start_Date__c = System.today() + 1, End_Date__c = System.today() + 10);
    insert course2;

    List<Messaging.SendEmailResult> results = TutorsNotifier.findAndNotify();

    Test.stopTest();

    System.assertEquals(1, results.size());
    System.assert(results[0].isSuccess());

   }

   @isTest
   static void findAndNotify_ShouldSend5Emails_IfThereAre5TutorsWithEmptyCourses(){

    Test.startTest();

    List<String> emails = new List<String>{'email1@gmail.com', 'email2@gmail.com', 'email3@gmail.com', 'email4@gmail.com', 'email5@gmail.com'};
    List<Person__c> persons = new List<Person__c>();

    for(String email : emails){
        persons.add(new Person__c(Name = 'FirstName LastName', First_Name__c = 'FirstName', Last_Name__c = 'LastName', Email__c = email));
    }

    insert persons;

    List<Person__c> personIds = [SELECT ID FROM Person__c WHERE Name = 'FirstName LastName'];
    List<Course__c> courses = new List<Course__c>();

    for(Person__c p : personIds){
        courses.add(new Course__c(Name = 'Course Name', Name__c = 'Course Name', Tutor__c = p.Id, Attendees_Quota__c = 10, Credit__c = 50, Description__c = 'My course description', Start_Date__c = System.today() + 1, End_Date__c = System.today() + 10));
    }
    insert courses;

    List<Messaging.SendEmailResult> results = TutorsNotifier.findAndNotify();

    Test.stopTest();

    System.assertEquals(5, results.size());

   }

   @isTest
   static void findAndNotify_ShouldNotSendAnEmail_IfThereIsNoTutorThatHasCoursesWithoutAttendees(){

    Test.startTest();

    List<Messaging.SendEmailResult> results = TutorsNotifier.findAndNotify();

    Test.stopTest();

    System.assert(results.isEmpty());

   }


}