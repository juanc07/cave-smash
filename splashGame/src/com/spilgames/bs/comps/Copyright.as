// Copyright 2010 Spil Games BV
package com.spilgames.bs.comps
{
	import com.spilgames.api.SpilGamesServices;
	import com.spilgames.bs.BrandingComponentTypes;
	import com.spilgames.bs.BrandingManager;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * The Spil Games copyright notice is used to display the 
	 * Spil Games copyright in game menus, in 
	 * pre-loaders and wherever else a copyright notice should be placed.
	 * 
	 * @private
	 * 
	 * @since 1.3
	 * @langversion 3.0
	 * @playerversion Flash 10
	 */
	public class Copyright extends MovieClip
	{
		// ====================================
		// PRIVATE VARS
		// ====================================
		
		private var _validated			: Boolean = true;
		private var _brandLogoImpl		: MovieClip;

		/**
		 * Creates a new instance of the Copyright notice.
		 */
		public function Copyright()
		{
			if ( BrandingManager.getInstance() )
			{
				if ( !BrandingManager.getInstance().isReady() )
				{
					BrandingManager.getInstance().addEventListener(
						SpilGamesServices.COMPONENTS_READY, onComponentsReady,
						false, 0, true);
				}
				else
				{
					onComponentsReady(null);
				}
			}
		}

		// ====================================
		// PUBLIC METHODS
		// ====================================
		
		/**
		 * Set the size of this control.
		 * 
		 * <p>Also sets the xScale and yScale properties to 1.</p>
		 * 
		 * @param w
		 * @param h
		 */
		public function setSize(w:Number, h:Number):void
		{
			super.width = w;
			super.height = h;
			
			scaleX = scaleY = 1;
			invalidateProperties();
		}
		
		/**
		 * Used to update this control on screen when a property is changed 
		 * 
		 * @see flash.display.Stage#invalidate
		 * @see #validateNow
		 */
		public function invalidateProperties():void
		{
			if (_validated)
			{
				if (stage)
				{
					addEventListener(Event.RENDER, validateNow);
					stage.invalidate();
				}
				else
				{
					addEventListener(Event.ENTER_FRAME, validateNow);
				}
				_validated = false;
			}
		}
		
		/**
		 * Sets the control as validated so it can be 
		 * updated onscreen via invalidateProperties
		 * 
		 * <p>For more information on the flex component lifecycle see
		 * http://livedocs.adobe.com/flex/3/html/help.html?content=ascomponents_advanced_2.html </p>
		 * 
		 * @param event
		 * @see #invalidateProperties
		 */
		public function validateNow(event:Event = null):void
		{
			removeEventListener(Event.RENDER, validateNow);
			removeEventListener(Event.ENTER_FRAME, validateNow);
			
			_validated = true;
		}

		// ====================================
		// EVENT HANDLERS
		// ====================================
		
		/**
		 * @param event
		 */
		private function initialize(event:Event = null):void
		{
			removeEventListener(Event.RENDER, initialize);
		}
		
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
				
				addChild( BrandingManager.getInstance().createComponent(BrandingComponentTypes.COPYRIGHT) as MovieClip );			
							
				visible = true;
			}
		}
		
		/**
		 * @param event
		 */		
		private function onLocaleChanged(event:Event):void
		{
			invalidateProperties();
		}
		
	}
}