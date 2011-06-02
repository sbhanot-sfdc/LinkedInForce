@isTest
private class SyncLinkedInChatterStatusTest {

    static testMethod void testLinkedInIntegration() {
    	User testU = createTestUserData();
    	testU.CurrentStatus = 'test #linkedin';
    	update testU;
    }

    private static User createTestUserData()
    {
    	Profile sysAdmin = [select id from Profile where name = 'System Administrator' limit 1];
    	User u = new User (Username = 'test@createTestUserData.com',
    					   LastName = 'Test User',
    					   Email = 'test@test.com',
    					   Alias = 'testUser',
    					   emailencodingkey = 'UTF-8', 
    					   languagelocalekey = 'en_US',
    					   localesidkey = 'en_US',
    					   timezonesidkey = 'America/Los_Angeles',
    					   profileid = sysAdmin.id);
    	insert u;
    	return u;				   
    }
}