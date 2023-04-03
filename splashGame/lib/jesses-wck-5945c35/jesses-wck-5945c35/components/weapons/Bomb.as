package components.weapons
{
	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.ContactEvent;
	import com.greensock.TweenLite;
	import com.monsterPatties.config.CaveSmashConfig;
	import com.monsterPatties.config.SoundConfig;
	import com.monsterPatties.events.CaveSmashEvent;
	import components.config.CSObjects;
	import components.players.Player2;
	import flash.events.Event;
	import flash.geom.Point;
	import misc.Util;
	/**
	 * ...
	 * @author jc
	 */
	public class Bomb extends DynamicWeaponBase
	{
		/*----------------------------------------------------------------------Constants-------------------------------------------------------------*/
		private static const DIRECTION_RIGHT:int = 0;
		private static const DIRECTION_LEFT:int = 1;
		private static const LABEL_EXPLODE:String = "explode";
		private static const MOVE_POWER:Number = CaveSmashConfig.BLUE_BOX_MOVE_SPEED;
		/*----------------------------------------------------------------------Properties-------------------------------------------------------------*/
		private var currentDirection:int = DIRECTION_RIGHT;
		private var hasRemoved:Boolean;
		
		private var target:Player2;
		private var monster:*;
		private var boss:*;
		private var isMovingRight:Boolean = false;
		private var isMovingLeft:Boolean = false;
		public var hasExplode:Boolean = false;
		
		public function Bomb()
		{
			super();
		}
		
		public function setDirection( dir:int ):void
		{
			currentDirection = dir;
		}
		
		private function removeME():void
		{
			if ( !hasRemoved ) {
				this.mc.addFrameScript( this.mc.totalFrames - 2, null );
				this.mc.addFrameScript( this.mc.totalFrames * 0.5 , null );
				hasRemoved = true;
				this.remove();
			}
		}
		
		override public function shapes():void
		{
			super.shapes();
			if ( this != null && this.mc != null ) {
				if ( currentDirection == DIRECTION_RIGHT ) {
					//this.mc.scaleX = -1;
					//this.collider.x = this.collider.width * 0.5;
				}
			}
		}
		
		private function killSelf():void
		{
			TweenLite.killDelayedCallsTo( killSelf );
			if ( this.mc.currentLabel != LABEL_EXPLODE ) {
				hasExplode = true;
				playSFX();
				addExplosionEffect();
				this.mc.gotoAndPlay(LABEL_EXPLODE);
				this.mc.addFrameScript( this.mc.totalFrames - 2, onEndAnimation );
			}
		}
		
		private function playSFX():void{
			//_caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.EXPLODE_BOMB );
			//_es.dispatchESEvent( _caveSmashEvent );
			
			_caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.PLAY_SFX );
			_caveSmashEvent.obj.id = SoundConfig.EXPLOSION_SFX;
			_es.dispatchESEvent( _caveSmashEvent );
		}
		
		private function addExplosionEffect():void
		{
			if(this != null && world != null && !hasRemoved  ){
				var explodeEffect:ExplodeMC = new ExplodeMC();
				var xpos:Number = ( explodeEffect.width * 0.5 ) * -1;
				var ypos:Number = ( explodeEffect.height * -1 )+ 35;
				Util.addChildAtPosOf( world, explodeEffect, this, -1, new Point( xpos , ypos ) );
				
				var bombRangeMC:BombRangeMC = new BombRangeMC();
				bombRangeMC.setDirection( currentDirection );
				Util.addChildAtPosOf( world, bombRangeMC, this, -1, new Point( 0 , 0 ) );
			}
		}
		
		override public function create():void
		{
			super.create();
			applyGravity = true;
		}
		
		
		/* methods*/
		
		private function checkIfHitTarget():void
		{
			if (this != null){
				if( target != null ){
					if ( !target.isDead && hasExplode ) {
						clearMe();
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
			if ( this != null){
				if ( monster != null && hasExplode ){
					clearMe();
					monster.kill();
					monster = null;
				}
			}else {
				return;
			}
		}
		
		private function checkIfHitBoss():void
		{
			if ( this != null){
				if ( boss != null && hasExplode ){
					clearMe();
					boss.hit(  currentDirection, true, 1 );
					boss = null;
				}
			}else {
				return;
			}
		}
		
		
		private function onEndAnimation():void
		{
			if ( this != null ){
				this.mc.addFrameScript( this.mc.totalFrames - 2, null );
				clearMe();
			}
		}
		
		private function clearMe():void
		{
			if( this != null ){
				removeME();
				this.dispatchEvent( new Event( Event.COMPLETE ) );
			}
		}
		
		public function moveRight( ):void
		{
			trace( "[ Bomb]: moveRight!!!" );
			if ( _levelIsDone ) {
				return;
			}
			
			if( this != null ){
				var speedX:Number = this.b2body.m_linearVelocity.x;
				var speedY:Number = this.b2body.m_linearVelocity.y;
				
				if ( speedX < 0 ) {
					b2body.SetLinearVelocity( new V2( 0,speedY ) );
				}
				
				b2body.ApplyImpulse(new V2( MOVE_POWER, 0), b2body.GetWorldCenter());
				isMovingRight = true;
				isMovingLeft = false;
				trace( "[ Bomb]: moveRight!!!" );
			}
		}
		
		
		public function moveLeft():void
		{
			trace( "[ Bomb]: moveLeft!!!" );
			if ( _levelIsDone ) {
				return;
			}
			
			if( this != null ){
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
		
		private function goLeft( ):void
		{
			if( this != null && !hasRemoved ){
				b2body.SetLinearVelocity( new V2( -MOVE_POWER, 0) );
			}
		}
		
		private function goRight(  ):void
		{
			if( this != null && !hasRemoved ){
				b2body.SetLinearVelocity( new V2( MOVE_POWER, 0) );
			}
		}
		
		private function checkSpeedX():void
		{
			if( this != null && !hasRemoved ){
				var speedX:Number = this.b2body.m_linearVelocity.x;
				var limit:Number = CaveSmashConfig.TORNADO_SPEED;
				
				var clipped_linear_velocity:V2 = this.b2body.GetLinearVelocity().normalize();
				
				if ( speedX < 0 ){
					speedX *= -1;
				}
				
				if ( speedX >= limit ){
					this.b2body.m_linearVelocity.x = clipped_linear_velocity.multiplyN(limit).x;
				}
			}
		}
		
		
		/*------------------------------------------------EventHanlders---------------------------------------------*/
		
		override public function handleContact(e:ContactEvent):void
		{
			super.handleContact(e);
			TweenLite.delayedCall( 5, killSelf );
			trace( "[ Bomb ]: begin contact with: === >" + e.other.GetBody().GetUserData() );
			if ( this != null ){
				if( e.other.GetBody().m_userData is Player ){
					target = e.other.GetBody().m_userData;
				}
				
				if ( e.other.GetBody().m_userData is CatcherMC ) {
					clearMe();
				}
				
				var monsterLen:int = CSObjects.MONSTERS.length;
				for (var i:int = 0; i < monsterLen; i++)
				{
					if (e.other.GetBody().m_userData is CSObjects.MONSTERS[i] ){
						monster = e.other.GetBody().m_userData;
						break;
					}
				}
				
				var bossLen:int = CSObjects.BOSS.length;
				for (var i:int = 0; i < bossLen; i++)
				{
					if (e.other.GetBody().m_userData is CSObjects.BOSS[i] ){
						boss = e.other.GetBody().m_userData;
						break;
					}
				}
			}
		}
		
		override public function endContact(e:ContactEvent):void
		{
			super.endContact(e);
			
			if ( this != null ){
				if( e.other.GetBody().m_userData is Player ){
					target = null;
				}
				
				var monsterLen:int = CSObjects.MONSTERS.length;
				for (var i:int = 0; i < monsterLen; i++)
				{
					if (e.other.GetBody().m_userData is CSObjects.MONSTERS[i] ){
						monster =null;
						break;
					}
				}
				
				var bossLen:int = CSObjects.BOSS.length;
				for (var i:int = 0; i < bossLen; i++)
				{
					if (e.other.GetBody().m_userData is CSObjects.BOSS[i] ){
						boss = null;
						break;
					}
				}
			}
		}
		
		override public function onLevelComplete(e:CaveSmashEvent):void{
			super.onLevelComplete(e);
			TweenLite.killDelayedCallsTo( killSelf );
		}
		
		override public function onLevelFailed(e:CaveSmashEvent):void{
			super.onLevelFailed(e);
			TweenLite.killDelayedCallsTo( killSelf );
		}
		
		override public function onReloadLevel(e:CaveSmashEvent):void{
			super.onReloadLevel(e);
			TweenLite.killDelayedCallsTo( killSelf );
		}
		
		override public function OnLevelQuit(e:CaveSmashEvent):void
		{
			super.OnLevelQuit(e);
			TweenLite.killDelayedCallsTo( killSelf );
		}
		
		override public function onLevelStarted(e:CaveSmashEvent):void
		{
			super.onLevelStarted(e);
			TweenLite.killDelayedCallsTo( killSelf );
		}
		
		override public function parseInput(e:Event):void
		{
			super.parseInput(e);
			if (!world  || this == null || hasRemoved || _levelIsDone ) return;
			checkIfHitTarget();
			checkIfHitMonster();
			checkIfHitBoss();
		}
	}
}