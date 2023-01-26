@isTest
global class ResponseHttpCalloutMock implements HttpCalloutMock{

    private String body;
    private Integer statusCode;

    global ResponseHttpCalloutMock(String body, Integer statusCode){
        this.body = body;
        this.statusCode = statusCode;
    }
    
    global HTTPResponse respond(HTTPRequest request) {
        
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody(body);
        response.setStatusCode(statusCode);
        return response; 
    }

}