/**
 * @File Name          : ProjectCalloutService.cls
 * @Description        : 
 * @Author             : bruno.zpc@hotmail.com
 * @Group              : 
 * @Last Modified By   : bruno.paiva@moldsoft.com.br
 * @Last Modified On   : 16/06/2020 16:54:46
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    09/06/2020   bruno.zpc@hotmail.com       Initial Version
**/
public with sharing class ProjectCalloutService {

    public static final String ENDPOINT_NAMED_CREDENTIALS = 'callout:ProjectService';
    public static final String SERVICE_TOKEN_NAME = 'ProjectServiceToken';

    @InvocableMethod(label='Post Opportunity to PMS' description='' category= 'Opportunity')
    public static void PostOpportunityToPMS(List<Id> oppsId){
        List<Opportunity> opps = [SELECT Id, Name, Account.Name, CloseDate, Amount FROM Opportunity WHERE Id IN :oppsId];
        if(opps.size() > 0){
            ServiceTokens__c st = ServiceTokens__c.getValues(SERVICE_TOKEN_NAME);
            Opportunity opp = opps[0];
            String requestBody = '{"opportunityId": "' + opp.Id + '", "opportunityName": "' + opp.Name + '", "accountName": "' + (opp.Account != null ? opp.Account.Name : null) + '", "closeDate": "' + opp.CloseDate + '", "amount": ' + (opp.amount != null ? opp.amount : 0) + '}';
            System.debug(System.enqueueJob(new QueueablePMSCall(requestBody, st.Token__c, opp.Id)));
        }
    }

    
    public with sharing class QueueablePMSCall implements Queueable, Database.AllowsCallouts {
        public String serviceToken;
        public String requestBody;
        public String oppId;

        public QueueablePMSCall(String requestBody, String serviceToken, String oppId){
            this.requestBody = requestBody;
            this.serviceToken = serviceToken;
            this.oppId = oppId;
        }
        
        public void execute(QueueableContext ctx){
            System.debug('executando aq');
            HttpRequest request = new HttpRequest();
            request.setEndpoint(ENDPOINT_NAMED_CREDENTIALS);
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            request.setHeader('token', serviceToken);
            request.setMethod('POST');
            request.setBody(requestBody);
            HttpResponse response = new Http().send(request);
            Opportunity opp = [SELECT StageName FROM Opportunity WHERE Id = :oppId];
            if(response.getStatusCode() == 201){
                System.debug('Registro criado com sucesso!');
                opp.StageName = 'Submitted Project';
            }else{
                System.debug('Houve um problema ao salvar o registro.');
                System.debug(response.getBody());
                opp.StageName = 'Resubmit Project';
            }
            update opp;
        }
    }
}