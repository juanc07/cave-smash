package com.monsterPatties.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author monsterpatties
	 */
	public class GameEvent extends Event 
	{
		
		/*-----------------------------------------------------------------Constant---------------------------------------------------------------*/
		public static const GAME_OVER:String = "GAME_OVER";
		public static const GAME_EXIT:String = "GAME_EXIT";
		public static const GAME_PAUSED:String = "GAME_PAUSED";
		public static const GAME_OUT_FOCUS:String = "GAME_OUT_FOCUS";
		public static const GAME_GOT_FOCUS:String = "GAME_GOT_FOCUS";
		public static const GAME_UNPAUSED:String = "GAME_UNPAUSED";
		
		public static const GAME_DEACTIVATE_CONTROLS:String = "GAME_DEACTIVATE_CONTROLS";
		public static const GAME_ACTIVATE_CONTROLS:String = "GAME_ACTIVATE_CONTROLS";
		
		public static const SHOW_PAUSED_SCREEN:String = "SHOW_PAUSED_SCREEN";		
		public static const SHOW_GAME_SETTING:String = "SHOW_GAME_SETTING";
		public static const PRESS_WHAT:String = "PRESS_WHAT";		
		public static const TOGGLE_MUSIC:String = "TOGGLE_MUSIC";
		public static const LOCK_SHORCUT_KEYS:String = "LOCK_SHORCUT_KEYS";
		public static const REMOVE_LEVEL_CLEAR_POP_UP:String = "REMOVE_LEVEL_CLEAR_POP_UP";
		public static const REMOVE_CLEAR_SAVE_POP_UP:String = "REMOVE_CLEAR_SAVE_POP_UP";
		
		public static const PAUSE_BTN_CLICK:String = "PAUSE_BTN_CLICK";
		public static const MUTE_BTN_CLICK:String = "MUTE_BTN_CLICK";
		public static const SETTING_BTN_CLICK:String = "SETTING_BTN_CLICK";
		public static const SHOP_BTN_CLICK:String = "SHOP_BTN_CLICK";
		public static const MAP_BTN_CLICK:String = "MAP_BTN_CLICK";
		
		public static const HELP_BTN_CLICK:String = "HELP_BTN_CLICK";
		public static const HOME_BTN_CLICK:String = "HOME_BTN_CLICK";
		
		public static const GET_AWARD:String = "GET_AWARD";
		public static const SPIL_BRANDING_READY:String = "SPIL_BRANDING_READY";
		
		/*-----------------------------------------------------------------Properties---------------------------------------------------------------*/
		private var _obj:Object = new Object();
		/*-----------------------------------------------------------------Constructor---------------------------------------------------------------*/
		
		
		public function GameEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new GameEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("GameEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}	
		
		
		/*-----------------------------------------------------------------Methods---------------------------------------------------------------*/
		
		/*-----------------------------------------------------------------Setters---------------------------------------------------------------*/
		public function set obj(value:Object):void 
		{
			_obj = value;
		}
		/*-----------------------------------------------------------------Getters---------------------------------------------------------------*/
		public function get obj():Object 
		{
			return _obj;
		}
		/*-----------------------------------------------------------------EventHandlers----------------------------------------------------------*/
		
	}
	
}