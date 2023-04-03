package components.monsters
{
	
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
	
	public class BossFly extends BodyShape
	{
		
		/*--------------------------------------------------------------------------Constant--------------------------------------------------------------*/
		
		public static const DIRECTION_RIGHT:int = 0;
		public static const DIRECTION_LEFT:int = 1;
		
		public static const LABEL_IDLE:String = "idle";
		public static const LABEL_DIE:String = "die";
		public static const LABEL_RIGHT:String = "right";
		public static const LABEL_LEFT:String = "left";
		public static const LABEL_HIT:String = "hit";
		public static const LABEL_WALK:String = "walk";
		
		public static const BISON_RANGE_LEFT:int = 330;
		public static const BISON_RANGE_RIGHT:int = 1040;
		/*--------------------------------------------------------------------------Properties--------------------------------------------------------------*/
		
		public var HIT_DELAY:Number = 0.5;
		public var KNOCK_BACK_POWER:Number = CaveSmashConfig.HERO_KNOCK_BACK_POWER;
		public var JUMP_POWER:Number = -1.5;
		public var MOVE_POWER:Number = CaveSmashConfig.BOSS_BISON_SPEED;
		
		public var currentDirection:int = DIRECTION_RIGHT;
		public var isJumping:Boolean = false;
		public var isAttacking:Boolean = false;
		public var isFalling:Boolean = false;
		public var isDead:Boolean = false;
		public var isMovingRight:Boolean = false;
		public var isMovingLeft:Boolean = false;
		public var isHit:Boolean = false;
		private var BOSS_LIFE:Number = CaveSmashConfig.BOSS_BISON_HP;
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
		public var magnitude:Number = 0;
		public var magnitudeOffset:Number = 0;
		public var magnitudeOffsetY:Number = 0;
		
		protected var p1:Point //start point
		protected var p2:Point //end point
		protected var v1:V2 //start point in world.scale
		protected var v2:V2 //end point in world.scale
		
		//stored by raycast callback.
		protected var valid:Boolean;
		protected var fixture:b2Fixture;
		protected var point:V2;
		//raycast things
		
		private var _gdc:GameDataController;
		public var _es:EventSatellite;
		public var _caveSmashEvent:CaveSmashEvent;
		
		private var _target:Player2;
		
		public var _levelIsDone:Boolean = false;
		private var hasRemoved:Boolean;
		
		public var isMovingUp:Boolean = false;
		public var isMovingDown:Boolean = false;
		public var powerDash:int;
		public var isAiming:Boolean = false;		
		private var _isAttack2Complete:Boolean = true;
		public var _hasDropItem:Boolean;
		private var targetX:int;
		private var hasTeleport:Boolean;
		private var isEmergencyTeleport:Boolean;		
		/*--------------------------------------------------------------------------Constructor--------------------------------------------------------------*/
		
		public override function shapes():void
		{
		}
		
		public override function create():void
		{
			//trace( "[monster] create monster" );			
			super.create();
			
			//type = "Kinematic";
			type = "Dynamic";
			applyGravity = false;
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
			lookRight();
			addGameEvent();
			
			driveRight();
			//offHorizontalMovement();
			//offVerticalMovement();			
		}
		
		/*--------------------------------------------------------------------------Methods--------------------------------------------------------------*/
		
		/*-----------------------------------------[ for raycasting methods ] ----------------------------------------------------------------------------*/
		protected function updateVector():void
		{
			if (_levelIsDone)
			{
				return;
			}
			
			//convert start and end locations to world.			
			p1 = new Point(0, 0);
			if (currentDirection == DIRECTION_RIGHT)
			{
				p2 = new Point(magnitude, magnitudeOffsetY); //assumes that art is facing right at 0º
			}
			else if (currentDirection == DIRECTION_LEFT)
			{
				p2 = new Point(-(magnitude - magnitudeOffset), magnitudeOffsetY);
			}
			
			p1 = world.globalToLocal(this.localToGlobal(p1));
			p2 = world.globalToLocal(this.localToGlobal(p2));
			
			v1 = new V2(p1.x, p1.y);
			v2 = new V2(p2.x, p2.y);
			
			v1.divideN(world.scale);
			v2.divideN(world.scale);
		}
		
		protected function startRayCast(v1:V2, v2:V2):void
		{
			if (_levelIsDone)
			{
				return;
			}
			valid = false;
			
			world.b2world.RayCast(rcCallback, v1, v2); //see onRayCast();
			
			if (valid)
			{
				
				var body:BodyShape = fixture.m_userData.body //tip for finding the wck body.				
				//trace("fly raycast hit", fixture.GetBody().GetUserData());
				
				var blocksLen:int = CSObjects.DESTROYER_BLOCKS.length;
				for (var i:int = 0; i < blocksLen; i++)
				{
					if (fixture.GetBody().GetUserData() is CSObjects.DESTROYER_BLOCKS[i])
					{
						isDetectPlayer = false;
						//switchWhereToLook();
						hitWallWhenMovingX();					
						break;
					}
				}				
				
				var trapLen:int = CSObjects.TRAPS.length;
				for (i = 0; i < trapLen; i++)
				{
					if (fixture.GetBody().GetUserData() is CSObjects.TRAPS[i])
					{
						isDetectPlayer = false;
						//switchWhereToLook();						
						break;
					}
				}
				
				var monstersLen:int = CSObjects.MONSTERS.length;
				for (var j:int = 0; j < monstersLen; j++)
				{
					if (fixture.GetBody().GetUserData() is CSObjects.MONSTERS[j])
					{
						isDetectPlayer = false;
						//switchWhereToLook();
						break;
					}
				}
				
				if (fixture.GetBody().GetUserData() is Player){
					isDetectPlayer = true;					
				}
				
				drawLaser();
			}
			else{ 
				isDetectPlayer = false;				
				point = v2; //full length
				drawLaser();				
			}
		}
		
		
		
		protected function rcCallback(_fixture:b2Fixture, _point:V2, normal:V2, fraction:Number):Number
		{
			//found one
			if (_fixture.IsSensor())
			{ //is it a sensor?
				return -1 //pass through
			}
			
			//set this one as the current closest find
			valid = true;
			fixture = _fixture;
			point = _point;
			
			return fraction; //then check again for any closer finds.
		}
		
		protected function drawLaser():void
		{
			if (!_levelIsDone)
			{
				var pt:Point = new Point(point.x * world.scale, point.y * world.scale);
				pt = globalToLocal(world.localToGlobal(pt));
				
				graphics.lineTo(pt.x, pt.y);
			}
		}
		
		/*-----------------------------------------[ for raycasting methods ] ----------------------------------------------------------------------------*/
		
		public function goAttack2():void
		{
			if (_isAttack2Complete)
			{
				_isAttack2Complete = false;
			}
		}
		
		
		private function stopAndAimTarget():void 
		{
			if ( !isAiming ) {
				TweenLite.killDelayedCallsTo( stopAndAimTarget );
				isAiming = true;
				stopMoving();
				lockTarget();
			}
		}
		
		private function goIdle():void 
		{
			stopMoving();
		}
		
		public function hit(dir:int, isKnockBack:Boolean = false, damage:int = 1):Boolean
		{
			if(!isHit && !isDead){
				hp -= damage;
				
				_caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.MONSTER_HIT );
				_es.dispatchESEvent( _caveSmashEvent );
				
				_caveSmashEvent = new CaveSmashEvent(CaveSmashEvent.BOSS_RECIEVED_DAMAGED);
				_caveSmashEvent.obj.max = BOSS_LIFE;
				_caveSmashEvent.obj.hp = hp;
				_es.dispatchESEvent(_caveSmashEvent);
				TweenLite.delayedCall(HIT_DELAY, resetHit);
				
				if (hp > 0){
					if (isKnockBack){
						knockBack(dir);
					}
				}else{
					dropItem();
					kill();
				}
				
				isHit = true;
				return true;
			}else{
				return false;
			}
		}	
		
		public function kill():void
		{
			if (this != null && !isDead)
			{
				stopMoving();
				TweenLite.delayedCall(1.5, onRemoveFly);
			}
		}
		
		private function onRemoveFly():void
		{
			TweenLite.killDelayedCallsTo(onRemoveFly);
			isDead = true;
			var explodeEffect:Explode2MC = new Explode2MC();
			var xpos:Number = (explodeEffect.width * 0.5) * -1;
			var ypos:Number = (explodeEffect.height * -1) + 20;
			Util.addChildAtPosOf(world, explodeEffect, this, -1, new Point(xpos, ypos));
			
			_caveSmashEvent = new CaveSmashEvent(CaveSmashEvent.BOSS_DIED);
			_caveSmashEvent.obj.id = 1;
			_caveSmashEvent.obj.score = CaveSmashConfig.BOSS_MONSTER_SCORE;
			_es.dispatchESEvent(_caveSmashEvent);
			
			
			var _gameEvent:GameEvent = new GameEvent( GameEvent.GET_AWARD );
			_gameEvent.obj.id = 3;				
			_es.dispatchESEvent( _gameEvent );			
			
			removeME();
		}
		
		private function removeME():void
		{
			if (!hasRemoved && isDead)
			{
				hasRemoved = true;
				this.remove();
			}
		}		
		
		public function dropItem():void{			
		}
		
		private function knockBack(dir:int):void
		{
			//trace( "[Monster]: knockback!!!!!" );
			if (dir == DIRECTION_LEFT)
			{
				b2body.ApplyImpulse(new V2(-KNOCK_BACK_POWER, 0), b2body.GetWorldCenter());
				//currentDirection = DIRECTION_LEFT;
				lookRight();
			}
			else if (dir == DIRECTION_RIGHT)
			{
				b2body.ApplyImpulse(new V2(KNOCK_BACK_POWER, 0), b2body.GetWorldCenter());
				//currentDirection = DIRECTION_RIGHT;
				lookLeft();
			}
		}
		
		private function resetHit():void
		{
			isHit = false;
			if (isDead){
				removeControllers();
				remove();
			}
		}
		
		private function attackPlayer(target:Player2):void
		{
			var player:Player2 = target as Player2;
			if (!player.isDead && !isDead){
				isDetectPlayer = true;
				player.hit(2, 1,currentDirection);
			}else{
				isPlayerDead = true;
			}
		}
		
		private function switchWhereToLook():void
		{
			if (currentDirection == DIRECTION_RIGHT){
				lookLeft();
			}else if (currentDirection == DIRECTION_LEFT){
				lookRight();
			}
		}
		
		private function lookLeft():void
		{
			if (this.currentLabel != LABEL_LEFT){
				currentDirection = DIRECTION_LEFT;
				this.gotoAndStop(LABEL_LEFT);							
			}
		}
		
		private function lookRight():void
		{
			if (this.currentLabel != LABEL_RIGHT){
				currentDirection = DIRECTION_RIGHT;
				this.gotoAndStop(LABEL_RIGHT);				
			}
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
			_es.addEventListener(CaveSmashEvent.LEVEL_STARTED, onLevelStarted);
			_es.addEventListener(CaveSmashEvent.LEVEL_QUIT, OnLevelQuit);
			_es.addEventListener(CaveSmashEvent.LEVEL_COMPLETE, onLevelComplete);
			_es.addEventListener(CaveSmashEvent.LEVEL_FAILED, onLevelFailed);
			_es.addEventListener(CaveSmashEvent.RELOAD_LEVEL, onReloadLevel);
			//trace( "[Monster]:add GameEvent........................ " );
		}
		
		private function removeGameEvent():void
		{
			_es = EventSatellite.getInstance();
			_es.removeEventListener(CaveSmashEvent.LEVEL_STARTED, onLevelStarted);
			_es.removeEventListener(CaveSmashEvent.LEVEL_QUIT, OnLevelQuit);
			_es.removeEventListener(CaveSmashEvent.LEVEL_COMPLETE, onLevelComplete);
			_es.removeEventListener(CaveSmashEvent.LEVEL_FAILED, onLevelFailed);
			_es.removeEventListener(CaveSmashEvent.RELOAD_LEVEL, onReloadLevel);
			//trace( "[Monster]:remove GameEvent........................ " );
		}
		
		public function goRight():void
		{
			if (_levelIsDone && isDead)
			{
				return;
			}
			
			if (this != null)
			{			
				var speedX:Number = this.b2body.m_linearVelocity.x;
				var speedY:Number = this.b2body.m_linearVelocity.y;
				
				if (speedX < 0){
					b2body.SetLinearVelocity(new V2(0, speedY));
				}				
				
				b2body.m_linearVelocity.x += MOVE_POWER;
				isMovingRight = true;
				isMovingLeft = false;
			}
		}
		
		public function goLeft():void
		{
			if (_levelIsDone && isDead)
			{
				return;
			}
			
			if (this != null){			
				var speedX:Number = this.b2body.m_linearVelocity.x;
				var speedY:Number = this.b2body.m_linearVelocity.y;
				
				if (speedX > 0){
					b2body.SetLinearVelocity(new V2(0, speedY));
				}				
				
				b2body.m_linearVelocity.x -= MOVE_POWER;
				isMovingLeft = true;
				isMovingRight = false;
			}
		}
		
		public function stopMoving():void
		{
			b2body.SetLinearVelocity(new V2(0, 0));
			isMovingLeft = false;
			isMovingRight = false;
			isMovingUp = false;
			isMovingDown = false;
		}
		
		private function clearAll():void
		{
			removeAllListeners();
			removeControllers();
			removeGameEvent();
			//this.remove();			
		}		
		
		public function attack1():void
		{			
			b2body.SetLinearVelocity(new V2(0, 0));
			isMovingUp = false;
			isMovingDown = true;
		}	
		
		public function goUp():void
		{
			if (_levelIsDone && isDead){
				return;
			}			
			
			if (this != null){			
				var speedX:Number = this.b2body.m_linearVelocity.x;
				var speedY:Number = this.b2body.m_linearVelocity.y;
				
				if (speedY > 0){
					//b2body.SetLinearVelocity(new V2(speedX, 0));
					b2body.SetLinearVelocity(new V2(0, 0));
				}				
				
				b2body.m_linearVelocity.y -= 1;
				
				if ( this.x <= -200 ) {
					forceGoDown();
				}
			}			
		}
		
		private function forceGoDown():void 
		{
			if ( !hasTeleport ) {
				targetX = LiveData.playerPosition.x;
				hasTeleport = true;
				offHorizontalMovement();
				offVerticalMovement();
				TweenLite.delayedCall( 0.5, stopAndAimTarget );				
				trace("force boss bison start aiming target!!!!!!!!!!!!");
			}		
		}
		
		public function goDown():void
		{
			if (_levelIsDone && isDead){
				return;
			}			
			
			if (this != null){			
				var speedX:Number = this.b2body.m_linearVelocity.x;
				var speedY:Number = this.b2body.m_linearVelocity.y;
				
				if (speedY < 0){
					//b2body.SetLinearVelocity(new V2(speedX, 0));
					b2body.SetLinearVelocity(new V2(0, 0));
				}				
				
				b2body.m_linearVelocity.y += 1;				
			}	
		}	
		
		
		private function teleport():void 
		{
			if (LiveData.playerPosition != null && this != null && world != null && !isEmergencyTeleport ) {
				isEmergencyTeleport = true;
				TweenLite.delayedCall(1,activateEmergencyTeleport );
			}
		}
		
		private function activateEmergencyTeleport():void 
		{
			if (LiveData.playerPosition != null && this != null && world != null){				
				stopMoving();
				type = "Static";				
				this.x = LiveData.playerPosition.x;
				this.y = LiveData.playerPosition.y - 100;
				syncTransform();
				type = "Dynamic";				
				//trace("bison teleport to target successfully!!! !!!!!!!");
				isEmergencyTeleport = false;
			}
		}
		
		private function lockTarget():void 
		{			
			if (isAiming && LiveData.playerPosition != null && this != null && world != null )
			{
				stopMoving();
				type = "Static";
				
				if ( targetX < BISON_RANGE_LEFT ){
					targetX = BISON_RANGE_LEFT;
				}
				
				if ( targetX > BISON_RANGE_RIGHT ) {
					targetX = BISON_RANGE_RIGHT;
				}
				
				if( targetX <= BISON_RANGE_LEFT ){
					this.x = targetX + ( this.width * 0.5 );
				}else if( targetX >= BISON_RANGE_RIGHT ){
					this.x = targetX - ( this.width * 0.5 );
				}else {
					this.x = targetX;
				}
				
				syncTransform();
				type = "Dynamic";
				isAiming = false;
				//trace("locking target successfully!!! !!!!!!!");
				driveDown();
				hasTeleport = false;
			}else {
				//trace("locking target failed reason null references!!!!!!!");
			}
			
		}		
		
		public function summonTornado():void
		{		
			if (!_isAttack2Complete && this != null && world != null ){
				_isAttack2Complete = true;		
				var tornado:TornadoMC = new TornadoMC();
				tornado.setDirection(currentDirection);				
				if (currentDirection == DIRECTION_RIGHT){
					Util.addChildAtPosOf(world, tornado, this, -1, new Point(45, 30));
				}else{
					Util.addChildAtPosOf(world, tornado, this, -1, new Point(-45, 30));
				}
			}
		}
		
		
		private function removeTweens():void 
		{			
			TweenLite.killDelayedCallsTo(onRemoveFly);
			TweenLite.killDelayedCallsTo(resetHit);
			TweenLite.killDelayedCallsTo(stopAndAimTarget );
			TweenLite.killDelayedCallsTo(activateEmergencyTeleport );
			TweenLite.killDelayedCallsTo(goAttack2 );
		}
		/*--------------------------------------------------------------------------Setters---------------------------------------------------------------*/
		
		/*--------------------------------------------------------------------------Getters-----------------------------------------------------------------*/
		
		/*--------------------------------------------------------------------------EventHandlers------------------------------------------------------------*/
		
		public function parseInput(e:Event):void
		{
			if (!world || isDead || this == null || isPlayerDead || _levelIsDone)
				return;
				
			syncTransform();
			updateVector();
			graphics.clear();
			graphics.lineStyle(3, 0xff0000, RAY_CAST_ALPHA, false, "normal", CapsStyle.NONE);
			graphics.moveTo(0, 0);
			
			startRayCast(v1, v2);
			
			if (!isAiming){
				if (!_gdc.getIsLockControlls()){
					if (currentDirection == DIRECTION_RIGHT && !isAttacking && !isHit && !_levelIsDone) {
						if( isMovingRight && !isMovingLeft ){
							goRight();
						}
					}
					else if (currentDirection == DIRECTION_LEFT && !isAttacking && !isHit && !_levelIsDone) {
						if( !isMovingRight && isMovingLeft ){
							goLeft();
						}
					}
				}			
				
				if ( isMovingUp ){
					goUp();
				}
				if ( isMovingDown ){
					goDown();
				}
			}			
			
			checkSpeedX();
			checkIfHitPlayer();
			if( LiveData.playerPosition != null ){
				//trace("playex " + LiveData.playerPosition.x );
			}
		}
		
		private function checkIfHitPlayer():void
		{
			if (_levelIsDone)
			{
				return;
			}
			
			if (this != null)
			{
				if (_target != null)
				{
					attackPlayer(_target);
				}
			}
		}
		
		private function checkSpeedX():void
		{
			if (_levelIsDone)
			{
				return;
			}
			
			if (this != null)
			{
				var speedX:Number = this.b2body.m_linearVelocity.x;
				var limit:Number = CaveSmashConfig.RED_MONSTER_SPEED;
				
				var clipped_linear_velocity:V2 = this.b2body.GetLinearVelocity().normalize();
				
				if (speedX < 0)
				{
					speedX *= -1;
				}
				
				if (speedX >= limit)
				{
					this.b2body.m_linearVelocity.x = clipped_linear_velocity.multiplyN(limit).x;
				}
			}
		}
		
		public function endContact(e:ContactEvent):void
		{
			if (e.other.GetBody().GetUserData() is Player && !isDetectPlayer)
			{				
				_target = null;
			}
			else if (e.other.GetBody().GetUserData() is Player && isDetectPlayer)
			{
				_target = null;
			}
		}
		
		private function deActivateAttack():void
		{
			if (isAttacking)
			{
				isAttacking = false;
			}
		}		
		
		public function offHorizontalMovement():void 
		{
			isMovingLeft = false;
			isMovingRight = false;
		}
		
		public function offVerticalMovement():void 
		{			
			isMovingUp = false;
			isMovingDown = false;
		}		
		
		private function driveRight():void 
		{
			isMovingLeft = false;
			isMovingRight = true;
		}
		
		
		private function driveLeft():void 
		{
			isMovingLeft = true;
			isMovingRight = false;
		}
		
		public function driveUp():void 
		{
			isMovingUp = true;
			isMovingDown = false;
		}
		
		public function driveDown():void 
		{
			isMovingUp = false;
			isMovingDown = true;
		}
		
		private function searchTarget():void 
		{
			if (_levelIsDone && isDead){
				return;
			}			
			
			if (this != null && LiveData.playerPosition != null ) {								
				if( this.y >= 130 && ( isMovingLeft || isMovingRight ) ){
					//trace( " bison.x  " + this.x + " target.x " + targetX );
					if ( this.x == targetX ) {
						offHorizontalMovement();
						driveDown();
					}	
				}
			}
		}
		
		private function checkLeftRight():void 
		{
			offVerticalMovement();
			if ( currentDirection == DIRECTION_RIGHT ) {
				goRight();
			}else {
				goLeft();
			}
		}	
		
		private function hitWallWhenMovingX():void 
		{			
			offHorizontalMovement();
			if (currentDirection == DIRECTION_LEFT) {
				lookRight();
			}else {
				lookLeft();
			}
			driveUp();
		}
		
		private function hitSomethingWhenAttackDown():void 
		{
			if ( isMovingDown ){				
				checkLeftRight();
				TweenLite.delayedCall( 0.2, goAttack2 );				
			}else {
				goAttack2();
			}
		}
		
		public function handleContact(e:ContactEvent):void
		{
			trace( "[ BossFly ]: begin contact with: === >" + e.other.GetBody().GetUserData() );
			if (e.other.GetBody().GetUserData() is Wall_LongMC ) {
				hitWallWhenMovingX();
				trace("boss bison hit Wall_LongMC!!!!!!!!!!!!!!!!!!!");				
			}
			
			if (e.other.GetBody().GetUserData() is CatcherMC ) {
				activateEmergencyTeleport();
				trace("boss bison hit CatcherMC!!!!!!!!!!!!!!!!!!!");				
			}
			
			
			var blocksLen:int = CSObjects.DESTROYER_BLOCKS.length;
			for (var i:int = 0; i < blocksLen; i++)
			{
				if (e.other.GetBody().GetUserData() is CSObjects.DESTROYER_BLOCKS[i])
				{	
					hitSomethingWhenAttackDown();
					break;
				}
			}
			
			var specialLen:int = CSObjects.SPECIAL_BLOCKS.length;
			for (i = 0; i < specialLen; i++){
				if (e.other.GetBody().GetUserData() is CSObjects.SPECIAL_BLOCKS[i]){	
					hitSomethingWhenAttackDown();
					break;
				}
			}
			
			var trapLen:int = CSObjects.TRAPS.length;
			for (i = 0; i < trapLen; i++)
			{
				if (e.other.GetBody().GetUserData() is CSObjects.TRAPS[i])
				{					
					break;
				}
			}
			
			
			var monstersLen:int = CSObjects.MONSTERS.length;
			for (var j:int = 0; j < monstersLen; j++)
			{
				if (e.other.GetBody().GetUserData() is CSObjects.MONSTERS[j])
				{					
					break;
				}
			}
			
			if (e.other.GetBody().GetUserData() is Player) {
				_target = e.other.GetBody().m_userData;
				driveUp();
			}
			
			/*
			if (e.other.GetBody().GetUserData() is Player && !isDetectPlayer){				
				_target = e.other.GetBody().m_userData;				
				hitSomethingWhenAttackDown();
			}else if (e.other.GetBody().GetUserData() is Player && isDetectPlayer){
				_target = e.other.GetBody().m_userData;
				hitSomethingWhenAttackDown();
				checkLeftRight();				
			}*/
			
			if (e.other.GetBody().GetUserData() is CeillingLongMC ){
				trace("boss bison hit ceilling!!!!!!!!!!!!!!!!!!! bison.y " + this.y);
				if ( !hasTeleport ) {
					targetX = LiveData.playerPosition.x;
					hasTeleport = true;
					offHorizontalMovement();
					offVerticalMovement();
					TweenLite.delayedCall( 0.5, stopAndAimTarget );
					//stopAndAimTarget();
					trace("boss bison start aiming target!!!!!!!!!!!!");
				}				
			}							
		}
		
		private function onLevelFailed(e:CaveSmashEvent):void{
			goIdle();
			removeTweens();
			_levelIsDone = true;
			clearAll();
			//trace( "[Monster]: on level failed" );
		}
		
		private function onLevelComplete(e:CaveSmashEvent):void
		{
			removeTweens();
			_levelIsDone = true;
			clearAll();
			//trace( "[Monster]: onLevelComplete............................" );
		}
		
		private function onLevelStarted(e:CaveSmashEvent):void
		{
			removeTweens();
			_levelIsDone = false;
			initControllers();
			
			var caveSmashEvent:CaveSmashEvent = new CaveSmashEvent(CaveSmashEvent.SHOW_BOSS_HP);
			_es.dispatchESEvent(caveSmashEvent);
			LiveData.isBossLevel = true;
			//trace("[Boss1]: onLevelStarted............................");
			
			
			//trace( "[Monster]: onLevelStarted............................" );
		}
		
		private function OnLevelQuit(e:CaveSmashEvent):void
		{
			removeTweens();
			clearAll();
			removeME();
		}
		
		private function onReloadLevel(e:CaveSmashEvent):void
		{
			removeTweens();
			clearAll();
			removeME();
		}
	}
}