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
	import com.monsterPatties.config.GameConfig;
	import com.monsterPatties.controllers.GameDataController;
	import com.monsterPatties.events.CaveSmashEvent;
	import com.monsterPatties.utils.eventSatellite.EventSatellite;
	import components.config.CSObjects;
	import components.items.ItemGold;
	import extras.*;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.utils.*;
	import misc.*;
	import shapes.*;
	import wck.*;
	
	public class Runner extends BodyShape{
		
		/*--------------------------------------------------------------------------Constant--------------------------------------------------------------*/	
		private static const LABEL_RIGHT:String = "right";
		private static const LABEL_LEFT:String = "left";
		
		private static const LABEL_HIT:String = "hit";
		private static const LABEL_DIE:String = "die";
		private static const LABEL_DAMAGE:String = "damage";
		private static const LABEL_ATTACK:String = "attack";
		private static const LABEL_WALK:String = "walk";
		private static const LABEL_IDLE:String = "idle";
		
		private static const KNOCK_BACK_POWER:Number = CaveSmashConfig.HERO_KNOCK_BACK_POWER;		
		private static const MOVE_POWER:Number = CaveSmashConfig.RUNNER_MOVE_SPEED;
		
		private static const DIRECTION_RIGHT:int = 0;
		private static const DIRECTION_LEFT:int = 1;
		
		private static const ATTACK_DELAY:Number = 10;
		private static const HIT_DELAY:Number = 0.3;
		private static const IDLE_ATTACK_DELAY:Number = 1;
		/*--------------------------------------------------------------------------Properties--------------------------------------------------------------*/
		
		private var currentDirection:int = DIRECTION_RIGHT;
		private var isJumping:Boolean = false;
		private var isAttacking:Boolean = false;
		private var isFalling:Boolean = false;
		private var isDead:Boolean = false;
		private var isMovingRight:Boolean = false;
		private var isMovingLeft:Boolean = false;
		private var isHit:Boolean = false;
		private var isIdleAttack:Boolean = false;
		private var hp:Number = CaveSmashConfig.RUNNER_HP;
		private var isDetectPlayer:Boolean = false;
		private var isHitPlayer:Boolean = false;
		private var isPlayerDead:Boolean = false;
		private var isIdle:Boolean = false;
		
		//raycast things
		public var rot:Number = 0;
		private var RAY_CAST_ALPHA:int = CaveSmashConfig.MONSTER_RAY_CAST_ALPHA;		
		private var jump:Boolean;		
		//length of raycast
        private var magnitude:Number = CaveSmashConfig.RUNNER_RAY_CAST_LENGTH_DETECTION;
		private var magnitudeOffset:Number = 0;		
		private static const magnitudeOffsetY:Number = CaveSmashConfig.RUNNER_RAY_CAST_LENGTH;

		protected var p1:Point //start point
		protected var p2:Point //end point
		protected var v1:V2 //start point in world.scale
		protected var v2:V2 //end point in world.scale

		//stored by raycast callback.
		protected var valid:Boolean;
		protected var fixture:b2Fixture;
		protected var point:V2;	
		//raycast things
		
		//controlls
		private var _gdc:GameDataController;
		private var _es:EventSatellite;
		private var _isLevelDone:Boolean = false;
		
		public var contacts:ContactList;
		private var _player:Player;
		private var _caveSmashEvent:CaveSmashEvent;
		private var hasRemoved:Boolean;
		/*--------------------------------------------------------------------------Constructor--------------------------------------------------------------*/
		public override function shapes():void{
		}
		
		public override function create():void {
			//trace( "[Runner] create Runner" );			
			super.create();
			reportBeginContact = true;
			reportEndContact = true;
			fixedRotation = true;
			bullet = true;
			density = 1;
			friction = 0.3;
			restitution = 0.2;
			//_inertiaScale = 1;
			listenWhileVisible(world, StepEvent.STEP, parseInput, false, 10);
			listenWhileVisible(this, ContactEvent.BEGIN_CONTACT, handleContact);
			listenWhileVisible(this, ContactEvent.END_CONTACT, endContact);
			contacts = new ContactList();
			contacts.listenTo(this);			
			lookLeft();
			idle();
			
			if ( GameConfig.showCollider ){
				this.collider.alpha = 1;
			}
			
			addGameEvent();
		}
		
		/*--------------------------------------------------------------------------Methods--------------------------------------------------------------*/
		
		/*-----------------------------------------[ for raycasting methods ] ----------------------------------------------------------------------------*/ 
		protected function updateVector(  ):void {
			if ( this == null ) {
				return;
			}
			
			//convert start and end locations to world.			
			p1 = new Point(0, magnitudeOffsetY );
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
			if ( this == null ){
				return;
			}
			
			valid = false;
			world.b2world.RayCast(rcCallback, v1, v2);
			if(valid){
				var body:BodyShape = fixture.m_userData.body //tip for finding the wck body.				
				//trace( "Runner raycast hit", fixture.GetBody().GetUserData() );
				var blocksLen:int = CSObjects.DESTROYER_BLOCKS.length;
				for (var i:int = 0; i < blocksLen; i++) 
				{
					if (  fixture.GetBody().GetUserData() is CSObjects.DESTROYER_BLOCKS[ i ] ){
						isDetectPlayer = false;
						switchWhereToLook();
						deActivateAttack();
						idleAttack();
						break;
					}
				}
				
				
				var monstersLen:int = CSObjects.MONSTERS.length;
				for (var j:int = 0; j < monstersLen; j++) 
				{
					if (  fixture.GetBody().GetUserData() is CSObjects.MONSTERS[ j ] ) {
						isDetectPlayer = false;
						switchWhereToLook();
						deActivateAttack();
						idleAttack();
						break;
					}
				}
				
				
				if ( fixture.GetBody().GetUserData() is Player ){					
					isDetectPlayer = true;
					isIdle = false;
				}				
				drawLaser();
			}else {//if none were found
				isDetectPlayer = false;
				//switchWhereToLook();
				//deActivateAttack();
				//idleAttack();
				
				point=v2; //full length
				drawLaser();
				//trace( "[ runner ]not valid" );
			}
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
		
		protected function drawLaser():void{
			var pt:Point = new Point(point.x*world.scale, point.y*world.scale);
			pt = globalToLocal(world.localToGlobal(pt));

			graphics.lineTo(pt.x, pt.y);			
		}
		/*-----------------------------------------[ for raycasting methods ] ----------------------------------------------------------------------------*/
		
		private function attack():void 
		{
			if( this.mc.currentLabel != LABEL_ATTACK && !isHit  && !isAttacking && !isDead ){
				this.mc.gotoAndPlay( LABEL_ATTACK );
				isAttacking = true;
				//TweenLite.delayedCall( ATTACK_DELAY, deActivateAttack );
			}
		}		
		
		private function deActivateAttack():void 
		{
			isAttacking = false;
		}
		
		public function hit( dir:int , isKnockBack:Boolean = false ):Boolean 
		{
			if ( this.mc.currentLabel != LABEL_HIT && !isHit && !isDead ){
				//resetIdleAttack();
				hp--;
				
				_caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.MONSTER_HIT );
				_es.dispatchESEvent( _caveSmashEvent );
				
				TweenLite.delayedCall( HIT_DELAY, resetHit  );
				if( hp > 0 ){
					this.mc.gotoAndPlay( LABEL_HIT );
					if( isKnockBack ){
						knockBack( dir );
					}
				}else {
					dropItem();
					kill();
				}
				isHit = true;
				return true;
			}else {
				return false;
			}
		}
		
		public function kill():void
		{
			if ( this != null && !isDead ){
				isDead = true;
				this.mc.gotoAndStop( LABEL_DIE );
				var explodeEffect:Explode2MC = new Explode2MC();
				var xpos:Number = ( explodeEffect.width * 0.5 ) * -1;
				var ypos:Number = ( explodeEffect.height * -1 )+ 20;
				Util.addChildAtPosOf( world, explodeEffect, this, -1, new Point( xpos , ypos ) );
				
				_caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.MONSTER_DIED );
				_caveSmashEvent.obj.score = CaveSmashConfig.RUNNER_MONSTER_SCORE;
				_es.dispatchESEvent( _caveSmashEvent );
				
				removeME();
			}
		}
		
		private function removeME():void 
		{
			if( !hasRemoved && isDead ){
				hasRemoved = true;
				this.remove();
			}
		}
		
		
		private function dropItem():void
		{
			if ( this != null ){
				var rnd:int = Math.random() * 100;
				if ( rnd >= 0 && rnd <= 80 ){					
					Util.addChildAtPosOf(world, new ItemGold(), this );				
				}else {
					Util.addChildAtPosOf(world, new ItemHeartMC(), this );					
				}			
			}
		}
		
		private function knockBack( dir:int ):void 
		{			
			//trace( "[Monster]: knockback!!!!!" );
			if ( dir ==  DIRECTION_LEFT  ) {				
				b2body.ApplyImpulse(new V2( -KNOCK_BACK_POWER, 0), b2body.GetWorldCenter());
				//currentDirection = DIRECTION_LEFT;
				lookRight();
			}else if ( dir == DIRECTION_RIGHT  ) {				
				b2body.ApplyImpulse(new V2( KNOCK_BACK_POWER, 0), b2body.GetWorldCenter());
				//currentDirection = DIRECTION_RIGHT;
				lookLeft();
			}			
		}
		
		private function resetHit():void 
		{
			rest();
			isHit = false;
			if ( isDead ) {
				removeControllers();
				remove();
			}
		}	
		
		/*
		private function idle():void 
		{			
			if( !isDead ){
				if ( this.mc.currentLabel != LABEL_IDLE ){
					this.mc.gotoAndPlay( LABEL_IDLE );
				}			
			}
		}*/		
		
		private function idleAttack():void 
		{			
			//trace( "[ Runner ]: idleAttack1..........." );
			if ( this.mc.currentLabel != LABEL_IDLE && !isIdleAttack && !isHit && !isAttacking ) {
				//trace( "[ Runner ]: idleAttack2..........." );
				b2body.m_linearVelocity.x *= CaveSmashConfig.RUNNER_FRICTION_ON_STOP_X;
				this.mc.gotoAndPlay( LABEL_IDLE );
				isIdleAttack = true;
				TweenLite.delayedCall( IDLE_ATTACK_DELAY, resetIdleAttack  );
			}			
		}
		
		
		private function resetIdleAttack():void 
		{	
			isIdleAttack = false;
			attack();			
		}
		
		private function attackPlayer(  ):void 
		{			
			//trace( "[Runner]: attackPlayer checl player1 " + _player );
			if ( _player != null ) {	
				//trace( "[Runner]: attackPlayer checl player2 " + _player );
				if ( !_player.isDead && !isDead ) {
					//trace( "[Runner]: attackPlayer checl player3 " + _player );
					isDetectPlayer = true;					
					_player.hit( 3, 1, currentDirection );
					isAttacking = false;				
				}else {
					isPlayerDead = true;
					idle();
				}
			}
		}
		
		private function switchWhereToLook():void 
		{			
			if( currentDirection == DIRECTION_RIGHT ){
				lookLeft();
			}else if( currentDirection == DIRECTION_LEFT ){
				lookRight();
			}			
			//idle();
		}
		
		private function lookLeft():void 
		{
			if( this.currentLabel != LABEL_LEFT ){
				currentDirection = DIRECTION_LEFT;
				this.gotoAndStop( LABEL_LEFT );
				isMovingRight = false;
				isMovingLeft = true;
				//trace( "[ Monster ]: begin contact with: === > look left" );
			}
		}
		
		private function lookRight():void 
		{
			if( this.currentLabel != LABEL_RIGHT ){
				currentDirection = DIRECTION_RIGHT;
				this.gotoAndStop( LABEL_RIGHT );
				isMovingRight = true;
				isMovingLeft = false;
				//trace( "[ Monster ]: begin contact with: === > look right" );
			}
		}
        
        private function rest():void{
            isMovingRight = false;
			isMovingLeft = false;
            if ( this.mc.currentLabel != LABEL_IDLE && !isHit  && !isAttacking && !isDead ) {
                this.mc.gotoAndPlay( LABEL_IDLE );				
            }
        }
		
		private function idle():void 
		{			
            //if ( this.mc.currentLabel != LABEL_IDLE && !isHit  && !isAttacking && !isDead && !isIdle ) {
			if ( !isDead && !isIdle ) {
                this.mc.gotoAndPlay( LABEL_IDLE );
				isIdle = true;
				isMovingRight = false;
				isMovingLeft = false;
            }
		}
		
		private function addGameEvent():void 
		{
			_es = EventSatellite.getInstance();
			_es.addEventListener( CaveSmashEvent.LEVEL_STARTED, onLevelStarted );
			_es.addEventListener( CaveSmashEvent.LEVEL_QUIT, OnLevelQuit );
			_es.addEventListener( CaveSmashEvent.LEVEL_COMPLETE, onLevelComplete );			
			_es.addEventListener( CaveSmashEvent.LEVEL_FAILED, onLevelFailed );
			_es.addEventListener( CaveSmashEvent.RELOAD_LEVEL, onReloadLevel );
			//trace( "[Runner]:add GameEvent........................ " );
		}		
		
		private function removeGameEvent():void 
		{
			_es = EventSatellite.getInstance();
			_es.removeEventListener( CaveSmashEvent.LEVEL_STARTED, onLevelStarted );
			_es.removeEventListener( CaveSmashEvent.LEVEL_QUIT, OnLevelQuit );
			_es.removeEventListener( CaveSmashEvent.LEVEL_COMPLETE, onLevelComplete );			
			_es.removeEventListener( CaveSmashEvent.LEVEL_FAILED, onLevelFailed );
			_es.removeEventListener( CaveSmashEvent.RELOAD_LEVEL, onReloadLevel );
			//trace( "[Runner]:remove GameEvent........................ " );
		}
		
		private function initControllers():void 
		{
			_gdc = GameDataController.getInstance();
		}			
		
		private function removeControllers():void 
		{			
			
		}
		
		
		private function checkIfRamingPlayer():void 
		{
			if ( this == null ) {
				return;
			}
			
			if( this != null ){
				if ( isHitPlayer ) {
					attackPlayer();
				}
			}
		}
		
		
		private function goRight():void 
		{
			if( this != null ){
				if( this.mc.currentLabel != LABEL_WALK && !isHit && !isDetectPlayer && !isDead ){
					this.mc.gotoAndPlay( LABEL_WALK );					
				}	
				
				var speedX:Number = this.b2body.m_linearVelocity.x;
				var speedY:Number = this.b2body.m_linearVelocity.y;
				
				if ( speedX < 0 ) {
					b2body.SetLinearVelocity( new V2( 0,speedY ) );
				}			
				
				b2body.ApplyImpulse(new V2( MOVE_POWER, 0), b2body.GetWorldCenter());				
				isMovingRight = true;
				isMovingLeft = false;
			}
		}
		
		
		private function goLeft():void
		{
			if( this != null ){
				if( this.mc.currentLabel != LABEL_WALK && !isHit && !isDetectPlayer && !isDead ){
					this.mc.gotoAndPlay( LABEL_WALK );
				}
				
				var speedX:Number = this.b2body.m_linearVelocity.x;
				var speedY:Number = this.b2body.m_linearVelocity.y;
				
				if ( speedX > 0 ) {
					b2body.SetLinearVelocity( new V2( 0,speedY ) );
				}
				
				b2body.ApplyImpulse(new V2( -MOVE_POWER, 0), b2body.GetWorldCenter());
				isMovingLeft = true;
				isMovingRight = false;
			}
		}
		
		private function checkSpeedX():void 
		{
			if ( _isLevelDone ) {
				return;
			}
			
			if( this != null ){
				var speedX:Number = this.b2body.m_linearVelocity.x;
				var limit:Number = CaveSmashConfig.RUNNER_MOVE_SPEED;
				
				var clipped_linear_velocity:V2 = this.b2body.GetLinearVelocity().normalize();
				
				if ( speedX < 0 ){
					speedX *= -1;
				}
				
				if ( speedX >= limit ){
					this.b2body.m_linearVelocity.x = clipped_linear_velocity.multiplyN(limit).x;
				}
			}
		}
		
		private function clearAll():void
		{
			removeAllListeners();			
			removeControllers();
			removeGameEvent();
			//this.remove();
			//destroy();
		}
		/*--------------------------------------------------------------------------Setters--------------------------------------------------------------*/
		
		/*--------------------------------------------------------------------------Getters--------------------------------------------------------------*/
		
		/*--------------------------------------------------------------------------EventHandlers--------------------------------------------------------------*/
		
		public function parseInput(e:Event):void{
			if (!world || isDead || this == null || isPlayerDead || _isLevelDone ) return;

			updateVector();			
			graphics.clear();
			graphics.lineStyle(3, 0xff0000, RAY_CAST_ALPHA, false, "normal", CapsStyle.NONE);
			graphics.moveTo(0,0);

			startRayCast(v1, v2);			
			
			if( !isIdleAttack && !isIdle && !_gdc.getIsLockControlls() ){
				if ( currentDirection == DIRECTION_RIGHT && !isHit ){				
					goRight();
				}else if ( currentDirection == DIRECTION_LEFT && !isHit ){				
					goLeft();
				}
			}			
			checkIfRamingPlayer();
			checkSpeedX();
		}	
		
		public function endContact(e:ContactEvent):void{
			if ( e.other.GetBody().GetUserData() is Player  ){
				_player = null;
				isHitPlayer = false;				
			}
		}
		
		public function handleContact(e:ContactEvent):void {						
			trace( "[ Runner ]: begin contact with: === >" + e.other.GetBody().GetUserData() );
			
			if ( e.other.GetBody().GetUserData() is CatcherMC  ) {
				kill();
			}
			
			var blocksLen:int = CSObjects.DESTROYER_BLOCKS.length;
			for (var i:int = 0; i < blocksLen; i++)
			{
				if (  e.other.GetBody().GetUserData() is CSObjects.DESTROYER_BLOCKS[ i ] ){
					//switchWhereToLook();
					break;
				}
			}
			
			var monstersLen:int = CSObjects.MONSTERS.length;
			for (var j:int = 0; j < monstersLen; j++)
			{
				if (  e.other.GetBody().GetUserData() is CSObjects.MONSTERS[ j ] ){
					//switchWhereToLook();
					break;
				}
			}
			
			if ( e.other.GetBody().GetUserData() is Player && !isDetectPlayer ) {
				if ( e.other.GetBody().m_userData != null ){
					isHitPlayer = true;
					_player = e.other.GetBody().m_userData;
				}
			}else if ( e.other.GetBody().GetUserData() is Player && isDetectPlayer ) {
				if ( e.other.GetBody().m_userData != null ){
					isHitPlayer = true;
					_player = e.other.GetBody().m_userData;
				}
			}
		}
		
		private function onLevelFailed(e:CaveSmashEvent):void 
		{
			_isLevelDone = true;
			idle();
			clearAll();
			//trace( "[Runner]: on level failed" );
		}
		
		private function onLevelComplete(e:CaveSmashEvent):void 
		{			
			_isLevelDone = true;
			clearAll();			
			//trace( "[Runner]: onLevelComplete............................" );
		}
		
		private function onLevelStarted(e:CaveSmashEvent):void 
		{
			_isLevelDone = false;
			initControllers();
			//trace( "[Runner]: onLevelStarted............................" );
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