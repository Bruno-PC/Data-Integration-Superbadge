/**
 * @File Name          : ProjectCalloutServiceMockFailure.cls
 * @Description        : 
 * @Author             : bruno.paiva@moldsoft.com.br
 * @Group              : 
 * @Last Modified By   : bruno.paiva@moldsoft.com.br
 * @Last Modified On   : 16/06/2020 16:57:32
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    11/06/2020   bruno.paiva@moldsoft.com.br     Initial Version
**/
@isTest
global class ProjectCalloutServiceMockFailure implements HttpCalloutMock {
   public HTTPResponse respond(HTTPRequest req) {
      HttpResponse res = new HttpResponse();
      res.setHeader('Content-Type', 'application/json');
      res.setStatusCode(400);
      return res;
   }
}