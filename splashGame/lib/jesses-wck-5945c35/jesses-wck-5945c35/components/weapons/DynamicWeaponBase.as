package components.weapons {	
	
	import Box2DAS.Dynamics.ContactEvent;
	import Box2DAS.Dynamics.StepEvent;
	import com.monsterPatties.events.CaveSmashEvent;
	import com.monsterPatties.utils.eventSatellite.EventSatellite;
	import flash.events.Event;
	import wck.*;
	
	public class DynamicWeaponBase extends BodyShape{
	
		/*------------------------------------------------------------------Constant----------------------------------------------------------------------*/		
		/*------------------------------------------------------------------Properties--------------------------------------------------------------------*/	
		public var contacts:ContactList;		
		public var _caveSmashEvent:CaveSmashEvent;
		public var _es:EventSatellite;
		private var hasRemoved:Boolean;
		public var _levelIsDone:Boolean = false;
		/*------------------------------------------------------------------Constructor----------------------------------------------------------------------*/		
		public override function shapes():void {
			super.shapes();
		}
		
		override public function create():void 
		{
			super.create();
			
			type = "Dynamic";
			applyGravity = false;
			fixedRotation = false;
			
			reportBeginContact = true;
			reportEndContact = true;
			fixedRotation = true;
			active = true;
			
			listenWhileVisible(world, StepEvent.STEP, parseInput, false, 10);
			listenWhileVisible(this, ContactEvent.BEGIN_CONTACT, handleContact);
			listenWhileVisible(this, ContactEvent.END_CONTACT, endContact);
			contacts = new ContactList();
			contacts.listenTo(this);
			addGameEvent();
		}
		
		/*------------------------------------------------------------------Methods----------------------------------------------------------------------*/
		private function clearAll():void
		{			
			removeAllListeners();
			removeControllers();
			removeGameEvent();			
		}
		
		private function initControllers():void 
		{
			
		}			
		
		private function removeControllers():void 
		{			
			
		}
		
		private function addGameEvent():void 
		{
			if ( this == null ) {
				return;
			}
			_es = EventSatellite.getInstance();
			_es.addEventListener( CaveSmashEvent.LEVEL_STARTED, onLevelStarted );
			_es.addEventListener( CaveSmashEvent.LEVEL_COMPLETE, onLevelComplete );			
			_es.addEventListener( CaveSmashEvent.LEVEL_FAILED, onLevelFailed );
			_es.addEventListener( CaveSmashEvent.RELOAD_LEVEL, onLevelFailed );		
			_es.addEventListener( CaveSmashEvent.LEVEL_QUIT, OnLevelQuit );
			_es.addEventListener( CaveSmashEvent.RELOAD_LEVEL, onReloadLevel );	
			//trace( "[DynamicWeaponBase]:add GameEvent........................ " );
		}	
		
		private function removeGameEvent():void 
		{
			_es = EventSatellite.getInstance();
			_es.removeEventListener( CaveSmashEvent.LEVEL_STARTED, onLevelStarted );
			_es.removeEventListener( CaveSmashEvent.LEVEL_COMPLETE, onLevelComplete );			
			_es.removeEventListener( CaveSmashEvent.LEVEL_FAILED, onLevelFailed );
			_es.removeEventListener( CaveSmashEvent.RELOAD_LEVEL, onLevelFailed );
			_es.removeEventListener( CaveSmashEvent.LEVEL_QUIT, OnLevelQuit );
			_es.removeEventListener( CaveSmashEvent.RELOAD_LEVEL, onReloadLevel );	
			//trace( "[DynamicWeaponBase]:remove GameEvent........................ " );
		}
		
		private function removeME():void 
		{
			if( !hasRemoved ){
				hasRemoved = true;
				this.remove();
			}
		}
		/*------------------------------------------------------------------Setters----------------------------------------------------------------------*/
		
		/*------------------------------------------------------------------Getters----------------------------------------------------------------------*/
		
		/*------------------------------------------------------------------EventHandlers----------------------------------------------------------------*/
		public function parseInput(e:Event):void {
			if ( this == null || world == null || this.b2body == null || hasRemoved ) {
				return;
			}
		}
		
		public function endContact(e:ContactEvent):void {
			//trace( "[ DynamicWeaponBase ]: end contact with: === >" + e.other.GetBody().GetUserData() );
		}
		public function handleContact(e:ContactEvent):void {
			//trace( "[ DynamicWeaponBase ]: begin contact with: === >" + e.other.GetBody().GetUserData() );			
		}	
		
		public function onLevelFailed(e:CaveSmashEvent):void{			
			_levelIsDone = true;
			clearAll();			
		}
		
		public function onLevelComplete(e:CaveSmashEvent):void{			
			_levelIsDone = true;
			clearAll();
		}
		
		public function onLevelStarted(e:CaveSmashEvent):void{
			_levelIsDone = false;
			initControllers();			
		}
		
		public function onReloadLevel(e:CaveSmashEvent):void 
		{
			clearAll();
			removeME();
		}
		
		public function OnLevelQuit(e:CaveSmashEvent):void 
		{
			clearAll();
			removeME();
		}
	}
}