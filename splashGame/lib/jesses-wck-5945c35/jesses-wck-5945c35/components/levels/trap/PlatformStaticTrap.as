package components.levels.trap {
	
	import Box2DAS.Dynamics.ContactEvent;
	import Box2DAS.Dynamics.StepEvent;
	import com.monsterPatties.events.CaveSmashEvent;
	import com.monsterPatties.utils.eventSatellite.EventSatellite;
	import components.monsters.Runner;
	import components.players.Player2;
	import flash.events.Event;
	import wck.*;
	
	public class PlatformStaticTrap extends BodyShape{
		private var target:Player2;
		private var monster:MonsterMC;
		private var runner:RunnerMC;
	
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
		private function checkIfHitTarget():void
		{
			if ( this != null ){
				if( target != null ){
					if( !target.isDead ){
						//target.hit( 0,0,0 );
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
				}else if( e.other.GetBody().m_userData is MonsterMC ){
					monster = e.other.GetBody().m_userData;
				}else if( e.other.GetBody().m_userData is RunnerMC ){
					runner = e.other.GetBody().m_userData;
				}
				
			}
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
		
		private function OnLevelQuit(e:CaveSmashEvent):void{
			clearAll();
			removeME();
		}
	}
}