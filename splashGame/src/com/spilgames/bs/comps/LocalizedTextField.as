// Copyright 2010 Spil Games BV
package com.spilgames.bs.comps
{
	import com.spilgames.api.SpilGamesServices;
	import com.spilgames.bs.BrandingComponentTypes;
	import com.spilgames.bs.BrandingManager;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	/**
	 * Use this object like a normal textfield, setting the text property to a given
	 * key between {} braces (e.g. {MyLocalizedString}) and it will display the given 
	 * word or phrase in the language currently set, or selected by the user in a LanguageSelect
	 * object.
	 * 
	 * <p>
	 * The translations are retrieved from the localization file which should be provided
	 * by your Spil contact once you've submitted a localization request. Please get in touch
	 * with your contact at Spil Games or visit http://www.spilgames.com/developers for more inforamation.
	 * </p>
	 * 
	 * <p>This class requires your game to target Flash Player 10 or higher.
	 * It utilises the Text Layout Framework from the Flex 4 SDK and your application
	 * must have the provided <code>textLayout.swc</code> library available in its
	 * library path.</p>
	 * 
	 * <p>To make use of embedded fonts you need to create a Flex SDK 4 embedded font
	 * SWC and link that SWC to your Flash CS4 application. SpilGames provides a set of
	 * precompiled fonts which can be used for linkage.</p>
	 * 
	 * @since 1.3
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @see http://help.adobe.com/en_US/as3/dev/WSb2ba3b1aad8a27b0-1b8898a412218ad3df9-8000.html Text Layout Framework
	 */
	public class LocalizedTextField extends MovieClip
	{
		// ====================================
		// TRANSLATION CONSTANTS
		// ====================================
		
		/**
		 * A constant which defines the identifier for the localized String "More Games" 
		 * */
		public static const MORE_GAMES		: String = "{moregames}";
		
		/**
		 * A constant which defines the identifier for the localized String "Start Game" 
		 * */
		public static const START_GAME		: String = "{btn_startgame}";
		
		// ====================================
		// CLASS CONSTANTS
		// ====================================
		
		/**
		 * Space between the bounds of the AutoTextField and the bounds of the inner
		 * used TextField.
		 * 
		 * <p>For performance reasons the value is actually twice the padding size.</p>
		 */
		private static const PADDING		: int = 4;
		
		/**
		 * The maximum number of lines to be displayed.
		 * 
		 * <p>We set this, since we want to know if the text displayed is
		 * being truncated, so we can size down if needed.</p>
		 */
		public static const MAX_NUM_LINES	: int = 100;
		
		/**
		 * The String identifier used to update properties on the client side after they are replaced
		 * by their server side counterparts.
		 * */
		public static const SERVER_SIDE_IDENTIFIER	: String = "LocalizedTextFieldImplementation";
		
		// ====================================
		// PRIVATE VARS
		// ====================================
		
		/**
		 * 
		 */		
		private static var defaultFont		: String = null;
		
		/**
		 * 
		 */		
		private static var embedFonts		: Boolean = true;
		
		/**
		 * 
		 */
		private static var embeddedFontList	: Array;
		
		/**
		 * 
		 */		
		private var _isLivePreview			: Boolean = false;
		
		/**
		 * 
		 */		
		private var _validated				: Boolean = true;
		
		/**
		 * 
		 */	
		private var _languageBundle			: String	= "SpilGames_Game";
		
		/**
		 * @private
		 * */
		private var _isButton				: Boolean = false;
		
		// ====================================
		// PROTECTED VARIABLES
		// ====================================
		
		/**
		 * @private
		 */
		protected var _textSizeImpl		: Number = 12;
		
		/**
		 * @private
		 */
		protected var _textSize			: Number = 12;
		
		/**
		 * @private
		 */
		protected var _text				: String = "defaultTextEx";
		
		/**
		 * @private
		 */
		protected var _fontName			: String = "";
		
		/**
		 * @private
		 */
		protected var _bold		: Boolean = false;
		
		/**
		 * @private
		 */
		protected var _invertHorizontalAlignmentOnDirectionChange:Boolean = true;
		
		/**
		 * @private
		 */
		protected var _horizontalAlign		: String = "center";
		
		/**
		 * @private
		 */
		protected var _verticalAlign		: String = "middle";
		
		/**
		 * @private
		 */
		protected var _multiline	: Boolean = false;
		
		/**
		 * @private
		 */
		protected var _selectable:Boolean = false;
		
		/**
		 * @private
		 */
		protected var _disableWordWrap	: Boolean = false;
		
		/**
		 * @private
		 */
		protected var _embedFonts:Boolean = true;
		
		/**
		 * @private
		 */
		protected var _direction:String =  "ltr";/* Direction.LTR */;
		
		/**
		 * 
		 * */
		protected var _serverSideImplementation: *;
		
		
		// ====================================
		// GETTER/SETTER
		// ====================================
		
		/**
		 * Specifies the plain text displayed by this control.
		 * 
		 * @default "defaultTextEx"
		 */
		[Inspectable(name="text", defaultValue="defaultTextEx")]
		public function set text(value:String):void
		{
			if (_text != value)
			{
				_text = value;
				
				//If server side implementation exists update the text
				if(_serverSideImplementation)
					_serverSideImplementation.text = _text;
				
				invalidateProperties();
			}
		}
		
		public function get text():String
		{
			return _text;
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
		//[Inspectable(name="fontName", defaultValue="")]
		public function set fontName(value:String):void
		{
			if (_fontName != value)
			{
				_fontName = value;
				
				//If server side implementation exists propagate value
				if(_serverSideImplementation)
					_serverSideImplementation.fontName = _fontName;
				
				invalidateProperties();
			}
		}
		public function get fontName():String
		{
			return _fontName;
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
		[Inspectable(name="languageBundle", defaultValue="SpilGames_Game")]
		public function set languageBundle(value:String):void
		{
			if (_languageBundle != value)
			{
				_languageBundle = value;	
				
				//If server side implementation exists propagate value
				if(_serverSideImplementation)
					_serverSideImplementation.languageBundle = _languageBundle;
				
			}
		}
		public function get languageBundle():String
		{
			return _languageBundle;
		}
		
		/**
		 * @private
		 */
		protected var _textColor	: uint = 0;
		/**
		 * Color of text in the component, including the component label.
		 * 
		 * @default 0x000000 (black)
		 */
		[Inspectable(name="textColor", type="Color", defaultValue="0x000000")]
		public function set textColor(value:uint):void
		{
			if (_textColor != value)
			{
				_textColor = value;
				
				//If server side implementation exists propagate value
				if(_serverSideImplementation)
					_serverSideImplementation.textColor = _textColor;
								
				invalidateProperties();
			}
		}
		public function get textColor():uint
		{
			return _textColor;
		}
		
		/**
		 * The point size of the text.
		 * 
		 * @default 12
		 */
		[Inspectable(name="textSize", defaultValue="12")]
		public function set textSize(value:Number):void
		{
			if (_textSize != value)
			{
				if (value > 0)
				{
					_textSize = _textSizeImpl = value;
					
					//If server side implementation exists propagate value
					if(_serverSideImplementation)
						_serverSideImplementation.textSize = _textSize;
					
					invalidateProperties();
				}
			}
		}
		public function get textSize():Number
		{
			return _textSize;
		}
		
		/**
		 * Indicates whether or not the text is displayed in bold style.
		 * 
		 * @default false
		 */
		[Inspectable(name="bold", defaultValue="false")]
		public function set bold(value:Boolean):void
		{
			if (_bold != value)
			{
				_bold = value;
				
				//If server side implementation exists propagate value
				if(_serverSideImplementation)
					_serverSideImplementation.bold = _bold;
				
				invalidateProperties();
			}
		}
		public function get bold():Boolean
		{
			return _bold;
		}
		
		/**
		 * @private
		 */
		protected var _italic:Boolean = false;
		/**
		 * Indicates whether or not the text is displayed in italic style.
		 * 
		 * @default false
		 */
		[Inspectable(name="italic", defaultValue="false")]
		public function set italic(value:Boolean):void
		{
			if (_italic != value)
			{
				_italic = value;
				
				//If server side implementation exists propagate value
				if(_serverSideImplementation)
					_serverSideImplementation.italic = _italic;
				
				invalidateProperties();
			}
		}
		public function get italic():Boolean
		{
			return _italic;
		}
		
		/**
		 * @private
		 */
		protected var _underline		: Boolean = false;
		/**
		 * Indicates whether or not the text is displayed in underlined style.
		 * 
		 * @default false
		 */
		[Inspectable(name="underline", defaultValue="false")]
		public function set underline(value:Boolean):void
		{
			if (_underline != value)
			{
				_underline = value;
				
				//If server side implementation exists propagate value
				if(_serverSideImplementation)
					_serverSideImplementation.underline = _underline;
				
				invalidateProperties();
			}
		}
		public function get underline():Boolean
		{
			return _underline;
		}
		
		/**
		 * The horizontal alignment of the text.
		 * 
		 * <p>Possible values are <code>left</code>, <code>center</code>
		 * and <code>right</code>.</p>
		 * 
		 * @default "center"
		 */
		[Inspectable(name="horizontalAlign", type="list", enumeration="left,center,right,justify", defaultValue="center")]
		public function set horizontalAlign(value:String):void
		{
			if (_horizontalAlign != value)
			{
				if (value == "left" || value == "center" ||
					value == "right" || value == "justify")
				{
					_horizontalAlign = value;
					
					//If server side implementation exists propagate value
					if(_serverSideImplementation)
						_serverSideImplementation.horizontalAlign = _horizontalAlign;
					
					invalidateProperties();
				}
			}
		}
		public function get horizontalAlign():String
		{
			return _horizontalAlign;
		}
		
		/**
		 * Indicates whether horizontal alignment should be inverted when the
		 * <code>direction</code> property changes.
		 * 
		 * <p>Changing this value will not invalidate the properties of this object.</p>
		 * 
		 * @default true
		 * @see #direction
		 */
		[Inspectable(name="invertHorizontalAlignmentOnDirectionChange", defaultValue="true")]
		public function set invertHorizontalAlignmentOnDirectionChange(value:Boolean):void
		{
			_invertHorizontalAlignmentOnDirectionChange = value;
			
			//If server side implementation exists propagate value
			if(_serverSideImplementation)
				_serverSideImplementation.invertHorizontalAlignmentOnDirectionChange = _invertHorizontalAlignmentOnDirectionChange;
			
		}
		public function get invertHorizontalAlignmentOnDirectionChange():Boolean
		{
			return _invertHorizontalAlignmentOnDirectionChange;
		}
		
		/**
		 * The vertical alignment of the text.
		 * 
		 * <p>Possible values are: <code>top</code>, <code>middle</code> and
		 * <code>bottom</code>.</p>
		 * 
		 * @default "middle"
		 */
		[Inspectable(name="verticalAlign", type="list", enumeration="top,middle,bottom", defaultValue="middle")]
		public function set verticalAlign(value:String):void
		{
			if (_verticalAlign != value)
			{
				if (value == "top" || value == "middle" || value == "bottom")
				{
					_verticalAlign = value;
					
					//If server side implementation exists propagate value
					if(_serverSideImplementation)
						_serverSideImplementation.verticalAlign = _verticalAlign;
					
					invalidateProperties();
				}
			}
		}
		public function get verticalAlign():String
		{
			return _verticalAlign;
		}
		
		/**
		 * @private
		 * */		
		public function get isButton():Boolean
		{
			return _isButton;	
		}
		/**
		 * @private
		 * */
		public function set isButton(value:Boolean):void
		{
			_isButton = value;
		}
		
		
		/**
		 * Indicates whether the text can be selected.
		 * 
		 * <p>Making the text selectable lets you copy text from the control.</p>
		 * 
		 * @default false
		 */
		[Inspectable(name="selectable", defaultValue="false")]
		public function set selectable(value:Boolean):void
		{
			if (_selectable != value)
			{
				_selectable = value;
				
				//If server side implementation exists propagate value
				if(_serverSideImplementation)
					_serverSideImplementation.selectable = _selectable;
				
				invalidateProperties();
			}
		}
		public function get selectable():Boolean
		{
			return _selectable;
		}
		
		/**
		 * Indicates whether or not the text can be displayed over multiple
		 * lines.
		 * 
		 * @default <code>false</code>
		 */
		[Inspectable(name="multiline", defaultValue="false")]
		public function set multiline(value:Boolean):void
		{
			if (_multiline != value)
			{
				_multiline = value;
				
				//If server side implementation exists propagate value
				if(_serverSideImplementation)
					_serverSideImplementation.multiline = _multiline;
				
				
				invalidateProperties();
			}
		}
		public function get multiline():Boolean
		{
			return _multiline;
		}
		
		
		/**
		 * Indicates whether or not the <code>wordWrap</code> property
		 * for the text field is disabled.
		 * 
		 * @default false
		 */
		[Inspectable(name="disableWordWrap", defaultValue="false")]
		public function set disableWordWrap(value:Boolean):void
		{
			if (_disableWordWrap != value)
			{
				_disableWordWrap = value;
				
				//If server side implementation exists propagate value
				if(_serverSideImplementation)
					_serverSideImplementation.disableWordWrap = _disableWordWrap;
				
				
				invalidateProperties();
			}
		}
		public function get disableWordWrap():Boolean
		{
			return _disableWordWrap;
		}
		
		/**
		 * Indicates whether or not fonts should be embedded.
		 * 
		 * @default true
		 */
		[Inspectable(name="embedFonts", defaultValue="true")]
		public function set embedFonts(value:Boolean):void
		{
			if (_embedFonts != value)
			{
				_embedFonts = value;
				
				//If server side implementation exists propagate value
				if(_serverSideImplementation)
					_serverSideImplementation.embedFonts = _embedFonts;
				
				
				invalidateProperties();
			}
		}
		public function get embedFonts():Boolean
		{
			return _embedFonts;
		}
		
		/**
		 * The directionality of the text displayed by the component.
		 * 
		 * <p>The allowed values are "ltr" for left-to-right text, as in
		 * Latin-style scripts, and "rtl" for right-to-left text, as
		 * in Arabic and Hebrew.</p>
		 * 
		 * @default "ltr"
		 */
		public function set direction(value:String):void
		{
			if (_direction != value)
			{
				if (value == "ltr" || value == "rtl")
				{
					_direction = value;
					
					//If server side implementation exists propagate value
					if(_serverSideImplementation)
						_serverSideImplementation.direction = _direction;
					
					if (_invertHorizontalAlignmentOnDirectionChange)
					{
						if (_horizontalAlign == "left")
						{
							_horizontalAlign = "right";
							
							//If server side implementation exists propagate value
							if(_serverSideImplementation)
								_serverSideImplementation.horizontalAlign = _horizontalAlign;
							
						}
						else if (_horizontalAlign == "right")
						{
							_horizontalAlign = "left";
							
							//If server side implementation exists propagate value
							if(_serverSideImplementation)
								_serverSideImplementation.horizontalAlign = _horizontalAlign;
						}
					}
					invalidateProperties();
				}
			}
		}
		public function get direction():String
		{
			return _direction;
		}
		
		/**
		 * Sets the width of this control.
		 */
		override public function set width(value:Number):void
		{
			super.width = value;
			
			//If server side implementation exists propagate value
			if(_serverSideImplementation)
				_serverSideImplementation.width = super.width;
		}
		
		/**
		 * Sets the height of this control.
		 */
		override public function set height(value:Number):void
		{
			super.height = value;		
			
			//If server side implementation exists propagate value
			if(_serverSideImplementation)
				_serverSideImplementation.height = super.height;			
		}
		
		/**
		 * Constructor.
		 */
		public function LocalizedTextField()
		{
			//Movieclips need some content to be able to set the size
			graphics.drawRect(0, 0, 1, 1);
			
			addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		// ====================================
		// PUBLIC METHODS
		// ====================================
		
		/**
		 * Sets the size of the control to the given width and height in pixels.
		 * 
		 * @param w The width of the control in pixels.
		 * @param h The height of the control in pixels.
		 */
		public function setSize(w:Number, h:Number):void
		{
			super.width = w;
			super.height = h;
			
			//If server side implementation exists propagate value
			if(_serverSideImplementation){
				_serverSideImplementation.width = super.width;
				_serverSideImplementation.height = super.height;
			}
			
		}
		
		/**
		 * @private
		 * 
		 * Used to update this control on screen when a property is changed 
		 * 
		 * <p>For more information on the flex component lifecycle see
		 * http://livedocs.adobe.com/flex/3/html/help.html?content=ascomponents_advanced_2.html </p>
		 * 
		 * @see flash.display.Stage#invalidate
		 * @see #validateNow
		 */
		public function invalidateProperties():void
		{
			if (_validated && _serverSideImplementation )
			{
				_textSizeImpl = _textSize;
								
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
		 * @private
		 * 
		 * Sets the control as validated so it can be 
		 * updated onscreen via invalidateProperties
		 * 
		 * <p>For more information on the flex component lifecycle see
		 * http://livedocs.adobe.com/flex/3/html/help.html?content=ascomponents_advanced_2.html </p>
		 * 
		 * @see #invalidateProperties
		 */
		public function validateNow(event:Event = null):void
		{
			removeEventListener(Event.RENDER, validateNow);
			removeEventListener(Event.ENTER_FRAME, validateNow);
			
			if (!_text)
			{
				_validated = true;
				return;
			}
			
			_validated = true;
		}
		
		// ====================================
		// EVENT HANDLERS
		// ====================================
		
		/**
		 * @param e
		 */		
		private function added(e:Event) : void
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			if ( BrandingManager.getInstance() )
			{
				if ( !BrandingManager.getInstance().isReady())
				{
					BrandingManager.getInstance().addEventListener(
						SpilGamesServices.COMPONENTS_READY,
						onComponentsReady, false, 0, true);
				}
				else
				{
					onComponentsReady(null);
				}
			}			
		}
		
		/**
		 * @param event
		 */		
		private function onComponentsReady(event:Event):void
		{
			if (BrandingManager.getInstance().isReady())
			{
				BrandingManager.getInstance().removeEventListener(
					SpilGamesServices.COMPONENTS_READY, onComponentsReady );
				
				var c:MovieClip = BrandingManager.getInstance().createComponent(
					BrandingComponentTypes.LOCALISED_TEXTFIELD) as MovieClip;
				
				if (c)
				{
					//First make sure fonts appear then handle the rest
					if ( c.hasOwnProperty( "updateLocale" ))
					{
						c["updateLocale"](this);
					}
					// second: update/clone properties from this class to the New Brand_LT class.
					if ( c.hasOwnProperty( "cloneProperties" ))
					{
						c["cloneProperties"](this);
					}
					
					// third: remove all 'dummy' children
					if(!_isButton)
					{
						var n:int = numChildren;
						while (--n > -1)
						{
							removeChildAt(0);
						}
					}
					
					// rescale so with do not get streched words
					scaleX = 1;
					scaleY = 1;
					
					// fourth: add the latest retrieved LTF
					addChild( c );
					
					for(var i:int = 0; i < c.numChildren; i++)
					{	
						var child:* = c.getChildAt(i);
						
						if(child.hasOwnProperty("_identifier") 
							&& child["_identifier"] == SERVER_SIDE_IDENTIFIER)
							_serverSideImplementation = child;
					}
					
					visible = true;
				}
			}
		}
		
	}
}