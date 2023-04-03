package components.base {	
	
	import Box2DAS.Dynamics.ContactEvent;
	import com.monsterPatties.controllers.GameDataController;
	import com.monsterPatties.events.CaveSmashEvent;
	import com.monsterPatties.utils.eventSatellite.EventSatellite;
	import components.items.ItemConfig;
	import wck.*;
	
	public class StaticItemBase extends BodyShape{
	
		/*------------------------------------------------------------------Constant----------------------------------------------------------------------*/		
		/*------------------------------------------------------------------Properties--------------------------------------------------------------------*/
		public var contacts:ContactList;
		public var itemType:String = ItemConfig.DEFAULT;
		public var _caveSmashEvent:CaveSmashEvent;
		public var _es:EventSatellite;
		private var hasRemoved:Boolean;
		public var gdc:GameDataController;
		/*------------------------------------------------------------------Constructor----------------------------------------------------------------------*/		
		override public function shapes():void 
		{
			super.shapes();			
		}
		
		override public function create():void 
		{
			super.create();			
			type = "Static";
			fixedRotation = false;
			listenWhileVisible(this, ContactEvent.BEGIN_CONTACT, handleContact);
			listenWhileVisible(this, ContactEvent.END_CONTACT, endContact);
			contacts = new ContactList();
			contacts.listenTo(this);		
			addGameEvent();
		}
		/*------------------------------------------------------------------Methods----------------------------------------------------------------------*/
		public function clearAll():void
		{			
			removeAllListeners();
			removeControllers();
			removeGameEvent();			
		}
		
		public function initControllers():void 
		{
			gdc = GameDataController.getInstance();
		}			
		
		private function removeControllers():void 
		{			
			
		}
		
		public function addGameEvent():void 
		{
			_es = EventSatellite.getInstance();
			_es.addEventListener( CaveSmashEvent.LEVEL_STARTED, onLevelStarted );
			_es.addEventListener( CaveSmashEvent.LEVEL_COMPLETE, onLevelComplete );			
			_es.addEventListener( CaveSmashEvent.LEVEL_FAILED, onLevelFailed );
			_es.addEventListener( CaveSmashEvent.LEVEL_QUIT, onLevelQuit );
			_es.addEventListener( CaveSmashEvent.RELOAD_LEVEL, onReloadLevel );
			//trace( "[StaticItemBase]:add GameEvent........................ " );
		}
		
		public function removeGameEvent():void 
		{
			_es = EventSatellite.getInstance();
			_es.removeEventListener( CaveSmashEvent.LEVEL_STARTED, onLevelStarted );
			_es.removeEventListener( CaveSmashEvent.LEVEL_COMPLETE, onLevelComplete );			
			_es.removeEventListener( CaveSmashEvent.LEVEL_FAILED, onLevelFailed );
			_es.removeEventListener( CaveSmashEvent.LEVEL_QUIT, onLevelQuit );
			_es.removeEventListener( CaveSmashEvent.RELOAD_LEVEL, onReloadLevel );
			//trace( "[StaticItemBase]:remove GameEvent........................ " );
		}		
		
		private function removeME():void 
		{
			if( !hasRemoved  ){
				hasRemoved = true;
				this.remove();
				while (this.numChildren > 0){
					this.removeChildAt(0);
				}
				//trace( "ItemCrystal clear via reloader level!!!!!!!!!!!!!!!!!!!!" );
			}
		}	
		
		/*------------------------------------------------------------------Setters----------------------------------------------------------------------*/
		
		/*------------------------------------------------------------------Getters----------------------------------------------------------------------*/
		
		/*------------------------------------------------------------------EventHandlers----------------------------------------------------------------*/
		public function endContact(e:ContactEvent):void {
			//trace( "[ StaticItemBase ]: end contact with: === >" + e.other.GetBody().GetUserData() );
		}
		public function handleContact(e:ContactEvent):void {
			//trace( "[ StaticItemBase ]: begin contact with: === >" + e.other.GetBody().GetUserData() );			
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
		
		public function onReloadLevel(e:CaveSmashEvent):void 
		{
			clearAll();
			removeME();
		}
		
		public function onLevelQuit(e:CaveSmashEvent):void 
		{
			clearAll();
			removeME();
		}
	}
}