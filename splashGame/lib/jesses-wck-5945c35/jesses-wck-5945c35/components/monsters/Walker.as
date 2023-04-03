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
	import com.monsterPatties.utils.eventSatellite.EventSatellite;
	import components.config.CSObjects;
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
	
	public class Walker extends BodyShape {	
        
		/*--------------------------------------------------------------------------Constant--------------------------------------------------------------*/	
		
		public static const DIRECTION_STILL:int = -1;
		public static const DIRECTION_RIGHT:int = 0;
		public static const DIRECTION_LEFT:int = 1;
		
		public static const LABEL_DIE:String = "die";
		public static const LABEL_RIGHT:String = "right";
		public static const LABEL_LEFT:String = "left";
		public static const LABEL_HIT:String = "hit";
		public static const LABEL_IDLE:String = "idle";
		public static const LABEL_WALK:String = "walk";
		/*--------------------------------------------------------------------------Properties--------------------------------------------------------------*/	
		
		public var HIT_DELAY:Number = 0.3;
		public var KNOCK_BACK_POWER:Number = CaveSmashConfig.HERO_KNOCK_BACK_POWER;
		public var JUMP_POWER:Number = -1.5;
		public var MOVE_POWER:Number = CaveSmashConfig.WALKER_MONSTER_SPEED;
		public var DASH_POWER:Number = 0;
		
		
		public var currentDirection:int = DIRECTION_RIGHT;
		public var prevDirection:int = DIRECTION_RIGHT;
		public var isJumping:Boolean = false;
		public var isAttacking:Boolean = false;
		public var isPreparingToAttack:Boolean = false;
		public var isFalling:Boolean = false;
		public var isDead:Boolean = false;
		public var isMovingRight:Boolean = false;
		public var isMovingLeft:Boolean = false;
		public var isHit:Boolean = false;		
		public var hp:Number = CaveSmashConfig.WALKER_HP;
		public var isDetectPlayer:Boolean = false;
		public var isPlayerDead:Boolean = false;
		
		//type monster
		public var isDigger:Boolean = false;
		public var isDasher:Boolean = false;
		//	
		
		public var contacts:ContactList;
		
		//raycast things
		public var rot:Number = 0;
		private var RAY_CAST_ALPHA:int = CaveSmashConfig.MONSTER_RAY_CAST_ALPHA;
		private var jump:Boolean;
		//length of raycast
        public var magnitude:Number = 40;
		protected var magnitudeOffset:Number = 0;
		public var magnitudeOffsetY:Number = CaveSmashConfig.MONSTER_RAY_CAST_LENGTH;

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
		
		public var _target:Player2;
		public var _levelIsDone:Boolean = false;
		private var hasRemoved:Boolean;		
		public var hasIdle:Boolean = false;
		private var isLanded:Boolean = false;
		public var isSpeedType:Boolean = false;
		public var isAgressive:Boolean = false;
		public var idleTime:Number = CaveSmashConfig.WALKER_IDLE_TIME;		
		/*--------------------------------------------------------------------------Constructor--------------------------------------------------------------*/	
		
		//public override function shapes():void {
			//
		//}
		
		override public function shapes():void{
			//super.shapes();			
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
			//_inertiaScale = 1;
			listenWhileVisible(world, StepEvent.STEP, parseInput, false, 10);
			listenWhileVisible(this, ContactEvent.BEGIN_CONTACT, handleContact);
			listenWhileVisible(this, ContactEvent.END_CONTACT, endContact);
			contacts = new ContactList();
			contacts.listenTo(this);
			lookRight();			
			addGameEvent();
			
			trace( "hasIdle " + hasIdle );
			if( hasIdle ){
				TweenLite.delayedCall( idleTime, goStill );
			}
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
			if ( _levelIsDone || this ==null || this.b2body == null || world ==null  ) {
				return;
			}
			valid = false;

			world.b2world.RayCast(rcCallback, v1, v2); //see onRayCast();

			if(valid){
				var body:BodyShape = fixture.m_userData.body //tip for finding the wck body.				
				//trace( "walker raycast hit", fixture.GetBody().GetUserData() );
				
				
				var blocksLen:int = CSObjects.MONSTER_TERRAIN.length;
				for (var i:int = 0; i < blocksLen; i++) 
				{
					if (  fixture.GetBody().GetUserData() is CSObjects.MONSTER_TERRAIN[ i ] ){
						isDetectPlayer = false;
						switchWhereToLook();
						break;
					}
				}				
				
				
				if ( fixture.GetBody().GetUserData() is Player ) {
					isDetectPlayer = true;
					if (isDasher && !isPreparingToAttack && !isAttacking && !isHit ) {
						prepareAttack();
					}
				}
				
				drawLaser();
			}else {//if none were found
				isDetectPlayer = false;
				switchWhereToLook();
				point=v2; //full length
				drawLaser();
				//trace( "not valid" );
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
		
		protected function drawLaser():void {
			if( !_levelIsDone ){
				var pt:Point = new Point(point.x*world.scale, point.y*world.scale);
				pt = globalToLocal(world.localToGlobal(pt));

				graphics.lineTo(pt.x, pt.y);			
			}
		}
		/*-----------------------------------------[ for raycasting methods ] ----------------------------------------------------------------------------*/
		
		public function prepareAttack():void {			
			TweenLite.killDelayedCallsTo(goStill );
			goStillToAttack();
			isPreparingToAttack = true;			
		}
		
		public function attack():void{			
			isAttacking = true;			
		}
		
		public function summonShot():void{
			
		}
		
		public function setDirection(dir:int):void{
			if ( dir == DIRECTION_RIGHT ) {
				lookRight();
			}else {
				lookLeft();
			}
			initControllers();
			_levelIsDone = false;
		}
		
		public function hit( dir:int , isKnockBack:Boolean = false ):Boolean 
		{
			if ( !isHit && !isDead ){
				hp--;
				isPreparingToAttack = false;
				isAttacking  = false;
				
				_caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.MONSTER_HIT );
				_es.dispatchESEvent( _caveSmashEvent );
				
				TweenLite.delayedCall( HIT_DELAY, resetHit  );
				if( hp > 0 ){					
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
				var explodeEffect:Explode2MC = new Explode2MC();
				var xpos:Number = ( explodeEffect.width * 0.5 ) * -1;
				var ypos:Number = ( explodeEffect.height * -1 )+ 20;
				Util.addChildAtPosOf( world, explodeEffect, this, -1, new Point( xpos , ypos ) );
				
				
				isDead = true;
				_caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.MONSTER_DIED );
				_caveSmashEvent.obj.score = CaveSmashConfig.RED_MONSTER_SCORE;
				_es.dispatchESEvent( _caveSmashEvent );
				
				removeME();
			}
		}
		
		private function removeME():void 
		{
			if ( !hasRemoved && isDead ) {
				TweenLite.killDelayedCallsTo(goStill);
				TweenLite.killDelayedCallsTo( continueMoving );
				hasRemoved = true;
				this.remove();
			}
		}
		
		protected function dropItem():void{			
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
		
		public function resetHit():void 
		{			
			isHit = false;
			if ( isDead ) {
				removeControllers();
				remove();
			}
		}		
		
		public function attackPlayer( target:Player2 ):void 
		{
			var player:Player2 = target as Player2;
			if( !player.isDead && !isDead ){
				isDetectPlayer = true;
				if(!isDasher){
					player.hit( 2, 1, currentDirection );
				}else {
					player.hit( 4, 1, currentDirection );
				}
			}else {
				isPlayerDead = true;				
			}
		}
		
		private function switchWhereToLook():void{
			if( currentDirection == DIRECTION_RIGHT ){
				lookLeft();
			}else if( currentDirection == DIRECTION_LEFT ){
				lookRight();
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
		}
		
		private function lookRight():void 
		{
			if( this.currentLabel != LABEL_RIGHT ){				
				this.gotoAndStop( LABEL_RIGHT );				
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
			if ( _levelIsDone ) {
				return;
			}
			
			if( this != null && this.b2body != null ){				
				var speedX:Number = this.b2body.m_linearVelocity.x;
				var speedY:Number = this.b2body.m_linearVelocity.y;
				
				if ( speedX < 0 ){
					b2body.SetLinearVelocity( new V2( 0,speedY ) );
				}				
				b2body.ApplyImpulse(new V2( MOVE_POWER, 0), b2body.GetWorldCenter());				
			}
		}
		
		public function dashRight():void 
		{
			if ( _levelIsDone ) {
				return;
			}
			
			if( this != null ){				
				var speedX:Number = this.b2body.m_linearVelocity.x;
				var speedY:Number = this.b2body.m_linearVelocity.y;
				
				if ( speedX < 0 ){
					b2body.SetLinearVelocity( new V2( 0,speedY ) );
				}				
				b2body.ApplyImpulse(new V2( DASH_POWER, 0), b2body.GetWorldCenter());	
				
				trace("walker base dashing right!!!!!!!!");
			}
		}
		
		
		private function stopMoving():void 
		{
			if ( _levelIsDone ) {
				return;
			}
			
			if( this != null && b2body != null ){	
				b2body.SetLinearVelocity( new V2( 0, 0 ) );
			}
		}
		
		
		public function goLeft():void
		{
			if ( _levelIsDone ) {
				return;
			}
			
			if( this != null && this.b2body != null){
				var speedX:Number = this.b2body.m_linearVelocity.x;
				var speedY:Number = this.b2body.m_linearVelocity.y;
				
				if ( speedX > 0 ){
					b2body.SetLinearVelocity( new V2( 0,speedY ) );
				}
				
				b2body.ApplyImpulse(new V2( -MOVE_POWER, 0), b2body.GetWorldCenter());				
			}
		}
		
		public function dashLeft():void
		{
			if ( _levelIsDone ) {
				return;
			}
			
			if( this != null ){
				var speedX:Number = this.b2body.m_linearVelocity.x;
				var speedY:Number = this.b2body.m_linearVelocity.y;
				
				if ( speedX > 0 ){
					b2body.SetLinearVelocity( new V2( 0,speedY ) );
				}
				
				b2body.ApplyImpulse(new V2( -DASH_POWER, 0), b2body.GetWorldCenter());	
				
				trace("walker base dashing left!!!!!!!!");
			}
		}
		
		private function clearAll():void 
		{			
			TweenLite.killDelayedCallsTo(goStill);
			TweenLite.killDelayedCallsTo( continueMoving );
			removeAllListeners();
			removeControllers();
			removeGameEvent();			
		}		
		
		public function goStill():void {
			if ( _levelIsDone ) {
				return;
			}
			
			if( this != null && hasIdle && this.b2body != null ){
				TweenLite.killDelayedCallsTo(goStill);
				prevDirection = currentDirection;
				currentDirection == DIRECTION_STILL;
				isMovingLeft = false;
				isMovingRight = false;
				stopMoving();
				TweenLite.delayedCall( 2, continueMoving );
				//trace("go stil fucker!!!!!!!!!!");
			}
		}
		
		public function goStillToAttack():void {
			if ( _levelIsDone ) {
				return;
			}
			
			if( this != null ){
				TweenLite.killDelayedCallsTo(goStillToAttack);
				prevDirection = currentDirection;
				currentDirection == DIRECTION_STILL;				
				isMovingLeft = false;
				isMovingRight = false;
				stopMoving();				
			}
		}
		
		public function continueMoving():void 
		{
			if ( _levelIsDone ) {
				return;
			}
			
			if( this != null ){
				TweenLite.killDelayedCallsTo( continueMoving );
				checkDirection();
				TweenLite.delayedCall( idleTime, goStill );
			}
		}
		
		public function checkDirection():void{
			if ( _levelIsDone ) {
				return;
			}
			
			if ( this != null ) {	
				if (currentDirection == DIRECTION_STILL) {
					currentDirection = prevDirection;	
				}
				
				if (currentDirection == DIRECTION_RIGHT) {
					lookRight();
				}else {
					lookLeft();
				}
			}
		}	
		
		private function doSomeRayCastStuff():void{
			updateVector();			
			graphics.clear();
			graphics.lineStyle(3, 0xff0000, RAY_CAST_ALPHA, false, "normal", CapsStyle.NONE);
			graphics.moveTo(0,0);
		}
		
		private function hitSomethingWhileAttacking():void{
			if ( isAttacking && isDasher && !isPreparingToAttack ) {
				isAttacking = false;
				goStill();
			}
		}
		
		private function checkActionTodo():void {			
			if( this != null && this.b2body != null && world != null && _gdc != null ){
				if ( !_gdc.getIsLockControlls() && !isAttacking && !isHit && !_levelIsDone && !isPreparingToAttack ){				
					if ( isMovingRight ) {					
						goRight();					
					}else if ( isMovingLeft ){
						goLeft();
					}else {
						goStill();
					}
				}else{
					if (isDasher && isAttacking && !isPreparingToAttack ){
						if (isMovingRight) {
							dashRight();
						}else {
							dashLeft();
						}
					}
				}
			}
		}
		
		/*--------------------------------------------------------------------------Setters---------------------------------------------------------------*/	
		
		/*--------------------------------------------------------------------------Getters-----------------------------------------------------------------*/	
		
		/*--------------------------------------------------------------------------EventHandlers------------------------------------------------------------*/	
		
		public function parseInput(e:Event):void {
			if (world==null || this.b2body == null || isDead || this == null || isPlayerDead || _levelIsDone ) return;

			if(isLanded){
				doSomeRayCastStuff();
				startRayCast(v1, v2);			
			}
			checkActionTodo();
			checkSpeedX();
			checkIfHitPlayer();
		}
		
		
		private function checkIfHitPlayer():void 
		{
			if ( _levelIsDone) {
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
			if ( _levelIsDone) {
				return;
			}
			
			if( this != null ){
				var speedX:Number = this.b2body.m_linearVelocity.x;
				var speedLimit:Number = MOVE_POWER;
				
				if (isDasher && isAttacking ){
					speedLimit = DASH_POWER;
				}else {
					speedLimit = MOVE_POWER;					
				}
				
				var clipped_linear_velocity:V2 = this.b2body.GetLinearVelocity().normalize();
				
				if ( speedX < 0 ){
					speedX *= -1;
				}
				
				if ( speedX >= speedLimit ){
					this.b2body.m_linearVelocity.x = clipped_linear_velocity.multiplyN(speedLimit).x;
				}
			}
		}		
		
		public function endContact(e:ContactEvent):void{
			if ( e.other.GetBody().GetUserData() is Player){				
				_target = null;
			}
		}
		
		public function handleContact(e:ContactEvent):void{
			//trace( "[ walker ]: begin contact with: === >" + e.other.GetBody().GetUserData() );
			if (!isLanded){
				isLanded = true;
			}
			hitSomethingWhileAttacking();			
			
			if ( e.other.GetBody().GetUserData() is CatcherMC  ) {
				kill();
			}
			
			
			var blocksLen:int = CSObjects.MONSTER_BLOCKS.length;
			for (var i:int = 0; i < blocksLen; i++)
			{
				if (  e.other.GetBody().GetUserData() is CSObjects.MONSTER_BLOCKS[ i ] ) {
					//trace("walker hit block: "+ CSObjects.MONSTER_BLOCKS[ i ] );
					switchWhereToLook();
					return;
					break;
				}
			}
			
			var specialLen:int = CSObjects.SPECIAL_BLOCKS.length;
			for (i = 0; i < specialLen; i++)
			{
				if (  e.other.GetBody().GetUserData() is CSObjects.SPECIAL_BLOCKS[ i ] ){					
					switchWhereToLook();
					return;
					break;
				}
			}
			
			var trapLen:int = CSObjects.TRAPS.length;
			for (i = 0; i < trapLen; i++)
			{
				if (  e.other.GetBody().GetUserData() is CSObjects.TRAPS[ i ] ){					
					switchWhereToLook();
					return;
					break;
				}
			}
			
			var monstersLen:int = CSObjects.MONSTERS.length;
			for (var j:int = 0; j < monstersLen; j++)
			{
				if (  e.other.GetBody().GetUserData() is CSObjects.MONSTERS[ j ] ){
					switchWhereToLook();
					return;
					break;
				}
			}			
			
			if ( e.other.GetBody().GetUserData() is Player){				
				_target = e.other.GetBody().m_userData;
				//if(!isAgressive){
					//switchWhereToLook();					
				//}
				return;
			}
		}		
		
		private function onLevelFailed(e:CaveSmashEvent):void 
		{
			_levelIsDone = true;
			goStill();
			clearAll();
			//trace( "[Monster]: on level failed" );
		}
		
		private function onLevelComplete(e:CaveSmashEvent):void 
		{			
			_levelIsDone = true;
			goStill();
			clearAll();			
			//trace( "[Monster]: onLevelComplete............................" );
		}
		
		private function onLevelStarted(e:CaveSmashEvent):void{
			_levelIsDone = false;
			initControllers();
			//trace( "[Monster]: onLevelStarted............................" );
		}
		
		private function OnLevelQuit(e:CaveSmashEvent):void{
			goStill();
			clearAll();
			removeME();
		}
		
		private function onReloadLevel(e:CaveSmashEvent):void{
			goStill();
			clearAll();
			removeME();
		}
	}
}