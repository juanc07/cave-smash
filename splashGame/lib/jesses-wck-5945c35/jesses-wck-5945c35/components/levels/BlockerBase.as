package components.levels {	
	
	import Box2DAS.Dynamics.ContactEvent;
	import com.monsterPatties.events.CaveSmashEvent;
	import com.monsterPatties.utils.eventSatellite.EventSatellite;
	import wck.*;
	
	public class BlockerBase extends BodyShape{
	
		/*------------------------------------------------------------------Constant----------------------------------------------------------------------*/		
		/*------------------------------------------------------------------Properties--------------------------------------------------------------------*/
		public var _es:EventSatellite;
		public var contacts:ContactList;
		public var _hasBeenRemove:Boolean = false;
		public var id:int;
		/*------------------------------------------------------------------Constructor----------------------------------------------------------------------*/
		
		public override function shapes():void {			
			type = "Static";			
			applyGravity = false;			
			listenWhileVisible(this, ContactEvent.BEGIN_CONTACT, handleContact);
			listenWhileVisible(this, ContactEvent.END_CONTACT, endContact);
			contacts = new ContactList();
			contacts.listenTo(this);		
			
			_hasBeenRemove = false;
			initControllers();
		}		
		
		/*------------------------------------------------------------------Methods----------------------------------------------------------------------*/
		public function activate():void 
		{
			
		}
		
		public function removeBlocker():void 
		{
			
		}		
		
		private function initControllers():void 
		{
			_es = EventSatellite.getInstance();
			_es.addEventListener( CaveSmashEvent.SWITCH_ACTIVATED, onSwitchActivated );
			_es.addEventListener( CaveSmashEvent.BOSS_DIED, onSwitchActivated );
		}
		
		public function removeControllers():void 
		{
			_es.removeEventListener( CaveSmashEvent.SWITCH_ACTIVATED, onSwitchActivated );
			_es.removeEventListener( CaveSmashEvent.BOSS_DIED, onSwitchActivated );
		}
		
		/*------------------------------------------------------------------Setters----------------------------------------------------------------------*/
		
		/*------------------------------------------------------------------Getters----------------------------------------------------------------------*/
		
		/*------------------------------------------------------------------EventHandlers----------------------------------------------------------------*/		
		public function endContact(e:ContactEvent):void {
			trace( "[ BlockerBase ]: end contact with: === >" + e.other.GetBody().GetUserData() );			
		}
		public function handleContact(e:ContactEvent):void {
			trace( "[ BlockerBase ]: begin contact with: === >" + e.other.GetBody().GetUserData() );
		}
		
		private function onSwitchActivated(e:CaveSmashEvent):void 
		{
			id = e.obj.id;
			removeBlocker();
		}
	}
}