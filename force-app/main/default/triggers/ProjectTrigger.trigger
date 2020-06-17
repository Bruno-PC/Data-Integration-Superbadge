/**
 * @File Name          : ProjectTrigger.trigger
 * @Description        : 
 * @Author             : bruno.paiva@moldsoft.com.br
 * @Group              : 
 * @Last Modified By   : bruno.paiva@moldsoft.com.br
 * @Last Modified On   : 17/06/2020 17:58:24
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    17/06/2020   bruno.paiva@moldsoft.com.br     Initial Version
**/
trigger ProjectTrigger on Project__c (after update) {
    //Call the Billing Service callout logic here
    if(Trigger.isAfter && Trigger.isUpdate){
        for(Project__c prj : Trigger.new){
            BillingCalloutService.callBillingService(prj.Id, prj.Billable_Amount__c);
        }
    }
}