@isTest
global class InvalidResponseCodeHttpCalloutMock implements HttpCalloutMock{
    
    global HTTPResponse respond(HTTPRequest request) {
        
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('invalid response code');
        response.setStatusCode(201);
        return response; 
    }

}