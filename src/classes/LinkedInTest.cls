@isTest
private class LinkedInTest
{
    private class LinkedInTester extends LinkedIn
    {
        LinkedInTester(String userId)
        {
            super(userId);
        }

        public override HttpResponse executeLinkedInRequest(HttpRequest req)
        {
            return new HttpResponse();
        }
        
        public override String getResponseBody(HttpRequest req, HttpResponse resp )
        {
            return null;
        }
    }
    
    static testMethod void testUpdateUserShare() {
        LinkedInTester testClass = new LinkedInTester(UserInfo.getUserId());
        simulateOAuthLogin();
        LinkedIn.Share s = new LinkedIn.Share();
        s.comment = 'Testing';
        s.visibility = 'anyone';
        s.description = 'abc';
        s.updateTwitter = false;
        testClass.updateUserShare(s);
    }

    static testMethod void testOAuthAuthorize() {
        //LinkedInTester testClass = new LinkedInTester(UserInfo.getUserId());
        simulateOAuthLogin();
        LinkedInController c = new LinkedInController();
        c.userAuthorize();
        //testClass.oAuthAuthorize(null);
    }
    
    private static void simulateOAuthLogin()
    {
        List<OAuthService__c> svcs = [select id from OAuthService__c];
        delete(svcs);
        OAuthService__c lIn = new OAuthService__c(    name = LinkedIn.LINKED_OAUTH_SERVICE_NAME,
                                                      Access_Token_URL__c = 'http://abc.com', 
                                                      Authorization_URL__c = 'http://abc.com',
                                                      Request_Token_URL__c = 'http://abc.com',
                                                      Consumer_Key__c = '123',
                                                      Consumer_Secret__c  = '123');
                                                      
        insert lIn;                                              
        OAuth_Token__c t = new OAuth_Token__c (OAuth_Service__c = lIn.Id,
                                             secret__c = '123',
                                             token__c = '123',
                                             isAccess__c = true,
                                             Owner__c = UserInfo.getUserId());
        insert t;                                     
    }
}