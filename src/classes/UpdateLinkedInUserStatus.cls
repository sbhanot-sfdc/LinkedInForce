public with sharing class UpdateLinkedInUserStatus {
    
    @future(callout=true)
    public static void updateStatus(List<String> userIds, List<String> statusUpdates)
    {       
        for (Integer i = 0; i< userIds.size(); i++)
        {
            LinkedIn l = new LinkedIn(userIds.get(i));
            LinkedIn.Share s = new LinkedIn.Share();
            s.comment = statusUpdates.get(i);
            s.visibility = 'anyone';
            try
            {
                if (Limits.getLimitCallouts() > Limits.getCallouts())
                {
                    l.updateUserShare(s);
                }   
            }
            catch(Exception e){}
        }
    }

}