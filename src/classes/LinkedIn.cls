public with sharing virtual class LinkedIn
{
    public static final String LINKED_IN_API_URL = 'http://api.linkedin.com/v1';
    public static final String LINKED_OAUTH_SERVICE_NAME = 'LinkedIn';
    private String sfdcUserId;
    private OAuth oa;       
    
    
    public LinkedIn(String userId)
    {
        sfdcUserId = userId;
    }
    
    public String updateUserShare(Share s)
    {
        HttpRequest req = createRequest('/people/~/shares','POST', s.toXML());
        HttpResponse resp = executeLinkedInRequest(req);
        return getResponseBody(req, resp);
    }
    
    protected virtual HttpRequest createRequest(String path, String method, DOM.Document request)
    {        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(LINKED_IN_API_URL  + path);
        req.setMethod(method == null ? 'GET' : method);
        req.setHeader('Content-Type', 'text/xml');
        req.setTimeout(60000);
        
        if (request != null)
            req.setBodyDocument(request); 
        
        if (oa == null)
        {
            oa = new OAuth();       
            if (!oa.setService(LINKED_OAUTH_SERVICE_NAME, sfdcUserId))
            {
                System.debug('Didnt work:'+oa.message);
                throw new AuthenticationException(oa.message);
            }
        }
        
        oa.sign(req); 
        return req;   
    }
    
    protected virtual HttpResponse executeLinkedInRequest(HttpRequest req)
    {
        HttpResponse res = new Http().send(req);
        
        if (req.getMethod() == 'POST' && res.getStatusCode() != 201)
        {
            System.debug('OAuth header:'+res.getHeader('oauth_problem'));
            throw new TwitterApiException (res.getBody());
        }
        else if (req.getMethod() == 'GET' && res.getStatusCode() != 200)
            throw new TwitterApiException (res.getBody());

        return res;
    }
    
    protected virtual String getResponseBody(HttpRequest req, HttpResponse resp )
    {
        return resp.getBody();
    }
        
    public PageReference oAuthAuthorize(PageReference successRedirectPage)
    {
        //Use the OAuth class that is part of the OAuth Consumer Google Code Share project 
        //(http://code.google.com/p/sfdc-oauth-playground/)
        //to authorize the user
        oa = new OAuth();
        String authUrl = oa.newAuthorization(LINKED_OAUTH_SERVICE_NAME, successRedirectPage);
        System.debug('URL is:'+authUrl);
        if(authUrl==null) {
          return null;
        } else {
          return new PageReference(authUrl);
        }
    }
    
    public class Share
    {
        public String comment {get;set;}
        public String title {get;set;}
        public String submittedUrl {get;set;}
        public String submittedImageUrl {get;set;}
        public String description {get;set;}
        public String visibility {get;set;}
        public Boolean updateTwitter {get;set;}
        
        public Share()
        {
            updateTwitter = false;
        }
        
        public DOM.Document toXML()
        {
            DOM.Document doc = new DOM.Document();
            Dom.XmlNode req = doc.createRootElement('share', null, null);
            req.addChildElement('comment', null, null).addTextNode(comment);
            
            if (title != null || submittedImageUrl != null || submittedUrl != null || description != null)
            {
                Dom.XmlNode c = req.addChildElement('content', null, null);
                c.addChildElement('title', null, null).addTextNode((title != null)?title:'');
                c.addChildElement('submitted-url', null, null).addTextNode((submittedUrl != null)?submittedUrl:'');
                c.addChildElement('submitted-image-url', null, null).addTextNode((submittedImageUrl != null)?submittedImageUrl:'');
                c.addChildElement('description', null, null).addTextNode((description!= null)?description:'');
            }
            req.addChildElement('visibility', null, null).addChildElement('code', null, null).addTextNode((visibility != null)?visibility:'connections-only');
            return doc;
        }        
    }
    
    public virtual class TwitterException extends Exception {}
    public class AuthenticationException extends Exception {}
    public class TwitterApiException extends Exception {}
}