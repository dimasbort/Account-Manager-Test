@RestResource(urlMapping='/api/v1/account/*')
global with sharing class CoralService {

    public static final String RESPONSE_STATUS_SUCCESS = 'success';
    public static final String RESPONSE_STATUS_ERROR = 'error';
    public static final String RESPONSE_STATUS_KEY = 'status';
    public static final String RESPONSE_MESSAGE_KEY = 'message';
    public static final String OBJECT_MESSAGE_KEY = 'accountId';

    private static final List<String> ACCOUNT_TYPE_VALUE = new List<String>{'Prospect',
                                                                            'Customer - Direct',
                                                                            'Customer - Channel',
                                                                            'Channel Partner / Reseller',
                                                                            'Installation Partner',
                                                                            'Technology Partner',
                                                                            'Other'};
    
    @HttpPost
    global static void processPost() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        Map<String, Object> result = doPostImpl();
        res.responseBody = Blob.valueOf(JSON.serialize(result));
        res.statusCode = result.get(RESPONSE_STATUS_KEY) == RESPONSE_STATUS_SUCCESS ? 201 : 400;
    }

    public static Map<String, Object> doPostImpl() {
        Map<String, Object> result = new Map<String, Object>();
        try {
            String requestData = RestContext.request.requestBody.toString();
            String actionName = RestContext.request.requestURI;

            switch on getActionName(actionName) {
                when 'create' {
                    return getCreateOperation(requestData, actionName);
                } 
                when else {
                    throw new ActionException();
                }
            }
        } catch (Exception e) {
            result.put(RESPONSE_STATUS_KEY, RESPONSE_STATUS_ERROR);
            result.put(RESPONSE_MESSAGE_KEY, 'Bad request. Malformed content, incorrect parameter or action values.');
        } 
        
        return result;
    }

    private static Map<String, Object> getCreateOperation(String requestData, String actionName) {

        Map<String, Object> result = new Map<String, Object>();
        if (checkIfContainsRequiredParameters(requestData, getActionName(actionName))) {
            return createAccount(requestData, result);
        } else {
            result.put(RESPONSE_STATUS_KEY, RESPONSE_STATUS_ERROR);
            result.put(RESPONSE_MESSAGE_KEY, 'Bad request. Malformed content, incorrect parameter or action values.');
        }
        
        return result;
    }

    private static Map<String, Object> createAccount(String requestData, Map<String, Object> result) {

        AccountDataWrapper mainRequest = (AccountDataWrapper) JSON.deserialize(requestData, AccountDataWrapper.class);

        if(ACCOUNT_TYPE_VALUE.contains(mainRequest.type)) {

            Account acct = new Account(
                Name    = mainRequest.name,
                Type    = mainRequest.type,
                Website = mainRequest.website,
                Phone   = mainRequest.phone
            );

            insert acct;
    
            result.put(RESPONSE_STATUS_KEY, RESPONSE_STATUS_SUCCESS);
            result.put(RESPONSE_MESSAGE_KEY, 'Account has been created');
            result.put(OBJECT_MESSAGE_KEY, acct.Id);
        } else {
            throw new CreateException();
        }

        return result;
    }

    private static String getActionName(String requestUri) {
        String result = 'unknown';
        try {
            result = requestUri.substring(requestUri.lastIndexOf('/') + 1);
        } catch (Exception ex) {
            result = ex.getMessage();
            System.debug('Error parsing action' + ex.getMessage());
        }
        return result;
    }

    public static Boolean checkIfContainsRequiredParameters(String requestData, String actionName) {

        Boolean passed = false;

        if (actionName == 'create') {
            if (requestData.contains('"name"')
                    && requestData.contains('"phone"')
                    && requestData.contains('"website"')
                    && requestData.contains('"type"')) {
                passed = true;
            }
        } 

        return passed;
    }

    global class AccountDataWrapper {

        public String name {get; set;}
        public String type {get; set;}
        public String website {get; set;}
        public String phone {get; set;}
    }

    public class CreateException extends Exception {
    }

    public class ActionException extends Exception {
    }
}