package com.zaalabs.air.cookies
{
    import flash.net.URLRequestHeader;
    
    import mx.formatters.DateBase;
    import mx.utils.StringUtil;
    
    public class CookieUtil
    {
        /**
         * Parses the element string in the format of key=value 
         * @param element String in the format of key=value
         * @return returns an object with two properties {key: 'foo', value: 'bar'}
         */		
        public static function parseElement(element:String):Object
        {
            element = StringUtil.trim(element);
            
            if(element.toLowerCase() == "secure")
                return {key: "Secure", value: true}
            
            var firstEquals:int = element.indexOf("=");
            return {key: element.slice(0, firstEquals), value: element.slice(firstEquals+1, element.length)};			
        }
        
        public static function parseExpiration(dateString:String):Date
        {
            var date:Date = new Date();
            
            var year:String = dateString.substr(12, 4);
            var month:String = convertMonthToNumber(dateString.substr(8, 3));
            var day:String = dateString.substr(5, 2);
            var hours:String = dateString.substr(17, 2);
            var minutes:String = dateString.substr(20, 2);
            var seconds:String = dateString.substr(23, 2);
            var timezone:String = dateString.substr(26, 3);
            
            if(timezone.toLowerCase() == "gmt")
            {
                date.setTime(Date.UTC(year, month, day, hours, minutes, seconds));
            }
            else
            {
                trace("Unsupported timezone in CookieUtil");
                date = new Date(year, month, day, hours, minutes, seconds);
            }
            
            return date;
        }
        
        /**
         * Converts a three letter month acronym to an int the Date object
         * recognizes. This function is case-insensitive.
         * @param month Three letter month acronym, example: Jan, Feb, Mar
         * @return An integer that Date can use
         */		
        public static function convertMonthToNumber(month:String):String
        {
            var str:String = month.substr(0, 1).toUpperCase() + month.substr(1, month.length);
            return DateBase.monthNamesShort.indexOf(str).toString();
        }
        
        /**
         * Parses the domain from the provided URL 
         * @param url String to parse domain from, example -- http://www.google.com
         * @return the domain from the url, example -- "www.google.com"
         */		
        public static function getDomainFromURL(url:String):String
        {
            var result:String = url.split("/")[2].split(":")[0];
            return result;
        }
        
        /**
         * Parse a Set-Cookie http response header.
         * @param httpHeader The URLRequestHeader to parse, should be a 'Set-Cookie' header
         * @return A vector of type Cookie
         */		
        public static function parseHttpHeader(httpHeader:URLRequestHeader):Vector.<Cookie>
        {
            if(httpHeader.name != "Set-Cookie") return null;
            
            var cookieVector:Vector.<Cookie> = new Vector.<Cookie>();
            var cookieAry:Array = httpHeader.value.split(/,(?=[^;,]*=)|,$/g); 
            
            for(var i:int=0; i < cookieAry.length; i++)
            {
                var cookie:Cookie = new Cookie();
                var c:String = cookieAry[i];
                var cookieElements:Array = c.split(/;+/);
                
                // The first value is always the actual cookie name and value
                var cookieValue:Object = CookieUtil.parseElement(cookieElements.shift());
                cookie.name = cookieValue.key;
                cookie.value = cookieValue.value;
                
                /*** Process the remaining elements ***/
                for(var j:int=0; j < cookieElements.length; j++)
                {
                    var str:String = cookieElements[j];
                    
                    // Skip one-off semi-colons
                    if(str.length <= 0) continue;
                    
                    var elem:Object = CookieUtil.parseElement(str);
                    
                    switch(elem.key.toLowerCase())
                    {
                        case "path":
                            cookie.path = elem.value;
                            break;
                        case "domain":
                            cookie.domain = elem.value;
                            break;
                        case "expires":
                            cookie.expires = CookieUtil.parseExpiration(elem.value);
                            break;
                        case "secure":
                            cookie.secure = elem.value;
                            break;
                        default:
                            trace("Unknown Element in Cookie: "+elem.key);
                    }
                }
                
                cookieVector.push(cookie);
            }
            
            return cookieVector;
        }
    }
}