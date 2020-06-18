/**
 * @File Name          : ProjectTrigger.trigger
 * @Description        : 
 * @Author             : bruno.paiva@moldsoft.com.br
 * @Group              : 
 * @Last Modified By   : bruno.paiva@moldsoft.com.br
 * @Last Modified On   : 18/06/2020 10:55:02
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    17/06/2020   bruno.paiva@moldsoft.com.br     Initial Version
**/
trigger ProjectTrigger on Project__c (after update) {
    //Call the Billing Service callout logic here
    if(Trigger.isAfter && Trigger.isUpdate){
        for(Project__c prj : Trigger.new){
            if(Trigger.oldMap.get(prj.Id).Status__c != 'Billed' && prj.Status__c == 'Billed'){
                BillingCalloutService.callBillingService(prj.Id, prj.Billable_Amount__c);
            }
        }
    }
}