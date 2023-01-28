@isTest
public with sharing class TestTutorsNotifier {
    
    
   @isTest
   static void findAndNotify_ShouldReturnTrue_IfThereIsTutorThatHasOneCourseWithoutAttendees(){

    Test.startTest();

    Person__c person = new Person__c(Name = 'FirstName LastName', First_Name__c = 'FirstName', Last_Name__c = 'LastName', Email__c = 'cejicsasa17@gmail.com');
    insert person;
    Course__c course = new Course__c(Name = 'Course Name', Name__c = 'Course Name', Tutor__c = person.Id, Attendees_Quota__c = 10, Credit__c = 50, Description__c = 'My course description', Start_Date__c = System.today() + 1, End_Date__c = System.today() + 10);
    insert course;

    boolean result = TutorsNotifier.findAndNotify();

    Test.stopTest();

    System.assert(result);

   }

   @isTest
   static void findAndNotify_ShouldReturnTrue_IfThereIsTutorThatHasMoreThanOneCoursesWithoutAttendees(){

    Test.startTest();

    Person__c person = new Person__c(Name = 'FirstName LastName', First_Name__c = 'FirstName', Last_Name__c = 'LastName', Email__c = 'cejicsasa17@gmail.com');
    insert person;
    Course__c course1 = new Course__c(Name = 'Course 1 Name', Name__c = 'Course 1 Name', Tutor__c = person.Id, Attendees_Quota__c = 10, Credit__c = 50, Description__c = 'My course description', Start_Date__c = System.today() + 1, End_Date__c = System.today() + 10);
    insert course1;

    Course__c course2 = new Course__c(Name = 'Course 2 Name', Name__c = 'Course 2 Name', Tutor__c = person.Id, Attendees_Quota__c = 10, Credit__c = 50, Description__c = 'My course description', Start_Date__c = System.today() + 1, End_Date__c = System.today() + 10);
    insert course2;

    boolean result = TutorsNotifier.findAndNotify();

    Test.stopTest();

    System.assert(result);

   }

   @isTest
   static void findAndNotify_ShouldReturnFalse_IfThereIsNoTutorThatHasCoursesWithoutAttendees(){

    List<Course__c> coursesWithoutAttendees = [SELECT Id  FROM Course__c WHERE Attendees_Count__c = 0 ORDER BY Tutor__r.Email__c];

    Test.startTest();

    if(!coursesWithoutAttendees.isEmpty()){
        delete coursesWithoutAttendees;
    }

    boolean result = TutorsNotifier.findAndNotify();

    Test.stopTest();

    System.assert(!result);

   }


}