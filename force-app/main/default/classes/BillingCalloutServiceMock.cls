/**
 * @File Name          : BillingCalloutServiceMock.cls
 * @Description        : 
 * @Author             : bruno.paiva@moldsoft.com.br
 * @Group              : 
 * @Last Modified By   : bruno.paiva@moldsoft.com.br
 * @Last Modified On   : 18/06/2020 14:16:01
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    18/06/2020   bruno.paiva@moldsoft.com.br     Initial Version
**/
@isTest
global class BillingCalloutServiceMock implements WebServiceMock{
   //Implement http mock callout here
   global void doInvoke(
            Object stub,
            Object request,
            Map<String, Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNS,
            String responseName,
            String responseType) {

         // Create response element from the autogenerated class.
         // Populate response element.
         // Add response element to the response parameter, as follows:
         BillingServiceProxy.billProjectResponse_element response_x = new BillingServiceProxy.billProjectResponse_element();
         response_x.status = '200';
         response.put('response_x', response_x);
   }
   
}