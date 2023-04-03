package com.spilgames.api
{
	/**
	* <p>The BusinessRequirements class provides information on business-specific features.</p> 
	*
	* <p>For example, you should first check if 'BusinessRequirements.showAvatarDialog' is set to true before
	* showing an avatar upload screen.</p>
	*
    * <p><b>Important:</b> the connection to SpilGamesServices needs to be established before using
    * the BusinessRequirements class. Listen to the SpilGamesServices.SERVICES_READY event
	* to check whether the connection is established.</p>
	* 
	* @since 1.3
	* @langversion 3.0
	* @playerversion Flash 10
	*
	* @includeExample BusinessRequirements_example1.as
	* @see SpilGamesServices
	*/
	public class BusinessRequirements
	{
		/**
		 * Defines whether the album item upload dialog should be made available or not.
		 **/
		public static function get showAlbumDialog():Boolean { return _getRequirement("showAlbumDialog"); }
		
		/**
		 * Defines whether the branding logo should be visible on an album item upload dialog.
		 **/
		public static function get showAlbumBranding():Boolean { return _getRequirement("showAlbumBranding"); }
		
		/**
		 * Defines whether the avatar upload/set dialog should be made available or not.
		 **/
		public static function get showAvatarDialog():Boolean { return _getRequirement("showAvatarDialog"); }
		
		/**
		 * Defines whether the branding logo should be visible on an avatar upload/set dialog.
		 **/
		public static function get showAvatarBranding():Boolean { return _getRequirement("showAvatarBranding"); }
		
		private static function _getRequirement(requirementName:String):*
		{
			var returnValue:*;
			
			var connection:* = SpilGamesServices.getInstance().connection;
			if (connection && SpilGamesServices.getInstance().connected)
				returnValue = connection.getBusinessRequirement(requirementName);
			else
				trace("ERROR: A connection has to be established before using the BusinessRequirements. Please wait for the SpilGamesServices.SERVICES_READY event.");
		
			return returnValue;
		}
	}
}