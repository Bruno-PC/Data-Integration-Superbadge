/**
 * @File Name          : ProjectRESTService.cls
 * @Description        : 
 * @Author             : bruno.paiva@moldsoft.com.br
 * @Group              : 
 * @Last Modified By   : bruno.paiva@moldsoft.com.br
 * @Last Modified On   : 17/06/2020 16:52:43
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    16/06/2020   bruno.paiva@moldsoft.com.br     Initial Version
**/
@RestResource(urlMapping='/Project/*')
global class ProjectRESTService {
    //Implement service logic here
    @HttpPost
    global static String postProjectData(
        String ProjectRef, String ProjectName, String OpportunityId, 
        Date StartDate, Date EndDate, Double Amount, String Status
    ){
        Savepoint sp = Database.setSavepoint();
        List<Project__c> prjList = [SELECT Id FROM Project__c WHERE ProjectRef__c = :ProjectRef];
        Project__c prj = new Project__c();
        if(prjList.size() > 0){
            prj = prjList[0];
        }else{
            prj.Opportunity__c = OpportunityId;
        }
        prj.ProjectRef__c = ProjectRef;
        prj.Name = ProjectName;
        prj.Start_Date__c = StartDate;
        prj.End_Date__c = EndDate;
        prj.Billable_Amount__c = Amount;
        prj.Status__c = Status;
        try {
            upsert prj;
            Opportunity opp = new Opportunity(Id = OpportunityId);
            opp.DeliveryInstallationStatus__c = 'In progress';
            Database.SaveResult sr = Database.update(opp);
            return 'OK';
        } catch (Exception e) {
            Database.rollback(sp);
            return 'ERROR!';
        }
    }
}