// Copyright 2010 Spil Games BV
package com.spilgames.api
{
	import flash.display.MovieClip;
	
	/**
	 * The DateService provides the ability to retrieve the UTC time of the Spil
	 * Games servers.
	 * 
	 * <p>Some games depend on the current date (for example, a game that wants to display 
	 * a different level every day). When using the native <code>Date</code> class, the 
	 * time is read from the user's computer, meaning the user could easily cheat by 
	 * changing the date on their computer.</p>
	 * 
	 * <p>By using DateService, the game can retrieve the time on the Spil Games server,
	 * expressed as seconds since '00:00:00 1970-01-01 UTC'.</p>
	 * 
	 * @since 1.3
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @includeExample dateService_example1.as
	 */
	public class DateService extends MovieClip
	{
		// ====================================
		// CONSTANTS
		// ====================================
		
		private static const DATE	: String = "Date";
		
		// ====================================
		// STATIC METHODS
		// ====================================
		
		/**
		 * Submits a request to retrieve the Spil Games server time, expressed as
		 * seconds since '00:00:00 1970-01-01 UTC'.
		 * 
		 * @param callback [optional] Function which handles any data received from
		 *   the server. This callback is both used upon success or failure. The function must be defined as follows:
		 * <listing version="3.0">function functionName(callbackID:int, data:Object):void;</listing>
		 * <p>The <code>callbackID</code> argument is of type <code>int</code>
		 * and is used to identify the call which triggered the callback. This
		 * identifier is returned when you call the <code>getTime()</code> method.</p>
		 * <p>The second argument represents an Object that holds data retrieved
		 * from the service, or an error message.</p>
		 * <p>An example of a callback function:</p>
		 * <listing version="3.0">
		 * function myGetTimeCallback(callbackID:int, data:Object):void
		 * {
		 *     if (!data.success)
		 *     {
		 *         trace(data.errorMessage);
		 *     }
		 *     else
		 *     {
		 *         trace("Time received (in sec): " + data.args);
		 * 
		 *         var date:Date = new Date();
		 *         date.setTime(data.args &#42; 1000);
		 *         trace("Time received (date): " + date.toString());
		 *     }
		 * }
		 * </listing>
		 * 
		 * @return Returns a positive numeric id to identify which request calls
		 *   the given callback, or <code>SpilGamesServices.INVALID_ID</code> when
		 *   the request fails immediately.
		 * 
		 * @see com.spilgames.api.SpilGamesServices#INVALID_ID SpilGamesServices.INVALID_ID
		 */
		public static function getTime(callback:Function):int
		{
			return SpilGamesServices.getInstance().send(DATE, "getTime", callback);
		}
		
		/**
		 * @copy AlbumService#isAvailable()
		 * @example  The following code shows how to check the availability of
		 *           the DateService in your game:
		 * <listing version="3.0">
		 * import com.spilgames.api.DateService;
		 * 
		 * if ( DateService.isAvailable() )
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
			return SpilGamesServices.getInstance().isServiceAvailable(DATE);
		}
	}
}