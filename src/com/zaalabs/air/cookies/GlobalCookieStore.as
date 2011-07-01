package com.zaalabs.air.cookies
{
    public class GlobalCookieStore
    {
        public var cookies:CookieStore;
        
        // =======================================
        //  Singleton instance
        // =======================================
        
        /** Storage for the singleton instance. */
        private static const _instance:GlobalCookieStore = new GlobalCookieStore( SingletonLock );
        
        public static function get instance():GlobalCookieStore
        {
            return _instance;
        }
        
        public function GlobalCookieStore(lock:Class)
        {
            if ( lock != SingletonLock )
            {
                throw new Error( "Invalid Singleton access.  Use GlobalCookieStore.instance." );
            }
            
            cookies = new CookieStore();
        }
    }
}

class SingletonLock {}