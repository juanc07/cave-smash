package components.levels.trap {	
	
	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.ContactEvent;
	import Box2DAS.Dynamics.StepEvent;
	import com.monsterPatties.config.CaveSmashConfig;
	import com.monsterPatties.config.SoundConfig;
	import com.monsterPatties.events.CaveSmashEvent;
	import com.monsterPatties.utils.eventSatellite.EventSatellite;
	import components.blocks.TrapConfig;
	import components.config.CSObjects;
	import components.players.Player2;
	import flash.events.Event;
	import misc.Util;
	import wck.*;
	
	public class RockTrap extends BodyShape {		
	
		/*------------------------------------------------------------------Constant----------------------------------------------------------------------*/		
		/*------------------------------------------------------------------Properties--------------------------------------------------------------------*/
		public var contacts:ContactList;
		public var blockType:String = TrapConfig.ROCK_TRAP;		
		private var _caveSmashEvent:CaveSmashEvent;
		private var _es:EventSatellite;
		private var _target:Player2;
		
		public var currentDirection:int = DIRECTION_RIGHT;
		public var yCurrentDirection:int = DIRECTION_DOWN;;
		
		public static const DIRECTION_RIGHT:int = 0;
		public static const DIRECTION_LEFT:int = 1;
		public static const DIRECTION_UP:int = 2;
		public static const DIRECTION_DOWN:int = 3;		
		
		public static const DAMAGING_POWER:Number = 1.5;
		private var hasDamagingPower:Boolean;
		
		private static const MOVE_POWER:Number = CaveSmashConfig.BLUE_BOX_MOVE_SPEED;
		private var isMovingRight:Boolean = false;
		private var isMovingLeft:Boolean = false;
		private var _levelIsDone:Boolean = false;
		private var hasRemoved:Boolean;
		/*------------------------------------------------------------------Constructor----------------------------------------------------------------------*/
		
		override public function shapes():void 
		{
			super.shapes();
			circle();
		}
		
		override public function create():void 
		{
			super.create();
			
			type = "Dynamic";
			fixedRotation = false;			
			
			listenWhileVisible(this, ContactEvent.BEGIN_CONTACT, handleContact);
			listenWhileVisible(this, ContactEvent.END_CONTACT, endContact);
			listenWhileVisible(world, StepEvent.STEP, parseInput, false, 10);
			contacts = new ContactList();
			contacts.listenTo(this);		
			addGameEvent();
		}
		/*------------------------------------------------------------------Methods----------------------------------------------------------------------*/
		private function clearAll():void
		{			
			if( this != null ){
				removeAllListeners();
				removeControllers();
				removeGameEvent();				
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
			}
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
			_es.addEventListener( CaveSmashEvent.LEVEL_QUIT, OnLevelQuit );
			_es.addEventListener( CaveSmashEvent.LEVEL_COMPLETE, onLevelComplete );			
			_es.addEventListener( CaveSmashEvent.LEVEL_FAILED, onLevelFailed );
			_es.addEventListener( CaveSmashEvent.RELOAD_LEVEL, onReloadLevel );
			trace( "[RockTrap]:add GameEvent........................ " );
		}		
		
		private function removeGameEvent():void 
		{
			_es = EventSatellite.getInstance();
			_es.removeEventListener( CaveSmashEvent.LEVEL_STARTED, onLevelStarted );
			_es.removeEventListener( CaveSmashEvent.LEVEL_QUIT, OnLevelQuit );
			_es.removeEventListener( CaveSmashEvent.LEVEL_COMPLETE, onLevelComplete );			
			_es.removeEventListener( CaveSmashEvent.LEVEL_FAILED, onLevelFailed );
			_es.removeEventListener( CaveSmashEvent.RELOAD_LEVEL, onReloadLevel );
			trace( "[RockTrap]:remove GameEvent........................ " );
		}
		
		private function attackPlayer(  ):void 
		{
			if( _target != null && this != null ){
				var player:Player2 = _target as Player2;
				if( !player.isDead  ){
					if ( player.currentDirection == DIRECTION_RIGHT && currentDirection == DIRECTION_LEFT ){
						player.hit( 1,1, currentDirection );
					}else if ( player.currentDirection == DIRECTION_LEFT && currentDirection == DIRECTION_RIGHT ){
						player.hit( 1,1,currentDirection );
					}
				}
			}
		}
		
		private function checkX():void 
		{
			if( this != null ){
				var speedX:Number = this.b2body.m_linearVelocity.x;
				var speedY:Number = this.b2body.m_linearVelocity.y;
				
				if ( speedX >= DAMAGING_POWER || speedX <= -DAMAGING_POWER ) {
					hasDamagingPower = true;
					attackPlayer();
				}else if ( speedY >= DAMAGING_POWER || speedY <= -DAMAGING_POWER ) {
					hasDamagingPower = true;
					attackPlayer();
				}else {
					hasDamagingPower = false;
				}
				
			}
		}
		
		private function checkDirection():void 
		{
			var speedX:Number = this.b2body.m_linearVelocity.x;
			var speedY:Number = this.b2body.m_linearVelocity.y;
			
			if ( speedX > 0 ){
				currentDirection = DIRECTION_RIGHT;
			}else if (  speedX < 0) {
				currentDirection = DIRECTION_LEFT;
			}
			
			if ( speedY > 0 ){
				yCurrentDirection = DIRECTION_DOWN;
			}else if (  speedY < 0) {
				yCurrentDirection = DIRECTION_UP;
			}
		}
		
		public function moveRight( ):void 
		{
			trace( "[ MoveableBase]: moveRight!!!" );
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
				trace( "[ MoveableBase]: moveRight!!!" );
			}
		}
		
		
		public function moveLeft():void 
		{
			trace( "[ MoveableBase]: moveLeft!!!" );
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
		/*------------------------------------------------------------------Setters----------------------------------------------------------------------*/
		
		/*------------------------------------------------------------------Getters----------------------------------------------------------------------*/
		
		/*------------------------------------------------------------------EventHandlers----------------------------------------------------------------*/
		public function endContact(e:ContactEvent):void {			
			if ( this != null ) {
				trace( "[ MoveableBlock ]: end contact with: === >" + e.other.GetBody().GetUserData() );
				if ( e.other.GetBody().GetUserData() is Player ){
					_target = null;
				}
			}
		}
		public function handleContact(e:ContactEvent):void {			
			if ( this != null ){
				//trace( "[ MoveableBlock ]: begin contact with: === >" + e.other.GetBody().GetUserData() );			
				trace( "rock Trap hit what: " + e.other.GetBody().GetUserData() );				
				if ( e.other.GetBody().GetUserData() is Player ) {
					_caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.PLAY_SFX );
					_caveSmashEvent.obj.id = SoundConfig.BIG_ROCK_SFX;
					_es.dispatchESEvent( _caveSmashEvent );
					
					_target = e.other.GetBody().m_userData;
				}
				
				var monster:*;
				
				var monsterLen:int = CSObjects.MONSTERS.length;
				for (var i:int = 0; i < monsterLen; i++) 
				{
					if(  e.other.GetBody().GetUserData() is CSObjects.MONSTERS[ i ] && hasDamagingPower ){						
						monster = e.other.GetBody().m_userData;
						if ( monster != null ){									
							monster.hit(  currentDirection, true );							
							break;
						}
					}
				}
				
				var bosslen:int = CSObjects.BOSS.length;
				var rockEffect:BlockExplodeMC;
				
				for ( i = 0; i < bosslen; i++) 
				{
					if(  e.other.GetBody().GetUserData() is CSObjects.BOSS[ i ]){						
						monster= e.other.GetBody().m_userData;						
						if ( monster != null ) {
							if ( hasDamagingPower ){
								monster.hit(  currentDirection, true, 7 );
							}
							rockEffect = new BlockExplodeMC();
							rockEffect.scaleX = 2;
							rockEffect.scaleY = 2;
							Util.addChildAtPosOf(world, rockEffect, this );
							clearAll();
							removeME();
							break;							
						}
					}
				}
				
				if(  e.other.GetBody().GetUserData() is NormalBlockMC && hasDamagingPower ){						
					var block:NormalBlockMC = e.other.GetBody().m_userData;
					if ( block != null ){									
						block.animate();						
					}
				}
			}
		}
		
		private function onLevelFailed(e:CaveSmashEvent):void 
		{			
			clearAll();
			//trace( "[RockTrap]: on level failed" );
		}
		
		private function onLevelComplete(e:CaveSmashEvent):void 
		{			
			clearAll();			
			//trace( "[RockTrap]: onLevelComplete............................" );
		}
		
		private function onLevelStarted(e:CaveSmashEvent):void 
		{
			initControllers();
			//trace( "[RockTrap]: onLevelStarted............................" );
		}
		
		public function parseInput(e:Event):void {			
			if (!world  || this == null ) return;
			//trace( "[ RockTrap ]: m_linearVelocity.x " + this.b2body.m_linearVelocity.x + " m_linearVelocity.y:  " + this.b2body.m_linearVelocity.y );
			checkDirection();
			checkX();
		}
		
		private function OnLevelQuit(e:CaveSmashEvent):void 
		{
			clearAll();
			removeME();
		}
		
		private function onReloadLevel(e:CaveSmashEvent):void{
			clearAll();
			removeME();
		}
	}
}