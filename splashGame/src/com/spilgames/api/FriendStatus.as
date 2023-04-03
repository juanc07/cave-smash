package com.spilgames.api
{
	/**
	 * Contains the status codes of a friendship as defined in Profilar.
	 * 
	 * @since 1.3.1
	 * @langversion 3.0
	 * @playerversion Flash 10
	 */
	public class FriendStatus 
	{
		/**
		 * No relationship or pending invitation between the given users.
		 */
		public static const NONE		: String	= "none";
		
		/**
		 * Invitation was sent by the requesting user but not accepted nor declined yet.
		 */
		public static const SENT		: String	= "sent";
		
		/**
		 * Invitation was received by the requesting user but not accepted nor declined yet.
		 */
		public static const RECEIVED	: String	= "received";
		
		/**
		 * Friendship established.
		 */
		public static const ACCEPTED	: String	= "accepted";
		
		/**
		 * Invitation was declined.
		 */
		public static const DECLINED	: String	= "declined";
		
		/**
		 * Friendship was deleted.
		 */
		public static const DELETED		: String	= "deleted";
	}
}
