/**
 * @File Name          : ProjectRESTServiceTest.cls
 * @Description        : 
 * @Author             : bruno.paiva@moldsoft.com.br
 * @Group              : 
 * @Last Modified By   : bruno.paiva@moldsoft.com.br
 * @Last Modified On   : 17/06/2020 16:47:42
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    17/06/2020   bruno.paiva@moldsoft.com.br     Initial Version
**/
@isTest
private class ProjectRESTServiceTest {
  //Implement Apex REST service tests here
  @TestSetup
  static void makeData(){
    Opportunity opp = new Opportunity(
      Name = 'Test opp',
      StageName = 'Submitted Project',
      CloseDate = System.TODAY()
    );
    insert opp;
    Project__c prj = new Project__c(Opportunity__c = opp.Id, ProjectRef__c = 'testPrj', Name = 'Project');
    insert prj;
  }

  @isTest static void testException(){
    System.assertEquals('ERROR!', ProjectRESTService.postProjectData(null, null, null, null, null, null, null));
  }

  @isTest static void testSuccess(){
    Project__c prj = [SELECT Name, Opportunity__c, ProjectRef__c FROM Project__c WHERE ProjectRef__C = 'testPrj'];
    String result = ProjectRESTService.postProjectData(
      prj.ProjectRef__c,
      prj.Name,
      prj.Opportunity__c,
      (System.TODAY()-1),
      System.TODAY(),
      (double) 2314.72,
      'Billed'
    );
    System.assertEquals('OK', result);
  }
}