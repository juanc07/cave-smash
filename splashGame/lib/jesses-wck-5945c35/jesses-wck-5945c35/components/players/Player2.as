package components.players{
	
	import Box2D.Dynamics.b2Fixture;
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
	import com.monsterPatties.config.SoundConfig;
	import com.monsterPatties.controllers.GameDataController;
	import com.monsterPatties.events.CaveSmashEvent;
	import com.monsterPatties.events.GameEvent;
	import com.monsterPatties.utils.eventSatellite.EventSatellite;
	import components.config.CSObjects;
	import components.config.LiveData;
	import components.items.ItemConfig;
	import extras.*;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.utils.*;
	import misc.*;
	import shapes.*;
	import wck.*;
	
	public class Player2 extends BodyShape {
		
		
		private static const DIRECTION_RIGHT:int = 0;
		private static const DIRECTION_LEFT:int = 1;
		public static const DIRECTION_UP:int = 2;
		public static const DIRECTION_DOWN:int = 3;
		
		
		private static const LABEL_DIE:String = "die";
		private static const LABEL_RIGHT:String = "right";
		private static const LABEL_LEFT:String = "left";
		private static const LABEL_JUMP:String = "jump";
		private static const LABEL_FALL:String = "fall";
		private static const LABEL_HIT:String = "hit";
		private static const LABEL_CLIMB:String = "climb";
		private static const LABEL_END_CLIMB:String = "endClimb";
		private static const LABEL_WALL_SLIDE:String = "wallSlide";
		private static const LABEL_DAMAGE:String = "damage";
		private static const LABEL_DAMAGE2:String = "damage2";
		private static const LABEL_DAMAGE3:String = "damage3";
		private static const LABEL_JUMP_DAMAGE:String = "jumpDamage";
		private static const LABEL_ATTACK:String = "attack";
		private static const LABEL_ATTACK2:String = "attack2";
		private static const LABEL_ATTACK3:String = "attack3";
		private static const LABEL_RUN:String = "run";
		private static const LABEL_IDLE:String = "idle";
		private static const LABEL_STAND:String = "stand";
		private static const LABEL_JUMP_ATTACK:String = "jumpAttack";
		private static const LABEL_GRAB:String = "grab";
		private static const LABEL_GRAB_UP:String = "grabUp";
		private static const LABEL_END_GRAB:String = "endGrab";
		
		public var currentDirection:int = DIRECTION_RIGHT;
		private var isJumping:Boolean = false;
		private var hasDoubleJump:Boolean = false;
		private var isAttacking:Boolean = false;
		private var activatedAttack2:Boolean = false;
		private var activatedAttack3:Boolean = false;
		private var isHit:Boolean = false;
		private var isHitWall:Boolean = false;
		private var isClimbing:Boolean = false;
		private var isGrabing:Boolean = false;
		private var isReadyToGrab:Boolean = true;
		private var grabCtrForward:Number = 0;
		private var isHoldingWall:Boolean = false;
		private var isKnockBack:Boolean  = false;
		private var knockCtr:Number = 0;
		private var _knockBackPower:Number = 0;
		private var _knockBackRange:Number = 0;
		private var isLevelComplete:Boolean = false;
		private var isCameraSliding:Boolean = false;
		private var isHitPlatform:Boolean = false;
		
		private static const ATTACK_BOMB_DELAY:Number = CaveSmashConfig.ATTACK_BOMB_DELAY;
		private static const HIT_DELAY:Number = CaveSmashConfig.HERO_HIT_DELAY;
		private static const ATTACK_THROW_DELAY:Number = CaveSmashConfig.HERO_ATTACK_THROW_DELAY;
		private static const ATTACK_JUMP_DELAY:Number = CaveSmashConfig.HERO_ATTACK_JUMP_DELAY;
		private static const SECOND_JUMP_DELAY:Number = CaveSmashConfig.HERO_SECOND_JUMP_DELAY;
		private static const ATTACK_DELAY:Number = CaveSmashConfig.HERO_ATTACK_DELAY;
		private static const ATTACK_DELAY2:Number = CaveSmashConfig.HERO_ATTACK_DELAY2;
		private static const ATTACK_DELAY3:Number = CaveSmashConfig.HERO_ATTACK_DELAY3;
		
		//PHYSICS CONFIG
		private var HERO_DENSITY:Number = CaveSmashConfig.HERO_DENSITY;
		private var HERO_FRICTION:Number = CaveSmashConfig.HERO_FRICTION ;
		private var HERO_MOVING_PLATFORM_FRICTION:Number = CaveSmashConfig.HERO_MOVING_PLATFORM_FRICTION;
		private var HERO_LINEAR_DAMPING:Number = CaveSmashConfig.HERO_LINEAR_DUMPING;
		private var HERO_RESTITUTION:Number = CaveSmashConfig.HERO_RESTITUTION;
		
		private var hp:Number = CaveSmashConfig.HERO_HP;
		public var isDead:Boolean = false;

		private static const CLIMBING_POWER:Number = CaveSmashConfig.CLIMBING_POWER;
		private static const KNOCK_BACK_POWER:Number = CaveSmashConfig.KNOCK_BACK_POWER;
        private static const JUMP_POWER:Number = CaveSmashConfig.JUMP_POWER;
		private static const SECOND_JUMP_POWER:Number = CaveSmashConfig.SECOND_JUMP_POWER;
		private static const MOVE_POWER:Number = CaveSmashConfig.MOVE_POWER;
		private static const DASH_POWER:Number = CaveSmashConfig.DASH_POWER;
		private static const WALL_SLIDE_POWER:Number = CaveSmashConfig.WALL_SLIDE_POWER;
		private static const WALL_GRAB_POWER:Number = CaveSmashConfig.WALL_GRAB_POWER;
		private static const WALL_GRAB_UP_POWER:Number = CaveSmashConfig.WALL_GRAB_UP_POWER;
		private static const WALL_GRAB_FORWARD_POWER:Number = CaveSmashConfig.WALL_GRAB_FORWARD_POWER;
		private var WALL_GRAB_UP_MAX:Number = 0;
		private var WALL_GRAB_TARGET:Number = 0;
		private static const WALL_GRAB_FORWARD_MAX:Number = CaveSmashConfig.WALL_GRAB_FORWARD_MAX;
		private static const READY_TO_GRAB_DELAY:Number = CaveSmashConfig.READY_TO_GRAB_DELAY;
		
		
		public var contacts:ContactList;
		
		//target monster
		//private var _target:*;
		
		//raycast things
		public var rot:Number = 0;
		private const RAY_CAST_ALPHA:int = CaveSmashConfig.HERO_RAY_CAST_ALPHA;
		private var up:Boolean;
		private var down:Boolean;
		//length of raycast
		protected var magnitude:Number = CaveSmashConfig.HERO_ATTACK_RANGE;
		protected var magnitudeOffset:Number = CaveSmashConfig.HERO_ATTACK_RANGE_OFFSET;

		protected var p1:Point //start point
		protected var p2:Point //end point
		protected var v1:V2 //start point in world.scale
		protected var v2:V2 //end point in world.scale

		//stored by raycast callback.
		protected var valid:Boolean;
		protected var fixture:b2Fixture;
		protected var point:V2;
		//raycast things
		
		private var _hasDetectMonster:Boolean;
		
		//current treasure Box
		private var _currentTreasureBox:TreasureBoxMC;
		private var _gdc:GameDataController;
		private var _es:EventSatellite;
		private var _caveSmashEvent:CaveSmashEvent;
		private var dot:Number;
		private var isAddEffect:Boolean;
		private var hitPlatform;
		private var playerLocalPoint;
		
		private var horizontalMovingPlatform:HorizontalMovingPlatformMC;
		private var verticalMovingPlatform:VerticalMovingPlatformMC;
		
		//new
		private var _isAttackRangeRemove:Boolean;
		private var hasRemoved:Boolean;
		private var isKillBombMonster:Boolean;
		private var _hasBombed:Boolean;
		private var _hitDirection:int;
		private var hasTeleport:Boolean;
		private var live:int = 3;
		
		public override function shapes():void {
		}
		
		public override function create():void {
			trace( "[Player2] create player hero" );
			super.create();
			reportBeginContact = true;
			reportEndContact = true;
			fixedRotation = true;
			bullet = true;
			density = HERO_DENSITY;
			friction = HERO_FRICTION;
			restitution = HERO_RESTITUTION;
			_inertiaScale = 1;
			gravityScale = 1;
			active = true;
			
			angularDamping = 0;
			angularVelocity = 0;
			gravityAngle = 0;
			linearDamping = HERO_LINEAR_DAMPING;
			allowDragging = true;
			linearVelocity = new V2( 0, 0 );
			live = 3;
			
			listenWhileVisible(world, StepEvent.STEP, parseInput, false, 10);
			listenWhileVisible(this, ContactEvent.BEGIN_CONTACT, handleContact);
			listenWhileVisible(this, ContactEvent.END_CONTACT, endContact);
			contacts = new ContactList();
			contacts.listenTo(this);
			
			if ( GameConfig.showCollider ){
				this.collider.alpha = 1;
			}
			_isAttackRangeRemove = true;
			
			addGameEvent();
		}
		
		private function clearAll():void
		{
			removeAllListeners();
			removeControllers();
			removeGameEvent();
			//this.remove();
		}
		
		private function addGameEvent():void
		{
			_es = EventSatellite.getInstance();
			_es.addEventListener( CaveSmashEvent.LEVEL_STARTED, onLevelStarted );
			_es.addEventListener( CaveSmashEvent.LEVEL_QUIT, OnLevelQuit );
			_es.addEventListener( CaveSmashEvent.LEVEL_COMPLETE, onLevelComplete );
			_es.addEventListener( CaveSmashEvent.LEVEL_FAILED, onLevelFailed );
			_es.addEventListener( CaveSmashEvent.PICK_UP_ITEM, onPickUpItem );
			_es.addEventListener( CaveSmashEvent.ON_REMOVE_ATTACK_RANGE, onRemoveAttackRange );
			_es.addEventListener( CaveSmashEvent.ON_START_CAMERA_SLIDE, onStartCameraSlide );
			_es.addEventListener( CaveSmashEvent.ON_STOP_CAMERA_SLIDE, onStopCameraSlide );
			_es.addEventListener( GameEvent.GAME_DEACTIVATE_CONTROLS, onGamePaused );
			_es.addEventListener( GameEvent.GAME_ACTIVATE_CONTROLS, onUnGamePaused );
			_es.addEventListener( GameEvent.GAME_OUT_FOCUS, onGameOutFocus );
			_es.addEventListener( GameEvent.GAME_GOT_FOCUS, onGameGotFocus );
			_es.addEventListener( CaveSmashEvent.RELOAD_LEVEL, onReloadLevel );
			//trace( "[player2]:add GameEvent........................ " );
		}
		
		private function removeGameEvent():void
		{
			_es = EventSatellite.getInstance();
			_es.removeEventListener( CaveSmashEvent.LEVEL_STARTED, onLevelStarted );
			_es.removeEventListener( CaveSmashEvent.LEVEL_QUIT, OnLevelQuit );
			_es.removeEventListener( CaveSmashEvent.LEVEL_COMPLETE, onLevelComplete );
			_es.removeEventListener( CaveSmashEvent.LEVEL_FAILED, onLevelFailed );
			_es.removeEventListener( CaveSmashEvent.PICK_UP_ITEM, onPickUpItem );
			_es.removeEventListener( CaveSmashEvent.ON_START_CAMERA_SLIDE, onStartCameraSlide );
			_es.removeEventListener( CaveSmashEvent.ON_STOP_CAMERA_SLIDE, onStopCameraSlide );
			_es.removeEventListener( CaveSmashEvent.ON_REMOVE_ATTACK_RANGE, onRemoveAttackRange );
			_es.removeEventListener( GameEvent.GAME_DEACTIVATE_CONTROLS, onGamePaused );
			_es.removeEventListener( GameEvent.GAME_ACTIVATE_CONTROLS, onUnGamePaused );
			_es.removeEventListener( GameEvent.GAME_OUT_FOCUS, onGameOutFocus );
			_es.removeEventListener( GameEvent.GAME_GOT_FOCUS, onGameGotFocus );
			_es.removeEventListener( CaveSmashEvent.RELOAD_LEVEL, onReloadLevel );
			//trace( "[player2]:remove GameEvent........................ " );
		}
		
		/*-----------------------------------------[ for raycasting methods ] ----------------------------------------------------------------------------*/
		protected function updateVector(  ):void {
			if( this != null && !isDead ){
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
		}
		
		
		private function checkIfHitPlatform( fixture:b2Fixture ):void
		{
			var blocksLen:int = CSObjects.GRAB_TERRAIN.length;
			for (var i:int = 0; i < blocksLen; i++)
			{
				if (  fixture.GetBody().GetUserData() is CSObjects.GRAB_TERRAIN[ i ] ) {
					//trace("detech grabable platform" + CSObjects.GRAB_TERRAIN[ i ] );
					isHitPlatform = true;
					hitPlatform  = fixture.GetBody().m_userData;
					playerLocalPoint = b2body.GetUserData();
					var offsetY:Number =  playerLocalPoint.y - hitPlatform.y;
					if ( offsetY < 0 ) {
						offsetY *= -1;
					}
					var grabUp:Number = ( playerLocalPoint.height * 0.75 ) - offsetY;
					
					WALL_GRAB_UP_MAX = grabUp;
					WALL_GRAB_TARGET = playerLocalPoint.y - grabUp;
					//trace(  " [Player]: platformPosY " + hitPlatform.y + " grabUp " + grabUp  + " playerLocalPoint " + playerLocalPoint.y + " offsetY " + offsetY );
					//trace(  " [Player]: playerLocalPoint.height " + playerLocalPoint.height + " pLocalPoint1/4 height " + playerLocalPoint.height * 0.25    );
				}
			}
		}
		
		protected function startRayCast(v1:V2, v2:V2):void {
			if( this != null && !isDead ){
				valid = false;
				world.b2world.RayCast(rcCallback, v1, v2); //see onRayCast();
				if(valid){
					var body:BodyShape = fixture.m_userData.body //tip for finding the wck body.
					//trace( "raycast hit" ,fixture.m_userData );
					//trace( "[ Player ]: raycast hit", fixture.GetBody().GetUserData() );
					checkIfHitPlatform( fixture );
					if ( this.mc.currentLabel == LABEL_DAMAGE
						|| this.mc.currentLabel == LABEL_DAMAGE2
						|| this.mc.currentLabel == LABEL_DAMAGE3
						|| this.mc.currentLabel == LABEL_JUMP_DAMAGE
						){
						
						if (  fixture.GetBody().GetUserData() is NormalBlockMC ) {
							var normalBlockMC:NormalBlockMC = fixture.GetBody().m_userData;
							if ( normalBlockMC ){
								normalBlockMC.animate();
							}
						}
						
						if (  fixture.GetBody().GetUserData() is UnBreakableBlockMC ) {
							var unBreakableBlockMC:UnBreakableBlockMC = fixture.GetBody().m_userData;
							if ( unBreakableBlockMC ){
								unBreakableBlockMC.animate();
							}
						}
						
						if (  fixture.GetBody().GetUserData() is SwitchMC ){
							var switchMC:SwitchMC = fixture.GetBody().m_userData;
							if ( switchMC ){
								switchMC.activate();
							}
						}
						
						if (  fixture.GetBody().GetUserData() is Switch2MC ){
							var switch2MC:Switch2MC = fixture.GetBody().m_userData;
							if ( switch2MC ){
								switch2MC.activate();
							}
						}
					
						var monsterLen:int = CSObjects.MONSTERS.length;
						for (var i:int = 0; i < monsterLen; i++)
						{
							if ( fixture.GetBody().GetUserData() is BombWalkerMC ) {
								isKillBombMonster = true;
								trace("kill bomb monster!!!");
								break;
							}
							
							if (  fixture.GetBody().GetUserData() is CSObjects.MONSTERS[ i ] ){
								_hasDetectMonster = true;
								var monster:* = fixture.GetBody().m_userData;
								if ( monster != null ){
									isAddEffect = monster.hit(  currentDirection, true );
									addHitEffect( isAddEffect );
									break;
								}else {
									_hasDetectMonster = false;
								}
							}
						}
						
						var bossLen:int = CSObjects.BOSS.length;
						for (i = 0; i < bossLen; i++)
						{
							if (  fixture.GetBody().GetUserData() is CSObjects.BOSS[ i ] ){
								_hasDetectMonster = true;
								var monster:* = fixture.GetBody().m_userData;
								if ( monster != null ){
									isAddEffect = monster.hit(  currentDirection, true, 1 );
									addHitEffect( isAddEffect );
									break;
								}else {
									_hasDetectMonster = false;
								}
							}
						}
					}
					drawLaser();
				}else{//if none were found
					point=v2; //full length
					drawLaser();
					//trace( "not valid" );
				}
			}
		}
		
		
		private function removeME():void
		{
			if( !hasRemoved  ){
				hasRemoved = true;
				this.remove();
				while (this.numChildren > 0){
					this.removeChildAt(0);
				}
				//trace( "player2 clear via reload level!!!!!!!!!!!!!!!!!!!!" );
			}
		}
		
		private function addHitEffect( val:Boolean ):void
		{
			if( val && this != null ){
				if( currentDirection == DIRECTION_RIGHT ){
					Util.addChildAtPosOf( world, new HitEffectMC(), this, -1, new Point( 20 , -15 ) );
				}else {
					Util.addChildAtPosOf( world, new HitEffectMC(), this, -1, new Point(  -75 , -15 ) );
				}
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
			var speedY:Number = this.b2body.m_linearVelocity.y;
			
			if ( !isJumping ) {
				attack1();
			}else {
				if ( dot == -1 ){
					jumpAttack();
				}else {
					attack1();
				}
			}
		}
		
		private function attack1():void
		{
			if ( 	this.mc.currentLabel != LABEL_ATTACK
					&& this.mc.currentLabel != LABEL_ATTACK2
					&& this.mc.currentLabel != LABEL_ATTACK3
					&& !isAttacking
					&& !isDead
			) {
				if ( activatedAttack2 || activatedAttack3 && horizontalMovingPlatform == null && verticalMovingPlatform == null ) {
					if ( currentDirection == DIRECTION_RIGHT ) {
						dashRight();
					}else {
						dashLeft();
					}
				}
				
				
				if ( !activatedAttack2 && !activatedAttack3 ) {
					playSFX(1);
					this.mc.gotoAndPlay( LABEL_ATTACK );
					TweenLite.delayedCall( ATTACK_DELAY, activateAttack );
				}else if ( activatedAttack2 && !activatedAttack3 ){
					playSFX(2);
					TweenLite.killDelayedCallsTo( deActivateAttack2 );
					this.mc.gotoAndPlay( LABEL_ATTACK2 );
					TweenLite.delayedCall( ATTACK_DELAY2, activateAttack3 );
				}else if ( !activatedAttack2 && activatedAttack3 ) {
					playSFX(3);
					TweenLite.killDelayedCallsTo( deActivateAttack3 );
					this.mc.gotoAndPlay( LABEL_ATTACK3 );
					TweenLite.delayedCall( ATTACK_DELAY3, refreshAllAttack );
				}
				
				isAttacking = true;
			}
		}
		
		
		private function playSFX(sfx:int):void {
			var sfxId:String;
			switch (sfx)
			{
				case 1:
					sfxId = SoundConfig.ATTACK1_SFX;
				break;
				
				case 2:
					sfxId = SoundConfig.ATTACK2_SFX;
				break;
				
				case 3:
					sfxId = SoundConfig.ATTACK1_SFX;
				break;
				
				case 4:
					sfxId = SoundConfig.PLAYER_HIT_SFX;
				break;
				
				case 5:
					sfxId = SoundConfig.FALL_SFX;
				break;
				
				case 6:
					sfxId = SoundConfig.JUMP_SFX;
				break;
				
				default:
			}
			
			_caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.PLAY_SFX );
			_caveSmashEvent.obj.id = sfxId;
			_es.dispatchESEvent( _caveSmashEvent );
			
		}
		
		private function checkIfReadyToDamage():void
		{
			if( this != null && !isDead && _isAttackRangeRemove ){
				if ( 	this.mc.currentLabel == LABEL_DAMAGE
						|| this.mc.currentLabel == LABEL_DAMAGE2
						|| this.mc.currentLabel == LABEL_DAMAGE3
						|| this.mc.currentLabel == LABEL_JUMP_DAMAGE
				) {
					_isAttackRangeRemove = false;
					var attackRangeMC:AttackRangeMC = new AttackRangeMC();
					attackRangeMC.setDirection( currentDirection );
					
					if( currentDirection == DIRECTION_RIGHT ){
						Util.addChildAtPosOf( world, attackRangeMC, this, -1, new Point( 40 , -10 ) );
					}else {
						Util.addChildAtPosOf( world, attackRangeMC, this, -1, new Point(  -40 , -10 ) );
					}
				}
			}
		}
		
		private function jumpAttack():void
		{
			if ( this.mc.currentLabel != LABEL_JUMP_ATTACK && !isAttacking && !isDead ){
				playSFX(1);
				this.mc.gotoAndPlay( LABEL_JUMP_ATTACK );
				isAttacking = true;
				TweenLite.delayedCall( ATTACK_JUMP_DELAY, activateJumpAttack );
			}
		}
		
		private function activateJumpAttack():void
		{
			TweenLite.killDelayedCallsTo( activateJumpAttack );
			isAttacking = false;
		}
		
		private function activateAttack():void
		{
			TweenLite.killDelayedCallsTo( activateAttack );
			isAttacking = false;
			
			if( _gdc.hasComboAttack() ){
				activatedAttack3 = false;
				activatedAttack2 = true;
				TweenLite.delayedCall( ATTACK_DELAY2, deActivateAttack2 );
			}
		}
		
		private function activateAttack3():void
		{
			TweenLite.killDelayedCallsTo( activateAttack3 );
			isAttacking = false;
			activatedAttack2 = false;
			activatedAttack3 = true;
			TweenLite.delayedCall( ATTACK_DELAY3, deActivateAttack3 );
		}
		
		private function deActivateAttack2():void
		{
			TweenLite.killDelayedCallsTo( deActivateAttack2 );
			activatedAttack2 = false;
		}
		
		private function deActivateAttack3():void
		{
			TweenLite.killDelayedCallsTo( deActivateAttack3 );
			activatedAttack3 = false;
		}
		
		private function refreshAllAttack ():void
		{
			TweenLite.killDelayedCallsTo( refreshAllAttack );
			isAttacking = false;
			activatedAttack2 = false;
			activatedAttack3 = false;
		}
		
		
		public function die():void {
			if (!hasTeleport) {
				if ( live >1 && _gdc.getCheckpoint() != null ) {
					_gdc.setIsLockControlls(true);
					hasTeleport = true;
					TweenLite.delayedCall( 0.2, teleport );
				}else {
					_gdc.setIsLockControlls(false);
					_gdc.setLive( 0 );
					_caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.PLAYER_RECIEVED_DAMAGED );
					_es.dispatchESEvent( _caveSmashEvent );
					
					this.mc.gotoAndPlay( LABEL_DIE );
					isDead = true;
					isSensor = true;
					_caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.LEVEL_FAILED );
					_es.dispatchESEvent( _caveSmashEvent );
				}
			}
		}
		
		public function teleport():void {
			if (LiveData.playerPosition != null && this != null && world != null && hasTeleport && _gdc.getCheckpoint() != null ){
				type = "Static";
				this.x = _gdc.getCheckpoint().x;
				this.y = _gdc.getCheckpoint().y;
				syncTransform();
				type = "Dynamic";
				isJumping = false;
				hasDoubleJump = false;
				hasTeleport = false;
				_gdc.setIsLockControlls(false);
				live -= 1;
			}
		}
		
		public function hit( knockBackPower:Number = 0, knockBackRange:Number = 0, hitDirection:int = DIRECTION_RIGHT ):void
		{
			trace("hit player by monster _knockBackPower " + _knockBackPower + " knockBackRange " + knockBackRange  + " hitDirection " + hitDirection );
			//overide all throw value no more knock back from now sorry!
			//knockBackPower = 1;
			//knockBackRange = 1;
			
			//trace( "[PLayer2]: hit check _gdc " + _gdc );
			if( this.mc != null && this != null && !isDead && _gdc != null ){
				if ( this.mc.currentLabel != LABEL_HIT && !isHit && !isDead && !isAttacking
					&& this.mc.currentLabel != LABEL_DAMAGE
					&& this.mc.currentLabel != LABEL_DAMAGE2
					&& this.mc.currentLabel != LABEL_DAMAGE3
				){
					//trace( "[PLayer2]: hit check life b4 deduct " +  _gdc.getLive() );
					_gdc.updateLive( -1 );
					hp = _gdc.getLive();
					//trace( "[PLayer2]: hit check life  after deduct " +  hp );
					isHit = true;
					TweenLite.delayedCall( HIT_DELAY, resetHit  );
					
					_caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.PLAYER_RECIEVED_DAMAGED );
					_es.dispatchESEvent( _caveSmashEvent );
					
					if ( hp > 0 ) {
						playSFX(4);
						this.mc.gotoAndPlay( LABEL_HIT );
						if ( knockBackPower > 0 && knockBackRange > 0  ) {
							_hitDirection = hitDirection;
							isKnockBack = true;
							_knockBackPower = knockBackPower;
							_knockBackRange = knockBackRange;
						}
						quickStop();
					}else {
						die();
					}
				}else {
					//updateKnockback(knockBackPower,knockBackRange);
				}
			}
		}
		
		public function updateKnockback( knockBackPower:Number = 0, knockBackRange:Number = 0):void{
			if ( knockBackPower > 0 && knockBackRange > 0  ) {
				if( currentDirection == DIRECTION_RIGHT ){
					_hitDirection = DIRECTION_LEFT;
				}else {
					_hitDirection = DIRECTION_RIGHT;
				}
				isKnockBack = true;
				_knockBackPower = 2;
				_knockBackRange = 2;
			}
			quickStop();
		}
		
		public function forceHit( knockBackPower:Number = 0, knockBackRange:Number = 0 ):void
		{
			if( this.mc != null && this != null && !isDead && _gdc != null ){
				if ( !isDead ) {
					isKillBombMonster = false;
					_gdc.updateLive( -1 );
					hp = _gdc.getLive();
					isHit = true;
					TweenLite.delayedCall( HIT_DELAY, resetHit  );
					
					_caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.PLAYER_RECIEVED_DAMAGED );
					_es.dispatchESEvent( _caveSmashEvent );
					
					if( hp > 0 ){
						this.mc.gotoAndPlay( LABEL_HIT );
						if( knockBackPower > 0 && knockBackRange > 0  ){
							isKnockBack = true;
							_knockBackPower = knockBackPower;
							_knockBackRange = knockBackRange;
						}
						quickStop();
					}else {
						die();
					}
				}
			}
		}
		
		private function knockBack(  ):void
		{
			if( this != null && !isDead ){
				if ( isKnockBack ){
					this.b2body.SetLinearVelocity( new V2( 0, 0 ) );
					
					/*
					if ( currentDirection == DIRECTION_RIGHT && _hitDirection == DIRECTION_RIGHT ) {
						b2body.ApplyImpulse(new V2( _knockBackPower, 0), b2body.GetWorldCenter());
					}else if ( currentDirection == DIRECTION_RIGHT && _hitDirection == DIRECTION_LEFT ){
						b2body.ApplyImpulse(new V2( -_knockBackPower, 0), b2body.GetWorldCenter());
					}else if ( currentDirection == DIRECTION_LEFT && _hitDirection == DIRECTION_LEFT ){
						b2body.ApplyImpulse(new V2( -_knockBackPower, 0), b2body.GetWorldCenter());
					}else if ( currentDirection == DIRECTION_LEFT && _hitDirection == DIRECTION_RIGHT ) {
						b2body.ApplyImpulse(new V2( _knockBackPower, 0), b2body.GetWorldCenter());
					}
					*/
					
					
					if ( _hitDirection ==  DIRECTION_RIGHT  ) {
						b2body.ApplyImpulse(new V2( _knockBackPower, 0), b2body.GetWorldCenter());
					}else{
						b2body.ApplyImpulse(new V2( -_knockBackPower, 0), b2body.GetWorldCenter());
					}
					
					knockCtr += _knockBackPower;
					if ( knockCtr >= ( _knockBackRange ) ) {
						isKnockBack = false;
						knockCtr = 0;
					}
				}
			}
		}
		
		private function releaseGrab():void
		{
			if ( this != null && world != null ){
				isHitPlatform = false;
				isReadyToGrab = false;
				isGrabing = false;
				grabCtrForward = 0;
				playerLocalPoint = b2body.GetUserData();
				WALL_GRAB_TARGET = playerLocalPoint.y  + 1;
				TweenLite.delayedCall( READY_TO_GRAB_DELAY, readyGrab );
			}
		}
		
		private function readyGrab():void
		{
			isReadyToGrab = true;
		}
		
		public function idle():void{
			if( !isDead && this.mc.currentLabel != LABEL_IDLE ){
				this.mc.gotoAndPlay( LABEL_IDLE );
				releaseGrab();
			}
		}
		
		public function grab():void {
			if( this != null && !isDead ){
				if ( !isDead && this.mc.currentLabel != LABEL_GRAB && !isGrabing ) {
					isGrabing = true;
					this.mc.gotoAndPlay( LABEL_GRAB );
				}
			}
		}
		
		private function checkIfGrabing():void
		{
			if( this != null && !isDead ){
				if ( isGrabing && isHitPlatform ){
					b2body.m_linearVelocity.y *= WALL_GRAB_POWER;
					playerLocalPoint = b2body.GetUserData();
					if ( playerLocalPoint.y >= WALL_GRAB_TARGET ) {
						b2body.m_linearVelocity.y -= WALL_GRAB_UP_POWER;
					}else {
						if( currentDirection == DIRECTION_RIGHT ){
							b2body.m_linearVelocity.x += WALL_GRAB_FORWARD_POWER;
						}else {
							b2body.m_linearVelocity.x -= WALL_GRAB_FORWARD_POWER;
						}
						grabCtrForward += WALL_GRAB_FORWARD_POWER;
						
						if ( grabCtrForward >= WALL_GRAB_FORWARD_MAX ) {
							releaseGrab();
						}
					}
				}else {
					releaseGrab();
				}
			}
			
			/*
			if( this != null && !isDead ){
				if ( isGrabing ){
					if ( isHitPlatform ) {
						b2body.m_linearVelocity.y *= WALL_GRAB_POWER;
						playerLocalPoint = b2body.GetUserData();
						b2body.m_linearVelocity.y -= WALL_GRAB_UP_POWER;
					}else {
						if( currentDirection == DIRECTION_RIGHT ){
							b2body.m_linearVelocity.x += WALL_GRAB_FORWARD_POWER;
						}else {
							b2body.m_linearVelocity.x -= WALL_GRAB_FORWARD_POWER;
						}
						grabCtrForward += WALL_GRAB_FORWARD_POWER;
						
						if ( grabCtrForward >= WALL_GRAB_FORWARD_MAX ) {
							releaseGrab();
						}
					}
				}
			}*/
		}
		
		private function climb():void
		{
			//trace( "[ player2 ] climb check: " + this.mc.currentLabel );
			if ( !isDead && this.mc.currentLabel != LABEL_CLIMB ){
				this.mc.gotoAndPlay( LABEL_CLIMB );
			}
		}
		
		private function resetHit():void
		{
			if( this != null && !isDead ){
				TweenLite.killDelayedCallsTo( resetHit );
				isHit = false;
				goIdle();
				if ( isDead ){
					//remove();
				}
			}
		}
		
		private function quickStop():void
		{
			if( this != null && !isDead ){
				if( this.mc != null && this != null && this.b2body != null ){
					var limit:Number = 0;
					var clipped_linear_velocity:V2 = this.b2body.GetLinearVelocity().normalize();
					this.b2body.SetLinearVelocity(clipped_linear_velocity.multiplyN(limit));
				}
			}
		}
		
		private function checkSpeedX():void
		{
			if( this != null && !isDead ){
				if( horizontalMovingPlatform == null && verticalMovingPlatform == null ){
					var speedX:Number = this.b2body.m_linearVelocity.x;
					var limit:Number;
					
					if ( hasDoubleJump ){
						limit = CaveSmashConfig.MOVE_AIR_LIMIT_X;
					}else {
						limit = CaveSmashConfig.MOVE_LIMIT_X;
					}
					
					var clipped_linear_velocity:V2 = this.b2body.GetLinearVelocity().normalize();
					
					if ( speedX < 0 ) {
						speedX *= -1;
					}
					
					if ( speedX >= limit ){
						//this.b2body.SetLinearVelocity(clipped_linear_velocity.multiplyN(limit));
						this.b2body.m_linearVelocity.x = clipped_linear_velocity.multiplyN(limit).x;
					}
				}
			}
		}
		
		private function checkSpeedY():void
		{
			if( this != null && !isDead ){
				var speedY:Number = this.b2body.m_linearVelocity.y;
				var limit:Number;
				
				if ( !isClimbing) {
					limit = CaveSmashConfig.MOVE_LIMIT_Y;
				}else {
					limit = CaveSmashConfig.MOVE_CLIMB_LIMIT_Y;
				}
				
				if ( speedY < 0 ) {
					speedY *= -1;
				}
				
				if( speedY >= limit ){
					var clipped_linear_velocity:V2 = this.b2body.GetLinearVelocity().normalize();
					//this.b2body.SetLinearVelocity(clipped_linear_velocity.multiplyN(limit));
					this.b2body.m_linearVelocity.y = clipped_linear_velocity.multiplyN(limit).y;
				}
			}
		}
		
		
		private function resetAcceleration():void
		{
			if( this != null && !isDead ){
				var clipped_linear_velocity:V2 = new V2( 0,0 );
				this.b2body.SetLinearVelocity(clipped_linear_velocity.multiplyN(0));
			}
		}
		
		private function dashRight():void
		{
			if( this != null && !isDead ){
				if( horizontalMovingPlatform == null && verticalMovingPlatform == null ){
					b2body.ApplyImpulse(new V2( DASH_POWER, 0), b2body.GetWorldCenter());
				}else {
					b2body.m_linearVelocity.x += CaveSmashConfig.MOVING_PLATFORM_MIN_MOVE_POWER;
				}
			}
		}
		
		private function dashLeft():void
		{
			if( this != null && !isDead ){
				if( horizontalMovingPlatform == null && verticalMovingPlatform == null ){
					b2body.ApplyImpulse(new V2( -DASH_POWER, 0), b2body.GetWorldCenter());
				}else {
					b2body.m_linearVelocity.x -= CaveSmashConfig.MOVING_PLATFORM_MIN_MOVE_POWER;
				}
			}
		}
		
		private function goLeft(  ):void
		{
			if( this != null && !isDead ){
				var speedX:Number = this.b2body.m_linearVelocity.x;
				var speedY:Number = this.b2body.m_linearVelocity.y;
				
				if ( speedX > 0 ) {
					b2body.SetLinearVelocity( new V2( 0,speedY ) );
				}
				
				if ( this.mc.currentLabel != LABEL_DAMAGE3 ) {
					if( horizontalMovingPlatform == null && verticalMovingPlatform == null ){
						b2body.ApplyImpulse(new V2( -MOVE_POWER, 0), b2body.GetWorldCenter());
						//b2body.m_linearVelocity.x -= MOVE_POWER;
					}else {
						if ( !isJumping ) {
							
							if( horizontalMovingPlatform != null ){
								if( horizontalMovingPlatform.currentDirection == DIRECTION_LEFT ){
									b2body.SetLinearVelocity( new V2( -2.5, 0) );
								}else if( horizontalMovingPlatform.currentDirection == DIRECTION_RIGHT ){
									b2body.SetLinearVelocity( new V2( -2, 0) );
								}
							}
							
							if( verticalMovingPlatform != null ){
								if ( verticalMovingPlatform.currentDirection == DIRECTION_DOWN ){
									b2body.SetLinearVelocity( new V2( -2, 0) );
								}else if ( verticalMovingPlatform.currentDirection == DIRECTION_UP ) {
									//b2body.SetLinearVelocity( new V2( -6.5, 0) );
									b2body.SetLinearVelocity( new V2( -3, 0) );
								}
							}
						}
					}
				}
				
				if ( this.mc.currentLabel != LABEL_RUN
					&& this.mc.currentLabel != LABEL_ATTACK
					&& this.mc.currentLabel != LABEL_ATTACK2
					&& this.mc.currentLabel != LABEL_ATTACK3
					&& this.mc.currentLabel != LABEL_JUMP_ATTACK
					&& this.mc.currentLabel != LABEL_DAMAGE
					&& this.mc.currentLabel != LABEL_DAMAGE2
					&& this.mc.currentLabel != LABEL_DAMAGE3
					&& this.mc.currentLabel != LABEL_JUMP_DAMAGE
					&& this.mc.currentLabel != LABEL_HIT
					//&& this.mc.currentLabel != LABEL_WALL_SLIDE
					&& !isClimbing
					&& !isDead
				) {
					this.mc.gotoAndPlay( LABEL_RUN );
				}
				currentDirection = DIRECTION_LEFT;
				this.gotoAndStop( LABEL_LEFT );
				
				if ( _gdc.getDir(  ) != currentDirection ) {
					_gdc.setDir( currentDirection );
				}
			}
		}
		
		private function goRight():void
		{
			if( this != null && !isDead ){
				var speedX:Number = this.b2body.m_linearVelocity.x;
				var speedY:Number = this.b2body.m_linearVelocity.y;
				
				if ( speedX < 0 ) {
					b2body.SetLinearVelocity( new V2( 0,speedY ) );
				}
				
				if ( this.mc.currentLabel != LABEL_DAMAGE3 ) {
					if( horizontalMovingPlatform == null && verticalMovingPlatform == null ){
						b2body.ApplyImpulse(new V2( MOVE_POWER, 0), b2body.GetWorldCenter());
						//b2body.m_linearVelocity.x += MOVE_POWER;
					}else{
						if ( !isJumping ) {
							
							if( horizontalMovingPlatform != null ){
								if( horizontalMovingPlatform.currentDirection == DIRECTION_RIGHT ){
									b2body.SetLinearVelocity( new V2( 2.5, 0) );
								}else if( horizontalMovingPlatform.currentDirection == DIRECTION_LEFT ){
									b2body.SetLinearVelocity( new V2( 2, 0) );
								}
							}
							
							if( verticalMovingPlatform != null ){
								if ( verticalMovingPlatform.currentDirection == DIRECTION_DOWN ){
									b2body.SetLinearVelocity( new V2( 2, 0) );
								}else if ( verticalMovingPlatform.currentDirection == DIRECTION_UP ) {
									//b2body.SetLinearVelocity( new V2( 6.5, 0) );
									b2body.SetLinearVelocity( new V2( 3, 0) );
								}
							}
						}
					}
				}
				
				if ( this.mc.currentLabel != LABEL_RUN
					&& this.mc.currentLabel != LABEL_ATTACK
					&& this.mc.currentLabel != LABEL_ATTACK2
					&& this.mc.currentLabel != LABEL_ATTACK3
					&& this.mc.currentLabel != LABEL_JUMP_ATTACK
					&& this.mc.currentLabel != LABEL_DAMAGE
					&& this.mc.currentLabel != LABEL_DAMAGE2
					&& this.mc.currentLabel != LABEL_DAMAGE3
					&& this.mc.currentLabel != LABEL_JUMP_DAMAGE
					&& this.mc.currentLabel != LABEL_HIT
					//&& this.mc.currentLabel != LABEL_WALL_SLIDE
					&& !isClimbing
					&& !isDead
				) {
					this.mc.gotoAndPlay( LABEL_RUN );
				}
				currentDirection = DIRECTION_RIGHT;
				this.gotoAndStop( LABEL_RIGHT );
				
				if ( _gdc.getDir(  ) != currentDirection ) {
					_gdc.setDir( currentDirection );
				}
			}
		}
		
		private function changeGravity():void
		{
			gravityMod = true;
			gravityScale = 3;
		}
		
		private function normalizeGravity():void
		{
			gravityMod = false;
			gravityScale = 1;
		}
		
		private function goIdle():void
		{
			if ( 	this.mc.currentLabel != LABEL_IDLE
					&& !isDead
					&& !isHoldingWall
					&& !isClimbing
					&& !isHit
					&& this.mc.currentLabel != LABEL_JUMP_DAMAGE
					&& this.mc.currentLabel != LABEL_JUMP
					&& this.mc.currentLabel != LABEL_FALL
					&& this.mc.currentLabel != LABEL_JUMP_ATTACK
					&& this.mc.currentLabel != LABEL_HIT
					&& this.mc.currentLabel != LABEL_ATTACK
					&& this.mc.currentLabel != LABEL_ATTACK2
					&& this.mc.currentLabel != LABEL_ATTACK3
					&& this.mc.currentLabel != LABEL_DAMAGE
					&& this.mc.currentLabel != LABEL_DAMAGE2
					&& this.mc.currentLabel != LABEL_DAMAGE3
					&& this.mc.currentLabel != LABEL_GRAB
				){
				idle();
			}
		}
		
		private function goJumpAnimation():void
		{
			if ( this.mc.currentLabel != LABEL_JUMP
				&& this.mc.currentLabel != LABEL_RUN
				&&  this.mc.currentLabel != LABEL_ATTACK
				&& this.mc.currentLabel != LABEL_ATTACK2
				&& this.mc.currentLabel != LABEL_ATTACK3
				&&  this.mc.currentLabel != LABEL_DAMAGE
				&& this.mc.currentLabel != LABEL_DAMAGE2
				&& this.mc.currentLabel != LABEL_DAMAGE3
				&& this.mc.currentLabel != LABEL_JUMP_DAMAGE
				&&  this.mc.currentLabel != LABEL_JUMP_ATTACK
				&& this.mc.currentLabel != LABEL_HIT
				&& this.mc.currentLabel != LABEL_WALL_SLIDE
				&& !isDead
			){
				this.mc.gotoAndPlay( LABEL_JUMP );
			}
		}
		
		private function goFallAnimation():void
		{
			if ( this.mc.currentLabel != LABEL_FALL
				&& this.mc.currentLabel != LABEL_RUN
				&&  this.mc.currentLabel != LABEL_ATTACK
				&& this.mc.currentLabel != LABEL_ATTACK2
				&& this.mc.currentLabel != LABEL_ATTACK3
				&&  this.mc.currentLabel != LABEL_DAMAGE
				&& this.mc.currentLabel != LABEL_DAMAGE2
				&& this.mc.currentLabel != LABEL_DAMAGE3
				&& this.mc.currentLabel != LABEL_JUMP_DAMAGE
				&&  this.mc.currentLabel != LABEL_JUMP_ATTACK
				&& this.mc.currentLabel != LABEL_STAND
				&& this.mc.currentLabel != LABEL_HIT
				&& !isDead
			){
				this.mc.gotoAndPlay( LABEL_FALL );
			}
		}
		
		private function  goWallSlideAnimation():void
		{
			if ( this.mc.currentLabel != LABEL_WALL_SLIDE
				&& this.mc.currentLabel != LABEL_FALL
				&&  this.mc.currentLabel != LABEL_ATTACK
				&& this.mc.currentLabel != LABEL_ATTACK2
				&& this.mc.currentLabel != LABEL_ATTACK3
				&&  this.mc.currentLabel != LABEL_DAMAGE
				&& this.mc.currentLabel != LABEL_DAMAGE2
				&& this.mc.currentLabel != LABEL_DAMAGE3
				&&  this.mc.currentLabel != LABEL_JUMP_ATTACK
				&& this.mc.currentLabel != LABEL_STAND
				&& this.mc.currentLabel != LABEL_HIT
				&& !isDead
			){
				this.mc.gotoAndPlay( LABEL_WALL_SLIDE );
				b2body.m_linearVelocity.y *= WALL_SLIDE_POWER;
				//trace( "[Playe2]:go slide2...." );
			}
		}
		
		
		private function goClimb():void
		{
			if( this != null && !isDead ){
				isClimbing = true;
				applyGravity = false;
				//trace( "[ player2 ]: go climb!!!!!!!" );
				if ( this.mc.currentLabel != LABEL_END_CLIMB ){
					this.mc.gotoAndStop( LABEL_END_CLIMB );
				}
			}
		}
		
		private function offClimb():void
		{
			isClimbing = false;
			applyGravity = true;
		}
		
		private function goJump():void
		{
			if ( this != null && !isDead ){
				b2body.ApplyImpulse(new V2(0, JUMP_POWER ), b2body.GetWorldCenter());
				isJumping = true;
				playSFX(6);
				addJumpDust();
			}
		}
		
		private function addJumpDust():void{
			var jumpEffect:DustEffectMC = new DustEffectMC();
			Util.addChildAtPosOf( world,jumpEffect, this, -1, new Point(0,16));
		}
		
		private function goDoubleJump():void
		{
			if ( this != null && !isDead ) {
				playSFX(6);
				resetAcceleration();
				b2body.ApplyImpulse(new V2(0, SECOND_JUMP_POWER ), b2body.GetWorldCenter());
				hasDoubleJump = true;
				//trace("[player2]: go double jump!!");
			}
		}
		
		private function attackThrow():void
		{
			if( this != null && !isDead ){
				//trace( "[player2]: attack throw!!!" );
				if ( this.mc.currentLabel != LABEL_ATTACK
					&& this.mc.currentLabel != LABEL_ATTACK2
					&& this.mc.currentLabel != LABEL_ATTACK3
					&& !isAttacking
					&& !isDead
				){
					this.mc.gotoAndPlay( LABEL_ATTACK );
					
					var hammer:HammerMC = new HammerMC();
					hammer.setDirection( currentDirection );
					hammer.pattern = 3;
					Util.addChildAtPosOf( world, hammer, this, -1, new Point(0,-35) );
					
					isAttacking = true;
					TweenLite.delayedCall( ATTACK_THROW_DELAY, activateThrowAttack );
				}
			}
		}
		
		private function attackBomb():void
		{
			if (!_hasBombed) {
				_hasBombed = true;
				TweenLite.delayedCall(ATTACK_BOMB_DELAY, onBombReady);
				var bomb:BombMC = new BombMC();
				bomb.setDirection( currentDirection );
				
				if( currentDirection == DIRECTION_RIGHT ){
					Util.addChildAtPosOf( world, bomb, this, -1, new Point( 40 , 0 ) );
				}else {
					Util.addChildAtPosOf( world, bomb, this, -1, new Point(  -40 , 0 ) );
				}
			}
		}
		
		private function onBombReady():void
		{
			_hasBombed = false;
		}
		
		
		private function activateThrowAttack():void
		{
			isAttacking = false;
		}
		
		//public function carryX( val:V2, xpos:Number, ypos:Number ):void
		//{
			//if( this != null && !isDead ){
				//b2body.m_xf.position.x = val.x;
				//b2body.m_xf.position.y = val.y;
				//this.mc.x = xpos;
				//this.mc.y = ypos;
			//}
		//}
		
		
		private function initControllers():void
		{
			_gdc = GameDataController.getInstance();
			_gdc.setCheckpoint(null);
			hp = CaveSmashConfig.HERO_HP; //_gdc.getLive();
		}
		
		private function removeControllers():void
		{
			
		}
		
		private function checkIfKillBombMonster():void
		{
			if( isKillBombMonster ){
				forceHit(1,1);
				trace("kill bomb must recieved damage!!!");
			}
		}
		
		/*-------------------------------------------------------------------------Events--------------------------------------------------------------*/
		public function endContact(e:ContactEvent):void {
			if ( this != null && !isDead ) {
				
				var wallLen:int = CSObjects.WALL_TERRAIN.length;
				for (var i:int = 0; i < wallLen; i++)
				{
					if ( e.other.GetBody().GetUserData() is CSObjects.WALL_TERRAIN[i] && !isClimbing ){
						isHitWall = false;
						break;
					}
				}
				
				if ( e.other.GetBody().GetUserData() is Ladder && isClimbing ) {
					offClimb();
				}else if ( 	e.other.GetBody().GetUserData() is Wall_LongMC ) {
					//isHitWall = false;
				}else if (  e.other.GetBody().GetUserData() is TreasureBoxMC ){
					_currentTreasureBox = null;
				}else if (  e.other.GetBody().GetUserData() is HorizontalMovingPlatformMC ){
					horizontalMovingPlatform = null;
				}else if ( e.other.GetBody().GetUserData() is VerticalMovingPlatformMC ){
					verticalMovingPlatform = null;
				}
			}
		}
		
		
		public function handleContact(e:ContactEvent):void {
			if ( this != null ) {
				
				if(!isDead){
					var playerBlockLen:int = CSObjects.PLAYER_BLOCKS.length;
					for (var i:int = 0; i < playerBlockLen; i++)
					{
						if ( e.other.GetBody().GetUserData() is CSObjects.PLAYER_BLOCKS[i] && !isClimbing ) {
							offJump();
							break;
						}
					}
					
					var wallLen:int = CSObjects.WALL_TERRAIN.length;
					for (i = 0; i < wallLen; i++)
					{
						if ( e.other.GetBody().GetUserData() is CSObjects.WALL_TERRAIN[i] && !isClimbing ){
							offJump();
							isHitWall = true;
							break;
						}
					}
					
					var specialBlockLen:int = CSObjects.SPECIAL_BLOCKS.length;
					for (i = 0; i < specialBlockLen; i++)
					{
						if ( e.other.GetBody().GetUserData() is CSObjects.SPECIAL_BLOCKS[i] ){
							offJump();
							break;
						}
					}
					
					var monsterLen:int = CSObjects.MONSTERS.length;
					for (i = 0; i < monsterLen; i++)
					{
						if ( e.other.GetBody().GetUserData() is CSObjects.MONSTERS[i] ){
							isKnockBack = false;
							break;
						}
					}
					
					if ( e.other.GetBody().GetUserData() is Ladder && !isClimbing ) {
						goClimb();
					}else if ( 	e.other.GetBody().GetUserData() is Wall_LongMC ) {
						//isHitWall = true;
						isKnockBack = false;
					}else if (  e.other.GetBody().GetUserData() is Block
								|| e.other.GetBody().GetUserData() is NormalBlockMC
								|| e.other.GetBody().GetUserData() is UnBreakableBlockMC
								|| e.other.GetBody().GetUserData() is SwitchMC
								|| e.other.GetBody().GetUserData() is BlockerMC
								|| e.other.GetBody().GetUserData() is InnerDivider
								|| e.other.GetBody().GetUserData() is FloorSmallMC
								|| e.other.GetBody().GetUserData() is FloorMediumMC
								|| e.other.GetBody().GetUserData() is FloorLongMC
								|| e.other.GetBody().GetUserData() is CeillingLongMC
								|| e.other.GetBody().GetUserData() is UnBreakableBlockMC
							){
						isKnockBack = false;
					}else if (  e.other.GetBody().GetUserData() is TreasureBoxMC ){
						var treasureBox:TreasureBoxMC = e.other.GetBody().m_userData;
						if ( !treasureBox.isCollected ){
							_currentTreasureBox = null;
							_currentTreasureBox = treasureBox;
						}
					}else if (  e.other.GetBody().GetUserData() is HorizontalMovingPlatformMC  ) {
						trace( "detect moving platform" );
						horizontalMovingPlatform = e.other.GetBody().m_userData;
						isKnockBack = false;
						offJump();
					}else if ( e.other.GetBody().GetUserData() is VerticalMovingPlatformMC ) {
						verticalMovingPlatform = e.other.GetBody().m_userData;
						isKnockBack = false;
						offJump();
					}
				}else {
					//type = "Static";
				}
			}
		}
		
		public function parseInput(e:Event):void{
			if (!world || isDead || this == null || this.mc == null ) return;
			updateVector();
			graphics.clear();
			graphics.lineStyle(3, 0xff0000, RAY_CAST_ALPHA, false, "normal", CapsStyle.NONE);
			graphics.moveTo(0,0);

			startRayCast(v1, v2);
			
			
			var manifold:b2WorldManifold = null;
			dot = -1;
			
			if( this != null && !isDead ){
				// Search for the most ground/floor-like contact.
				if(!contacts.isEmpty()) {
					contacts.forEach(function(keys:Array, c:ContactEvent) {
						var wm:b2WorldManifold = c.getWorldManifold();
						if(wm.normal) {
							
							// Dot producting the contact normal with gravity indicates how floor-like the
							// contact is. If the dot product = 1, it is a flat foor. If it is -1, it is
							// a ceiling. If it's 0.5, it's a sloped floor. Save the contact manifold
							// that is the most floor like.
							var d:Number = wm.normal.dot(gravity);
							if(!manifold || d > dot) {
								manifold = wm;
								dot = d;
							}
						}
					});
					contacts.clean();
				}
			}
			
			var left:Boolean;
			var right:Boolean;
			var throwWeapon:Boolean;
			var placeBomb:Boolean;
			var interactItem:Boolean;
			var attackTrigger:Boolean;
			
			
			left = Input.kd(CaveSmashConfig.LEFT_CONTROL, CaveSmashConfig.LEFT_CONTROL2);
			right = Input.kd(CaveSmashConfig.RIGHT_CONTROL, CaveSmashConfig.RIGHT_CONTROL2);
			down = Input.kd(CaveSmashConfig.DOWN_CONTROL, CaveSmashConfig.DOWN_CONTROL2);
			throwWeapon = Input.kp(CaveSmashConfig.THROW_CONTROL, CaveSmashConfig.THROW_CONTROL2);
			interactItem = Input.kp(CaveSmashConfig.INTERACT_CONTROL, CaveSmashConfig.INTERACT_CONTROL2);
			placeBomb = Input.kp(CaveSmashConfig.PLACE_BOMB, CaveSmashConfig.PLACE_BOMB2);
			
			if ( isClimbing  ){
				up = Input.kd(CaveSmashConfig.UP_CONTROL, CaveSmashConfig.UP_CONTROL2);
			}else{
				up = Input.kp(CaveSmashConfig.UP_CONTROL, CaveSmashConfig.UP_CONTROL2 );
			}
			
			attackTrigger = Input.kp(CaveSmashConfig.ATTACK_CONTROL2, CaveSmashConfig.ATTACK_CONTROL3, CaveSmashConfig.ATTACK_CONTROL, CaveSmashConfig.ATTACK_CONTROL4);
			
			var v:V2;
			//trace( "[player2] check dot value: " + dot );
			// Here we could add a dot product threshold for disallowing the player from jumping
			// off of walls, ceilings, etc. For example:
			// if(up && manifold && dot > 0){
			
			//for stairs
			if (  isClimbing && !isGrabing && !isHit ){
				if ( up ){
					climb();
					if( this != null && !isDead ){
						b2body.ApplyImpulse(new V2(0, -CLIMBING_POWER ), b2body.GetWorldCenter());
					}
				}else if ( down && isClimbing ) {
					climb();
					if( this != null && !isDead ){
						b2body.ApplyImpulse(new V2(0, CLIMBING_POWER ), b2body.GetWorldCenter());
					}
				}
			}
			
			if ( !hasDoubleJump && up && !isClimbing && isJumping && !isHitWall && !isGrabing && _gdc.hasDoubleJump() && !isHit){
				isHoldingWall = false;
				goDoubleJump();
			}
			
			if( this != null && !isDead && !_gdc.getIsLockControlls() && !isHit ){
				if( !isKnockBack && !isLevelComplete && !isDead && this != null && !isGrabing ){
					if ( attackTrigger || throwWeapon || up || placeBomb && !isCameraSliding ){
						if ( attackTrigger){
							attack();
						}else if ( throwWeapon && _gdc.hasThrowWeapon() ){
							attackThrow();
						}else if ( placeBomb && _gdc.hasBomber() ) {
							trace("place bomb now!!!!!!!!!!!!!!!");
							attackBomb();
						}else if ( up && manifold && !isClimbing && !isJumping || ( isHitWall && isHoldingWall  ) ){
							isHoldingWall = false;
							goJump();
						}
					}else{
						if( left && !isCameraSliding ){
							goLeft();
						}else if( right && !isCameraSliding ){
							goRight();
						}else{
							goIdle();
						}
					}
				}
			}
			
			
			if( !up && !down && isClimbing ){
				//stop the amplied force
				if( this != null && !isDead ){
					b2body.m_linearVelocity.y *= CaveSmashConfig.FRICTION_ON_STOP_Y;
				}
			}
			
			//if( !right && !left || ( attackTrigger ) ){
			if( !right && !left ){
				//b2body.m_linearVelocity.x *= 0.25;
				if( this != null && !isDead ){
					b2body.m_linearVelocity.x *= CaveSmashConfig.FRICTION_ON_STOP_X;
				}
			}
			
			//check for detecting jumps and falls
			//solves which animation to show which action to do based on dot values
			
			var speedY:Number = this.b2body.m_linearVelocity.y;
			if ( dot == 10 && speedY == 0.5 && isJumping && !isGrabing /*|| ( dot < 10 && dot > 0 )*/ ){
				offJump();
			}
			
			if ( isJumping && !isClimbing  && !isGrabing ){
				if ( dot == -1 && speedY > 0 ){
					if( !isHitWall ){
						goFallAnimation();
					}
				}else if ( dot == -1 && speedY < 0 ){
					goJumpAnimation();
				}else if ( ( dot == -4.371138828673793e-7 || dot == 4.371138828673793e-7 ) && isHitWall && _gdc.hasWallClimb() ){
					trace( "[Playe2]:go slide1...." );
					if ( left || right && isHitWall ){
						isHoldingWall = true;
						goWallSlideAnimation();
					}else {
						isHoldingWall = false;
						if ( speedY < 0 ){
							goJumpAnimation();
						}else {
							goFallAnimation();
						}
					}
				}
			}
			
			if ( dot == 0 && !isGrabing && isHitPlatform && /*playerLocalPoint.y > hitPlatform.y &&*/ isReadyToGrab  ){
				trace( "[palyer2]: detect platform corner!!!! dot : " + dot );
				grab();
			}
			
			checkIfGrabing();
			
			if ( interactItem  ){
				if ( _currentTreasureBox != null ){
					if ( !_currentTreasureBox.isCollected ){
						_currentTreasureBox.collect();
						_currentTreasureBox = null;
					}
				}
			}
			
			checkSpeedX();
			checkSpeedY();
			knockBack();
			checkIfReadyToDamage();
			checkIfKillBombMonster();
			//trace( " isJumping:  " + isJumping );
			//trace( "[Player2]:  dot" + dot );
			//trace( "[Player2]:  dot" + dot + " this.b2body.m_linearVelocity.x " +  this.b2body.m_linearVelocity.x + " this.b2body.m_linearVelocity.y " +  this.b2body.m_linearVelocity.y  );
			//trace( "[Player2]:  dot" + dot + " Speed " + speedY + " Manifold " + manifold + " isClimbing " + isClimbing + " isJumping " + isJumping );
		}
		
		private function offJump():void
		{
			isJumping = false;
			hasDoubleJump = false;
			idle();
		}
		
		private function onPickUpItem(e:CaveSmashEvent):void
		{
			var itemType:String = e.obj.itemType;
			if ( itemType == ItemConfig.HEART ){
				hp = _gdc.getLive();
				//trace( "[Player2]: update life has collect heart!!! CHECK HP " + hp );
			}
		}
		
		private function onLevelComplete(e:CaveSmashEvent):void
		{
			quickStop();
			isLevelComplete = true;
			goIdle();
			removeControllers();
			removeGameEvent();
			//trace( "[Player2]: onLevelComplete............................" );
		}
		
		private function onLevelStarted(e:CaveSmashEvent):void
		{
			isLevelComplete = false;
			initControllers();
			//trace( "[Player2]: onLevelStarted............................" );
		}
		
		private function onLevelFailed(e:CaveSmashEvent):void
		{
			isLevelComplete = true;
			//trace( "[Player2]: onLevelFailed............................" );
		}
		
		private function onStopCameraSlide(e:CaveSmashEvent):void
		{
			isCameraSliding = false;
		}
		
		private function onStartCameraSlide(e:CaveSmashEvent):void
		{
			quickStop();
			isCameraSliding = true;
		}
		
		private function onGamePaused(e:GameEvent):void
		{
			deActivateControl();
		}
		
		private function onGameOutFocus(e:GameEvent):void
		{
			deActivateControl();
		}
		
		private function onGameGotFocus(e:GameEvent):void
		{
			//welcome back
		}
		
		private function onUnGamePaused(e:GameEvent):void
		{
			//welcome back
		}
		
		private function deActivateControl():void
		{
			quickStop();
		}
		
		private function onRemoveAttackRange(e:CaveSmashEvent):void
		{
			_isAttackRangeRemove = true;
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