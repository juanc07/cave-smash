// Copyright 2010 Spil Games BV
package com.spilgames.bs.comps
{
	import com.spilgames.api.SpilGamesServices;
	import com.spilgames.bs.BrandingComponentTypes;
	import com.spilgames.bs.BrandingManager;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * The BrandLogo is used to display Spil Games network brand logos in game
	 * menus, in preloaders, actually wherever you would like to place
	 * a logo (and where Spil Games requires the placement of logos of course).	 
	 * 
	 * @since 1.3
	 * @langversion 3.0
	 * @playerversion Flash 10
	 */
	public class Logo extends MovieClip
	{
		// ====================================
		// PRIVATE VARS
		// ====================================
		
		/**
		 * 
		 */		
		private var _validated		: Boolean = true;
		
		/**
		 * 
		 */		
		private var _serverSideImplementation	: *;
		
		/**
		 *@private Deprecated property for internal API use only
		 * */
		private var _uniqueIdentifier	: String = "More_Games_Button_CustomButton";
		
		/**
		 * Creates a new instance of the SpilGamesLogoProxy.
		 */
		public function Logo()
		{
			if ( BrandingManager.getInstance() )
			{
				if ( !BrandingManager.getInstance().isReady() )
				{
					BrandingManager.getInstance().addEventListener(SpilGamesServices.COMPONENTS_READY,
						onComponentsReady, false, 0, true);
				}
				else
				{
					onComponentsReady(null);
				}
			}
		}
		
		/**
		 * @private
		 * */ 
		[Deprecated("For internal API use only")]
		public function get uniqueIdentifier():String
		{
			return _uniqueIdentifier;
		}

		/**
		 *@private
		 */ 
		[Deprecated("For internal API use only")]
		public function set uniqueIdentifier(value:String):void
		{
			if (_uniqueIdentifier != value)
			{
				_uniqueIdentifier = value;
			}
		}			
		
		/** 
		 * Setting the size of the branding logo has no effect. This method is solely
		 * provided to allow live preview components to be resized back upon scale/resize
		 * transformations in the Flash IDE.
		 * 
		 * @param w Width of the logo.
		 * @param h	Height of the logo.
		 */
		public function setSize(w:Number = 202, h:Number = 35):void
		{
			super.width = 202;
			super.height = 35;
			
			scaleX = scaleY = 1;
		}


		// ====================================
		// EVENT HANDLERS
		// ====================================
		
		/**
		 * @param event
		 */
		private function onComponentsReady(event:Event = null):void
		{
			if (BrandingManager.getInstance().isReady())
			{
				BrandingManager.getInstance().removeEventListener(
					SpilGamesServices.COMPONENTS_READY, onComponentsReady );
								
				// Remove all children
				var n:int = numChildren;
				while (--n > -1)
				{
					removeChildAt(0);
				}			
				
				_serverSideImplementation = addChild( BrandingManager.getInstance().createComponent(BrandingComponentTypes.LOGO) as MovieClip );			
							
				visible = true;
			}
		}
	}
}