/**
 * @File Name          : ProjectCalloutServiceTest.cls
 * @Description        : 
 * @Author             : bruno.paiva@moldsoft.com.br
 * @Group              : 
 * @Last Modified By   : bruno.paiva@moldsoft.com.br
 * @Last Modified On   : 16/06/2020 16:55:46
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    11/06/2020   bruno.paiva@moldsoft.com.br     Initial Version
**/
@isTest
private class ProjectCalloutServiceTest {
  //Implement mock callout tests here

  @TestSetup
  static void makeData(){
    Account acc = new Account(Name = 'Test Account');
    insert acc;
    Opportunity opp = new Opportunity(Name = 'Test', StageName = 'Prospecting', CloseDate = (System.TODAY()+1), AccountId = acc.Id);
    insert opp;
    ServiceTokens__c sT = new ServiceTokens__c(Name = ProjectCalloutService.SERVICE_TOKEN_NAME, Token__c = '12312312313akdasksak123123aksdka');
    insert sT;
  }

  @isTest static void successTest(){
    List<Opportunity> opps = [SELECT Id FROM Opportunity LIMIT 1];
    if(opps.size() > 0){
      Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMock());
      Test.startTest();
      ProjectCalloutService.PostOpportunityToPMS(new List<Id>{opps[0].Id});
      Test.stopTest();
      Opportunity opp = [SELECT StageName FROM Opportunity WHERE Id = :opps[0].id];
      System.assertEquals('Submitted Project', opp.StageName);
    }
  }
  
  @isTest static void failureTest(){
    List<Opportunity> opps = [SELECT Id FROM Opportunity LIMIT 1];
    Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMockFailure());
    Test.startTest();
    ProjectCalloutService.PostOpportunityToPMS(new List<Id>{opps[0].Id});
    Test.stopTest();
    Opportunity opp = [SELECT StageName FROM Opportunity WHERE Id = :opps[0].id];
    System.assertEquals('Resubmit Project', opp.StageName);
  }
}