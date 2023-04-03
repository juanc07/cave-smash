// Copyright 2010 Spil Games BV
package com.spilgames.api
{
	import flash.display.MovieClip;
	
	/**
	 * The AwardsService provides an easy-to-use interface to notify the 
	 * Spil Games services when a player receives an award in your game. 
	 * Awards are specified in the translation Excel file completed and returned
	 * to your Spil contact. These are set on the Spil backend and associated 
	 * with your game. Five awards are set per game and usually use awardTags
	 * <code>award1</code>, <code>award2</code>, <code>award3</code>, <code>award4</code>, <code>award5</code>
	 * 
	 * <p> When an award is successfully unlocked it will be displayed in an award 
	 * widget on the page outside of your game.</p>
	 *  
	 * 
	 * 
	 * @since 1.3
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @includeExample awardsService_example1.as
	 */
	public class AwardsService extends MovieClip
	{
		// ====================================
		// CLASS CONSTANTS
		// ====================================
		
		private static const AWARDS	: String = "Awards";
		
		// ====================================
		// STATIC METHODS
		// ====================================
		
		/**
		 * Notifies the Spil Games services that the user has received an award in your
		 * game. Once an award is submitted an optional callback can be specified in order to receive
		 * notifications and data regarding the sent request.
		 * 
		 * @param awardTag A String value specifying the award the user has achieved. This
		 *   tag <b>must</b> correspond to a tag name as set in the developer agreement in
		 *   order for it to work correctly.
		 * @param callback [optional] Function that handles any data received from the server. 
		 * This callback is used upon both success and failure. The function must be defined as follows:  
		 * <listing version="3.0">function functionName(callbackID:int, data:Object):void;</listing>
		 * <p>The <code>callbackID</code> argument is of type <code>int</code>
		 * and is used to identify the call that triggered the callback. This
		 * identifier is returned when you call <code>submitAward</code>, for example.</p>
		 * 
		 * <p>The second returned object, <code>data</code> is of type <code>Object</code>
		 * and contains the following parameters: </p>
		 * 
		 * <p><table class="innertable"> 
		 * <tr><th>Property</th><th>Type</th><th>Description</th></tr>
		 * <tr><td><code>success</code></td><td>Boolean</td><td>Indicates whether the attempted award unlock was successful or not</td></tr>
		 * <tr><td><code>errorMessage</code></td><td>String</td><td>Describes the reason for a failed upload in the event <code>success</code> is <code>false</code></td></tr>
		 * <tr><td><code>xml</code></td><td>XML</td><td>The xml data which is associated with the successfully unlocked award</td></tr>
		 * </table></p>
		 * 
		 * <p>An example of a callback function:</p>
		 * <listing version="3.0">
		 * function mySubmitAwardCallback(callbackID:int, data:Object):void
		 * {
		 *     if (!data.success)
		 *     {
		 *         trace(data.errorMessage);
		 *     }
		 *     else
		 *     {
		 *         // data.xml holds XML returned from the service
		 *         trace("Award submitted: " + data.xml);
		 *     }
		 * }
		 * </listing>
		 * 
		 * @return Returns a positive numeric id to identify which request triggers
		 *   the given callback, or <code>SpilGamesServices.INVALID_ID</code> when
		 *   the request fails immediately.
		 * 
		 * @see com.spilgames.api.SpilGamesServices#INVALID_ID SpilGamesServices.INVALID_ID
		 */
		public static function submitAward(awardTag:Object,
										   callback:Function = null):int
		{
			return SpilGamesServices.getInstance().send(AWARDS, "submitAward", callback, {
					tag:awardTag,
					userName:User.getUserName(),
					userHash:User.getUserHash()
				});
		}
		
		/**
		 * @copy AlbumService#isAvailable()
		 * @example  The following code shows how to check the availability of
		 *           the AwardsService in your game:
		 * <listing version="3.0">
		 * import com.spilgames.api.AwardsService;
		 * 
		 * if ( AwardsService.isAvailable() )
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
			return SpilGamesServices.getInstance().isServiceAvailable(AWARDS);
		}
	}
}