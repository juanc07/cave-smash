// Copyright 2010 Spil Games BV
package com.spilgames.bs.comps
{
	import com.spilgames.api.SpilGamesServices;
	import com.spilgames.bs.BrandingComponentTypes;
	import com.spilgames.bs.BrandingManager;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * The LanguageSelect class allows users to select a locale to be used in game, 
	 * based on which locales are available for the game. 
	 * 
	 * <p>The LanguageSelect component acts as a placement component for the actual 
	 * component. The actual component is loaded from the Spil Games network and 
	 * will replace the instances of this class. You can see this class as a proxy 
	 * class.</p>
	 * 
	 * @since 1.3
	 * @langversion 3.0
	 * @playerversion Flash 10
	 */
	public class LanguageSelect extends MovieClip
	{
		// ====================================
		// CLASS CONSTANTS
		// ====================================
		
		/**
		 * Constant indicating the up direction for the dropdown.
		 */		
		public static const DROP_DOWN_DIRECTION_UP		: String = "up";
		
		/**
		 * Constant indicating the down direction for the dropdown.
		 */		
		public static const DROP_DOWN_DIRECTION_DOWN	: String = "down";
		
		// ====================================
		// GETTER/SETTER
		// ====================================
		
		private var _implementation	: MovieClip;
		private var _direction		: String = DROP_DOWN_DIRECTION_UP;
		/**
		 * The direction of the language dropdown.
		 * 
		 * <p>After the components are ready changing the direction has no effect.</p>
		 * 
		 * @default "up"
		 * @internal Used in CloneProperties. Do not just change the name of the function.
		 */
		[Inspectable(name="direction", type="list", enumeration="up,down", defaultValue="up")]
		public function set direction(value:String):void
		{
			if (_direction != value)
			{
					_direction = value;
					if (_implementation)
					{
						_implementation.direction = _direction;
					}
			}
		}
		
		public function get direction():String
		{
			return _direction;
		}
		
		/**
		 * @internal Overriden, since resizing of the combo box is not provided.
		 * @inheritDoc
		 */
		override public function set width(value:Number):void
		{
			setSize();
		}
		
		/**
		 * @internal Overriden, since resizing of the combo box is not provided.
		 * @inheritDoc
		 */
		override public function set height(value:Number):void
		{
			setSize();
		}
		
		/**
		 * Creates a new LanguageSelect.
		 */
		public function LanguageSelect()
		{			
			initConstructor();
		}
		
		// ====================================
		// PUBLIC METHODS
		// ====================================
		
		/**
		 * Resizing the combo box does not have any effect.
		 * 
		 * @param w Width of the combobox.
		 * @param h Height of the combobox.
		 */
		public function setSize(w:Number = 151, h:Number = 21):void
		{
			super.width = 151;
			super.height = 21;
			
			scaleX = scaleY = 1;
		}
		
		// ====================================
		// PRIVATE METHODS
		// ====================================
		
		/**
		 * 
		 */		
		private function initConstructor():void
		{
			if ( BrandingManager.getInstance() )
			{
				if ( !BrandingManager.getInstance().isReady() )
				{
					BrandingManager.getInstance().addEventListener(
						SpilGamesServices.COMPONENTS_READY, onComponentsReady, false, 0, true);
				}
				else
				{
					onComponentsReady(null);
				}
			}	
		}
		
		/**
		 * Initialize the language select proxy.
		 */		
		private function initialize():void
		{
			
		}
		
		// ====================================
		// EVENT HANDLERS
		// ====================================
		
		/**
		 * @param event
		 */		
		private function onRender(event:Event = null):void
		{
			removeEventListener(Event.RENDER, onRender);
			initialize();
		}
		
		/**
		 * @param event
		 */		
		private function onAddedToStage(event:Event = null):void
		{
			addEventListener(Event.RENDER, onRender);
			initialize();
		}
		
		/**
		 * @param event
		 */		
		private function onComponentsReady(event:Event = null):void
		{
			if (BrandingManager.getInstance().isReady())
			{
				BrandingManager.getInstance().removeEventListener( SpilGamesServices.COMPONENTS_READY, onComponentsReady );

				// Remove all children
				while (numChildren)
				{
					removeChildAt(0);
				}

				_implementation = addChild( BrandingManager.getInstance().createComponent(BrandingComponentTypes.LANGUAGE_SELECTOR) as MovieClip ) as MovieClip;			

				// update/clone properties from this object to the New BrandLanguageSelect object.
				if (_implementation && _implementation.hasOwnProperty("cloneProperties") )
				{
					_implementation["cloneProperties"](this);
				}
				
				visible = true;
			}
		}
		
	}
}