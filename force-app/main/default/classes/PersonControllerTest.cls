@isTest
public with sharing class PersonControllerTest {
    
   @isTest
   static void getPersons_ShouldReturnAnEmptyList_IfThereAreNoRecords(){

        Test.startTest();

        List<Person__c> persons = PersonController.getPersons(0);

        Test.stopTest();

        System.assertEquals(0, persons.size());

   }

   @isTest
   static void getPersons_ShouldReturnThePopulatedList_IfThereAreRecords(){

        Person__c person1 = new Person__c(Name = 'FirstName1 LastName1', First_Name__c = 'FirstName1', Last_Name__c = 'LastName1', Email__c = 'cejicsasa17@gmail.com');
        Person__c person2 = new Person__c(Name = 'FirstName2 LastName2', First_Name__c = 'FirstName2', Last_Name__c = 'LastName2', Email__c = 'cejicsasa17@gmail.com');
        Person__c person3 = new Person__c(Name = 'FirstName3 LastName3', First_Name__c = 'FirstName3', Last_Name__c = 'LastName3', Email__c = 'cejicsasa17@gmail.com');

        List<Person__c> createdPersons = new List<Person__c>();

        createdPersons.add(person1);
        createdPersons.add(person2);
        createdPersons.add(person3);

        Test.startTest();

        insert createdPersons;

        List<Person__c> persons = PersonController.getPersons(0);

        Test.stopTest();

        
        System.assertEquals(3, persons.size());


        List<String> personNames  = new List<String>();



        for(Person__c p : persons){
          personNames.add(p.Name);
        }

       //TODO Assert by ID
        system.assert(personNames.contains(person1.Name));
        system.assert(personNames.contains(person2.Name));
        system.assert(personNames.contains(person3.Name));


   }

   @isTest
   static void getPersons_ShouldReturnTwoRecords_IfThereAreThreeRecords_AndOffsetNumberIsOne(){

        Person__c person1 = new Person__c(Name = 'FirstName1 LastName1', First_Name__c = 'FirstName1', Last_Name__c = 'LastName1', Email__c = 'cejicsasa17@gmail.com');
        Person__c person2 = new Person__c(Name = 'FirstName2 LastName2', First_Name__c = 'FirstName2', Last_Name__c = 'LastName2', Email__c = 'cejicsasa17@gmail.com');
        Person__c person3 = new Person__c(Name = 'FirstName3 LastName3', First_Name__c = 'FirstName3', Last_Name__c = 'LastName3', Email__c = 'cejicsasa17@gmail.com');

        List<Person__c> createdPersons = new List<Person__c>();

        createdPersons.add(person1);
        createdPersons.add(person2);
        createdPersons.add(person3);

        Test.startTest();

        insert createdPersons;

        List<Person__c> persons = PersonController.getPersons(1);

        Test.stopTest();


        System.assertEquals(2, persons.size());


        List<String> personNames  = new List<String>();

        for(Person__c p : persons){
          personNames.add(p.Name);
        }
        
        system.assert(personNames.contains(person2.Name));
        system.assert(personNames.contains(person3.Name));


   }

   @isTest
   static void searchPersons_ShouldReturnAnEmptyLIst_IfNoRecordsAreInsertedAndSearchTermIsBlank(){

        Test.startTest();

        List<Person__c> persons = PersonController.searchPersons('', 0);

        Test.stopTest();

        System.assertEquals(0, persons.size());

   }

   @isTest
   static void searchPersons_ShouldReturnAllPersons_IfThreeRecordsAreInsertedAndSearchTermIsBlank(){

        Person__c person1 = new Person__c(Name = 'FirstName1 LastName1', First_Name__c = 'FirstName1', Last_Name__c = 'LastName1', Email__c = 'cejicsasa17@gmail.com');
        Person__c person2 = new Person__c(Name = 'FirstName2 LastName2', First_Name__c = 'FirstName2', Last_Name__c = 'LastName2', Email__c = 'cejicsasa17@gmail.com');
        Person__c person3 = new Person__c(Name = 'FirstName3 LastName3', First_Name__c = 'FirstName3', Last_Name__c = 'LastName3', Email__c = 'cejicsasa17@gmail.com');

        List<Person__c> createdPersons = new List<Person__c>();

        createdPersons.add(person1);
        createdPersons.add(person2);
        createdPersons.add(person3);

        Test.startTest();

        insert createdPersons;

        List<Person__c> persons = PersonController.searchPersons('', 0);

        Test.stopTest();


        System.assertEquals(3, persons.size());



        List<String> personNames  = new List<String>();


        for(Person__c p : persons){
          personNames.add(p.Name);
        }

        system.assert(personNames.contains(person1.Name));
        system.assert(personNames.contains(person2.Name));
        system.assert(personNames.contains(person3.Name));


   }

   @isTest
   static void searchPersons_ShouldReturnOneRecord_IfOneRecordNameMatchesSearchParameters(){

        Person__c person1 = new Person__c(Name = 'Smith Manison', First_Name__c = 'Smith', Last_Name__c = 'Manison', Email__c = 'sth@gmail.com');
        Person__c person2 = new Person__c(Name = 'Mike Hopkins', First_Name__c = 'Mike', Last_Name__c = 'Hopkins', Email__c = 'hpkns@gmail.com');
        Person__c person3 = new Person__c(Name = 'Steve Owen', First_Name__c = 'Steve', Last_Name__c = 'Owen', Email__c = 'stow@gmail.com');

        List<Person__c> createdPersons = new List<Person__c>();

        createdPersons.add(person1);
        createdPersons.add(person2);
        createdPersons.add(person3);

        Test.startTest();

        insert createdPersons;

        List<Person__c> persons = PersonController.searchPersons('Smith Manison', 0);

        Test.stopTest();

        System.assertEquals(1, persons.size());

        System.assert(persons[0].Name == person1.Name);

   }

   @isTest
   static void searchPersons_ShouldReturnOneRecord_IfOneRecordPhoneMatchesSearchParameters(){
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

        List<Person__c> persons = PersonController.searchPersons('+382 908837', 0);

        Test.stopTest();

        System.assertEquals(1, persons.size());
        System.assert(persons[0].Name == person2.Name);

        System.assert(persons[0].Name == person2.Name);

   }

   @isTest
   static void searchPersons_ShouldReturnOneRecord_IfOneRecordEmailMatchesSearchParameters(){

        Person__c person1 = new Person__c(Name = 'Smith Manison', First_Name__c = 'Smith', Last_Name__c = 'Manison', Email__c = 'sth@gmail.com');
        Person__c person2 = new Person__c(Name = 'Mike Hopkins', First_Name__c = 'Mike', Last_Name__c = 'Hopkins', Email__c = 'hpkns@gmail.com');
        Person__c person3 = new Person__c(Name = 'Steve Owen', First_Name__c = 'Steve', Last_Name__c = 'Owen', Email__c = 'stow@gmail.com');

        List<Person__c> createdPersons = new List<Person__c>();

        createdPersons.add(person1);
        createdPersons.add(person2);
        createdPersons.add(person3);

        Test.startTest();

        insert createdPersons;

        List<Person__c> persons = PersonController.searchPersons('stow@gmail.com', 0);

        Test.stopTest();

        System.assertEquals(1, persons.size());

        System.assert(persons[0].Name == person3.Name);


   }


   @isTest
   static void searchPersons_ShouldReturnTwoRecords_IfThreeRecordEmailsMatchSearchParametersAndOffsetNumberIsOne(){

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

        List<Person__c> persons = PersonController.searchPersons('gmail', 1);

        Test.stopTest();

        System.assertEquals(2, persons.size());

        List<String> personNames  = new List<String>();

        for(Person__c p : persons){
          personNames.add(p.Name);
        }
        system.assert(personNames.contains(createdPersons[1].Name));
        system.assert(personNames.contains(createdPersons[2].Name));


   }



}