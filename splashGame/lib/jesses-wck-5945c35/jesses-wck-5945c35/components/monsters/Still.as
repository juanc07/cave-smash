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
	
	public class Still extends BodyShape {	
        
		/*--------------------------------------------------------------------------Constant--------------------------------------------------------------*/	
		
		public static const DIRECTION_STILL:int = -1;
		public static const DIRECTION_RIGHT:int = 0;
		public static const DIRECTION_LEFT:int = 1;
		
		public static const LABEL_DIE:String = "die";
		public static const LABEL_RIGHT:String = "right";
		public static const LABEL_LEFT:String = "left";
		public static const LABEL_HIT:String = "hit";		
		/*--------------------------------------------------------------------------Properties--------------------------------------------------------------*/	
		
		public var HIT_DELAY:Number = 0.3;
		public var KNOCK_BACK_POWER:Number = CaveSmashConfig.HERO_KNOCK_BACK_POWER;
		public var JUMP_POWER:Number = -1.5;		
		
		public var currentDirection:int = DIRECTION_RIGHT;
		public var isJumping:Boolean = false;
		public var isAttacking:Boolean = false;
		public var isFalling:Boolean = false;
		public var isHiding:Boolean = false;
		public var isDead:Boolean = false;		
		public var isHit:Boolean = false;		
		public var hp:Number = CaveSmashConfig.STILL_MONSTER_HP;
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
        protected var magnitude:Number = 60;
		protected var magnitudeOffset:Number = 0;
		private static const magnitudeOffsetY:Number = CaveSmashConfig.MONSTER_RAY_CAST_LENGTH;

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
		private var _es:EventSatellite;		
		private var _caveSmashEvent:CaveSmashEvent;
		
		public var _target:Player2;
		public var _levelIsDone:Boolean = false;
		private var hasRemoved:Boolean;
		/*--------------------------------------------------------------------------Constructor--------------------------------------------------------------*/	
		
		public override function shapes():void{
		}
		
		public override function create():void {
			//trace( "[monster] create monster" );			
			super.create();
			type = "Static";
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
			lookRight();			
			addGameEvent();			
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
				p2 = new Point(magnitude, 0); //assumes that art is facing right at 0º
			}else if( currentDirection == DIRECTION_LEFT ){				
				p2 = new Point( -( magnitude - magnitudeOffset ), 0 );
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
				var body:BodyShape = fixture.m_userData.body //tip for finding the wck body.				
				//trace( "walker raycast hit", fixture.GetBody().GetUserData() );
				var blocksLen:int = CSObjects.MONSTER_TERRAIN.length;
				for (var i:int = 0; i < blocksLen; i++) 
				{
					if (  fixture.GetBody().GetUserData() is CSObjects.MONSTER_TERRAIN[ i ] ){
						isDetectPlayer = false;
						//switchWhereToLook();
						break;
					}
				}			
				
				if ( fixture.GetBody().GetUserData() is Player ) {
					isDetectPlayer = true;					
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
		public function hit( dir:int , isKnockBack:Boolean = false ):Boolean 
		{
			if ( /*this.mc.currentLabel != LABEL_HIT &&*/ !isHit && !isDead ) {
				hp--;
				switchWhereToLook();
				_caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.MONSTER_HIT );
				_es.dispatchESEvent( _caveSmashEvent );
				
				TweenLite.delayedCall( HIT_DELAY, resetHit  );
				if( hp > 0 ){
					//this.mc.gotoAndPlay( LABEL_HIT );
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
			if( !hasRemoved && isDead ){
				hasRemoved = true;
				this.remove();
			}
		}
		
		protected function dropItem():void{}
		
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
			if ( !player.isDead && !isDead ) {
				if(!isHiding){
					isDetectPlayer = true;
					player.hit( 1.5, 0.5, currentDirection );
				}
			}else {
				isPlayerDead = true;				
			}
		}
		
		private function switchWhereToLook():void 
		{
			if( currentDirection == DIRECTION_RIGHT ){
				lookLeft();
			}else if( currentDirection == DIRECTION_LEFT ){
				lookRight();
			}
		}
		
		public function lookLeft():void{
			currentDirection = DIRECTION_LEFT;			
		}
		
		public function lookRight():void{		
			currentDirection = DIRECTION_RIGHT;				
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
		
		private function clearAll():void 
		{			
			removeAllListeners();
			removeControllers();
			removeGameEvent();
			//this.remove();			
		}		
		
		protected function goStill():void 
		{
			currentDirection == DIRECTION_STILL;		
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
			checkIfHitPlayer();
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
		
		public function endContact(e:ContactEvent):void{
			if ( e.other.GetBody().GetUserData() is Player && !isDetectPlayer ) {
				//switchWhereToLook();
				_target = null;
			}else if ( e.other.GetBody().GetUserData() is Player && isDetectPlayer ) {
				_target = null;				
			}
		}
		
		public function handleContact(e:ContactEvent):void {						
			//trace( "[ walker ]: begin contact with: === >" + e.other.GetBody().GetUserData() );
			if ( e.other.GetBody().GetUserData() is CatcherMC  ) {
				kill();
			}
			
			
			var blocksLen:int = CSObjects.MONSTER_BLOCKS.length;
			for (var i:int = 0; i < blocksLen; i++)
			{
				if (  e.other.GetBody().GetUserData() is CSObjects.MONSTER_BLOCKS[ i ] ) {
					//trace("walker hit block: "+ CSObjects.MONSTER_BLOCKS[ i ] );
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
				//switchWhereToLook();				
				_target = e.other.GetBody().m_userData;
			}else if ( e.other.GetBody().GetUserData() is Player && isDetectPlayer ){
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
		
		public function onLevelStarted(e:CaveSmashEvent):void 
		{
			_levelIsDone = false;
			initControllers();
			//trace( "[Monster]: onLevelStarted............................" );
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