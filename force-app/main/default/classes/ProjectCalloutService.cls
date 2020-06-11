/**
 * @File Name          : ProjectCalloutService.cls
 * @Description        : 
 * @Author             : bruno.zpc@hotmail.com
 * @Group              : 
 * @Last Modified By   : bruno.paiva@moldsoft.com.br
 * @Last Modified On   : 11/06/2020 10:56:15
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    09/06/2020   bruno.zpc@hotmail.com       Initial Version
**/
public with sharing class ProjectCalloutService {

    public static final String endpointNamedCredentials = 'callout:ProjectService';

    @InvocableMethod(label='Post Opportunity to PMS' description='' category= 'Opportunity')
    public static void PostOpportunityToPMS(List<Id> oppsId){
        List<Opportunity> opps = [SELECT Id, Name, Account.Name, CloseDate, Amount FROM Opportunity WHERE Id IN :OppsId];
        if(opps.size() > 0){
            ServiceTokens__c st = ServiceTokens__c.getValues('ProjectServiceToken');
            Opportunity opp = opps[0];
                String requestBody = '{"opportunityId": "' + opp.Id + '", "opportunityName": "' + opp.Name + '", "accountName": "' + opp.Account.Name + '", "closeDate": "' + opp.CloseDate + '", "amount": ' + (opp.amount != null ? opp.amount : 0) + '}';
            System.debug(System.enqueueJob(new QueueablePMSCall(requestBody, st.Token__c)));
        }
    }

    @Future(callout=true)
    public static void postOppToPMSCallout(String requestBody, String serviceToken){
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpointNamedCredentials);
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setHeader('token', serviceToken);
        request.setMethod('POST');
        request.setBody(requestBody);
        HttpResponse response = new Http().send(request);
        if(response.getStatusCode() == 201){
            System.debug('Registro criado com sucesso!');
        }else{
            System.debug('Houve um problema ao salvar o registro.');
            System.debug(response.getBody());
        }
    }
    
    public with sharing class QueueablePMSCall implements Queueable, Database.AllowsCallouts {
        public String serviceToken;
        public String requestBody;

        public QueueablePMSCall(String requestBody, String serviceToken){
            this.requestBody = requestBody;
            this.serviceToken = serviceToken;
        }
        
        public void execute(QueueableContext ctx){
            postOppToPMSCallout(requestBody, serviceToken);
        }
        

    }
}