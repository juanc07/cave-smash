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
	import com.monsterPatties.events.GameEvent;
	import com.monsterPatties.utils.eventSatellite.EventSatellite;	
	import components.config.CSObjects;
	import components.config.LiveData;
	import components.items.Item;
	import components.items.ItemGold;
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
	
	public class Boss1 extends BodyShape {	
        
		/*--------------------------------------------------------------------------Constant--------------------------------------------------------------*/	
		
		private static const DIRECTION_RIGHT:int = 0;
		private static const DIRECTION_LEFT:int = 1;
		
		private static const LABEL_RIGHT:String = "right";
		private static const LABEL_LEFT:String = "left";
		
		private static const LABEL_HIT:String = "hit";		
		private static const LABEL_DAMAGE:String = "damage";
		private static const LABEL_ATTACK:String = "attack";
		private static const LABEL_WALK:String = "walk";
		private static const LABEL_IDLE:String = "idle";
		private static const LABEL_STAND_UP:String = "standUp";
		
		private static const LABEL_TIRED:String = "tired";
		private static const LABEL_DEATH:String = "death";
		
		private static const ATTACK_COUNTER_MAX:Number = 3;
		private static const ATTACK_DELAY:Number = 2;
		private static const HIT_DELAY:Number = 0.6;
		private static const KNOCK_BACK_POWER:Number = CaveSmashConfig.HERO_KNOCK_BACK_POWER;
		private static const JUMP_POWER:Number = -1.5;
		private static const MOVE_POWER:Number = CaveSmashConfig.SMASHER_MOVE_SPEED;
		private var attackCounter:int = 0;
		
		private var BOSS_LIFE:Number = CaveSmashConfig.BOSS1_HP;
		/*--------------------------------------------------------------------------Properties--------------------------------------------------------------*/	
		private var currentDirection:int = DIRECTION_RIGHT;
		private var isJumping:Boolean = false;
		private var isAttacking:Boolean = false;
		private var isFalling:Boolean = false;
		private var isDead:Boolean = false;
		private var isMovingRight:Boolean = false;
		private var isMovingLeft:Boolean = false;
		private var isHit:Boolean = false;		
		private var isResting:Boolean = false;
		private var isIdle:Boolean = false;
		private var hp:Number = BOSS_LIFE;
		private var isDetectPlayer:Boolean = false;
		private var isPlayerDead:Boolean = false;
		
		//type monster
		private var isDigger:Boolean = false;
		//	
		
		public var contacts:ContactList;
		
		//raycast things
		public var rot:Number = 0;
		private var RAY_CAST_ALPHA:int = CaveSmashConfig.MONSTER_RAY_CAST_ALPHA;
		private var jump:Boolean;
		//length of raycast
        protected var magnitude:Number = CaveSmashConfig.RED_BOSS_RANGE;
		protected var magnitudeOffset:Number = 0;
		protected var magnitudeOffsetY:Number = CaveSmashConfig.RED_BOSS_RANGE_Y;

		protected var p1:Point //start point
		protected var p2:Point //end point
		protected var v1:V2 //start point in world.scale
		protected var v2:V2 //end point in world.scale

		//stored by raycast callback.
		protected var valid:Boolean;
		protected var fixture:b2Fixture;
		protected var point:V2;	
		//raycast things
		
		private var _rayCastTarget:Player2;
		private var _target:Player2;
		
		private var _gdc:GameDataController;
		private var _es:EventSatellite;
		private var _isLevelFailed:Boolean = false;		
		private var _caveSmashEvent:CaveSmashEvent;
		private var _hasGroundSpike:Boolean;
		private var _hasDropItem:Boolean;
		private var hasRemoved:Boolean;
		
		
		/*--------------------------------------------------------------------------Constructor--------------------------------------------------------------*/	
		
		public override function shapes():void {
			//test
			//super.shapes();
			//circle(  );
			//reportBeginContact = true;
			//reportEndContact = true;
			//fixedRotation = true;
			//bullet = true;
			//density = 1;
			//friction = 0.3;
			//restitution = 0.2;			
			//listenWhileVisible(world, StepEvent.STEP, parseInput, false, 10);
			//listenWhileVisible(this, ContactEvent.BEGIN_CONTACT, handleContact);
			//listenWhileVisible(this, ContactEvent.END_CONTACT, endContact);
			//contacts = new ContactList();
			//contacts.listenTo(this);			
			//
			//addGameEvent();						
			//currentDirection = DIRECTION_LEFT;
			//stopMoving();
			//lookLeft();
			//goLeft();
			//test
		}
		
		public override function create():void {
			//trace( "[monster] create monster" );			
			super.create();
			reportBeginContact = true;
			reportEndContact = true;
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
			currentDirection = DIRECTION_LEFT;
			stopMoving();
			lookLeft();
			goLeft();			
			initAttack();
		}
		
		/*--------------------------------------------------------------------------Methods--------------------------------------------------------------*/	
		
		/*-----------------------------------------[ for raycasting methods ] ----------------------------------------------------------------------------*/ 
		protected function updateVector(  ):void {
			if( this != null && !isDead ){
				//convert start and end locations to world.			
				p1 = new Point(0, magnitudeOffsetY );
				if( currentDirection == DIRECTION_RIGHT ){
					p2 = new Point(magnitude, magnitudeOffsetY); //assumes that art is facing right at 0º
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
		}
		
		protected function startRayCast(v1:V2, v2:V2):void {
			if( this != null && !isDead ){
				valid = false;
				world.b2world.RayCast(rcCallback, v1, v2);

				if(valid){
					var body:BodyShape = fixture.m_userData.body;
					
					
					var blocksLen:int = CSObjects.BOSS1_BLOCKS.length;
					for (var i:int = 0; i < blocksLen; i++) 
					{
						if (  fixture.GetBody().GetUserData() is CSObjects.BOSS1_BLOCKS[ i ] ) {							
							clearRayCastTarget();
							switchWhereToLook();
							break;							
						}
					}
					
					
					/*
					var monstersLen:int = CSObjects.MONSTERS.length;
					for (var j:int = 0; j < monstersLen; j++) 
					{
						if (  fixture.GetBody().GetUserData() is CSObjects.MONSTERS[ j ] ) {
							clearRayCastTarget();
							isDetectPlayer = false;
							attack();							
							break;
						}
					}*/
					
					
					if ( fixture.GetBody().GetUserData() is Player ) {
						_rayCastTarget = fixture.GetBody().m_userData;
						isDetectPlayer = true;
						if( hp <= 10 ){
							attack();
						}
					}
					
					drawLaser();
				}else {//if none were found
					clearRayCastTarget();
					point=v2; //full length
					drawLaser();
					//trace( "not valid" );
				}
			}
		}
		
		private function clearRayCastTarget():void 
		{
			isDetectPlayer = false;			
			_rayCastTarget = null;
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
			if( this != null && !isDead ){
				var pt:Point = new Point(point.x*world.scale, point.y*world.scale);
				pt = globalToLocal(world.localToGlobal(pt));
				graphics.lineTo(pt.x, pt.y);			
			}
		}
		/*-----------------------------------------[ for raycasting methods ] ----------------------------------------------------------------------------*/
		
		private function attack():void 
		{
			if( this != null && !isDead && !isIdle ){
				//trace( "[Boss1]: attack1....................... isAttacking " + isAttacking + " isResting " + isResting );
				if (  this.mc.currentLabel != LABEL_ATTACK 
					  && this.mc.currentLabel != LABEL_DAMAGE
					  && this.mc.currentLabel != LABEL_STAND_UP
					  && this.mc.currentLabel != LABEL_TIRED
					  && !isHit
					  && !isAttacking
					  && !isDead
					  && !isResting
					  && !_isLevelFailed
				) {				
					trace( "[Boss1]: attacking!!!!!!!!!!!!!!!!!!!!!!!!!!!!......................." );
					stopMoving();
					this.mc.gotoAndPlay( LABEL_ATTACK );
					isAttacking = true;
					
					attackCounter++;
					
					if( attackCounter >= ATTACK_COUNTER_MAX ){
						TweenLite.delayedCall( ATTACK_DELAY, standUp );
						attackCounter = 0;
					}else{					
						TweenLite.delayedCall( ATTACK_DELAY, quickIdle );
					}
				}
			}
		}
		
		private function summonGroundSpike():void 
		{
			if( !_hasGroundSpike ){
				_hasGroundSpike = true;
				var groundSpike:GroundSpikeMC = new GroundSpikeMC();				
				groundSpike.setDirection( currentDirection );
				groundSpike.addEventListener( Event.COMPLETE, onRemoveGroundSpike );
				if( currentDirection == DIRECTION_RIGHT ){
					Util.addChildAtPosOf( world, groundSpike, this, -1, new Point( 35 , 85 ) );
				}else {
					Util.addChildAtPosOf( world, groundSpike, this, -1, new Point(  -35 , 85 ) );
				}
			}
		}
		
		private function dropTreasureBox():void 
		{
			if ( !_hasDropItem ) {
				_hasDropItem = true;				
				var treasureBoxMC:TreasureBoxMC = new TreasureBoxMC();
				//Util.addChildAtPosOf( world, treasureBoxMC, this, -1, new Point( 0 , 80 ) );
				var index:int = world.getChildIndex( this );
				Util.addChildAtPosOf( world, treasureBoxMC, this, ( index -1 ), new Point( 0 , 0 ) );
				
			}			
		}
		
		
		private function dropKey():void 
		{
			if ( !_hasDropItem && this != null && world != null ) {
				_hasDropItem = true;				
				var itemKey:ItemKeyMC = new ItemKeyMC();
				//itemKey.gotoAndStop(2);
				var index:int = world.getChildIndex( this );
				Util.addChildAtPosOf( world, itemKey, this, ( index -1 ), new Point( 0 , 0 ) );
				
			}			
		}
		
		private function onRemoveGroundSpike(e:Event):void 
		{
			_hasGroundSpike = false;
		}
		
		private function standUp():void 
		{
			if( this != null && !isDead ){
				TweenLite.killDelayedCallsTo( standUp );
				if( this.mc.currentLabel != LABEL_STAND_UP && isAttacking && !isDead ){
					this.mc.gotoAndPlay( LABEL_STAND_UP );				
					TweenLite.delayedCall( 1.3, quickRest );
				}
			}
		}
		
		private function checkIfHitPlayer():void 
		{
			if ( this != null && !isDead ) {
				if ( this.mc.currentLabel == LABEL_DAMAGE ) {
					summonGroundSpike();
				}
				if ( _rayCastTarget != null && this.mc.currentLabel == LABEL_DAMAGE && isDetectPlayer ) {					
					attackPlayer( _rayCastTarget );
					//_rayCastTarget = null;
				}else if ( _target!= null /*&& this.mc.currentLabel == LABEL_DAMAGE*/ ){
					attackPlayer( _target );
					//_target = null;
				}
			}
		}		
		
		private function quickIdle():void {
			if( this != null && !isDead && !isIdle ){
				if ( this.mc.currentLabel != LABEL_IDLE && !isDead ){
					this.mc.gotoAndPlay( LABEL_IDLE );				
				}
				
				isMovingRight = false;
				isMovingLeft = false;			
				isResting = false;
				isAttacking = false;
				isDetectPlayer = false;
				isIdle = true;
				TweenLite.delayedCall( 0.5, activateWalk );
			}
		}
		
		private function clearAfterAction():void 
		{
			TweenLite.killDelayedCallsTo( quickRest );
			TweenLite.killDelayedCallsTo( activateWalk );
			TweenLite.killDelayedCallsTo( standUp );
		}
		
		private function quickRest():void {
			if( this != null && !isDead ){
				TweenLite.killDelayedCallsTo( quickRest );
				if ( !isResting ){
					if ( this.mc.currentLabel != LABEL_TIRED ){
						this.mc.gotoAndPlay( LABEL_TIRED );
					}				
					isResting = true;
					isAttacking = false;
					isDetectPlayer = false;	
					TweenLite.delayedCall( 2, activateWalk );
				}
			}
		}
		
		private function activateWalk():void {
			if( this != null && !isDead ){
				TweenLite.killDelayedCallsTo( activateWalk );
				isResting = false;
				isDetectPlayer = false;	
				isAttacking = false;
				isIdle = false;
				if ( currentDirection == DIRECTION_RIGHT ) {
					isMovingRight = true;
					isMovingLeft = false;
				}else {
					isMovingRight = false;
					isMovingLeft = true;
				}
				initAttack();
				//trace( "[Boss1]: activate walk move isMovingLeft? " + isMovingLeft + " isMovingRight " + isMovingRight );
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
		
		private function goIdle():void{
			stopMoving();
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
		
		private function lookWhereTarget():void{
			if ( LiveData.playerPosition != null ){
				if (LiveData.playerPosition.x > this.x) {
					lookRight();
				}else {
					lookLeft();
				}
			}
		}
		
		public function hit( dir:int , isKnockBack:Boolean, damage:int):Boolean 
		{
			trace( " isHit: " + isHit + " isAttacking: " + isAttacking );
			if( this != null && !isDead ){
				if ( this.mc.currentLabel != LABEL_HIT && this.mc.currentLabel != LABEL_DEATH && !isHit && !isDead && !isAttacking || ( this.mc.currentLabel == LABEL_TIRED || this.mc.currentLabel == LABEL_STAND_UP && this.mc.currentLabel != LABEL_DEATH && this.mc.currentLabel != LABEL_HIT && !isHit && !isDead ) ){
					lookWhereTarget();
					trace( "boss1 hp b4 " + hp + "damage check " + damage );
					hp -= damage;
					
					_caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.MONSTER_HIT );
					_es.dispatchESEvent( _caveSmashEvent );
					
					trace( "boss1 hp after " + hp );
					stopMoving();
					TweenLite.delayedCall(0.5, continueMoving);
					
					clearAfterAction();
					
					_caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.BOSS_RECIEVED_DAMAGED );
					_caveSmashEvent.obj.max = BOSS_LIFE;
					_caveSmashEvent.obj.hp = hp;
					_es.dispatchESEvent( _caveSmashEvent );
					
					if( hp > 0 ){
						this.mc.gotoAndPlay( LABEL_HIT );
						if( isKnockBack ){
							knockBack( dir );
						}
						TweenLite.delayedCall( HIT_DELAY, resetHit  );
					}else {
						isDead = true;
						//dropItem();						
						this.mc.gotoAndPlay( LABEL_DEATH );
						TweenLite.delayedCall( 5, removeMonster );
					}
					isHit = true;
					return true;
				}else {
					return false;
				}
			}else {
				return false;
			}
		}
		
		
		private function dropItem():void
		{
			if( this != null && isDead ){
				var rnd:int = Math.random() * 100;
				if ( rnd >= 40 && rnd <= 80 ){
					Util.addChildAtPosOf(world, new ItemGold(), this );
				}else{
					Util.addChildAtPosOf(world, new ItemHeartMC(), this );
				}
			}
		}
		
		private function knockBack( dir:int ):void 
		{			
			if( this != null && !isDead ){
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
		}
		
		private function resetHit():void 
		{
			if( this != null && !isDead ){
				isHit = false;
				//if( !isResting ){
					activateWalk();
				//}else{
					//quickIdle();
				//}
			}
		}
		
		private function removeMonster():void 
		{
			if ( this != null && isDead ) {
				//dropTreasureBox();
				dropKey();
				_caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.BOSS_DIED );
				_caveSmashEvent.obj.id = 1;
				_caveSmashEvent.obj.score = CaveSmashConfig.BOSS_MONSTER_SCORE;
				_es.dispatchESEvent( _caveSmashEvent );
				
				var _gameEvent:GameEvent = new GameEvent( GameEvent.GET_AWARD );
				_gameEvent.obj.id = 2;				
				_es.dispatchESEvent( _gameEvent );			
				
				removeControllers();
				remove();
			}
		}
		
		private function idle():void 
		{
			if( this != null && !isDead ){
				if( !_isLevelFailed ){
					if ( 	this.mc.currentLabel != LABEL_IDLE 
							&& this.mc.currentLabel != LABEL_ATTACK 
							&& !isHit 
							&& this.mc.currentLabel != LABEL_DAMAGE 
							&& this.mc.currentLabel != LABEL_WALK 
							&& this.mc.currentLabel != LABEL_STAND_UP 
							&& this.mc.currentLabel != LABEL_TIRED 
							&& !isDead
						){
						this.mc.gotoAndPlay( LABEL_IDLE );
					}
				}else {
					this.mc.gotoAndPlay( LABEL_IDLE );
				}
			}
		}		
		
		
		private function attackPlayer( target:Player2 ):void 
		{		
			if( this != null && !isDead ){
				//trace( "[Boss1]: attack player now 1..........................." );
				if ( target != null ){				
					if ( !target.isDead && !isDead ) {														
						target.hit( 3 , 1, currentDirection );					
						//trace( "[Boss1]: attack player now 2..........................." );
					}else {
						isPlayerDead = true;
						idle();
					}
				}
			}
		}	
		
		private function switchWhereToLook():void 
		{
			if( this != null && !isDead ){
				if( !isAttacking ){				
					if( currentDirection == DIRECTION_RIGHT ){
						lookLeft();
					}else if( currentDirection == DIRECTION_LEFT ){
						lookRight();
					}
				}
			}
		}
		
		private function lookLeft():void 
		{
			if( this.currentLabel != LABEL_LEFT ){				
				this.gotoAndStop( LABEL_LEFT );				
			}
			
			currentDirection = DIRECTION_LEFT;
			isMovingRight = false;
			isMovingLeft = true;
			//trace( "[ Boss1 ]: begin contact with: === > look left" );
		}
		
		private function lookRight():void 
		{
			if( this.currentLabel != LABEL_RIGHT ){				
				this.gotoAndStop( LABEL_RIGHT );				
				//trace( "[ Boss1 ]: begin contact with: === > look right" );
			}
			
			currentDirection = DIRECTION_RIGHT;
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
			_es.addEventListener( CaveSmashEvent.LEVEL_COMPLETE, onLevelComplete );
			_es.addEventListener( CaveSmashEvent.LEVEL_QUIT, OnLevelQuit );
			_es.addEventListener( CaveSmashEvent.LEVEL_FAILED, onLevelFailed );
			_es.addEventListener( CaveSmashEvent.RELOAD_LEVEL, onReloadLevel );		
			trace( "[Boss1]:add GameEvent........................ " );
		}		
		
		private function removeGameEvent():void 
		{
			_es = EventSatellite.getInstance();
			_es.removeEventListener( CaveSmashEvent.LEVEL_STARTED, onLevelStarted );
			_es.removeEventListener( CaveSmashEvent.LEVEL_COMPLETE, onLevelComplete );			
			_es.removeEventListener( CaveSmashEvent.LEVEL_FAILED, onLevelFailed );
			_es.removeEventListener( CaveSmashEvent.RELOAD_LEVEL, onReloadLevel );
			_es.removeEventListener( CaveSmashEvent.LEVEL_QUIT, OnLevelQuit );
			//trace( "[Boss1]:remove GameEvent........................ " );
		}		
		
		private function goRight():void 
		{
			if( this != null && !isDead ){			
				if( this.mc.currentLabel != LABEL_WALK && !isHit && !isDead ){
					this.mc.gotoAndPlay( LABEL_WALK );					
				}
				
				var speedX:Number = this.b2body.m_linearVelocity.x;
				var speedY:Number = this.b2body.m_linearVelocity.y;
				
				if ( speedX < 0 ) {
					b2body.SetLinearVelocity( new V2( 0,speedY ) );
				}
				
				b2body.ApplyImpulse(new V2( MOVE_POWER, 0), b2body.GetWorldCenter());
				//b2body.m_linearVelocity.x += MOVE_POWER;
				isMovingRight = true;
				isMovingLeft = false;
				
				//trace( "[Boss1]: go right........" );
			}
		}
		
		
		private function goLeft():void
		{
			if( this != null && !isDead ){
				if( this.mc.currentLabel != LABEL_WALK && !isHit && !isDead ){
						this.mc.gotoAndPlay( LABEL_WALK );					
				}
				
				var speedX:Number = this.b2body.m_linearVelocity.x;
				var speedY:Number = this.b2body.m_linearVelocity.y;
				
				if ( speedX > 0 ) {
					b2body.SetLinearVelocity( new V2( 0,speedY ) );
				}
				
				b2body.ApplyImpulse(new V2( -MOVE_POWER, 0), b2body.GetWorldCenter());
				//b2body.m_linearVelocity.x -= MOVE_POWER;
				isMovingLeft = true;
				isMovingRight = false;
				//trace( "[Boss1]: go Left........" );
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
		
		private function checkSpeedX():void 
		{
			if( this != null && !isDead ){
				var speedX:Number = this.b2body.m_linearVelocity.x;
				var limit:Number = CaveSmashConfig.SMASHER_MOVE_SPEED;
				
				var clipped_linear_velocity:V2 = this.b2body.GetLinearVelocity().normalize();
				
				if ( speedX < 0 ){
					speedX *= -1;
				}
				
				if ( speedX >= limit ){
					this.b2body.m_linearVelocity.x = clipped_linear_velocity.multiplyN(limit).x;
				}
			}
		}
		
		private function removeME():void 
		{
			if( !hasRemoved && isDead ){
				hasRemoved = true;
				this.remove();
			}
		}
		
		private function initAttack():void 
		{
			TweenLite.delayedCall( 5, onAttack );
		}
		
		private function onAttack():void 
		{
			TweenLite.killDelayedCallsTo( onAttack );
			attack();
		}
		/*--------------------------------------------------------------------------Setters---------------------------------------------------------------*/	
		
		/*--------------------------------------------------------------------------Getters-----------------------------------------------------------------*/	
		
		/*--------------------------------------------------------------------------EventHandlers------------------------------------------------------------*/	
		
		public function parseInput(e:Event):void{			
			if (!world || isDead || this == null || isPlayerDead || _isLevelFailed ) return;

			updateVector();			
			graphics.clear();
			graphics.lineStyle(3, 0xff0000, RAY_CAST_ALPHA, false, "normal", CapsStyle.NONE);
			graphics.moveTo(0,0);

			startRayCast(v1, v2);			
			
			if ( !_gdc.getIsLockControlls() ) {
				
				if (isMovingRight){
					goRight();
				}else if (isMovingLeft){
					goLeft();
				}				
				
				checkSpeedX();
				checkIfHitPlayer();
			}			
		}				
		
		public function endContact(e:ContactEvent):void{
			if ( e.other.GetBody().GetUserData() is Player ){				
				_target = null;
			}
		}
		
		public function handleContact(e:ContactEvent):void {
			trace("Boss1 hit something check " + e.other.GetBody().GetUserData() );			
			var blocksLen:int = CSObjects.BOSS1_BLOCKS.length;
			for (var i:int = 0; i < blocksLen; i++)
			{
				if (  e.other.GetBody().GetUserData() is CSObjects.BOSS1_BLOCKS[ i ] ) {					
					switchWhereToLook();
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
			
			trace( "[ Boss1 ]: begin contact with: === >" + e.other.GetBody().GetUserData() );		
			if ( e.other.GetBody().GetUserData() is Player){
				_target = e.other.GetBody().m_userData;				
			}
		}
		
		private function onLevelFailed(e:CaveSmashEvent):void{
			goIdle();
			_isLevelFailed = true;			
			clearAll();			
		}
		
		private function onLevelComplete(e:CaveSmashEvent):void 
		{			
			clearAll();
			//trace( "[Boss1]: onLevelComplete............................" );
		}
		
		private function onLevelStarted(e:CaveSmashEvent):void 
		{
			initControllers();
			
			var caveSmashEvent:CaveSmashEvent = new CaveSmashEvent( CaveSmashEvent.SHOW_BOSS_HP );
			_es.dispatchESEvent( caveSmashEvent );
			LiveData.isBossLevel = true;
			trace( "[Boss1]: onLevelStarted............................" );
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