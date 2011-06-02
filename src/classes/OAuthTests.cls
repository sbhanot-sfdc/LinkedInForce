/*
This class is a slightly modified version of this Google Code Share project - http://code.google.com/p/sfdc-oauth-playground/
*/
@isTest
private class OAuthTests {

	public static String createTestData() {
		OAuthService__c s = new OAuthService__c();
		s.name='test1234';
		s.request_token_url__c = 'http://requesttokenurl';
		s.access_token_url__c = 'http://requesttokenurl';
		s.consumer_key__c = 'consumerkey';
		s.consumer_secret__c = 'consumersecret';
		s.authorization_url__c = 'http://testauthorizationurl';
		insert s;
		
		return null;
	}
	
	public static testMethod void testGetUsersOfService() {
		OAuthTests.createTestData();
		OAuth o = new OAuth();
		o.setService('test1234');
		List<User> usrs = o.getUsersOfService('test1234');
		System.assertEquals(usrs.size(), 0);
	}

    public static testMethod void testAuthorize() {
    	
    	try {
    		OAuthTests.createTestData();
    		ApexPages.currentPage().getHeaders().put('Host','testhost');
    		AuthController ac = new AuthController();
    		ac.service = 'test1234';
    		ac.authUrl = 'bogus';
    		ac.message = 'bogus';
    		ac.authorize();
    		Test.setCurrentPage(Page.CompleteAuth);
	        ApexPages.currentPage().getParameters().put('oauth_token','token');
	        ApexPages.currentPage().getParameters().put('oauth_verifier','verifier');
    		ac.completeAuthorization();
			System.assertEquals(ac.authSuccess, true);
    	}
    	catch(Exception e) {
			throw e;
    	}
    }
    
}