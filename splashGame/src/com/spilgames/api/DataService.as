package com.spilgames.api
{
	import flash.display.MovieClip;
	
	/**
	 * The DataService provides the ability to load and save game data on
	 * the Spil Games network. 
	 * 
	 * <p>100kb of valid XML
	 * may be stored per game per user.</p>
	 * 
	 * @since 1.3
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @includeExample dataService_example1.as
	 * @includeExample dataService_example2.as
	 */
	
	public class DataService extends MovieClip
	{
		// ====================================
		// CLASS CONSTANTS
		// ====================================
		
		private static const DATASERVICE		: String = "Data";
		private static const TITLE				: String = "title";
		private static const DESCRIPTION		: String = "description";
		
		/**
		 * An index to keep track of the callbacks passed from the developer.
		 * Since we now use a generic internal callback for the getFriends request,
		 * we need to store the actual callback function that the developer has provided.
		 **/
		private static var callbackIndex		: Object = { };
		
		public function DataService()
		{
		
		}
		/**
		 * Saves a data entry i.e. A save file composed of 100kb of valid XML.
		 * 
		 * <p>A data entry is saved to the portal under a unique <code>dataID</code>.
		 * These can optionally be accompanied by a title and a brief description.</p>
		 * 
		 * <p>An optional callback can be specified in order to receive the dataID 
		 * returned from the request.</p>
		 * 
		 * @param data The XML object to be saved.
		 * @param callback [optional] Function which handles any data received from the server. 
		 * This callback is both used upon success or failure. The function must be defined as follows:
		 * <listing version="3.0">function functionName(callbackID:int, data:Object):void;</listing>
		 * <p>The <code>callbackID</code> argument is of type <code>int</code>
		 * and is used to identify the call that triggered the callback. This
		 * identifier is returned when you call the <code>saveData</code> method.</p>
		 * <p>The second argument is an Object that holds data retrieved
		 * from the service, or an error message.</p>
		 * <p>An example of a callback function:</p>
		 * <listing version="3.0">
		 * function myAddItemCallback(callbackID:int, data:Object):void
		 * {
		 *     if (!data.success)
		 *     {
		 *         trace(data.errorMessage);
		 *     }
		 *     else
		 *     {
		 *         // data.dataID holds dataID returned by the service
		 *         trace("dataID: " + data.dataID);
		 *     }
		 * }
		 * </listing>
		 * @param options [optional] An object specifying data containing the following properties:
		 * <p><table class="innertable"> 
		 * <tr><th>Property</th><th>Type</th><th>Description</th><th>Default</th></tr>
		 * <tr><td><code>title</code></td><td>String</td><td>An optional title to display with the album item.</td><td>Empty string.</td></tr>
		 * <tr><td><code>description</code></td><td>String</td><td>An optional description to display with the album item.</td><td>Empty string.</td></tr>
		 * </table></p>
		 * 
		 * @return Returns a positive numeric id to identify which request triggers
		 *         the given callback, or <code>SpilGamesServices.INVALID_ID</code> when
		 *         the request fails immediately.
		 * 
		 * @see com.spilgames.api.SpilGamesServices#INVALID_ID SpilGamesServices.INVALID_ID
		 */
		public static function saveData(data:XML,
									options:Object = null,
									callback:Function = null):int
		{
			//make sure we are getting some XML data to write off
			if(!data){
				throw new Error("No XML data found to save.");
			}
			
			if (!options)
			{
				options = {};
			}
			
			//set defaults
			options.title = (options.hasOwnProperty(TITLE)) ? options.title : "";
			options.description = (options.hasOwnProperty(DESCRIPTION)) ? options.description : "";
			
			return SpilGamesServices.getInstance().send(DATASERVICE, "saveData", callback, {
				userName: User.getUserName(),
				userHash: User.getUserHash(),
				
				data: data,
				options: options
			});
		}
		/**
		 * Loads a data entry.
		 * 
		 * <p>A data entry is loaded from the portal, using a unique <code>dataID</code>.</p>
		 * 
		 * <p>An optional callback can be specified in order to receive the XML 
		 * returned from the request.</p>
		 * 
		 * @param dataID The dataID needed to retrieve what is stored on the portal.
		 * @param callback [optional] Function which handles any XML received from the server. 
		 * This callback is both used upon success or failure. The function must be defined as follows:
		 * <listing version="3.0">function functionName(callbackID:int, data:Object):void;</listing>
		 * <p>The <code>callbackID</code> argument is of type <code>int</code>
		 * and is used to identify the call that triggered the callback. This
		 * identifier is returned when you call the <code>loadData</code> method.</p>
		 * <p>The second argument is an Object that holds data retrieved
		 * from the service, or an error message.</p>
		 * <p>An example of a callback function:</p>
		 * <listing version="3.0">
		 * function myAddItemCallback(callbackID:int, data:Object):void
		 * {
		 *     if (!data.success)
		 *     {
		 *         trace(data.errorMessage);
		 *     }
		 *     else
		 *     {
		 *         // data.xml holds XML returned by the service
		 *         trace("data: " + data.xml);
		 *     }
		 * }
		 * </listing>
		 * 
		 * @return Returns a positive numeric id to identify which request triggers
		 *         the given callback, or <code>SpilGamesServices.INVALID_ID</code> when
		 *         the request fails immediately.
		 * 
		 * @see com.spilgames.api.SpilGamesServices#INVALID_ID SpilGamesServices.INVALID_ID
		 */
		public static function loadData(dataID:int, callback:Function):int
		{	
			return SpilGamesServices.getInstance().send(DATASERVICE, "loadData", callback,{
				dataID: dataID
			});
		}
		
		/**
		 * Loads a data entry for each on of the user's friends.
		 * 
		 * <p>An optional callback can be specified in order to receive the XML 
		 * returned from the request.</p>
		 * 
		 * @param callback [optional] Function which handles any XML received from the server. 
		 * This callback is both used upon success or failure. The function must be defined as follows:
		 * <listing version="3.0">function functionName(callbackID:int, data:Object):void;</listing>
		 * <p>The <code>callbackID</code> argument is of type <code>int</code>
		 * and is used to identify the call that triggered the callback. This
		 * identifier is returned when you call the <code>loadData</code> method.</p>
		 * <p>The second argument is an Object that holds data retrieved
		 * from the service, or an error message.</p>
		 * <p>An example of a callback function:</p>
		 * <p>If successful, the data object will have a <code>friendsData</code> property which is an array
		 * of UserData instances.</p>
		 * <listing version="3.0">
		 * function myAddItemCallback(callbackID:int, data:Object):void
		 * {
		 *     if (!data.success)
		 *     {
		 *         trace(data.errorMessage);
		 *     }
		 *     else
		 *     {
		 *         // data.xml holds XML returned by the service
		 *         trace("data uploaded: " + data.xml);
		 * 		   //or
		 * 		   trace("data: " + data.userData.data);
		 *     }
		 * }
		 * </listing>
		 * 
		 * @return Returns a positive numeric id to identify which request triggers
		 *         the given callback, or <code>SpilGamesServices.INVALID_ID</code> when
		 *         the request fails immediately.
		 * 
		 * @see com.spilgames.api.SpilGamesServices#INVALID_ID SpilGamesServices.INVALID_ID
		 */
		public static function loadFriendsData(callback:Function):int
		{
			var id:int = SpilGamesServices.getInstance().send(DATASERVICE, "loadFriendsData", loadFriendsDataCallback, {
				userName: User.getUserName(),
				userHash: User.getUserHash()
			});
			
			callbackIndex[id] = {callbackFunc: callback};
			
			return id;
		}
		
		/**
		 * Added to convert the gamatar feed to UserData instances.
		 * Adds the friendsData attibute to the data object, which is an array of UserData instances.
		 * It then invokes the actual callback that the developer passed in the loadFriendsData method.
		 **/
		private static function loadFriendsDataCallback(id:int, data:Object):void
		{
			if (callbackIndex[id])
			{
				if (data.success)
				{
					data.friendsData = [];
					var resultArr:XMLList = data.xml.result;
					
					for (var i:uint; i < resultArr.length(); i++)
					{
						data.friendsData.push(new UserData(resultArr[i]));
					}
				}
				
				callbackIndex[id].callbackFunc(id, data);
				delete callbackIndex[id];
			}
		}
		
		/**
		 * Retrieves the dataID of the save data, if any, for the current user for the current game.
		 * 
		 * <p>A dataID is retrieved from the portal.</p>
		 * 
		 * <p>An optional <code>targetUser</code> can be specified in order to retrieve a dataID of the 
		 * <code>targetUser</code>. In this way the save data for friends of the currrent user can also be loaded.</p>
		 * 
		 * @param callback Function which handles any XML received from the server. 
		 * This callback is both used upon success or failure. The function must be defined as follows:
		 * <listing version="3.0">function functionName(callbackID:int, data:Object):void;</listing>
		 * <p>The <code>callbackID</code> argument is of type <code>int</code>
		 * and is used to identify the call that triggered the callback. This
		 * identifier is returned when you call the <code>getDataID</code> method.</p>
		 * <p>The second argument is an Object that holds data retrieved
		 * from the service, or an error message.</p>
		 * <p>An example of a callback function:</p>
		 * <listing version="3.0">
		 * function myAddItemCallback(callbackID:int, data:Object):void
		 * {
		 *     if (!data.success)
		 *     {
		 *         trace(data.errorMessage);
		 *     }
		 *     else
		 *     {
		 *         // data.dataID holds dataID returned by the service
		 *         trace("dataID: " + data.dataID);
		 *     }
		 * }
		 * </listing>
		 * @param targetUser [optional] Returns the dataID of the targetUser.
		 * 
		 * @return Returns a positive numeric id to identify which request triggers
		 *         the given callback, or <code>SpilGamesServices.INVALID_ID</code> when
		 *         the request fails immediately.
		 * 
		 * @see com.spilgames.api.SpilGamesServices#INVALID_ID SpilGamesServices.INVALID_ID
		 */
		public static function getDataID(callback:Function, targetUser:String = ""):int
		{
			return SpilGamesServices.getInstance().send(DATASERVICE, "getDataID", callback, {
				userName: User.getUserName(),
				userHash: User.getUserHash(),
				targetUser: targetUser
			});
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
		 *           the DataService in your game:
		 * <listing version="3.0">
		 * import com.spilgames.api.DataService;
		 * 
		 * if ( DataService.isAvailable() )
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
			return SpilGamesServices.getInstance().isServiceAvailable(DATASERVICE);
		}
	}
}