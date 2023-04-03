// Copyright 2010 Spil Games BV
package com.spilgames.api
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	
	/**
	 * The AlbumService allows users to save images generated in the games on the Spil 
	 * Games network. Such an image will be added to the user's profile and can be rated 
	 * and commented on by other users. 
	 * 
	 * <p>Note that this service may not be available on every Spil Games network site 
	 * the game will be added to. Therefore your game should call 
	 * <code>AlbumService.isAvailable()</code> after SpilGamesServices is successfully 
	 * loaded, and initialize and display UI elements (i.e., buttons which say 'Save This Item') 
	 * based upon the returned value of this call.</p>
	 * 
	 * @since 1.3
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @see #isAvailable()
	 * 
	 * @includeExample albumService_example1.as
	 */
	public class AlbumService extends MovieClip
	{	
		// ====================================
		// CONSTANTS
		// ====================================
		
		private static const ALBUM	: String = "Album";
		
		// ====================================
		// STATIC METHODS
		// ====================================
		
		/**
		 * Adds a new item to the album.
		 * 
		 * <p>An album item consists of two BitmapData instances, a full image, and a 
		 * preview. The full image will be displayed on a Spil Games network site if a 
		 * user clicks on a preview displayed. These can optionally be accompanied by a 
		 * title and a brief description.</p>
		 * 
		 * <p>An optional callback can be specified in order to receive notifications 
		 * regarding the sent request.</p>
		 * 
		 * @param imageBitmapData The original BitmapData instance to be saved
		 * 	                      to the user's album (max. size: 640 x 480).
		 * @param previewBitmapData A preview or thumbnail of the image saved
		 * 	                        to the user's album (max. size: 320 x 240).
		 * @param callback [optional] Function which handles any data received from
		 *   the server. This callback is both used upon success or failure. The function must be defined as follows:
		 * <listing version="3.0">function functionName(callbackID:int, data:Object):void;</listing>
		 * <p>The <code>callbackID</code> argument is of type <code>int</code>
		 * and is used to identify the call that triggered the callback. This
		 * identifier is returned to the callback method you specify
		 * when you call the <code>submitScore</code> method. See myAddItemCallback below.</p>
		 * <p>The second argument is an Object that holds data retrieved
		 * from the service, or an error message.</p>
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
		 * 
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
		 *         // data.xml holds XML returned from the service
		 *         trace("image uploaded: " + data.xml);
		 *     }
		 * }
		 * </listing>
		 * @param options [optional] An object specifying data to be sent along with the
		 * 	image data, containing the following properties:
		 * <p><table class="innertable"> 
		 * <tr><th>Property</th><th>Type</th><th>Description</th><th>Default</th></tr>
		 * <tr><td><code>encodingQuality</code></td><td>Number</td><td>An optional setting of the JPEG encoding quality, in the
		 * range 0-100.</td><td>90</td></tr>
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
		public static function addItem(imageBitmapData:BitmapData, 
									   previewBitmapData:BitmapData,
									   callback:Function = null,
									   options:Object = null,
									   editingData:XML = null):int
		{
			if (!options)
			{
				options = {};
			}
			
			// Set defaults
			options.title = (options.hasOwnProperty( "title" )) ? options.title : "";
			options.description = (options.hasOwnProperty( "description" )) ? options.description : "";
			options.encodingQuality = (options.hasOwnProperty( "encodingQuality" )) ? parseInt(
				                       options.encodingQuality) : 90;
			
			return SpilGamesServices.getInstance().send(ALBUM, "addItem", callback, {
				userName: User.getUserName(),
				userHash: User.getUserHash(),
				imageBitmapData: imageBitmapData,
				previewBitmapData: previewBitmapData,
				editingData: editingData,
				options: options
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
		 *           the AlbumService in your game:
		 * <listing version="3.0">
		 * import com.spilgames.api.AlbumService;
		 * 
		 * if ( AlbumService.isAvailable() )
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
			return SpilGamesServices.getInstance().isServiceAvailable( ALBUM );
		}
		
	}
}