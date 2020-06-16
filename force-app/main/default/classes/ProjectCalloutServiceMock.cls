/**
 * @File Name          : ProjectCalloutServiceMock.cls
 * @Description        : 
 * @Author             : bruno.paiva@moldsoft.com.br
 * @Group              : 
 * @Last Modified By   : bruno.paiva@moldsoft.com.br
 * @Last Modified On   : 12/06/2020 11:18:20
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    11/06/2020   bruno.paiva@moldsoft.com.br     Initial Version
**/
@isTest
global class ProjectCalloutServiceMock implements HttpCalloutMock {
   public HTTPResponse respond(HTTPRequest req) {
      HttpResponse res = new HttpResponse();
      System.assertNotEquals(null, req.getHeader('token'));
      res.setBody('Created');
      res.setHeader('Content-Type', 'application/json');
      res.setStatusCode(201);
      return res;
   }
}