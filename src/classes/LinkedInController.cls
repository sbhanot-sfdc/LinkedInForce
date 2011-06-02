public with sharing class LinkedInController {
  public boolean userAuthorized {get;set;}
  
  public LinkedInController ()
  {
    //Query the OAuth_Token__c object to determine if we have a valid OAuth token for the user. If not, the user will first have
    //to authenticate and authorize with Foursquare.
    userAuthorized = false;
    try
    {
      OAuth_Token__c t = [SELECT token__c, secret__c, isAccess__c 
                FROM OAuth_Token__c 
                WHERE owner__c=:UserInfo.getUserId() limit 1];
      userAuthorized = true;                           
    }
    catch(Exception e){}
  }

  public PageReference userAuthorize()
  {
        //Use the OAuth class that is part of the OAuth Consumer Google Code Share project (http://code.google.com/p/sfdc-oauth-playground/)
        //to authorize the user
        LinkedIn l = new LinkedIn(UserInfo.getUserId());
        return l.oAuthAuthorize(Page.LinkedInSettings);
  }  
}