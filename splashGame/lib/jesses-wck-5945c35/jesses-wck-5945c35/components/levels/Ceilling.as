package components.levels {	
	
	import Box2DAS.Dynamics.ContactEvent;
	import com.monsterPatties.events.CaveSmashEvent;
	import com.monsterPatties.utils.eventSatellite.EventSatellite;
	import wck.*;
	
	public class Ceilling extends BodyShape {		
	
		/*------------------------------------------------------------------Constant----------------------------------------------------------------------*/
		
		/*------------------------------------------------------------------Properties--------------------------------------------------------------------*/
		public var _caveSmashEvent:CaveSmashEvent;
		public var _es:EventSatellite;
		private var hasRemoved:Boolean;
		public var contacts:ContactList;
		/*------------------------------------------------------------------Constructor----------------------------------------------------------------------*/
		
		public override function shapes():void {
			type = "Static";
			//type = "Dynamic";
			//type = "Kinematic";
			applyGravity = false;
			_fixedRotation = true;
			
			reportBeginContact = true;
			reportEndContact = true;
			fixedRotation = true;			
			density = 1;
			friction = 0.3;
			restitution = 0;
			
			
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
			_es.addEventListener( CaveSmashEvent.RELOAD_LEVEL, onReloadLevel );
			_es.addEventListener( CaveSmashEvent.LEVEL_QUIT, OnLevelQuit );
			//trace( "[StaticItemBase]:add GameEvent........................ " );
		}
		
		private function removeGameEvent():void 
		{
			_es = EventSatellite.getInstance();
			_es.removeEventListener( CaveSmashEvent.LEVEL_STARTED, onLevelStarted );
			_es.removeEventListener( CaveSmashEvent.LEVEL_COMPLETE, onLevelComplete );			
			_es.removeEventListener( CaveSmashEvent.LEVEL_FAILED, onLevelFailed );
			_es.removeEventListener( CaveSmashEvent.RELOAD_LEVEL, onReloadLevel );
			_es.removeEventListener( CaveSmashEvent.LEVEL_QUIT, OnLevelQuit );
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
				//trace( "ItemKey clear via reloader level!!!!!!!!!!!!!!!!!!!!" );
			}
		}
		/*------------------------------------------------------------------Setters----------------------------------------------------------------------*/		
		/*------------------------------------------------------------------Getters----------------------------------------------------------------------*/		
		/*------------------------------------------------------------------EventHandlers----------------------------------------------------------------*/						
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
		
		private function OnLevelQuit(e:CaveSmashEvent):void{
			clearAll();
			removeME();
		}
		
		public function handleContact(e:ContactEvent):void{
			if (e.other.GetBody().GetUserData() is BossBisonMC){
				//type = "Static";
				trace("ceilling handle contact hit by bison!!!!!!!!!!!");
			}
		}
		
		public function endContact(e:ContactEvent):void
		{
			if (e.other.GetBody().GetUserData() is BossBisonMC){
				//type = "Dynamic";
				trace("ceilling end cotact hit by bison!!!!!!!!!!!");
			}
		}
	}
}