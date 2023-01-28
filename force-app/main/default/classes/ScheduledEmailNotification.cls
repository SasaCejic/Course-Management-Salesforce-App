global class ScheduledEmailNotification implements Schedulable{
    
    global void execute(SchedulableContext SC){
        TutorsNotifier.findAndNotify();
    }

}