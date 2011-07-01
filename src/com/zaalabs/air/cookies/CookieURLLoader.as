package com.zaalabs.air.cookies
{
    import flash.events.HTTPStatusEvent;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.net.URLRequestHeader;
    
    public class CookieURLLoader extends URLLoader
    {
        public function CookieURLLoader(cookieStore:CookieStore=null, request:URLRequest=null)
        {
            super(request);
            
            _cookieStore = cookieStore ? cookieStore : GlobalCookieStore.instance.cookies;
            configureListeners();

        }
        
        /**
         * @param request
         */        
        override public function load(request:URLRequest):void
        {
            var domain:String = CookieUtil.getDomainFromURL(request.url);
            
            // We set request.manageCookies to false because we're going to manage them ourselves.
            request.manageCookies = false;
            request.requestHeaders.push(_cookieStore.getCookies(domain));
            
            super.load(request);
        }
        
        protected function configureListeners():void
        {
            addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, onHttpResponse, false, 0, true);
        }
        
        /**
         * We need to interject an grab the cookie header and parse it when we get a response
         */        
        protected function onHttpResponse(event:HTTPStatusEvent):void
        {
            if(!event.responseHeaders) return;
            
            for each(var header:URLRequestHeader in event.responseHeaders)
            {
                if(header.name == "Set-Cookie")
                {
                    _cookieStore.setCookies(CookieUtil.getDomainFromURL(event.responseURL), header);
                }
            }
        }
        
        protected var _cookieStore:CookieStore;
    }
}