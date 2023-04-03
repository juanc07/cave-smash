package components.base {	
	
	import Box2DAS.Dynamics.ContactEvent;
	import Box2DAS.Dynamics.StepEvent;
	import com.monsterPatties.controllers.GameDataController;
	import com.monsterPatties.events.CaveSmashEvent;
	import com.monsterPatties.utils.eventSatellite.EventSatellite;	
	import flash.events.Event;
	import wck.*;
	
	public class DoorBase extends BodyShape{
	
		/*------------------------------------------------------------------Constant----------------------------------------------------------------------*/
		
		/*------------------------------------------------------------------Properties--------------------------------------------------------------------*/
		public var contacts:ContactList;
		public var _es:EventSatellite;
		public var _caveSmashEvent:CaveSmashEvent;
		public var _gdc:GameDataController;
		public var _isGameCompleted:Boolean = false;
		private var hasRemoved:Boolean;		
		/*------------------------------------------------------------------Constructor----------------------------------------------------------------------*/
		
		public override function shapes():void{			
			
			
		}	
		
		override public function create():void 
		{
			super.create();			
			type = "Static";
			applyGravity = false;
			isSensor = true;		
			addGameEvent();
		}
		
		/*------------------------------------------------------------------Methods----------------------------------------------------------------------*/
		public function initControllers():void 
		{
			if( this != null && world != null ){
				_gdc = GameDataController.getInstance();				
				
				listenWhileVisible(this, ContactEvent.BEGIN_CONTACT, handleContact);
				listenWhileVisible(this, ContactEvent.END_CONTACT, endContact);			
				listenWhileVisible(world, StepEvent.STEP, parseInput, false, 10);
				
				contacts = new ContactList();
				contacts.listenTo(this);
			}
		}
		
		private function removeControllers():void 
		{
			
		}
		
		private function addGameEvent():void 
		{
			_es = EventSatellite.getInstance();
			_es.addEventListener( CaveSmashEvent.LEVEL_STARTED, onLevelStarted );
			_es.addEventListener( CaveSmashEvent.LEVEL_QUIT, OnLevelQuit );
			_es.addEventListener( CaveSmashEvent.LEVEL_COMPLETE, onLevelComplete );			
			_es.addEventListener( CaveSmashEvent.LEVEL_FAILED, onLevelFailed );
			_es.addEventListener( CaveSmashEvent.RELOAD_LEVEL, onReloadLevel );			
			//trace( "[Entrance]:add GameEvent........................ " );
		}					
		
		private function removeGameEvent():void 
		{			
			_es.removeEventListener( CaveSmashEvent.LEVEL_STARTED, onLevelStarted );
			_es.removeEventListener( CaveSmashEvent.LEVEL_QUIT, OnLevelQuit );
			_es.removeEventListener( CaveSmashEvent.LEVEL_COMPLETE, onLevelComplete );			
			_es.removeEventListener( CaveSmashEvent.LEVEL_FAILED, onLevelFailed );
			_es.removeEventListener( CaveSmashEvent.RELOAD_LEVEL, onReloadLevel );			
			//trace( "[Entrance]:remove GameEvent........................ " );
		}
		
		private function clearAll():void
		{
			removeAllListeners();
			removeControllers();
			removeGameEvent();
			//this.remove();
			//destroy();
		}		
		
		
		private function removeME():void 
		{
			if( !hasRemoved  ){
				hasRemoved = true;
				this.remove();
				while (this.numChildren > 0){
					this.removeChildAt(0);
				}
				//trace( "Exit Door clear via reloader level!!!!!!!!!!!!!!!!!!!!" );
			}
		}
		
		public function bossExit():void{
			this.gotoAndStop(2);			
		}
		
		public function normalExit():void{
			this.gotoAndStop(1);
		}
		/*------------------------------------------------------------------Setters----------------------------------------------------------------------*/
		
		/*------------------------------------------------------------------Getters----------------------------------------------------------------------*/
		
		/*------------------------------------------------------------------EventHandlers----------------------------------------------------------------*/		
		public function endContact(e:ContactEvent):void{			
		}
		
		public function handleContact(e:ContactEvent):void{			
		}
		
		private function onLevelFailed(e:CaveSmashEvent):void 
		{
			clearAll();
		}
		
		private function onLevelComplete(e:CaveSmashEvent):void 
		{			
			clearAll();
		}
		
		private function onLevelStarted(e:CaveSmashEvent):void 
		{
			initControllers();
		}
		
		public function parseInput(e:Event):void{			
			if (!world  || this == null ) return;
		}
		
		public function OnLevelQuit(e:CaveSmashEvent):void 
		{
			clearAll();
			removeME();
		}
		
		public function onReloadLevel(e:CaveSmashEvent):void 
		{
			clearAll();
			removeME();
		}
	}
}