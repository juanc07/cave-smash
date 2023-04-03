package components.levels {	
	
	import Box2DAS.Dynamics.ContactEvent;
	import Box2DAS.Dynamics.StepEvent;
	import com.monsterPatties.events.CaveSmashEvent;
	import com.monsterPatties.utils.eventSatellite.EventSatellite;
	import flash.events.Event;
	import wck.*;
	
	public class Door extends BodyShape{
	
		/*------------------------------------------------------------------Constant----------------------------------------------------------------------*/
		
		/*------------------------------------------------------------------Properties--------------------------------------------------------------------*/
		public var contacts:ContactList;
		public var es:EventSatellite;
		public var isGameCompleted:Boolean = false;
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
			es = EventSatellite.getInstance();
			es.addEventListener( CaveSmashEvent.LEVEL_STARTED, onLevelStarted );
			es.addEventListener( CaveSmashEvent.LEVEL_QUIT, OnLevelQuit );
			es.addEventListener( CaveSmashEvent.LEVEL_COMPLETE, onLevelComplete );			
			es.addEventListener( CaveSmashEvent.LEVEL_FAILED, onLevelFailed );
			es.addEventListener( CaveSmashEvent.RELOAD_LEVEL, onLevelFailed );			
			//trace( "[Entrance]:add GameEvent........................ " );
		}			
		
		private function removeGameEvent():void 
		{			
			es.removeEventListener( CaveSmashEvent.LEVEL_STARTED, onLevelStarted );
			es.removeEventListener( CaveSmashEvent.LEVEL_QUIT, OnLevelQuit );
			es.removeEventListener( CaveSmashEvent.LEVEL_COMPLETE, onLevelComplete );			
			es.removeEventListener( CaveSmashEvent.LEVEL_FAILED, onLevelFailed );
			es.removeEventListener( CaveSmashEvent.RELOAD_LEVEL, onLevelFailed );			
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
		/*------------------------------------------------------------------Setters----------------------------------------------------------------------*/
		
		/*------------------------------------------------------------------Getters----------------------------------------------------------------------*/
		
		/*------------------------------------------------------------------EventHandlers----------------------------------------------------------------*/		
		public function endContact(e:ContactEvent):void {
			if( this != null ){
				trace( "[ Door ]: end contact with: === >" + e.other.GetBody().GetUserData() );
			}
		}
		public function handleContact(e:ContactEvent):void {
			if( this != null ){
				trace( "[ Door ]: begin contact with: === >" + e.other.GetBody().GetUserData() );
				
			}
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
		
		private function OnLevelQuit(e:CaveSmashEvent):void 
		{
			clearAll();
		}
	}
}