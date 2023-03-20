@isTest
public with sharing class PersonTableControllerTest {
    
    @isTest
    static void getPersons_shouldReturnEmptyList_IfThereAreNoPersons(){
        
        Test.startTest();

        PersonTableController ptc = new PersonTableController();

        List<Person__c> persons = ptc.getPersons();

        Test.stopTest();

        System.assert(persons.isEmpty());

    }

    @isTest
    static void getPersons_shouldReturnThreeRecords_IfThereAreThreePersonRecords(){

        Person__c person1 = new Person__c(Name = 'Smith Manison', First_Name__c = 'Smith', Last_Name__c = 'Manison', Email__c = 'sth@gmail.com');
        Person__c person2 = new Person__c(Name = 'Mike Hopkins', First_Name__c = 'Mike', Last_Name__c = 'Hopkins', Email__c = 'hpkns@gmail.com');
        Person__c person3 = new Person__c(Name = 'Steve Owen', First_Name__c = 'Steve', Last_Name__c = 'Owen', Email__c = 'stow@gmail.com');

        List<Person__c> createdPersons = new List<Person__c>();

        createdPersons.add(person1);
        createdPersons.add(person2);
        createdPersons.add(person3);
        
        Test.startTest();

        insert createdPersons;

        PersonTableController ptc = new PersonTableController();

        List<Person__c> persons = ptc.getPersons();

        Test.stopTest();

        System.assertEquals(persons.size(), createdPersons.size());

        List<String> personIds  = new List<String>();

        for(Person__c p : persons){
          personIds.add(p.Id);
        }
        system.assert(personIds.contains(createdPersons[0].Id));
        system.assert(personIds.contains(createdPersons[1].Id));
        system.assert(personIds.contains(createdPersons[1].Id));

    }


    @isTest
    static void createTutor_shouldReturnValidPageReference(){
        
        Test.startTest();

        PersonTableController ptc = new PersonTableController();

        PageReference actual = ptc.createTutor();

        Test.stopTest();

        PageReference expected = new PageReference('/apex/vfCreatePerson?recordType=Tutor');
        expected.setRedirect(true);


        System.assertEquals(expected.getUrl(), actual.getUrl());

    }

    @isTest
    static void createStudent_shouldReturnValidPageReference(){
        
        Test.startTest();

        PersonTableController ptc = new PersonTableController();

        PageReference actual = ptc.createStudent();

        Test.stopTest();

        PageReference expected = new PageReference('/apex/vfCreatePerson?recordType=Student');
        expected.setRedirect(true);


        System.assertEquals(expected.getUrl(), actual.getUrl());

    }


}