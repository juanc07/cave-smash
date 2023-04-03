// Copyright 2010 Spil Games BV
package com.spilgames.api
{
    /**
     * Build version number of the Spil Games API.
     * 
     * @since 1.3
     * @langversion 3.0
     * @playerversion Flash 9
     *
     * @includeExample buildVersion_example1.as
     */
	public class BuildVersion
	{
	    /**
         * Build version number.
         *
         * <p>Formatted like {VERSION_MAJOR}.{VERSION_MINOR}.{VERSION_BUILD}, ie. '1.3.1'.</p>
         */
		public static const BUILD_NUMBER  : String = getBuildNumber();
		
		/**
         * Major version number. 
         */     
        public static const VERSION_MAJOR   : int = 1;
        
        /**
         * Minor version number. 
         */     
        public static const VERSION_MINOR   : int = 3;
        
        /**
         * Build version number.
         */     
        public static const VERSION_BUILD   : int = 1;
        
        /**
         * @return The version number, ie. '1.3.1'.
         */     
        private static function getBuildNumber():String
        {
            return VERSION_MAJOR + "." + VERSION_MINOR + "." + VERSION_BUILD;
        }
	}
}