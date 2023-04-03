package components.base {	
	
	import Box2DAS.Dynamics.ContactEvent;
	import com.monsterPatties.events.CaveSmashEvent;
	import com.monsterPatties.utils.eventSatellite.EventSatellite;
	import components.items.ItemConfig;
	import wck.*;
	
	public class DynamicItemBase extends BodyShape{
	
		/*------------------------------------------------------------------Constant----------------------------------------------------------------------*/		
		/*------------------------------------------------------------------Properties--------------------------------------------------------------------*/
		public var contacts:ContactList;
		public var itemType:String = ItemConfig.DEFAULT;
		public var _caveSmashEvent:CaveSmashEvent;
		public var _es:EventSatellite;
		/*------------------------------------------------------------------Constructor----------------------------------------------------------------------*/		
		override public function shapes():void 
		{
			super.shapes();			
		}
		
		override public function create():void 
		{
			super.create();			
			type = "Dynamic";
			fixedRotation = true;			
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
			//reportBeginContact = true;
			//reportEndContact = true;
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
			trace( "[DynamicItemBase]:add GameEvent........................ " );
		}
		
		private function removeGameEvent():void 
		{
			_es = EventSatellite.getInstance();
			_es.removeEventListener( CaveSmashEvent.LEVEL_STARTED, onLevelStarted );
			_es.removeEventListener( CaveSmashEvent.LEVEL_COMPLETE, onLevelComplete );			
			_es.removeEventListener( CaveSmashEvent.LEVEL_FAILED, onLevelFailed );
			_es.removeEventListener( CaveSmashEvent.RELOAD_LEVEL, onLevelFailed );
			trace( "[DynamicItemBase]:remove GameEvent........................ " );
		}
		/*------------------------------------------------------------------Setters----------------------------------------------------------------------*/
		
		/*------------------------------------------------------------------Getters----------------------------------------------------------------------*/
		
		/*------------------------------------------------------------------EventHandlers----------------------------------------------------------------*/
		public function endContact(e:ContactEvent):void {
			trace( "[ DynamicItemBase ]: end contact with: === >" + e.other.GetBody().GetUserData() );
		}
		public function handleContact(e:ContactEvent):void {
			trace( "[ DynamicItemBase ]: begin contact with: === >" + e.other.GetBody().GetUserData() );			
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
	}
}