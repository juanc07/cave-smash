package components.monsters{
	
	import Box2DAS.*;
	import Box2DAS.Collision.*;
	import Box2DAS.Collision.Shapes.*;
	import Box2DAS.Common.*;
	import Box2DAS.Dynamics.*;
	import Box2DAS.Dynamics.Contacts.*;
	import Box2DAS.Dynamics.Joints.*;
	import cmodule.Box2D.*;
	import com.greensock.TweenLite;
	import com.monsterPatties.config.CaveSmashConfig;
	import com.monsterPatties.controllers.GameDataController;
	import com.monsterPatties.events.CaveSmashEvent;
	import com.monsterPatties.events.GameEvent;
	import com.monsterPatties.utils.eventSatellite.EventSatellite;	
	import components.config.CSObjects;
	import components.config.LiveData;
	import components.players.Player2;
	import extras.*;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.utils.*;
	import misc.*;
	import shapes.*;
	import wck.*;
	
	public class FinalDarkBoss extends BodyShape {	
        
		/*--------------------------------------------------------------------------Constant--------------------------------------------------------------*/	
		
		public static const DIRECTION_RIGHT:int = 0;
		public static const DIRECTION_LEFT:int = 1;
		
		public static const LABEL_DIE:String = "die";
		public static const LABEL_RIGHT:String = "right";
		public static const LABEL_LEFT:String = "left";
		public static const LABEL_HIT:String = "hit";
		public static const LABEL_WALK:String = "walk";
		public static const LABEL_ATTACK:String = "attack";
		public static const LABEL_ATTACK2:String = "attack2";
		public static const LABEL_GO_ATTACK2:String = "goAttack2";
		public static const LABEL_GO_ATTACK:String = "goAttack";
		
		/*--------------------------------------------------------------------------Properties--------------------------------------------------------------*/	
		
		public var HIT_DELAY:Number = 0.3;		
		public var KNOCK_BACK_POWER:Number = 1;		
		public var JUMP_POWER:Number = -1.5;
		public var MOVE_POWER:Number = CaveSmashConfig.DARK_BOSS_SPEED;
		private var BOSS_LIFE:Number = CaveSmashConfig.DARK_BOSS_HP;
		
		public var currentDirection:int = DIRECTION_RIGHT;
		public var isJumping:Boolean = false;
		public var isAttacking:Boolean = false;
		public var isAttack1:Boolean = false;
		public var isAttack2:Boolean = false;
		
		public var isFalling:Boolean = false;
		public var isDead:Boolean = false;
		public var isMovingRight:Boolean = false;
		public var isMovingLeft:Boolean = false;
		public var isHit:Boolean = false;		
		public var hp:Number = BOSS_LIFE;
		public var isDetectPlayer:Boolean = false;
		public var isPlayerDead:Boolean = false;
		
		//type monster
		public var isDigger:Boolean = false;
		//	
		
		public var contacts:ContactList;
		
		//raycast things
		public var rot:Number = 0;
		private var RAY_CAST_ALPHA:int = CaveSmashConfig.MONSTER_RAY_CAST_ALPHA;
		private var jump:Boolean;
		//length of raycast
        public var magnitude:Number = CaveSmashConfig.DARK_BOSS_RANGE;
		public var magnitudeOffset:Number = 0;
		public var magnitudeOffsetY:Number = CaveSmashConfig.DARK_BOSS_RANGE_Y;

		protected var p1:Point //start point
		protected var p2:Point //end point
		protected var v1:V2 //start point in world.scale
		protected var v2:V2 //end point in world.scale

		//stored by raycast callback.
		protected var valid:Boolean;
		protected var fixture:b2Fixture;
		protected var point:V2;	
		//raycast things
		
		public var _gdc:GameDataController;
		public var _es:EventSatellite;		
		public var _caveSmashEvent:CaveSmashEvent;
		
		private var _target:Player2;
		public var _levelIsDone:Boolean = false;
		private var hasRemoved:Boolean;
		public var hasDropItem:Boolean = false;		
		private var scannedTarget:Player;		
		public var ATTACK_DELAY:Number = CaveSmashConfig.DARK_BOSS_ATTACK_DELAY;		
		public var hasFireShot:Boolean;
		public var hasAttackRange:Boolean;
		public var darkBossRockCount:int;		
		
		/*--------------------------------------------------------------------------Constructor--------------------------------------------------------------*/	
		
		public override function shapes():void{
		}
		
		public override function create():void {
			//trace( "[monster] create monster" );			
			super.create();			
			reportBeginContact = true;
			reportEndContact = true;
			type = "Kinematic";			
			applyGravity = false;			
			fixedRotation = true;
			bullet = true;
			density = 1;
			friction = 0.3;
			restitution = 0.2;			
			listenWhileVisible(world, StepEvent.STEP, parseInput, false, 10);
			listenWhileVisible(this, ContactEvent.BEGIN_CONTACT, handleContact);
			listenWhileVisible(this, ContactEvent.END_CONTACT, endContact);
			contacts = new ContactList();
			contacts.listenTo(this);			
			addGameEvent();
			lookLeft();
			stopMoving();			
			TweenLite.delayedCall( ATTACK_DELAY, attack );			
		}
		
		/*--------------------------------------------------------------------------Methods--------------------------------------------------------------*/	
		
		/*-----------------------------------------[ for raycasting methods ] ----------------------------------------------------------------------------*/ 
		protected function updateVector(  ):void {
			if ( _levelIsDone ) {
				return;
			}
			
			//convert start and end locations to world.			
			p1 = new Point(0, 0 );
			if( currentDirection == DIRECTION_RIGHT ){
				p2 = new Point(magnitude, magnitudeOffsetY ); //assumes that art is facing right at 0º
			}else if( currentDirection == DIRECTION_LEFT ){
				p2 = new Point( -( magnitude - magnitudeOffset ), magnitudeOffsetY );
			}
            
			p1 = world.globalToLocal(this.localToGlobal(p1));
			p2 = world.globalToLocal(this.localToGlobal(p2));			
			
			v1 = new V2(p1.x, p1.y);			
			v2 = new V2( p2.x, p2.y);		
			
			v1.divideN(world.scale);
			v2.divideN(world.scale);		
		}
		
		protected function startRayCast(v1:V2, v2:V2):void {
			if ( _levelIsDone ) {
				return;
			}
			valid = false;

			world.b2world.RayCast(rcCallback, v1, v2); //see onRayCast();

			if(valid){
				var body:BodyShape = fixture.m_userData.body				
				if( this != null ){
					var blocksLen:int = CSObjects.BLOCKS.length;
					for (var i:int = 0; i < blocksLen; i++){
						if (  fixture.GetBody().GetUserData() is CSObjects.BLOCKS[ i ] ){
							isDetectPlayer = false;
							if(isMovingLeft || isMovingRight){
								switchWhereToLook();
							}
							break;
						}
					}
					
					var monsterLen:int = CSObjects.MONSTERS.length;
					for ( i = 0; i < monsterLen; i++){
						if (  fixture.GetBody().GetUserData() is CSObjects.MONSTERS[ i ] ){
							isDetectPlayer = false;							
							switchWhereToLook();
							break;
						}
					}
				}
				
				if ( fixture.GetBody().GetUserData() is Player ) {					
					isDetectPlayer = true;										
					scannedTarget = fixture.GetBody().m_userData;
					var halfLife:Number = ( CaveSmashConfig.DARK_BOSS_HP * 0.5 );
					if(hp <= halfLife){
						checkIfCanAttack();
					}
				}
				
				drawLaser();
			}else {//if none were found
				isDetectPlayer = false;
				//switchWhereToLook();
				point=v2; //full length
				drawLaser();
				//trace( "not valid" );
			}
		}	
		
		public function playAttack2():void{
			
		}
		
		protected function rcCallback(_fixture:b2Fixture, _point:V2, normal:V2, fraction:Number):Number{
			//found one
			if(_fixture.IsSensor() ){//is it a sensor?
				return -1//pass through
			}

			//set this one as the current closest find
			valid = true;
			fixture = _fixture;
			point = _point;

			return fraction;//then check again for any closer finds.
		}
		
		protected function drawLaser():void {
			if( !_levelIsDone ){
				var pt:Point = new Point(point.x*world.scale, point.y*world.scale);
				pt = globalToLocal(world.localToGlobal(pt));

				graphics.lineTo(pt.x, pt.y);			
			}
		}
		
		private function lookWhereTarget():void{
			if ( LiveData.playerPosition != null ){
				if (LiveData.playerPosition.x > this.x) {
					lookRight();
				}else {
					lookLeft();
				}
			}
		}
		
		/*-----------------------------------------[ for raycasting methods ] ----------------------------------------------------------------------------*/
		public function hit(dir:int, isKnockBack:Boolean = false, damage:int = 1):Boolean{
			if (!isHit && !isDead){				
				if ( scannedTarget == null ){
					lookWhereTarget();
				}else{
					//attack();					
					quickAttack();
				}
				
				hp -= damage;				
				_caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.MONSTER_HIT );
				_es.dispatchESEvent( _caveSmashEvent );
				
				_caveSmashEvent = new CaveSmashEvent(CaveSmashEvent.BOSS_RECIEVED_DAMAGED);
				_caveSmashEvent.obj.max = BOSS_LIFE;
				_caveSmashEvent.obj.hp = hp;
				_es.dispatchESEvent(_caveSmashEvent);				
				TweenLite.delayedCall( HIT_DELAY, resetHit  );
				
				if ( hp > 0 ){
					playHit();
					//if( isKnockBack ){
						//knockBack( dir );
					//}
				}else {
					if ( this != null) {
						dropItem();
					}
					kill();					
				}
				isHit = true;				
				return true;
			}else {
				return false;
			}			
		}
		
		public function playHit():void{
			
		}
		
		public function kill():void 
		{
			if ( this != null && !isDead ) {
				isDead = true;
				stopMoving();				
				
				_caveSmashEvent = new CaveSmashEvent(CaveSmashEvent.BOSS_DIED);
				_caveSmashEvent.obj.id = 1;
				_caveSmashEvent.obj.score = CaveSmashConfig.BOSS_MONSTER_SCORE;
				_es.dispatchESEvent(_caveSmashEvent);
				
				var _gameEvent:GameEvent = new GameEvent( GameEvent.GET_AWARD );
				_gameEvent.obj.id = 4;
				_es.dispatchESEvent( _gameEvent );			
				
				//removeME();
			}
		}
		
		public function cleanMe():void{
			clearAll();
			removeME();
		}
		
		private function removeME():void 
		{
			if( !hasRemoved && isDead ){
				hasRemoved = true;
				this.remove();
			}
		}
		
		public function dropItem():void{
			
		}
		
		private function knockBack( dir:int ):void 
		{			
			trace( "[Monster]: knockback!!!!! check dir " + dir );
			if ( dir ==  DIRECTION_LEFT  ){
				b2body.SetLinearVelocity( new V2( 0, 0 ) );
				b2body.ApplyImpulse(new V2( -0.3, 0), b2body.GetWorldCenter());				
				b2body.SetLinearVelocity( new V2( -KNOCK_BACK_POWER, 0) );
				lookRight();
			}else if ( dir == DIRECTION_RIGHT  ){
				b2body.SetLinearVelocity( new V2( 0, 0 ) );
				b2body.ApplyImpulse(new V2( 0.3, 0), b2body.GetWorldCenter());				
				b2body.SetLinearVelocity( new V2( KNOCK_BACK_POWER, 0) );
				lookLeft();
			}			
		}
		
		private function resetHit():void{			
			isHit = false;			
		}		
		
		private function attackPlayer( target:Player2 ):void 
		{
			var player:Player2 = target as Player2;
			if( !player.isDead && !isDead ){
				isDetectPlayer = true;	
				trace("final dark boss hit player currentDirection " + currentDirection );
				player.hit( 4, 1, currentDirection );
			}else {
				isPlayerDead = true;				
			}
		}
		
		private function switchWhereToLook():void 
		{
			stopMoving();
			if( currentDirection == DIRECTION_RIGHT ){
				lookLeft();
			}else if( currentDirection == DIRECTION_LEFT ){
				lookRight();
			}
		}
		
		private function lookLeft():void 
		{
			if( this.currentLabel != LABEL_LEFT ){
				currentDirection = DIRECTION_LEFT;
				this.gotoAndStop( LABEL_LEFT );							
			}
			
			isMovingRight = false;
			isMovingLeft = true;	
		}
		
		private function lookRight():void 
		{
			if( this.currentLabel != LABEL_RIGHT ){
				currentDirection = DIRECTION_RIGHT;
				this.gotoAndStop( LABEL_RIGHT );								
			}
			
			isMovingRight = true;
			isMovingLeft = false;
		}       
		
		private function initControllers():void 
		{
			_gdc = GameDataController.getInstance();			
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
			//trace( "[Monster]:add GameEvent........................ " );
		}			
		
		private function removeGameEvent():void 
		{
			_es = EventSatellite.getInstance();
			_es.removeEventListener( CaveSmashEvent.LEVEL_STARTED, onLevelStarted );
			_es.removeEventListener( CaveSmashEvent.LEVEL_QUIT, OnLevelQuit );
			_es.removeEventListener( CaveSmashEvent.LEVEL_COMPLETE, onLevelComplete );			
			_es.removeEventListener( CaveSmashEvent.LEVEL_FAILED, onLevelFailed );
			_es.removeEventListener( CaveSmashEvent.RELOAD_LEVEL, onReloadLevel );			
			//trace( "[Monster]:remove GameEvent........................ " );
		}
		
		public function goRight():void 
		{
			if ( _levelIsDone && isDead) {
				return;
			}
			
			if( this != null ){			
				var speedX:Number = this.b2body.m_linearVelocity.x;
				var speedY:Number = this.b2body.m_linearVelocity.y;
				
				if ( speedX < 0 ) {
					b2body.SetLinearVelocity( new V2( 0,speedY ) );
				}
				
				b2body.ApplyImpulse(new V2( MOVE_POWER, 0), b2body.GetWorldCenter());				
				//b2body.m_linearVelocity.x += MOVE_POWER;
				b2body.SetLinearVelocity( new V2( MOVE_POWER, 0) );
				//trace("fly go right!!");
			}
		}
		
		
		public function goLeft():void
		{
			if ( _levelIsDone && isDead) {
				return;
			}
			
			if( this != null ){				
				var speedX:Number = this.b2body.m_linearVelocity.x;
				var speedY:Number = this.b2body.m_linearVelocity.y;
				
				if ( speedX > 0 ) {
					b2body.SetLinearVelocity( new V2( 0,speedY ) );
				}
				
				b2body.ApplyImpulse(new V2( -MOVE_POWER, 0), b2body.GetWorldCenter());				
				//b2body.m_linearVelocity.x -= MOVE_POWER;
				b2body.SetLinearVelocity( new V2( -MOVE_POWER, 0) );
				//trace("fly go left!!");
			}
		}
		
		private function stopMoving():void 
		{
			if(this != null && world != null ){
				isMovingLeft = false;
				isMovingRight = false;
				b2body.SetLinearVelocity( new V2( 0, 0 ) );
			}
		}	
		
		private function clearAll():void 
		{			
			removeAllListeners();
			removeControllers();
			removeGameEvent();			
		}
		
		private function checkIfCanAttack():void{
			if ( _levelIsDone || this == null || this.b2body == null ) {
				return;
			}			
			
			if (!isHit  && !isAttacking && !isDead && !hasFireShot ){			
				TweenLite.killDelayedCallsTo( checkIfCanAttack );
				stopMoving();
				playAttack2();				
				isAttacking = true;
				isAttack1 = false;
				isAttack2 = true;
				TweenLite.delayedCall( ATTACK_DELAY, deActivateAttack );				
			}
		}
		
		private function attack():void 
		{			
			if ( _levelIsDone || this == null || this.b2body == null ) {
				return;
			}
			
			if (!isHit  && !isAttacking && !isDead ){			
				TweenLite.killDelayedCallsTo( attack );
				stopMoving();
				smash();
				isAttacking = true;
				isAttack1 = true;
				isAttack2 = false;
				TweenLite.delayedCall( ATTACK_DELAY, deActivateAttack );				
			}			
		}		
		
		private function quickAttack():void 
		{			
			if ( _levelIsDone || this == null || this.b2body == null ) {
				return;
			}
			
			if (!isAttacking && !isDead ) {			
				TweenLite.killDelayedCallsTo( attack );
				stopMoving();
				smash();
				isAttacking = true;				
				TweenLite.delayedCall( ATTACK_DELAY, deActivateAttack );				
			}			
		}
		
		public function smash():void 
		{
			
		}
		
		public function rapidShot():void {
			trace("minibossFly execute rapid shot!!!!!!!!!!!!!!!");
		}
		
		private function deActivateAttack():void 
		{
			TweenLite.killDelayedCallsTo( deActivateAttack );
			isAttacking = false;
			hasFireShot = false;
			hasAttackRange = false;
			if (isAttack1) {
				TweenLite.delayedCall( ATTACK_DELAY, checkIfCanAttack );				
			}else {
				TweenLite.delayedCall( ATTACK_DELAY, attack );
			}			
		}		
		
		private function continueMoving():void {
			TweenLite.killDelayedCallsTo(continueMoving);
			if (currentDirection ==  DIRECTION_RIGHT) {
				isMovingRight = true;
				isMovingLeft = false;
			}else {
				isMovingRight = false;
				isMovingLeft = true;
			}
		}		
		
		/*--------------------------------------------------------------------------Setters---------------------------------------------------------------*/	
		
		/*--------------------------------------------------------------------------Getters-----------------------------------------------------------------*/	
		
		/*--------------------------------------------------------------------------EventHandlers------------------------------------------------------------*/	
		
		public function parseInput(e:Event):void {
			if (!world || isDead || this == null || isPlayerDead || _levelIsDone ) return;

			updateVector();			
			graphics.clear();
			graphics.lineStyle(3, 0xff0000, RAY_CAST_ALPHA, false, "normal", CapsStyle.NONE);
			graphics.moveTo(0,0);

			startRayCast(v1, v2);
			
			/*
			if ( !_gdc.getIsLockControlls() && !isAttacking && !isHit && !_levelIsDone ) {
				if (isMovingRight){
					goRight();
				}else if (isMovingLeft) {
					goLeft();
				}
			}*/			
			checkSpeedX();
			checkIfHitPlayer();
			///trace("miniBossFly x " + this.x );
		}
		
		
		private function checkIfHitPlayer():void 
		{
			if ( _levelIsDone ) {
				return;
			}
			
			if( this != null ){
				if ( _target != null ) {
					attackPlayer( _target );				
				}
			}
		}
		
		
		private function checkSpeedX():void 
		{
			if ( _levelIsDone ) {
				return;
			}
			
			if( this != null ){
				var speedX:Number = this.b2body.m_linearVelocity.x;
				var limit:Number = MOVE_POWER;
				
				var clipped_linear_velocity:V2 = this.b2body.GetLinearVelocity().normalize();
				
				if ( speedX < 0 ){
					speedX *= -1;
				}
				
				if ( speedX >= limit ){
					this.b2body.m_linearVelocity.x = clipped_linear_velocity.multiplyN(limit).x;
				}
			}
		}		
		
		public function endContact(e:ContactEvent):void{
			if ( e.other.GetBody().GetUserData() is Player ){				
				_target = null;
			}else if ( e.other.GetBody().GetUserData() is Player ){
				_target = null;
			}
		}
		
		public function handleContact(e:ContactEvent):void {						
			if ( _levelIsDone ) {
				return;
			}
			
			if( this != null ){
				trace( "[ mini bosss Fly ]: begin contact with: === >" + e.other.GetBody().GetUserData() );
				if ( e.other.GetBody().GetUserData() is CatcherMC  ) {
					kill();
				}
			}
			var blocksLen:int;
			
			blocksLen = CSObjects.DESTROYER_BLOCKS.length;
			for (var i:int = 0; i < blocksLen; i++)
			{
				if (  e.other.GetBody().GetUserData() is CSObjects.DESTROYER_BLOCKS[ i ] ){
					switchWhereToLook();
					trace( "hit object: " +  CSObjects.DESTROYER_BLOCKS[ i ] );
					break;
				}
			}
			
			blocksLen = CSObjects.BLOCKS.length;
			for (i= 0; i < blocksLen; i++)
			{
				if (  e.other.GetBody().GetUserData() is CSObjects.BLOCKS[ i ] ){
					switchWhereToLook();
					trace( "hit object: " +  CSObjects.BLOCKS[ i ] );
					break;
				}
			}
			
			var monstersLen:int = CSObjects.MONSTERS.length;
			for (var j:int = 0; j < monstersLen; j++)
			{
				if (  e.other.GetBody().GetUserData() is CSObjects.MONSTERS[ j ] ){
					switchWhereToLook();
					break;
				}
			}		
			
			if ( e.other.GetBody().GetUserData() is Player ){				
				_target = e.other.GetBody().m_userData;
			}
		}		
		
		public function onLevelFailed(e:CaveSmashEvent):void 
		{
			_levelIsDone = true;
			clearAll();
			//trace( "[Monster]: on level failed" );
		}
		
		public function onLevelComplete(e:CaveSmashEvent):void 
		{			
			_levelIsDone = true;
			clearAll();			
			//trace( "[Monster]: onLevelComplete............................" );
		}
		
		public function manualSetup():void{
			_levelIsDone = false;
			initControllers();
			lookLeft();
			var caveSmashEvent:CaveSmashEvent = new CaveSmashEvent(CaveSmashEvent.SHOW_BOSS_HP);
			_es.dispatchESEvent(caveSmashEvent);
			LiveData.isBossLevel = true;
		}
		
		public function onLevelStarted(e:CaveSmashEvent):void{
			manualSetup();			
		}
		
		public function OnLevelQuit(e:CaveSmashEvent):void 
		{
			clearAll();
			removeME();
		}
		
		public function onReloadLevel(e:CaveSmashEvent):void 
		{
			clearAll();
			removeME();
		}
	}
}