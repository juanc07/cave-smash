// Copyright 2010 Spil Games BV
package com.spilgames.api
{
	import flash.display.MovieClip;
	
	/**
	 * ScoreService provides a convenient interface for submitting scores to
	 * Spil games portals
	 * 
	 * @since 1.3
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @includeExample scoreService_example1.as
	 */
	public class ScoreService extends MovieClip
	{
		// ====================================
		// CLASS CONSTANTS
		// ====================================
		
		private static const SCORE	: String = "Score";
		
		// ====================================
		// STATIC METHODS
		// ====================================
		
		/**
		 * Submits a score to the Spil Games highscore service.
		 * 
		 * <p>An optional callback can be specified in order to receive
		 * notifications and data regarding the sent request.</p>
		 * 
		 * @param score A numeric (<code>uint</code>, <code>int</code> or
		 *              <code>Number</code>) value for the score the user achieved.
		 * @param callback [optional] Function which handles any data received from
		 *   the server. This callback is both used upon success or failure. The function must be defined as follows:
		 * <listing version="3.0">function functionName(callbackID:int, data:Object):void;</listing>
		 * <p>The <code>callbackID</code> argument is of type <code>int</code>
		 * and is used to identify the call which triggered the callback. This
		 * identifier is returned when you call the <code>submitScore</code> method.</p>
		 * <p>The second returned object, <code>data</code> is of type <code>Object</code>
		 * and contains the following parameters: </p>
		 * 
		 * <p><table class="innertable"> 
		 * <tr><th>Property</th><th>Type</th><th>Description</th></tr>
		 * <tr><td><code>success</code></td><td>Boolean</td><td>Indicates whether the attempted score submission was successful or not</td></tr>
		 * <tr><td><code>xml</code></td><td>XML</td><td>The xml data which is associated with the successful score submission</td></tr>
		 * </table></p>
		 * <p>An example of a callback function:</p>
		 * <listing version="3.0">
		 * function mySubmitScoreCallback(callbackID:int, data:Object):void
		 * {
		 *     if (!data.success)
		 *     {
		 *         trace(data.errorMessage);
		 *     }
		 *     else
		 *     {
		 *         // data.xml holds XML returned from the service
		 *         trace("Score submitted: " + data.xml);
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
		public static function submitScore(score:Object, callback:Function = null):int
		{
			return SpilGamesServices.getInstance().send(SCORE, "submitScore", callback, {
					score: score,
					userName: User.getUserName(),
					userHash: User.getUserHash()
				});
		}
		
		/**
		 * @copy AlbumService#isAvailable()
		 * @example  The following code shows how to check the availability of
		 *           the ScoreService in your game:
		 * <listing version="3.0">
		 * import com.spilgames.api.ScoreService;
		 * 
		 * if ( ScoreService.isAvailable() )
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
			return SpilGamesServices.getInstance().isServiceAvailable(SCORE);
		}
		
	}
}