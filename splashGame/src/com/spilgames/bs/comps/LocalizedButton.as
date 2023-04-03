package com.spilgames.bs.comps
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * This class is a simple extension of LocalizedTextField which is supplied with between 1 and 3
	 * visual objects which define the states of a simple button {normal, over and hit}.
	 * 
	 * <p>
	 * A callback function may also be added in the constructor.
	 * </p>
	 * 
	 * @private
	 * 
	 * @author Paul Jones
	 * @since 1.3
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * */	
	public class LocalizedButton extends LocalizedTextField
	{
		// ====================================
		// PRIVATE VARS
		// ====================================
		/**
		 * A Display object set by the developer for the normal 
		 * */
		private var _normalState			: Sprite;
		
		/**
		 * A Display object set by the developer for the overstate of the localizedButton 
		 * */
		private var _overState				: Sprite;
		
		/**
		 * A Display object set by the developer for the hitState of the localizedButton 
		 * */
		private var _hitState				: Sprite;
		
		/**
		 * The function to be called when this button is clicked
		 * */
		private var _callback				: Function;
		
		/**
		 * The unique identifier for use when replacing client version of the branding
		 * components with their server counterparts
		 * */
		public var identifier				: String = "LocalizedButton";
		
		
		public function LocalizedButton(text:String, normalState:Sprite = null, overState:Sprite = null, 
										hitState:Sprite = null, callbackFunction:Function = null)
		{
			super();
			
			//Set as Button in Superclass so we don't 
			//lose visual elements of button
			super.isButton = true;
			super.mouseEnabled = false;
			
			if(normalState)
				_normalState = normalState;
			
			if(overState)
				_overState = overState;
			
			if(hitState)
				_hitState = hitState;
			
			if(callbackFunction != null)
				_callback = callbackFunction;
			
			addChild(_normalState);
			
			if(_normalState)
			{
				_normalState.mouseChildren = false;
				_normalState.addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
				_normalState.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			}
			
			super.text = text;
			super.languageBundle = "SpilGames_Internal";
			super.fontName = "myriad pro";
			buttonMode = true;
			
			addEventListener(MouseEvent.CLICK, onClick);
		}
		
		/**
		 * The language bundle to extract the localized text from.
		 * 
		 * <p>There are two main language bundles. One for branding and default
		 * texts defined by SpilGames called 'SpilGames_Internal'. And one game
		 * specific bundle provided by the game developer named 'SpilGames_Game'. 
		 * A translation must have been added to the SpilGames games configuration
		 * service before it will show the translations.</p>
		 * 
		 * <p>Possible Bundles:</p>
		 * <p><ul>
		 * <li>SpilGames_Game</li>
		 * <li>SpilGames_Internal</li>
		 * </ul></p>
		 * 
		 * @default SpilGames_Game
		 */
		[Inspectable(name="languageBundle", enumeration="SpilGames_Game, SpilGames_Internal", defaultValue="SpilGames_Game")]
		override public function set languageBundle(value:String):void
		{
			if(super.languageBundle != value)
				super.languageBundle = value;
		}
		
		/**
		 * The name of the Font to be used for text display.
		 * 
		 * <p>The font with the given name must be embedded in your game in order
		 * to be displayed correctly.</p>
		 * 
		 * @default ""
		 * @example To verify if the font is embedded correctly, you can use
		 *          the following code:
		 * 
		 * <listing version="3.0">
		 * var embeddedFonts:Array = Font.enumerateFonts();
		 * for (var i:int = 0; i &lt; embeddedFonts.length; ++i)
		 * {
		 *     trace(embeddedFonts[i].fontName);
		 * }
		 * </listing> 
		 */
		[Inspectable(name="fontName", defaultValue="Arial")]
		override public function set fontName(value:String):void
		{
			if (super.fontName != value)
			{
				super.fontName = value;
			}
		}
		
		/**
		 * @param evt
		 * */
		private function onClick(evt:MouseEvent):void
		{
			_callback();
		}
		
		/**
		 * @param evt
		 * */
		private function mouseOver(evt:MouseEvent):void 
		{
			_normalState.addChild(_overState);
		}
		
		/**
		 * @param evt
		 * */
		private function mouseOut(evt:MouseEvent):void
		{
			_normalState.removeChild(_overState);
		}
	}
}