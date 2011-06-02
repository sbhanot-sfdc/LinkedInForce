/*
This class is a slightly modified version of this Google Code Share project - http://code.google.com/p/sfdc-oauth-playground/
*/
public with sharing class AuthController {

    public String service { get; set; }
    
    public String authUrl { get; set; }
    
    public boolean authSuccess { get; set; }

    public String message { get; set; }

    public PageReference authorize() {
        OAuth oa = new OAuth();
        authUrl = oa.newAuthorization(service, null);
        System.debug(authUrl);
        if(authUrl==null) {
            this.message = oa.message;
            return null;
        } else {
            return new PageReference(authUrl);
        }
    }
    
    public PageReference completeAuthorization() {
        String token = ApexPages.currentPage().getParameters().get('oauth_token');
        String success_page = ApexPages.currentPage().getParameters().get('success_page');
        System.debug('Success Page:'+success_page);
        if(token!=null)
        {
            String verifier = ApexPages.currentPage().getParameters().get('oauth_verifier');
            OAuth oa = new OAuth();
            authSuccess = oa.completeAuthorization(token,verifier);
            if (authSuccess)
            {
                if (success_page != null)
                	return new PageReference (success_page);
                else
                	return null;	
            }     
            this.message = oa.message;
        }
        else {
            message = 'Invalid request. Missing parameter oauth_token';
        }
        return null;
    }
    
}