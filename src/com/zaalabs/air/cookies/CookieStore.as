package com.zaalabs.air.cookies
{
    import flash.net.URLRequestHeader;
    import flash.utils.Dictionary;
    
    public class CookieStore
    {
        protected var _domains:Dictionary = new Dictionary(true);
        
        public function setCookies(domain:String, httpHeader:URLRequestHeader):void
        {
            var newCookies:Vector.<Cookie> = CookieUtil.parseHttpHeader(httpHeader);
            
            for(var i:int=0; i<newCookies.length; i++)
            {
                var cookie:Cookie = newCookies[i];
                addCookie(domain, cookie);
            }
            
            trace("Cookies set");
        }
        
        public function addCookie(domain:String, cookie:Cookie):void
        {
            var cookies:Dictionary = getCookiesForDomain(domain);
            cookies[cookie.name] = cookie;
        }
        
        public function removeCookie(domain:String, cookieName:String):void
        {
            var cookies:Dictionary = getCookiesForDomain(domain);
            
            delete cookies[cookieName];
        }
        
        public function getCookie(domain:String, cookieName:String):Cookie
        {
            var cookies:Dictionary = getCookiesForDomain(domain);
            
            return cookies[cookieName];
        }
        
        public function getCookies(domain:String):URLRequestHeader
        {
            var cookies:Dictionary = getCookiesForDomain(domain);
            
            var cookieString:String = "";
            for (var key:String in cookies)
            {
                cookieString += cookies[key].toString() + "; ";
            }
            var header:URLRequestHeader = new URLRequestHeader("Cookie", cookieString);
            
            return header;
        }
        
        public function clearDomainCookies(domain:String):void
        {
            delete _domains[domain];
        }
        
        public function getQueryStringForDomain(domain:String):String
        {
            var cookies:Dictionary = getCookiesForDomain(domain);
            var str:String = "";
            for (var key:String in cookies)
            {
                str += key + "=" + encodeURIComponent(cookies[key].value) + "&";
            }
            
            return str;
        }
        
        public function toString():String
        {
            var dump:String = "";
            
            dump += " == Cookie Store Dump == \n";
            
            for(var domain:String in _domains)
            {
                dump += "Domain [ "+domain+" ]\n";
                var cookies:Dictionary = getCookiesForDomain(domain);
                for each(var cookie:Cookie in cookies)
                {
                    dump += "\tName: "+cookie.name+", Value: "+cookie.value+"\n";
                }
            }
            
            return dump;
        }
        
        protected function getCookiesForDomain(domain:String):Dictionary
        {
            if(!_domains[domain])
                _domains[domain] = new Dictionary(true);
            
            return _domains[domain];
        }
    }
}