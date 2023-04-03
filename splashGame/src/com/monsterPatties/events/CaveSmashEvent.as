package com.monsterPatties.events
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author jc
	 */
	public class CaveSmashEvent extends Event
	{
		/*------------------------------------------------------------------------Constant--------------------------------------------------------------*/
		public static const PICK_UP_ITEM:String = "PICK_UP_ITEM";
		public static const DESTROY_BLOCK:String = "DESTROY_BLOCK";
		public static const LEVEL_STARTED:String = "LEVEL_STARTED";
		public static const LEVEL_QUIT:String = "LEVEL_QUIT";
		public static const LEVEL_COMPLETE:String = "LEVEL_COMPLETE";
		public static const LEVEL_FAILED:String = "LEVEL_FAILED";
		public static const TELEPORT_PLAYER:String = "TELEPORT_PLAYER";
		public static const SWITCH_ACTIVATED:String = "SWITCH_ACTIVATED";
		
		public static const PLAYER_RECIEVED_DAMAGED:String = "PLAYER_RECIEVED_DAMAGED";
		public static const BOSS_RECIEVED_DAMAGED:String = "BOSS_RECIEVED_DAMAGED";
		public static const BOSS_DIED:String = "BOSS_DIED";
		public static const MINI_DARK_BOSS_DIED:String = "MINI_DARK_BOSS_DIED";
		public static const SUMMON_DARK_BOSS:String = "SUMMON_DARK_BOSS";
		public static const DARK_BOSS_SUMMON_COMPLETE:String = "DARK_BOSS_SUMMON_COMPLETE";
		public static const MONSTER_DIED:String = "MONSTER_DIED";
		public static const MONSTER_HIT:String = "MONSTER_HIT";
		public static const BOUNCE_MUSHROOM:String = "BOUNCE_MUSHROOM";
		public static const THROW_WEAPON:String = "THROW_WEAPON";
		public static const PLAY_SFX:String = "PLAY_SFX";
		
		public static const LOAD_LEVEL:String = "LOAD_LEVEL";
		public static const HIDE_BOSS_HP:String = "HIDE_BOSS_HP";
		public static const SHOW_BOSS_HP:String = "LOAD_BOSS_LEVEL";
		public static const RELOAD_LEVEL:String = "RELOAD_LEVEL";
		public static const RESET_LIFE:String = "RESET_LIFE";
		
		public static const ON_START_CAMERA_SLIDE:String = "ON_START_CAMERA_SLIDE";
		public static const ON_STOP_CAMERA_SLIDE:String = "ON_STOP_CAMERA_SLIDE";
		
		public static const ON_REMOVE_ATTACK_RANGE:String = "ON_REMOVE_ATTACK_RANGE";
		
		public static const ON_SHOW_CRYSTAL_INFO:String = "ON_SHOW_CRYSTAL_INFO";
		public static const ON_SHOW_COIN_INFO:String = "ON_SHOW_COIN_INFO";
		public static const ON_REMOVE_INFO:String = "ON_REMOVE_INFO";
		
		public static const ON_COLLECT_KEY:String = "ON_COLLECT_KEY";
		public static const ON_CRACK_NORMAL_BLOCK:String = "ON_CRACK_NORMAL_BLOCK";
		public static const ON_BUY_ITEM:String = "ON_BUY_ITEM";
		
		public static const DARK_BOSS_ROCK_EXPLODED:String = "DARK_BOSS_ROCK_EXPLODED";
		/*------------------------------------------------------------------------Properties--------------------------------------------------------------*/
		private var _obj:Object = new Object();
		/*------------------------------------------------------------------------Constructor--------------------------------------------------------------*/
		
		public function CaveSmashEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
		}
		
		
		/*------------------------------------------------------------------------Methods--------------------------------------------------------------*/
		
		public override function clone():Event
		{
			return new CustomEvent(type, bubbles, cancelable);
		}
		
		public override function toString():String
		{
			return formatToString("CustomEvent", "type", "bubbles", "cancelable", "eventPhase");
		}
		
		/*------------------------------------------------------------------------Setters--------------------------------------------------------------*/
		public function set obj(value:Object):void
		{
			_obj = value;
		}
		/*------------------------------------------------------------------------Getters--------------------------------------------------------------*/
		public function get obj():Object
		{
			return _obj;
		}
		
		/*------------------------------------------------------------------------EventHandlers---------------------------------------------------------*/
		
	}
	
}