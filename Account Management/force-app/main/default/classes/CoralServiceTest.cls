@isTest
private class CoralServiceTest {
    
    @isTest
    static void TestPostMethodPositive() {

        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        request.requestUri =
            '/api/v1/account/create';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"name":"Test",'
                    + '"phone":"123456-789",'
                    + '"type":"Prospect",'
                    + '"website":"www.site.com"}');
        RestContext.request = request;
        RestContext.response = response;

        Test.startTest();
        CoralService.processPost();
        Test.stopTest();

        System.assertEquals(201, response.statusCode);
    }

    @isTest
    static void TestPostMethodMissingField() {

        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        request.requestUri =
            '/api/v1/account/create';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"phone":"123456-789",'
                    + '"type":"Prospecting",'
                    + '"website":"www.site.com"}');
        RestContext.request = request;
        RestContext.response = response;

        Test.startTest();
        CoralService.processPost();
        Test.stopTest();

        System.assertEquals(400, response.statusCode);
    }

    @isTest
    static void TestPostMethodErrorPath() {

        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        request.requestUri =
            '/api/v1/account/';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"name":"Test",'
                    + '"phone":"123456-789",'
                    + '"type":"Prospect",'
                    + '"website":"www.site.com"}');
        RestContext.request = request;
        RestContext.response = response;

        Test.startTest();
        CoralService.processPost();
        Test.stopTest();

        System.assertEquals(400, response.statusCode);
    }

    @isTest
    static void TestPostMethodPicklistError() {

        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        request.requestUri =
            '/api/v1/account/create';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"name":"Test",'
                    + '"phone":"123456-789",'
                    + '"type":"Prospecting",'
                    + '"website":"www.site.com"}');
        RestContext.request = request;
        RestContext.response = response;

        Test.startTest();
        CoralService.processPost();
        Test.stopTest();

        System.assertEquals(400, response.statusCode);
    }
}