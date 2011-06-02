trigger SyncLinkedInChatterStatus on User (before update) {

    String defaultLinkedInKeyword = '#linkedin';

    List<String> userIds = new List<String>();
    List<String> statusUpdates = new List<String>();       

    for (Integer i=0; i < trigger.new.size(); i++)
    {
        User u = trigger.new[i];
        if (u.CurrentStatus != trigger.old[i].CurrentStatus && u.CurrentStatus != null &&  
            u.CurrentStatus.toLowerCase().contains(defaultLinkedInKeyword))
        {
            String statusUpdate = u.CurrentStatus;
            statusUpdate = statusUpdate.replaceAll(
                                RegExHelper.toRegex(defaultLinkedInKeyword, false), '').trim();
                        
            userIds.add(u.id);
            statusUpdates.add(statusUpdate);
        }
    }
    
    if (userIds.size() > 0)
        UpdateLinkedInUserStatus.updateStatus(userIds, statusUpdates);
    
}