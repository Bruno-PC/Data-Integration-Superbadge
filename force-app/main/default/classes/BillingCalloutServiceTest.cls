/**
 * @File Name          : BillingCalloutServiceTest.cls
 * @Description        : 
 * @Author             : bruno.paiva@moldsoft.com.br
 * @Group              : 
 * @Last Modified By   : bruno.paiva@moldsoft.com.br
 * @Last Modified On   : 18/06/2020 14:23:56
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    18/06/2020   bruno.paiva@moldsoft.com.br     Initial Version
**/
@isTest
private class BillingCalloutServiceTest {
  //Implement mock callout tests here
  @TestSetup
  static void makeData(){
    Opportunity opp = new Opportunity(Name = 'test', StageName = 'Submitted Project', CloseDate = System.TODAY());
    insert opp;
    Project__c prj = new Project__c(Opportunity__c = opp.Id, ProjectRef__c = 'testPrj', Name = 'Project', Status__c = 'Billable');
    insert prj;
    ServiceCredentials__c sc = new ServiceCredentials__c(Name = BillingCalloutService.SERVICE_CREDENTIALS_NAME, username__c = 'user', password__c = 'pwd');
    insert sc;
  }

  @isTest static void successTest(){
    Test.setMock(WebServiceMock.class, new BillingCalloutServiceMock());
    Project__c prj = [SELECT Id FROM Project__c WHERE ProjectRef__c = 'testPrj'];
    prj.Status__c = 'Billed';
    Test.startTest();
    update prj;
    Test.stopTest();
    System.assertEquals(1, Limits.getCallouts());
  }

  @isTest static void failureTest(){
    Test.setMock(WebServiceMock.class, new BillingCalloutServiceMockFailure());
    Project__c prj = [SELECT Id FROM Project__c WHERE ProjectRef__c = 'testPrj'];
    prj.ProjectRef__c = null;
    prj.Status__c = 'Billed';
    Test.startTest();
    update prj;
    Test.stopTest();
    System.assertEquals(1, Limits.getCallouts());
  }
}