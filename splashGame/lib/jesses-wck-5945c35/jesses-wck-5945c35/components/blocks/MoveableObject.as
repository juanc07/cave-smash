package components.blocks {	
	
	import Box2DAS.Dynamics.ContactEvent;
	import com.monsterPatties.events.CaveSmashEvent;
	import com.monsterPatties.utils.eventSatellite.EventSatellite;
	import wck.*;
	
	public class MoveableObject extends BodyShape {		
	
		/*------------------------------------------------------------------Constant----------------------------------------------------------------------*/		
		/*------------------------------------------------------------------Properties--------------------------------------------------------------------*/
		public var contacts:ContactList;
		public var blockType:String = BlockConfig.MOVEABLE;		
		private var _caveSmashEvent:CaveSmashEvent;
		private var _es:EventSatellite;
		/*------------------------------------------------------------------Constructor----------------------------------------------------------------------*/		
		override public function shapes():void 
		{
			super.shapes();
			//friction = -1;
			//_friction = -1;
		}
		
		override public function create():void 
		{
			super.create();
			
			type = "Dynamic";
			fixedRotation = false;			
			
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
			//this.remove();
			//destroy();
			//trace( "[NormalBlock]:ClearALl........................ " );
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
			trace( "[NormalBlock]:add GameEvent........................ " );
		}
		
		private function removeGameEvent():void 
		{
			_es = EventSatellite.getInstance();
			_es.removeEventListener( CaveSmashEvent.LEVEL_STARTED, onLevelStarted );
			_es.removeEventListener( CaveSmashEvent.LEVEL_COMPLETE, onLevelComplete );			
			_es.removeEventListener( CaveSmashEvent.LEVEL_FAILED, onLevelFailed );
			_es.removeEventListener( CaveSmashEvent.RELOAD_LEVEL, onLevelFailed );
			trace( "[NormalBlock]:remove GameEvent........................ " );
		}
		/*------------------------------------------------------------------Setters----------------------------------------------------------------------*/
		
		/*------------------------------------------------------------------Getters----------------------------------------------------------------------*/
		
		/*------------------------------------------------------------------EventHandlers----------------------------------------------------------------*/
		public function endContact(e:ContactEvent):void {
			trace( "[ MoveableBlock ]: end contact with: === >" + e.other.GetBody().GetUserData() );
		}
		public function handleContact(e:ContactEvent):void {
			trace( "[ MoveableBlock ]: begin contact with: === >" + e.other.GetBody().GetUserData() );			
		}
		
		private function onLevelFailed(e:CaveSmashEvent):void 
		{			
			clearAll();
			//trace( "[NormalBlock]: on level failed" );
		}
		
		private function onLevelComplete(e:CaveSmashEvent):void 
		{			
			clearAll();			
			//trace( "[NormalBlock]: onLevelComplete............................" );
		}
		
		private function onLevelStarted(e:CaveSmashEvent):void 
		{
			initControllers();
			//trace( "[NormalBlock]: onLevelStarted............................" );
		}
	}
}