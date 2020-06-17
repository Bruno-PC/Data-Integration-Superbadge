/**
 * @File Name          : BillingCalloutService.cls
 * @Description        : 
 * @Author             : bruno.paiva@moldsoft.com.br
 * @Group              : 
 * @Last Modified By   : bruno.paiva@moldsoft.com.br
 * @Last Modified On   : 17/06/2020 17:58:19
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    17/06/2020   bruno.paiva@moldsoft.com.br     Initial Version
**/
public class BillingCalloutService {
    //Implement business and callout logic methods here
    public static final String SERVICE_CREDENTIALS_NAME = 'BillingServiceCredential';
    @Future(callout=true)
    public static void callBillingService(String prjId, Decimal amount){
        BillingServiceProxy.project soapProject = new BillingServiceProxy.project();
        ServiceCredentials__c sc = ServiceCredentials__c.getValues(SERVICE_CREDENTIALS_NAME);
        soapProject.projectid = prjId;
        soapProject.billAmount = amount;
        soapProject.username = sc.username__c;
        soapProject.password = sc.password__c;
        String response = new BillingServiceProxy.InvoicesPortSoap11().billProject(soapProject);
        System.debug(response);
    }
}