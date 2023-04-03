package com.spilgames.api
{
	/**
	 * UserData contains the data information of a user as parsed from the xml feed of gamatar.
	 * In most cases you won't have to instantiate this class. This will be done from the API
	 * in order to return strongly typed objects for the users instead of the raw xml.
	 * 
	 * @since 1.3.1
	 * @langversion 3.0
	 * @playerversion Flash 10
	 **/
		
	public class UserData
	{
		
		private var _id					: uint;
		private var _username			: String	= "";
		private var _avatar				: int;
		private var _ratings			: uint;
		private var _average_rating		: Number;
		private var _title				: String	= "";
		private var _description		: String	= "";
		private var _created			: uint;
		private var _hasData			: Boolean;
		private var _hasPreview			: Boolean;
		private var _hasRendering		: Boolean;
		
		/**
		 * User data Identifier.
		 **/
		public function get id():uint { return _id; }
		
		/**
		 * Username of the user data submitter.
		 * 
		 * @default an empty string
		 **/
		public function get username():String { return _username; }
				
		/**
		 * Avatar id for the user data submitter.
		 * 
		 * @default -1
		 **/
		public function get avatar():int { return _avatar; }
		
		/**
		 * Total number of ratings on this user data
		 **/
		public function get ratings():uint { return _ratings; }
		
		/**
		 * The average of all the submitted ratings on this user data. This will be a float between 0 and 10.
		 **/
		public function get average_rating():Number { return _average_rating; }
		
		/**
		 * User data title.
		 **/
		public function get title():String { return _title; }
		
		/**
		 * User data description.
		 **/
		public function get description():String { return _description; }
		
		/**
		 * Seconds since '00:00:00 1970-01-01 UTC' when creating the user data.
		 **/
		public function get created():uint { return _created; }
		
		/**
		 * If the user has saved data.
		 **/
		public function get hasData():Boolean { return _hasData; }
		
		/**
		 * Preview image available if greater than 0.
		 **/
		public function get hasPreview():Boolean { return _hasPreview; }
		
		/**
		 * Rendering available if greater than 0.
		 **/
		public function get hasRendering():Boolean { return _hasRendering; }
		
		/**
		 * Constructor.
		 * 
		 * @param source An XML object created from the raw xml data returned from Profilar.
		 **/
		public function UserData(source:XML)
		{
			readXML(source);
		}
		
		/**
		 * Updates the properties from the raw xml data.
		 * 
		 * @param	xml The xml data returned from Profilar.
		 */
		private function readXML(xml:XML):void
		{
			_id 			= int((xml.id || "").toString());
			_username		= (xml.username || "").toString();
			_avatar			= int((xml.avatar || "").toString()) || -1;
			_ratings		= int((xml.ratings || "").toString());
			_average_rating	= Number((xml.average_rating || "").toString());
			_title			= (xml.title || "").toString();
			_description	= (xml.description || "").toString();
			_created		= int((xml.created || "").toString());
			_hasData		= (uint((xml.data || "").toString()) > 0);
			_hasPreview		= (uint((xml.preview || "").toString()) > 0);
			_hasRendering	= (uint((xml.rendering || "").toString()) > 0);
		}
	}
}
