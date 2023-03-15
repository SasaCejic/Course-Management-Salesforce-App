public with sharing class PersonDetailViewController {

    public String recordId{get; set;}

    public PersonDetailViewController() {
        this.recordId = System.currentPagereference().getParameters().get('id');
    }

}