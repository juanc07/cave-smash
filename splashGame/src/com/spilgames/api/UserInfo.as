package com.spilgames.api
{
	/**
	 * UserInfo contains the information of a user as parsed from the xml feed of profilar.
	 * In most cases you won't have to instantiate this class. This will be done from the API
	 * in order to return strongly typed objects for the users instead of the raw xml.
	 * 
	 * @since 1.3.1
	 * @langversion 3.0
	 * @playerversion Flash 10
	 **/

	public class UserInfo
	{
		
		private var _username		: String	= "";
		private var _friendStatus	: String	= "";
		private var _friendTime		: uint		= 0;
		private var _friendsCount	: uint		= 0;
		private var _avatar			: int		= -1;
		/**
		 * The username of the friend.
		 * 
		 * @default an empty string
		 **/
		public function get username():String { return _username; }
		
		/**
		 * A string that indicates the status of a friendship.
		 * 
		 * <p>The friendStatus can have the value of one of the following constants defined in the FriendStatus class:</p>
		 * <p><table class="innertable"> 
		 * <tr><th>Constant</th><th>Description</th></tr>
		 * <tr><td><code>FriendStatus.NONE</code></td><td>No relationship or pending invitation between the given users.</td></tr>
		 * <tr><td><code>FriendStatus.SENT</code></td><td>Invitation was sent by the requesting user but not accepted nor declined yet.</td></tr>
		 * <tr><td><code>FriendStatus.RECEIVED</code></td><td>Invitation was received by the requesting user but not accepted nor declined yet.</td></tr>
		 * <tr><td><code>FriendStatus.ACCEPTED</code></td><td>Friendship established.</td></tr>
		 * <tr><td><code>FriendStatus.DECLINED</code></td><td>Invitation was declined.</td></tr>
		 * <tr><td><code>FriendStatus.DELETED</code></td><td>Friendship was deleted.</td></tr>
		 * </table></p>
		 * 
		 * <p>A friendship can normally only be in one state at any given time.
		 * Exception to this rule are the FriendStatus.SENT and FriendStatus.RECEIVED codes, depending on who requests the status.
		 * For the requestor the status would be FriendStatus.SENT, for the requestee FriendStatus.RECEIVED.</p>
		 * 
		 * @default an empty string
		 * 
		 **/
		public function get friendStatus():String { return _friendStatus; }
		
		/**
		 * A uint representing the date and time of the last operation on the friendship,
		 * expressed as the number of seconds since '00:00:00 1970-01-01 UTC'.
		 * For a friendship with status FriendStatus.ACCEPTED,
		 * friendtime would contain the date and time of acceptance of the friendship.
		 * Similar, for a friendship with a friendstatus of FriendStatus.SENT or FriendStatus.RECEIVED,
		 * it would contain the date and time of invitation.
		 **/
		public function get friendTime():uint { return _friendTime; }
		
		/**
		 * A uint indicating the count of the user's friends.
		 **/
		public function get friendsCount():uint { return _friendsCount; }
		
		/**
		 * An integer indicating the user's avatar id. The value will be -1 if no avatar was found.
		 * 
		 * @default -1
		 **/
		public function get avatar():int { return _avatar; }
		
		/**
		 * Constructor.
		 * 
		 * @param source An XML object created from the raw xml data returned from Profilar.
		 **/
		public function UserInfo(source:XML)
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
			_username		= (xml.username || "").toString();
			_friendStatus	= (xml.friendstatus || "").toString();
			_friendTime		= uint((xml.friendtime || "").toString());
			_friendsCount	= uint((xml.friendscount || "").toString());
			_avatar			= int((xml.getprefs.avatar || "").toString()) || -1;
		}
	}
}
