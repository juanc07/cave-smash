package com.spilgames.api
{
	import flash.display.MovieClip;
	/**
	 * The FriendService is used to retrieve information on the friends of the currently logged in user. 
	 * 
	 * @since 1.3
	 * @langversion 3.0
	 * @playerversion Flash 10
	 *  
	 * @includeExample friendService_example1.as
	 * */
	public class FriendService extends MovieClip
	{
		// ====================================
		// CLASS CONSTANTS
		// ====================================
		private static const FRIENDSERVICE		: String = "Friend";
		
		/**
		 * An index to keep track of the callbacks passed from the developer.
		 * Since we now use a generic internal callback for the getFriends request,
		 * we need to store the actual callback function that the developer has provided.
		 **/
		private static var callbackIndex		: Object = { };
		
		/**
		 * Retrieves your friends from the Spil Games friend service.
		 * 
		 * <p>A callback needs to be specified in order to receive
		 * notifications and data regarding the sent request.</p>
		 * 
		 * @param callback Function which handles any data received from
		 *   the server. This callback is both used upon success or failure. The function must be defined as follows:
		 * <listing version="3.0">function functionName(callbackID:int, data:Object):void;</listing>
		 * <p>The <code>callbackID</code> argument is of type <code>int</code>
		 * and is used to identify the call which triggered the callback. This
		 * identifier is returned when you call the <code>getFriends</code> method.</p>
		 * <p>The second argument is an <code>Object</code> that holds data retrieved
		 * from the service, or an error message.</p>
		 * <p>The data.xml returned has the following format:</p>
		 * <listing version="3.0">
		 * &lt;profilar&gt;
		 * 	&lt;friendlist&gt;
		 * 		&lt;resultset&gt;
		 * 			&lt;result&gt;
		 * 				&lt;username&gt;friend1-dev8&lt;/username&gt;
		 * 				&lt;friendstatus&gt;accepted&lt;/friendstatus&gt;
		 * 				&lt;friendtime&gt;1330692504&lt;/friendtime&gt;
		 * 				&lt;friendscount&gt;5&lt;/friendscount&gt;
		 *				&lt;getprefs&gt;
		 * 					&lt;username&gt;friend1-dev8&lt;/username&gt;
		 * 					&lt;avatar&gt;117988458&lt;/avatar&gt;
		 * 				&lt;/getprefs&gt;
		 * 			&lt;/result&gt;
		 * 			&lt;result&gt;
		 * 				&lt;username&gt;friend2-dev8&lt;/username&gt;
		 * 				&lt;friendstatus&gt;accepted&lt;/friendstatus&gt;
		 * 				&lt;friendtime&gt;2230632454&lt;/friendtime&gt;
		 * 				&lt;friendscount&gt;5&lt;/friendscount&gt;
		 *				&lt;getprefs&gt;
		 * 					&lt;username&gt;friend2-dev8&lt;/username&gt;
		 * 					&lt;avatar&gt;117988455&lt;/avatar&gt;
		 * 				&lt;/getprefs&gt;
		 * 			&lt;/result&gt;
		 * 		&lt;/resultset&gt;
		 * 		&lt;returned&gt;2&lt;/returned&gt;
		 * 	&lt;total&gt;2&lt;/total&gt;
		 * 	&lt;/friendlist&gt;
		 * &lt;/profilar&gt;
		 * </listing>
		 * <p>The &lt;total&gt; node shows the count of friends of the user while the &lt;returned&gt; shows how many friends were retrieved for this request (usually &lt;total&gt; is equal to &lt;returned&gt;).</p>
		 * <p>For an explanation of the xml nodes of a &lt;result&gt; node (a friend's record), please refer to the <a href='UserInfo.html'>UserInfo</a> class documentation.</p>
		 * <p>If the request failed (when trying to retrieve friends while not logged in) the xml has the following format:</p>
		 * <listing version="3.0">
		 * &lt;profilar&gt;
		 * 	&lt;error&gt;
		 * 		&lt;code&gt;400&lt;/code&gt;
		 * 		&lt;message&gt;Bad Request&lt;/message&gt;
		 * 		&lt;operation&gt;friendlist&lt;/operation&gt;
		 * 		&lt;element&gt;username&lt;/element&gt;
		 * 	&lt;/error&gt;
		 * &lt;/profilar&gt;
		 * </listing>
		 * <p>Additionally, the data object will have a <code>friends</code> property which is an Array of
		 * UserInfo objects.</p>
		 * <p>An example of a callback function:</p>
		 * <listing version="3.0">
		 * import com.spilgames.api.UserInfo;
		 * 
		 * function myFriendCallback(callbackID:int, data:Object):void
		 * {
		 *     if (!data.success)
		 *     {
		 *         trace(data.errorMessage);
		 *     }
		 *     else
		 *     {
		 *         // data.xml holds XML returned from the service
		 *         trace("Friends: " + data.xml);
		 * 
		 *         //data.friends is an array of UserInfo objects
		 *         if (data.friends.length)
		 *             trace(UserInfo(data.friends[0]).username);
		 *     }
		 * }
		 * </listing>
		 * 
		 * @return Returns a positive numerical id to identify which request triggers
		 *         the given callback, or <code>SpilGamesServices.INVALID_ID</code> when
		 *         the request fails immediately.
		 * 
		 * @see com.spilgames.api.SpilGamesServices#INVALID_ID SpilGamesServices.INVALID_ID
		 */
		public static function getFriends(callback:Function):int
		{	
			var id:int = SpilGamesServices.getInstance().send(FRIENDSERVICE, "getFriends", getFriendsCallback, 
				{
					userName: User.getUserName(),
					userHash: User.getUserHash()
				}
			);
			
			callbackIndex[id] = { callbackFunc: callback };
			
			return id;
		}
		
		/**
		 * Added to convert the profilar feed to UserInfo instances.
		 * Adds the friends attibute to the data object, which is an array of UserInfo instances.
		 * It then invokes the actual callback that the developer passed in the getFriends method.
		 *  
		 **/
		private static function getFriendsCallback(id:int, data:Object):void
		{
			if (callbackIndex[id])
			{
				if (data.success)
				{
					data.friends = [];
					var resultArr:XMLList = data.xml.friendlist.resultset.result;
					
					for (var i:uint; i < resultArr.length(); i++)
					{
						data.friends.push(new UserInfo(resultArr[i]));
					}
				}
				
				callbackIndex[id].callbackFunc(id, data);
				delete callbackIndex[id];
			}
		}
		
		/**
		 * Retrieves the high scores of your friends for the current game from the Spil Games 
		 * high score service. Note that the current user data will also be returned in the results
		 * so ranking against friend scores can be determined.
		 * 
		 * <p>A callback needs to be specified in order to receive
		 * notifications and data regarding the sent request.</p>
		 * 
		 * @param callback Function which handles any data received from
		 *   the server. This callback is both used upon success or failure. The function must be defined as follows:
		 * @param options [optional] An Object specifying the kind of highscores to retrieve via the property <code>group</code>
		 *  if nothing is set then the default is <code>alltime.</code>
		 * <p><table class="innertable"> 
		 * <tr><th>Property</th><th>Type</th><th>Description</th><th>Default</th></tr>
		 * <tr><td><code>group</code></td><td>String</td><td>An optional setting to retrieve "daily", "weekly", "monthly", 
		 * "alltime"</td><td>"alltime"</td></tr>
		 * </table></p> 
		 * <listing version="3.0">function functionName(callbackID:int, data:Object):void;</listing>
		 * <p>The <code>callbackID</code> argument is of type <code>int</code>
		 * and is used to identify the call which triggered the callback. This
		 * identifier is returned when you call the <code>getHighscoreOfFriends</code> method.</p>
		 * <p>The second argument is an <code>Object</code> that holds data retrieved
		 * from the service, or an error message.</p>
		 * <p>An example of a callback function:</p>
		 * <listing version="3.0">
		 * function myFriendCallback(callbackID:int, data:Object):void
		 * {
		 *     if (!data.success)
		 *     {
		 *         trace(data.errorMessage);
		 *     }
		 *     else
		 *     {
		 *         // data.xml holds XML returned from the service
		 *         trace("Friend scores: " + data.xml);
		 *     }
		 * }
		 * </listing>
		 * 
		 * @return Returns a positive numerical id to identify which request triggers
		 *         the given callback, or <code>SpilGamesServices.INVALID_ID</code> when
		 *         the request fails immediately.
		 * 
		 * @see com.spilgames.api.SpilGamesServices#INVALID_ID SpilGamesServices.INVALID_ID
		 */
		public static function getHighscoreOfFriends(callback:Function, options:Object = null):int
		{			
			if (!options)
			{
				options = {};
				options.group = "alltime";
			}
			
			//set defaults
			options.userName = User.getUserName();
			options.userHash = User.getUserHash();
			
			return SpilGamesServices.getInstance().send(FRIENDSERVICE, 
				"getHighscoreOfFriends", callback, options
			);
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
		 *           the FriendService in your game:
		 * <listing version="3.0">
		 * import com.spilgames.api.FriendService;
		 * 
		 * if ( FriendService.isAvailable() )
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
			return SpilGamesServices.getInstance().isServiceAvailable(FRIENDSERVICE);
		}
	}
}