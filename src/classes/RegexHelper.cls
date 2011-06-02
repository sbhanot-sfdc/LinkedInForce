public class RegexHelper
{

    public static String toRegex(String s, boolean matchWholeWords)
    {
        String wholeWordBoundary = '';
        
        if(matchWholeWords)
            wholeWordBoundary = '\\b';
            
        String regex = wholeWordBoundary;//+'(';
        
        List<String> chars = s.split('',0);
        
        //start at 1 to skip initial blank entry
        for(Integer i = 1; i < chars.size(); i++)
        {
            regex += '['+chars[i].toLowerCase()+'|'+chars[i].toUpperCase()+']';
        }
        
        return regex + /*')'*/ +wholeWordBoundary;
    }
}