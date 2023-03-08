@isTest
public with sharing class PersonControllerTest {
    
   @isTest
   static void searchPersons_shouldReturnAnEmptyLIst_ifNoRecordsAreInsertedAndSearchTermIsBlank(){

        Test.startTest();

        List<Person__c> persons = PersonController.searchPersons('', 0, null);

        Test.stopTest();

        System.assertEquals(0, persons.size());

   }

   @isTest
   static void searchPersons_shouldReturnAllPersons_ifThreeRecordsAreInsertedAndSearchTermIsBlank(){

        Person__c person1 = new Person__c(Name = 'FirstName1 LastName1', First_Name__c = 'FirstName1', Last_Name__c = 'LastName1', Email__c = 'cejicsasa17@gmail.com');
        Person__c person2 = new Person__c(Name = 'FirstName2 LastName2', First_Name__c = 'FirstName2', Last_Name__c = 'LastName2', Email__c = 'cejicsasa17@gmail.com');
        Person__c person3 = new Person__c(Name = 'FirstName3 LastName3', First_Name__c = 'FirstName3', Last_Name__c = 'LastName3', Email__c = 'cejicsasa17@gmail.com');

        List<Person__c> createdPersons = new List<Person__c>();

        createdPersons.add(person1);
        createdPersons.add(person2);
        createdPersons.add(person3);

        Test.startTest();

        insert createdPersons;

        List<Person__c> persons = PersonController.searchPersons('', 0, null);

        Test.stopTest();


        System.assertEquals(3, persons.size());



        List<String> personIds  = new List<String>();


        for(Person__c p : persons){
          personIds.add(p.Id);
        }

        system.assert(personIds.contains(person1.Id));
        system.assert(personIds.contains(person2.Id));
        system.assert(personIds.contains(person3.Id));


   }

   @isTest
   static void searchPersons_shouldReturnOneRecord_ifOneRecordNameMatchesSearchParameters(){

        Person__c person1 = new Person__c(Name = 'Smith Manison', First_Name__c = 'Smith', Last_Name__c = 'Manison', Email__c = 'sth@gmail.com');
        Person__c person2 = new Person__c(Name = 'Mike Hopkins', First_Name__c = 'Mike', Last_Name__c = 'Hopkins', Email__c = 'hpkns@gmail.com');
        Person__c person3 = new Person__c(Name = 'Steve Owen', First_Name__c = 'Steve', Last_Name__c = 'Owen', Email__c = 'stow@gmail.com');

        List<Person__c> createdPersons = new List<Person__c>();

        createdPersons.add(person1);
        createdPersons.add(person2);
        createdPersons.add(person3);

        Test.startTest();

        insert createdPersons;

        List<Person__c> persons = PersonController.searchPersons('Smith Manison', 0, null);

        Test.stopTest();

        System.assertEquals(1, persons.size());

        System.assert(persons[0].Id == person1.Id);

   }

   @isTest
   static void searchPersons_shouldReturnOneRecord_ifOneRecordPhoneMatchesSearchParameters(){
        PersonTriggerHelper.called = true;
        Person__c person1 = new Person__c(Name = 'Smith Manison', First_Name__c = 'Smith', Last_Name__c = 'Manison', Email__c = 'sth@gmail.com', Phone__c = '+381 635472');
        Person__c person2 = new Person__c(Name = 'Mike Hopkins', First_Name__c = 'Mike', Last_Name__c = 'Hopkins', Email__c = 'hpkns@gmail.com', Phone__c = '+382 908837');
        Person__c person3 = new Person__c(Name = 'Steve Owen', First_Name__c = 'Steve', Last_Name__c = 'Owen', Email__c = 'stow@gmail.com', Phone__c = '+352 116253');

        List<Person__c> createdPersons = new List<Person__c>();

        createdPersons.add(person1);
        createdPersons.add(person2);
        createdPersons.add(person3);

        Test.startTest();

        insert createdPersons;

        List<Person__c> persons = PersonController.searchPersons('+382 908837', 0, null);

        Test.stopTest();

        System.assertEquals(1, persons.size());

        System.assert(persons[0].Id == person2.Id);

   }

   @isTest
   static void searchPersons_shouldReturnOneRecord_ifOneRecordEmailMatchesSearchParameters(){

        Person__c person1 = new Person__c(Name = 'Smith Manison', First_Name__c = 'Smith', Last_Name__c = 'Manison', Email__c = 'sth@gmail.com');
        Person__c person2 = new Person__c(Name = 'Mike Hopkins', First_Name__c = 'Mike', Last_Name__c = 'Hopkins', Email__c = 'hpkns@gmail.com');
        Person__c person3 = new Person__c(Name = 'Steve Owen', First_Name__c = 'Steve', Last_Name__c = 'Owen', Email__c = 'stow@gmail.com');

        List<Person__c> createdPersons = new List<Person__c>();

        createdPersons.add(person1);
        createdPersons.add(person2);
        createdPersons.add(person3);

        Test.startTest();

        insert createdPersons;

        List<Person__c> persons = PersonController.searchPersons('stow@gmail.com', 0, null);

        Test.stopTest();

        System.assertEquals(1, persons.size());

        System.assert(persons[0].Id == person3.Id);


   }


   @isTest
   static void searchPersons_shouldReturnTwoRecords_ifThreeRecordEmailsMatchSearchParametersAndOffsetNumberIsOne(){

        Person__c person1 = new Person__c(Name = 'Smith Manison', First_Name__c = 'Smith', Last_Name__c = 'Manison', Email__c = 'sth@gmail.com');
        Person__c person2 = new Person__c(Name = 'Mike Hopkins', First_Name__c = 'Mike', Last_Name__c = 'Hopkins', Email__c = 'hpkns@gmail.com');
        Person__c person3 = new Person__c(Name = 'Steve Owen', First_Name__c = 'Steve', Last_Name__c = 'Owen', Email__c = 'stow@gmail.com');

        List<Person__c> createdPersons = new List<Person__c>();

        createdPersons.add(person1);
        createdPersons.add(person2);
        createdPersons.add(person3);
        createdPersons.sort();

        Test.startTest();

        insert createdPersons;

        List<Person__c> persons = PersonController.searchPersons('gmail', 1, 10);

        Test.stopTest();

        System.assertEquals(2, persons.size());

        List<String> personIds  = new List<String>();

        for(Person__c p : persons){
          personIds.add(p.Id);
        }
        system.assert(personIds.contains(createdPersons[1].Id));
        system.assert(personIds.contains(createdPersons[2].Id));


   }

   @isTest
   static void searchPersons_shouldReturnTwoRecords_ifThreeRecordEmailsMatchSearchParametersAndLimitValueIsTwo(){

        Person__c person1 = new Person__c(Name = 'Smith Manison', First_Name__c = 'Smith', Last_Name__c = 'Manison', Email__c = 'sth@gmail.com');
        Person__c person2 = new Person__c(Name = 'Mike Hopkins', First_Name__c = 'Mike', Last_Name__c = 'Hopkins', Email__c = 'hpkns@gmail.com');
        Person__c person3 = new Person__c(Name = 'Steve Owen', First_Name__c = 'Steve', Last_Name__c = 'Owen', Email__c = 'stow@gmail.com');

        List<Person__c> createdPersons = new List<Person__c>();

        createdPersons.add(person1);
        createdPersons.add(person2);
        createdPersons.add(person3);
        createdPersons.sort();

        Test.startTest();

        insert createdPersons;

        List<Person__c> persons = PersonController.searchPersons('gmail', null, 2);

        Test.stopTest();

        System.assertEquals(2, persons.size());

        List<String> personIds  = new List<String>();

        for(Person__c p : persons){
          personIds.add(p.Id);
        }
        system.assert(personIds.contains(createdPersons[0].Id));
        system.assert(personIds.contains(createdPersons[1].Id));


   }

}