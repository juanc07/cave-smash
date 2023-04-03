package components.levels.trap {
	
	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.ContactEvent;
	import Box2DAS.Dynamics.StepEvent;
	import com.greensock.TweenLite;
	import com.monsterPatties.events.CaveSmashEvent;
	import com.monsterPatties.utils.eventSatellite.EventSatellite;
	import components.blocks.TrapConfig;
	import components.players.Player2;
	import flash.events.Event;
	import wck.*;
	
	public class DynamicTrap extends BodyShape{
		private var target:Player2;
		private var monster:MonsterMC;
		private var runner:RunnerMC;
	
		/*------------------------------------------------------------------Constant----------------------------------------------------------------------*/
		public static const DIRECTION_STILL:int = -1;
		public static const DIRECTION_RIGHT:int = 0;
		public static const DIRECTION_LEFT:int = 1;
		/*------------------------------------------------------------------Properties--------------------------------------------------------------------*/
		public var contacts:ContactList;
		private var _es:EventSatellite;
		private var _caveSmashEvent:CaveSmashEvent;
		private var hasRemoved:Boolean;
		public var movementForce:Number = 0;
		public var moveDelay:Number = 1;
		public var currentDirection:int = DIRECTION_STILL;
		public var trapType:String;
		/*------------------------------------------------------------------Constructor----------------------------------------------------------------------*/
		
		public override function shapes():void {
			
		}
		
		override public function create():void
		{
			super.create();
			
			type = "Dynamic";
			applyGravity = true;
			reportBeginContact = true;
			reportEndContact = true;
			
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
		
		private function clearAll():void{
			removeDelayTimer();
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
						//target.hit( 0,0,0 );
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
		
		private function applyForceLeft():void{
			if (this != null && this.b2body != null && world != null) {
				currentDirection = DIRECTION_LEFT;
				this.b2body.ApplyForce(new V2( -movementForce, 0), this.b2body.GetWorldCenter());
			}
		}
		
		private function applyForceRight():void{
			if (this != null && this.b2body != null && world != null) {
				currentDirection =  DIRECTION_RIGHT;
				this.b2body.ApplyForce(new V2( movementForce, 0), this.b2body.GetWorldCenter());
				//trace("dynamic trap apply impulse right!!!");
			}
		}
		
		private function applyImpulseLeft():void{
			if (this != null && this.b2body != null && world != null) {
				currentDirection = DIRECTION_LEFT;
				this.b2body.ApplyImpulse(new V2( -movementForce, 0), this.b2body.GetWorldCenter());
				//trace("dynamic trap apply impulse left!!!");
			}
		}
		
		private function applyImpulseRight():void{
			if (this != null && this.b2body != null && world != null) {
				currentDirection =  DIRECTION_RIGHT;
				this.b2body.ApplyImpulse(new V2( movementForce, 0), this.b2body.GetWorldCenter());
			}
		}
		
		private function moveForceChecker():void {
			//trace("Dynamic trap moveForceChecker called.!!!");
			if ( this != null && world != null && this.b2body != null ) {
				removeDelayTimer();
				
				if (currentDirection == DIRECTION_RIGHT){
					applyImpulseLeft();
				}else{
					applyImpulseRight();
				}
				
				/*
				if (this.b2body.m_linearVelocity.x < 0 ){
					applyImpulseLeft();
				}else {
					applyImpulseRight();
				}*/
				
				addDelayTimer();
			}
		}
		
		private function addDelayTimer():void{
			TweenLite.delayedCall( moveDelay, moveForceChecker );
		}
		
		private function removeDelayTimer():void{
			TweenLite.killDelayedCallsTo( moveForceChecker );
		}
		
		
		public function startForceMovement():void {
			applyForceRight();
			addDelayTimer();
		}
		/*------------------------------------------------------------------Setters----------------------------------------------------------------------*/
		
		/*------------------------------------------------------------------Getters----------------------------------------------------------------------*/
		
		/*------------------------------------------------------------------EventHandlers----------------------------------------------------------------*/
		public function parseInput(e:Event):void {
			checkIfHitTarget();
			checkIfHitMonster();
			
			if ( this != null && world != null && this.b2body != null ) {
				///trace("linearveloctiyx " + this.b2body.m_linearVelocity.x);
			}
		}
		
		public function endContact(e:ContactEvent):void {
			target = null;
		}
		public function handleContact(e:ContactEvent):void{
			if ( this != null ){
				if( e.other.GetBody().m_userData is Player ){
					target = e.other.GetBody().m_userData;
				}
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