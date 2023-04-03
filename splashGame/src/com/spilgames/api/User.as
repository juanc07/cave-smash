// Copyright 2010 Spil Games BV
package com.spilgames.api
{
	import flash.display.DisplayObject;

	/**
	 * The User class provides the ability to retrieve information about the
	 * status of the user on a Spil Games website.
	 * 
	 * @since 1.3
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @includeExample user_example1.as
	 */
	public class User
	{
		// ====================================
		// STATIC METHODS
		// ====================================
		
		/**
		 * Indicates whether or not the current user is a guest.
		 * 
		 * <p>A user is considered a guest when no username or user hash
		 * have been passed to the game.</p>
		 * 
		 * @return <code>false</code> when the user is connected and
		 *         contains valid data, otherwise <code>true</code>.
		 * 
		 * @example The following code shows how to detect the user type:
		 * <listing version="3.0">
		 * import com.spilgames.api.User;
		 * 
		 * var guest:Boolean = User.isGuest();
		 * if ( guest )
		 * {
		 *     trace("Welcome guest!");
		 *     // setup game for guest
		 * }
		 * else
		 * {
		 *     trace("Welcome registered user!");
		 *     // setup game for registered user
		 * }
		 * </listing>
		 */
		public static function isGuest():Boolean
		{
			var result:Boolean = true;
			var connection:* = SpilGamesServices.getInstance().connection;
			
			if (connection != null)
			{
				result = connection.isGuest();
			}
			else
			{
				// Backwards compatible
				//trace("WARNING: SpilGamesServices connection not ready yet");
				
				var root:DisplayObject = SpilGamesServices.getInstance().root;
				if (root && root.loaderInfo)
				{
					var vars:Object = root.loaderInfo.parameters;
					result = (!vars.username || vars.username == "" ||
						!vars.hash|| vars.hash == "");
				}
				else
				{
					result = false;
				}
			}
			
			return result;
		}
		
		/**
		 * Indicates whether user is logged in or not.
		 * 
		 * <p>A user is considered logged in when a username and a user hash
		 * has been passed to the game.</p>
		 * 
		 * @return <code>true</code> when the user is connected and
		 *         contains valid data, otherwise <code>false</code>.
		 * 
		 * @example The following code shows how to detect if the user is logged in:
		 * <listing version="3.0">
		 * import com.spilgames.api.User;
		 * 
		 * var loggedIn:Boolean = User.isLoggedIn();
		 * if ( loggedIn )
		 * {
		 *     trace("User is logged in!");
		 *     // setup game for logged in user
		 * }
		 * else
		 * {
		 *     trace("User is not logged in yet...");
		 *     // setup game for non-logged in user
		 * }
		 * </listing>
		 */
		public static function isLoggedIn():Boolean
		{
			var returnValue:Boolean = false;
			var connection:* = SpilGamesServices.getInstance().connection;
			
			if (connection != null)
			{
				returnValue = connection.isLoggedIn();
			}
			else
			{
				// Backwards compatible
				//trace("WARNING: SpilGamesServices connection not ready yet");
				
				var root:DisplayObject = SpilGamesServices.getInstance().root;
				if (root && root.loaderInfo)
				{
					var vars:Object = root.loaderInfo.parameters;
					returnValue = vars.username && vars.hash;
				}
				else
				{
					returnValue = true;
				}
			}
			
			return returnValue;
		}
		
		/**
		 * Retrieves the username, if any.
		 * 
		 * @return Either the username of the authenticated user when the connection has been
		 *         established or an empty String when: the connection is not ready,
		 *         or the game is not running on a Spil Games site.
		 * 
		 * @example The following code shows how to retrieve the username:
		 * <listing version="3.0">
		 * import com.spilgames.api.User;
		 * 
		 * var username:String = User.getUserName();
		 * if ( username != "" )
		 * {
		 *     trace("Welcome " + username + "!");
		 * }
		 * else
		 * {
		 *     // handle unknown user
		 * }
		 * </listing>
		 */
		public static function getUserName():String
		{
			var username:String = "";
			var connection:* = SpilGamesServices.getInstance().connection;
			
			if (connection != null)
			{
				username = connection.getUserName();
			}
			
			return username;
		}
		
		/**
		 * Retrieves the hash of the user that authenticated on the Spil Games
		 * portal where the game is running.
		 * 
		 * <p>The hash is used for server-side authentication of the user.</p>
		 * 
		 * @return Either the hash of the authenticated user when the connection
		 *         has been established, or an empty String when: the connection
		 *         is not ready, or the game is not running on a Spil Games
		 *         site.
		 * 
		 * @example The following code shows how to retrieve the user hash:
		 * <listing version="3.0">
		 * import com.spilgames.api.User;
		 * 
		 * var userhash:String = User.getUserHash();
		 * if ( userhash != "" )
		 * {
		 *     trace("Hash: " + userhash);
		 * }
		 * else
		 * {
		 *     // user was not authenticated
		 * }
		 * </listing>
		 */
		public static function getUserHash():String
		{
			var userHash:String = "";
			var connection:* = SpilGamesServices.getInstance().connection;

			if (connection != null)
			{
				userHash = connection.getUserHash();
			}
			
			return userHash;
		}
		
		/**
		 * Indicates whether or not the service is available for your game.
		 * 
		 * <p>Individual services may or may not be available on the website on which
		 * your game is placed. Therefore a game should not rely on functionality of the
		 * service, such as completing a callback, since a callback might never be
		 * called. You are advised to process the value returned by this function and act
		 * upon that.</p>
		 * 
		 * @return Returns <code>true</code> if the service is available,
		 *         otherwise <code>false</code>.
		 * 
		 * @example  The following code shows how to check the availability of
		 *           the User service in your game:
		 * <listing version="3.0">
		 * import com.spilgames.api.User;
		 * 
		 * if ( User.isAvailable() )
		 * {
		 *     // Service is available!
		 * }
		 * else
		 * {
		 *     // Service could not be found
		 * }
		 * </listing>
		 */
		public static function isAvailable():Boolean
		{
			//User info is related to Spil flashvars and availability
			//of this service is therefore related to root.loaderInfo
			return (SpilGamesServices.getInstance().root && 
				SpilGamesServices.getInstance().root.loaderInfo);
		}
	}
}