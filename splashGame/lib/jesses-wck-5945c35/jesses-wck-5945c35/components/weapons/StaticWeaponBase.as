package components.weapons {	
	
	import Box2DAS.Dynamics.ContactEvent;
	import Box2DAS.Dynamics.StepEvent;
	import com.monsterPatties.events.CaveSmashEvent;
	import com.monsterPatties.utils.eventSatellite.EventSatellite;
	import flash.events.Event;
	import wck.*;
	
	public class StaticWeaponBase extends BodyShape{
	
		/*------------------------------------------------------------------Constant----------------------------------------------------------------------*/		
		/*------------------------------------------------------------------Properties--------------------------------------------------------------------*/	
		public var contacts:ContactList;		
		public var _caveSmashEvent:CaveSmashEvent;
		public var _es:EventSatellite;
		private var hasRemoved:Boolean;
		/*------------------------------------------------------------------Constructor----------------------------------------------------------------------*/		
		public override function shapes():void {
			
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
			_es = EventSatellite.getInstance();
			_es.addEventListener( CaveSmashEvent.LEVEL_STARTED, onLevelStarted );
			_es.addEventListener( CaveSmashEvent.LEVEL_COMPLETE, onLevelComplete );			
			_es.addEventListener( CaveSmashEvent.LEVEL_FAILED, onLevelFailed );
			_es.addEventListener( CaveSmashEvent.RELOAD_LEVEL, onLevelFailed );		
			_es.addEventListener( CaveSmashEvent.LEVEL_QUIT, OnLevelQuit );
			_es.addEventListener( CaveSmashEvent.RELOAD_LEVEL, onReloadLevel );	
			trace( "[StaticWeaponBase]:add GameEvent........................ " );
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
			trace( "[StaticWeaponBase]:remove GameEvent........................ " );
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
		public function parseInput(e:Event):void{			
		}
		
		public function endContact(e:ContactEvent):void {
			trace( "[ StaticWeaponBase ]: end contact with: === >" + e.other.GetBody().GetUserData() );
		}
		public function handleContact(e:ContactEvent):void {
			trace( "[ StaticWeaponBase ]: begin contact with: === >" + e.other.GetBody().GetUserData() );			
		}	
		
		public function onLevelFailed(e:CaveSmashEvent):void 
		{			
			clearAll();			
		}
		
		public function onLevelComplete(e:CaveSmashEvent):void 
		{			
			clearAll();
		}
		
		public function onLevelStarted(e:CaveSmashEvent):void 
		{
			initControllers();			
		}
		
		private function onReloadLevel(e:CaveSmashEvent):void 
		{
			clearAll();
			removeME();
		}
		
		private function OnLevelQuit(e:CaveSmashEvent):void 
		{
			clearAll();
			removeME();
		}
	}
}