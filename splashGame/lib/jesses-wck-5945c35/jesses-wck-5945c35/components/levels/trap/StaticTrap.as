package components.levels.trap {	
	
	import Box2DAS.Dynamics.ContactEvent;
	import Box2DAS.Dynamics.StepEvent;
	import com.monsterPatties.events.CaveSmashEvent;
	import com.monsterPatties.utils.eventSatellite.EventSatellite;
	import components.monsters.Runner;
	import components.players.Player2;
	import flash.events.Event;
	import wck.*;
	
	public class StaticTrap extends BodyShape{
		private var target:Player2;
		private var monster:MonsterMC;
		private var runner:RunnerMC;
	
		/*------------------------------------------------------------------Constant----------------------------------------------------------------------*/
		
		/*------------------------------------------------------------------Properties--------------------------------------------------------------------*/
		public var contacts:ContactList;
		private var _es:EventSatellite;
		private var _caveSmashEvent:CaveSmashEvent;
		private var hasRemoved:Boolean;
		/*------------------------------------------------------------------Constructor----------------------------------------------------------------------*/
		
		public override function shapes():void {
			
		}
		
		override public function create():void 
		{
			super.create();
			
			type = "Static";
			applyGravity = false;
			
			listenWhileVisible(world, StepEvent.STEP, parseInput, false, 10);
			listenWhileVisible(this, ContactEvent.BEGIN_CONTACT, handleContact);
			listenWhileVisible(this, ContactEvent.END_CONTACT, endContact);
			contacts = new ContactList();
			contacts.listenTo(this);
			addGameEvent();
		}
		
		/*------------------------------------------------------------------Methods----------------------------------------------------------------------*/
		
		private function initControllers():void 
		{
			_es = EventSatellite.getInstance();
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
			//trace( "[ItemCrstal]:add GameEvent........................ " );
		}				
		
		private function removeGameEvent():void 
		{
			_es = EventSatellite.getInstance();
			_es.removeEventListener( CaveSmashEvent.LEVEL_STARTED, onLevelStarted );
			_es.removeEventListener( CaveSmashEvent.LEVEL_QUIT, OnLevelQuit );
			_es.removeEventListener( CaveSmashEvent.LEVEL_COMPLETE, onLevelComplete );			
			_es.removeEventListener( CaveSmashEvent.LEVEL_FAILED, onLevelFailed );
			_es.removeEventListener( CaveSmashEvent.RELOAD_LEVEL, onReloadLevel );
			//trace( "[ItemCrstal]:remove GameEvent........................ " );
		}		
		
		private function clearAll():void
		{			
			removeAllListeners();
			removeControllers();
			removeGameEvent();
			//this.remove();
			//destroy();
			//trace( "[Divider]:ClearALl........................ " );
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
		
		private function checkIfHitTarget():void 
		{
			if ( this != null ){
				if( target != null ){
					if( !target.isDead ){
						//target.hit(  );
						target.die();
						target = null;
					}
				}
			}else {
				return;
			}
		}
		
		private function checkIfHitMonster():void 
		{
			if ( this != null ){
				if( monster != null ){					
					monster.kill();
					monster = null;
				}
			}			
			
			if ( this != null ){
				if( runner != null ){					
					runner.kill();
					runner = null;
				}
			}
		}
		/*------------------------------------------------------------------Setters----------------------------------------------------------------------*/
		
		/*------------------------------------------------------------------Getters----------------------------------------------------------------------*/
		
		/*------------------------------------------------------------------EventHandlers----------------------------------------------------------------*/		
		public function parseInput(e:Event):void {
			checkIfHitTarget();
			checkIfHitMonster();
		}
		
		public function endContact(e:ContactEvent):void {
			//trace( "[ Spike ]: end contact with: === >" + e.other.GetBody().GetUserData() );			
			target = null;
			//monster = null;
			//runner = null;
		}
		public function handleContact(e:ContactEvent):void {
			//trace( "[ Spike ]: begin contact with: === >" + e.other.GetBody().GetUserData() );
			if ( this != null ){
				if( e.other.GetBody().m_userData is Player ){
					target = e.other.GetBody().m_userData;
				}
				
				//if( e.other.GetBody().m_userData is MonsterMC ){
					//monster = e.other.GetBody().m_userData;
				//}else if( e.other.GetBody().m_userData is RunnerMC ){
					//runner = e.other.GetBody().m_userData;
				//}
				
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
		
		private function OnLevelQuit(e:CaveSmashEvent):void 
		{
			clearAll();
			removeME();
		}
		
		private function onReloadLevel(e:CaveSmashEvent):void 
		{
			clearAll();
			removeME();
		}
	}
}