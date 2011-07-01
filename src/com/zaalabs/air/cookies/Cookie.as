package com.zaalabs.air.cookies
{	
	import flash.net.URLRequestHeader;

	public class Cookie
	{
		public var name:String;
		public var value:String;
		
		public var expires:Date;
		public var path:String;
		public var domain:String;
		public var secure:Boolean;  // not implemented yet
		
		public function Cookie(name:String=null, value:String=null, domain:String=null)
		{
			this.name = encodeURIComponent(name);
			this.value = encodeURIComponent(value);
			this.domain = domain;
		}
		
		/**
		 * Has this cookie expired? 
		 * @return true if the cookie has expired.
		 */		
		public function isExpired():Boolean
		{
			if(!expires)
			{
				return false;
			}
			else
			{
				var now:Date = new Date();
				return now.time > expires.time;
			}
		}
		
		/**
		 * This method will return a string the is able to be used in 
		 * URLRequest headers 
		 * @return String that can be used as a URL request header
		 */		
		public function toString():String
		{
			return name + "=" + value;
		}
	}
}