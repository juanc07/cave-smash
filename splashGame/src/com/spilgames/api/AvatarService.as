// Copyright 2010 Spil Games BV
package com.spilgames.api
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;

	/**
	 * The AvatarService allows users to save and load images generated in the games as avatars on the Spil Games network.
	 * 
	 * @since 1.3
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @includeExample avatarService_example1.as
	 * @includeExample avatarService_example2.as
	 */
	public class AvatarService extends MovieClip
	{
		// ====================================
		// CLASS CONSTANTS
		// ====================================
		
		private static const AVATAR				: String = "Avatar";
		private static const ENCODING_QUALITY	: String = "encodingQuality";
		private static const TITLE				: String = "title";
		private static const DESCRIPTION		: String = "description";
		
		// ====================================
		// STATIC METHODS
		// ====================================
		
		/**
		 * Encodes a raw DisplayObject instance into JPEG data and stores the output
		 * data on the server.
		 * 
		 * <p>If you want to save a BitmapData instance instead, then use the
		 * <code>saveBitmapData()</code> method.</p>
		 * 
		 * @param drawable    The DisplayObject source object to encode into JPEG.
		 * @param editingData [optional] XML data that holds the associated game/avatar 
		 *                    state.
		 * @param options [optional] An Object specifying data to be send along with the
		 * 	              image data, containing the following properties:
		 * <p><table class="innertable"> 
		 * <tr><th>Property</th><th>Type</th><th>Description</th><th>Default</th></tr>
		 * <tr><td><code>encodingQuality</code></td><td>Number</td><td>An optional setting of the JPEG encoding quality, in the
		 * range 0-100.</td><td>90</td></tr>
		 * <tr><td><code>title</code></td><td>String</td><td>An optional title to display with the avatar item.</td><td>Empty string.</td></tr>
		 * <tr><td><code>description</code></td><td>String</td><td>An optional description to display with the avatar item.</td><td>Empty string.</td></tr>
		 * </table></p>
		 * @param callback [optional] Function which handles any data received from
		 *   the server. This callback is both used upon success or failure. The function must be defined as follows:
		 * <listing version="3.0">function functionName(callbackID:int, data:Object):void;</listing>
		 * <p>The <code>callbackID</code> argument is of type <code>int</code>
		 * and is used to identify the call which triggered the callback. This
		 * identifier is returned when you call the <code>saveDrawable</code> method.</p>
		 * <p>The second returned object, <code>data</code> is of type <code>Object</code>
		 * and contains the following parameters: </p>
		 * 
		 * <p><table class="innertable"> 
		 * <tr><th>Property</th><th>Type</th><th>Description</th></tr>
		 * <tr><td><code>success</code></td><td>Boolean</td><td>Indicates whether the attempted upload was successful or not</td></tr>
		 * <tr><td><code>errorMessage</code></td><td>String</td><td>Describes the reason for a failed upload in the event <code>success</code> is <code>false</code></td></tr>
		 * <tr><td><code>xml</code></td><td>XML</td><td>The xml data which is associated with the successful upload</td></tr>
		 * </table></p>
		 * 
		 * <p>An example of a callback function:</p>
		 * <listing version="3.0">
		 * function mySaveDrawableCallback(callbackID:int, data:Object):void
		 * {
		 *     if (!data.success)
		 *     {
		 *         trace(data.errorMessage);
		 *     }
		 *     else
		 *     {
		 *         // data.xml holds XML returned from the service
		 *         trace("Drawable saved: " + data.xml);
		 *     }
		 * }
		 * </listing>
		 * 
		 * @return A positive numeric id to identify which request triggers
		 *   the given callback, or <code>SpilGamesServices.INVALID_ID</code> when
		 *   the request fails immediately.
		 * 
		 * @see flash.display.DisplayObject
		 * @see #saveBitmapData()
		 * @see com.spilgames.api.SpilGamesServices#INVALID_ID SpilGamesServices.INVALID_ID
		 */
		public static function saveDrawable(drawable:DisplayObject,
											editingData:XML = null,
											options:Object = null,
											callback:Function = null):int
		{
			if (!editingData)
			{
				editingData =
					<DATA>
						<NOCONTENT>This image has no data submitted.</NOCONTENT>
					</DATA>;
			}
			
			if (!options)
			{
				options = {};
			}
			
			
			// Set defaults
			options.encodingQuality = (options.hasOwnProperty(ENCODING_QUALITY)) ? options.encodingQuality : 90;
			options.title = (options.hasOwnProperty(TITLE)) ? options.title : "";
			options.description = (options.hasOwnProperty(DESCRIPTION)) ? options.description : "";
			
			return SpilGamesServices.getInstance().send(AVATAR, "addAvatar", callback, {
				userName: User.getUserName(),
				userHash: User.getUserHash(),
				displayObject: drawable,
				editingData: editingData,
				options: options
			});
		}
		
		/**
		 * Encodes a BitmapData instance into JPEG data and stores the output
		 * data on the server.
		 * 
		 * <p>If you want to save a DisplayObject (subclass) instance instead, then use the
		 * <code>saveDrawable()</code> method.</p>
		 * 
		 * @param bitmapData  The BitmapData source object to encode into JPEG.
		 * @param editingData [optional] XML data used to save a game status or to (re)construct
		 *                    the other user data components.
		 * @param options [optional] An Object specifying data to be send along with the
		 * 	              image data, containing the following properties:
		 * <p><table class="innertable"> 
		 * <tr><th>Property</th><th>Type</th><th>Description</th><th>Default</th></tr>
		 * <tr><td><code>encodingQuality</code></td><td>Number</td><td>An optional setting of the JPEG encoding quality, in the
		 * range 0-100.</td><td>90</td></tr>
		 * <tr><td><code>title</code></td><td>String</td><td>An optional title to display with the avatar item.</td><td>Empty string.</td></tr>
		 * <tr><td><code>description</code></td><td>String</td><td>An optional description to display with the avatar item.</td><td>Empty string.</td></tr>
		 * </table></p>
		 * @param callback [optional] Function which handles any data received from
		 *   the server. This callback is both used upon success or failure. The function must be defined as follows:
		 * <listing version="3.0">function functionName(callbackID:int, data:Object):void;</listing>
		 * <p>The <code>callbackID</code> argument is of type <code>int</code>
		 * and is used to identify the call which triggered the callback. This
		 * identifier is returned when you call the <code>saveBitmapData</code> method.</p>
		  <p>The second returned object, <code>data</code> is of type <code>Object</code>
		 * and contains the following parameters: </p>
		 * 
		 * <p><table class="innertable"> 
		 * <tr><th>Property</th><th>Type</th><th>Description</th></tr>
		 * <tr><td><code>success</code></td><td>Boolean</td><td>Indicates whether the attempted upload was successful or not</td></tr>
		 * <tr><td><code>errorMessage</code></td><td>String</td><td>Describes the reason for a failed upload in the event <code>success</code> is <code>false</code></td></tr>
		 * <tr><td><code>xml</code></td><td>XML</td><td>The xml data which is associated with the successful upload</td></tr>
		 * </table></p>
		 * <p>An example of a callback function:</p>
		 * <listing version="3.0">
		 * function mySaveBitmapDataCallback(callbackID:int, data:Object):void
		 * {
		 *     if (!data.success)
		 *     {
		 *         trace(data.errorMessage);
		 *     }
		 *     else
		 *     {
		 *         // data.xml holds XML returned from the service
		 *         trace("BitmapData saved: " + data.xml);
		 *     }
		 * }
		 * </listing>
		 * 
		 * @return A positive numeric id to identify which request triggers
		 *   the given callback, or <code>SpilGamesServices.INVALID_ID</code> when
		 *   the request fails immediately.
		 * 
		 * @see flash.display.BitmapData
		 * @see #saveDrawable()
		 * @see com.spilgames.api.SpilGamesServices#INVALID_ID SpilGamesServices.INVALID_ID
		 */
		public static function saveBitmapData(bitmapData:BitmapData,
			                                  editingData:XML = null,
											  options:Object = null,
											  callback:Function = null):int
		{
			if (!editingData)
			{
				editingData = new XML(
					<DATA>
						<NOCONTENT>This image has no data submitted.</NOCONTENT>
					</DATA>);
			}
			
			if (!options)
			{
				options = {};
			}
			
			// Set defaults
			options.encodingQuality = (options.hasOwnProperty(ENCODING_QUALITY)) ? options.encodingQuality : 90;
			options.title = (options.hasOwnProperty(TITLE)) ? options.title : "";
			options.description = (options.hasOwnProperty(DESCRIPTION)) ? options.description : "";
			
			return SpilGamesServices.getInstance().send(AVATAR, "addAvatar", callback, {
				userName: User.getUserName(),
				userHash: User.getUserHash(),
				bitmapData: bitmapData,
				editingData: editingData,
				options: options
			});
		}
		
		/**
		 * Loads image metadata for an avatar.
		 * 
		 * @param avatarID The numeric avatar id, which can be obtained with
		 *                 <code>getActiveAvatarID()</code>.
		 * @param callback [optional] Function which handles any data received from
		 *   the server. This callback is both used upon success or failure. The function must be defined as follows:
		 * <listing version="3.0">function functionName(callbackID:int, data:Object):void;</listing>
		 * <p>The <code>callbackID</code> argument is of type <code>int</code>
		 * and is used to identify the call which triggered the callback. This
		 * identifier is returned when you call the <code>loadEditingData</code> method.</p>
		  <p>The second returned object, <code>data</code> is of type <code>Object</code>
		 * and contains the following parameters: </p>
		 * 
		 * <p><table class="innertable"> 
		 * <tr><th>Property</th><th>Type</th><th>Description</th></tr>
		 * <tr><td><code>success</code></td><td>Boolean</td><td>Indicates whether the attempted upload was successful or not</td></tr>
		 * <tr><td><code>errorMessage</code></td><td>String</td><td>Describes the reason for a failed upload in the event <code>success</code> is <code>false</code></td></tr>
		 * <tr><td><code>xml</code></td><td>XML</td><td>The xml data which is associated with the successful upload</td></tr>
		 * </table></p>
		 * <p>An example of a callback function:</p>
		 * <listing version="3.0">
		 * function myloadEditingDataCallback(callbackID:int, data:Object):void
		 * {
		 *     if (!data.success)
		 *     {
		 *         trace(data.errorMessage);
		 *     }
		 *     else
		 *     {
		 *         // data.xml holds XML returned from the service
		 *         trace("Avatar data: " + data.xml);
		 *     }
		 * }
		 * </listing>
		 * @return A positive numeric id to identify which request triggers
		 *   the given callback, or <code>SpilGamesServices.INVALID_ID</code> when
		 *   the request fails immediately.
		 * 
		 * @see #getActiveAvatarID()
		 * @see com.spilgames.api.SpilGamesServices#INVALID_ID SpilGamesServices.INVALID_ID
		 */
		public static function loadEditingData(avatarID:int, callback:Function):int
		{
			return SpilGamesServices.getInstance().send(AVATAR, "loadAvatarData", callback, {
				avatarID: avatarID
			});
		}
		
		/**
		 * Loads the image data for an avatar.
		 * 
		 * @param avatarID The numeric avatar id, which can be obtained with
		 *                 <code>getActiveAvatarID()</code> for the current user or via the <code>FriendService</code>
		 * 					for avatars of friends.
		 * @param callback [optional] Function which handles any data received from
		 *   the server. This callback is both used upon success or failure. The function must be defined as follows:
		 * <listing version="3.0">function functionName(callbackID:int, data:Object):void;</listing>
		 * <p>The <code>callbackID</code> argument is of type <code>int</code>
		 * and is used to identify the call which triggered the callback. This
		 * identifier is returned when you call the <code>loadAvatar</code> method.</p>
		  <p>The second returned object, <code>data</code> is of type <code>Object</code>
		 * and contains the following parameters: </p>
		 * 
		 * <p><table class="innertable"> 
		 * <tr><th>Property</th><th>Type</th><th>Description</th></tr>
		 * <tr><td><code>success</code></td><td>Boolean</td><td>Indicates whether the attempted load was successful or not</td></tr>
		 * <tr><td><code>bitmapData</code></td><td>BitmapData</td><td>The requested Avatar image</td></tr>
		 * </table></p>
		 * <p>An example of a callback function:</p>
		 * <listing version="3.0">
		 * function loadAvatarCallback(callbackID:int, data:Object):void
		 * {
		 *     if (!data.success)
		 *     {
		 *         trace(data.errorMessage);
		 *     }
		 *     else
		 *     {
		 *         // data.bitmapData holds the avatar's BitmapData
		 *         trace("BitmapData returned: " + data.bitmapData);
		 *     }
		 * }
		 * </listing>
		 * @return A positive numeric id to identify which request triggers
		 *   the given callback, or <code>SpilGamesServices.INVALID_ID</code> when
		 *   the request fails immediately.
		 * 
		 * 
		 * 
		 * @see #getActiveAvatarID()
		 * @see com.spilgames.api.SpilGamesServices#INVALID_ID SpilGamesServices.INVALID_ID
		 */
		public static function loadAvatar(avatarID:int, callback:Function):int
		{
			return SpilGamesServices.getInstance().send(AVATAR, "loadAvatar", callback, {
				avatarID: avatarID
			});
		}
		
		/**
		 * Retrieves the active avatar id and returns it to the callback function supplied.
		 * 
		 * @param callback Function to which the active user's avatar data is returned.   
		 * 
		 * This callback is both used upon success or failure. The function must be defined as follows:
		 * <listing version="3.0">function functionName(callbackID:int, data:Object):void;</listing>
		 * <p>The <code>callbackID</code> argument is of type <code>int</code>
		 * and is used to identify the call which triggered the callback. This
		 * identifier is returned when you call the <code>loadAvatar</code> method.</p>
		 * <p>The second returned object, <code>data</code> is of type <code>Object</code>
		 * and contains the following parameters: </p>
		 * 
		 * <p><table class="innertable"> 
		 * <tr><th>Property</th><th>Type</th><th>Description</th></tr>
		 * <tr><td><code>success</code></td><td>Boolean</td><td>Indicates whether the attempted call was successful or not</td></tr>
		 * <tr><td><code>data</code></td><td>Object</td><td>Data returned from the server</td></tr>
		 * </table></p>
		 * 
		 * <p>The second returned object, <code>data</code> is of type <code>Object</code>
		 * and contains the following parameters: </p>
		 * 
		 * <p><table class="innertable"> 
		 * <tr><th>Property</th><th>Type</th><th>Description</th></tr>
		 * <tr><td><code>success</code></td><td>Boolean</td><td>Indicates whether the attempted load was successful or not</td></tr>
		 * <tr><td><code>xml</code></td><td>XML</td><td>The data returned from the server</td></tr>
		 * </table></p>
		 * 
		 * <p>An example of a callback function:</p>
		 * <listing version="3.0">
		 * function loadAvatarCallback(callbackID:int, data:Object):void
		 * {
		 *     if (!data.success)
		 *     {
		 *         trace(data.errorMessage);
		 *     }
		 *     else
		 *     {
		 *         // data.xml holds XML returned from the service
		 *         trace("User Avatar Data: " + data.xml);
		 *     }
		 * }
		 * </listing>
		 * 
		 * The following is an example of the xml data returned to data.xml
		 * <p></p>
		 * <code>
		 * &lt;profilar&gt;
  		 *		&lt;authenticate&gt;be9fdeb7aa00dba7dfca67e023bb29361676f0bed0e5bcc60812032e93581a0564657675617c31333230333938373632&lt;/authenticate&gt;
  		 *		<p>&lt;getprefs&gt;</p>
		 * 		<p>
         *		&lt;username&gt;devua&lt;/username&gt;
    	 *			&lt;avatar&gt;290&lt;/avatar&gt;
		 *    </p>
  		 *		<p>&lt;/getprefs&gt;</p>
		 * <p>
		 *	&lt;/profilar&gt;
		 * </p>
		 * </code>
		 */
		public static function getActiveAvatarID(callback:Function):int
		{
			return SpilGamesServices.getInstance().send(AVATAR, "getAvatarID", callback, {
					outputType: "xml"
				});
		}
		
		/**
		 * @copy AlbumService#isAvailable()
		 * @example  The following code shows how to check the availability of
		 *           the AvatarService in your game:
		 * <listing version="3.0">
		 * import com.spilgames.api.AvatarService;
		 * 
		 * if ( AvatarService.isAvailable() )
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
			return SpilGamesServices.getInstance().isServiceAvailable(AVATAR);
		}
		
	}
}