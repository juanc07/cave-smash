package components.colliders {	
	
	import Box2DAS.Dynamics.ContactEvent;
	import com.monsterPatties.events.CaveSmashEvent;
	import com.monsterPatties.utils.eventSatellite.EventSatellite;
	import wck.*;
	
	public class SwitchBase extends BodyShape {		
	
		/*------------------------------------------------------------------Constant----------------------------------------------------------------------*/
		public static const LABEL_ANIMATE:String = "animate";
		public var _isSwitch:Boolean = false;
		/*------------------------------------------------------------------Properties--------------------------------------------------------------------*/
		public var contacts:ContactList;
		public var _es:EventSatellite;
		public var _caveSmashEvent:CaveSmashEvent;
		public var id:int;
		/*------------------------------------------------------------------Constructor----------------------------------------------------------------------*/
		
		public override function shapes():void{
			
		}		
		
		override public function create():void 
		{
			super.create();
			
			type = "Static";			
			applyGravity = false;
			
			listenWhileVisible(this, ContactEvent.BEGIN_CONTACT, handleContact);
			listenWhileVisible(this, ContactEvent.END_CONTACT, endContact);
			contacts = new ContactList();
			contacts.listenTo(this);		
			
			_isSwitch = false;			
			addGameEvent();
		}
		
		/*------------------------------------------------------------------Methods----------------------------------------------------------------------*/
		public function activate():void 
		{			
			
		}		
		
		
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
			_es.addEventListener( CaveSmashEvent.LEVEL_QUIT, OnLevelQuit );
			_es.addEventListener( CaveSmashEvent.LEVEL_COMPLETE, onLevelComplete );			
			_es.addEventListener( CaveSmashEvent.LEVEL_FAILED, onLevelFailed );
			_es.addEventListener( CaveSmashEvent.RELOAD_LEVEL, onLevelFailed );
			trace( "[NormalBlock]:add GameEvent........................ " );
		}
		
		private function removeGameEvent():void 
		{
			_es = EventSatellite.getInstance();
			_es.removeEventListener( CaveSmashEvent.LEVEL_STARTED, onLevelStarted );
			_es.removeEventListener( CaveSmashEvent.LEVEL_QUIT, OnLevelQuit );
			_es.removeEventListener( CaveSmashEvent.LEVEL_COMPLETE, onLevelComplete );			
			_es.removeEventListener( CaveSmashEvent.LEVEL_FAILED, onLevelFailed );
			_es.removeEventListener( CaveSmashEvent.RELOAD_LEVEL, onLevelFailed );
			trace( "[NormalBlock]:remove GameEvent........................ " );
		}
		/*------------------------------------------------------------------Setters----------------------------------------------------------------------*/
		
		/*------------------------------------------------------------------Getters----------------------------------------------------------------------*/
		
		/*------------------------------------------------------------------EventHandlers----------------------------------------------------------------*/		
		public function endContact(e:ContactEvent):void {
			trace( "[ SwitchBase ]: end contact with: === >" + e.other.GetBody().GetUserData() );			
		}
		public function handleContact(e:ContactEvent):void {
			trace( "[ SwitchBase ]: begin contact with: === >" + e.other.GetBody().GetUserData() );
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
		
		private function OnLevelQuit(e:CaveSmashEvent):void 
		{
			clearAll();
		}
	}
}