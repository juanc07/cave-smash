package components.weapons 
{
	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.b2Fixture;
	import Box2DAS.Dynamics.ContactEvent;
	import Box2DAS.Dynamics.StepEvent;
	import com.greensock.TweenLite;
	import com.monsterPatties.config.CaveSmashConfig;
	import com.monsterPatties.events.CaveSmashEvent;
	import com.monsterPatties.utils.eventSatellite.EventSatellite;
	import components.config.CSObjects;
	import flash.display.CapsStyle;
	import flash.events.Event;
	import flash.geom.Point;
	import wck.BodyShape;
	import wck.ContactList;
	/**
	 * ...
	 * @author jc
	 */
	public class BaseShot extends BodyShape {	
		
		/*----------------------------------------------------------------------Constants-------------------------------------------------------------*/
		protected static const DIRECTION_RIGHT:int = 0;
		protected static const DIRECTION_LEFT:int = 1;
		
		/*----------------------------------------------------------------------Properties-------------------------------------------------------------*/
		protected var currentDirection:int = DIRECTION_RIGHT;
		public var contacts:ContactList;
		public var MOVE_POWER:Number = CaveSmashConfig.BASE_SHOT_SPEED;
		public var LIFE_SPAN:Number = CaveSmashConfig.BASE_SHOT_LIFE_SPAN;
		public var KNOCK_BACK_POWER:Number = CaveSmashConfig.BASE_SHOT_KNOCK_BACK_POWER;
		public var KNOCK_BACK_RANGE:Number = CaveSmashConfig.BASE_SHOT_KNOCK_BACK_RANGE;
		
		//cavesmash events
		public var _es:EventSatellite;
		public var _caveSmashEvent:CaveSmashEvent;	
		
		//raycast things
		public var rot:Number = 0;
		private var RAY_CAST_ALPHA:int = CaveSmashConfig.BULLET_RAY_CAST_ALPHA;
		//length of raycast
        protected var magnitude:Number = 60;
		protected var magnitudeOffset:Number = 0;

		protected var p1:Point //start point
		protected var p2:Point //end point
		protected var v1:V2 //start point in world.scale
		protected var v2:V2 //end point in world.scale

		//stored by raycast callback.
		protected var valid:Boolean;
		protected var fixture:b2Fixture;
		protected var point:V2;	
		//raycast things
		
		private var hasEffect:Boolean;
		private var hasRemoved:Boolean;
		private var isLevelComplete:Boolean = false;
		private var player:Player;
		/*----------------------------------------------------------------------Constructor-------------------------------------------------------------*/
		public override function shapes():void{									
		}
		
		override public function create():void 
		{
			super.create();
			type = "Dynamic";			
			bullet = true;
			active = true;
			applyGravity = false;
			fixedRotation = true;
			
			listenWhileVisible(world, StepEvent.STEP, parseInput, false, 10);
			listenWhileVisible(this, ContactEvent.BEGIN_CONTACT, handleContact);
			listenWhileVisible(this, ContactEvent.END_CONTACT, endContact);
			contacts = new ContactList();
			contacts.listenTo(this);
			addGameEvent();
			TweenLite.delayedCall( LIFE_SPAN, removeME )
		}
		
		/*----------------------------------------------------------------------Methods-------------------------------------------------------------*/
		
		public function setDirection( dir:int ):void 
		{
			currentDirection = dir;
		}
		
		protected function updateVector(  ):void{
			//convert start and end locations to world.			
			if( this != null && !hasRemoved ){
				p1 = new Point(0, 0 );
				if ( currentDirection == DIRECTION_RIGHT ) {
					//this.mc.scaleX = -1;
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
		
		protected function startRayCast(v1:V2, v2:V2):void {
			if( this != null && !hasRemoved && !isLevelComplete ){
				valid = false;
				world.b2world.RayCast(rcCallback, v1, v2); //see onRayCast();

				if(valid){
					var body:BodyShape = fixture.m_userData.body;
					var blocksLen:int;
					var i:int;
					
					if (  fixture.GetBody().GetUserData() is SwitchMC ){
						var switchMC:SwitchMC = fixture.GetBody().m_userData;
						if ( switchMC ){
							switchMC.activate();
						}
						removeME();
					}
					
					//if( this != null ){
						//var blocksLen:int = CSObjects.MONSTER_BLOCKS.length;
						//for (var i:int = 0; i < blocksLen; i++){
							//if (  fixture.GetBody().GetUserData() is CSObjects.MONSTER_BLOCKS[ i ] ){
								//removeME();
								//break;
							//}
						//}
					//}				
					
					if( this != null ){
						blocksLen = CSObjects.BLOCKS.length;
						for (i= 0; i < blocksLen; i++){
							if (  fixture.GetBody().GetUserData() is CSObjects.BLOCKS[ i ] ){
								removeME();
								break;
							}
						}
					}
					
					if( this != null ){
						blocksLen = CSObjects.TRAPS.length;
						for ( i = 0; i < blocksLen; i++){
							if (  fixture.GetBody().GetUserData() is CSObjects.TRAPS[ i ] ){
								removeME();
								break;
							}
						}
					}
					
					if( !hasRemoved ){
						drawLaser();
					}
				}else {//if none were found					
					point=v2; //full length
					drawLaser();					
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
		
		protected function drawLaser():void {
			if( this != null && !hasRemoved && !isLevelComplete ){
				var pt:Point = new Point(point.x*world.scale, point.y*world.scale);
				pt = globalToLocal(world.localToGlobal(pt));
				graphics.lineTo(pt.x, pt.y);			
			}
		}		
		
		private function initControllers():void 
		{
			_es = EventSatellite.getInstance();
		}
		
		private function removeControllers():void 
		{
			
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
		
		private function removeME():void 
		{
			if ( !hasRemoved ) {
				if (!hasEffect){
					hasEffect = true;
					addBaseShotEffect();
				}				
				removeTweens();
				clearAll();
				hasRemoved = true;
				this.remove();
			}
		}
		
		public function hit():void 
		{
			removeME();
		}
		
		private function clearAll():void
		{			
			removeAllListeners();
			removeControllers();
			removeGameEvent();			
		}	
		
		private function addGameEvent():void 
		{
			_es = EventSatellite.getInstance();
			_es.addEventListener( CaveSmashEvent.LEVEL_STARTED, onLevelStarted );
			_es.addEventListener( CaveSmashEvent.LEVEL_COMPLETE, onLevelComplete );
			_es.addEventListener( CaveSmashEvent.LEVEL_QUIT, onLevelQuit );
			_es.addEventListener( CaveSmashEvent.LEVEL_FAILED, onLevelFailed );
			_es.addEventListener( CaveSmashEvent.RELOAD_LEVEL, onLevelFailed );
			trace( "[BaseShot]:add GameEvent........................ " );
		}	
		
		private function removeGameEvent():void 
		{
			_es = EventSatellite.getInstance();
			_es.removeEventListener( CaveSmashEvent.LEVEL_QUIT, onLevelQuit );
			_es.removeEventListener( CaveSmashEvent.LEVEL_STARTED, onLevelStarted );
			_es.removeEventListener( CaveSmashEvent.LEVEL_COMPLETE, onLevelComplete );			
			_es.removeEventListener( CaveSmashEvent.LEVEL_FAILED, onLevelFailed );
			_es.removeEventListener( CaveSmashEvent.RELOAD_LEVEL, onLevelFailed );
			trace( "[BaseShot]:remove GameEvent........................ " );
		}		
		
		
		private function removeTweens():void 
		{
			TweenLite.killDelayedCallsTo(damagePlayer);
			TweenLite.killDelayedCallsTo(removeME);
		}	
		/*----------------------------------------------------------------------Setters-------------------------------------------------------------*/
		
		/*----------------------------------------------------------------------Getters-------------------------------------------------------------*/
		
		/*----------------------------------------------------------------------Events-------------------------------------------------------------*/
		
		public function endContact(e:ContactEvent):void {
			if( this != null && !hasRemoved ){
				//trace( "[ pOO ]: end contact with: === >" + e.other.GetBody().GetUserData() );			
				//if ( e.other.GetBody().GetUserData() is Player2 ) {
					//
				//}
			}
		}
		public function handleContact(e:ContactEvent):void{
			//trace( "[ pOO ]: begin contact with: === >" + e.other.GetBody().GetUserData() );
			if ( this != null && !hasRemoved && !isLevelComplete ) {
				
				//if (!hasEffect) {
					//hasEffect = true;
					//addBaseShotEffect();
				//}
				
				if ( e.other.GetBody().GetUserData() is Player	) {
					removeME();
					player = e.other.GetBody().m_userData;					
					TweenLite.delayedCall(0.1, damagePlayer);
					return;
				}
			}
			
			if( this != null ){
				var blocksLen:int = CSObjects.MONSTER_BLOCKS.length;
				for (var i:int = 0; i < blocksLen; i++){
					if (  e.other.GetBody().GetUserData() is CSObjects.MONSTER_BLOCKS[ i ] ){
						removeME();
						break;
						return;
					}
				}
			}	
		}		
		
		public function addBaseShotEffect():void{
			
		}
		
		private function damagePlayer():void {
			TweenLite.killDelayedCallsTo(damagePlayer);			
			player.hit( KNOCK_BACK_POWER, KNOCK_BACK_RANGE, currentDirection );
		}
		
		
		public function parseInput(e:Event):void {
			if (!world  || this == null && hasRemoved ) return;
			
			if( currentDirection == DIRECTION_RIGHT ){
				goRight();
			}else {
				goLeft();
			}
			checkSpeedX();
			
			updateVector();			
			graphics.clear();
			graphics.lineStyle(3, 0xff0000, RAY_CAST_ALPHA, false, "normal", CapsStyle.NONE);
			graphics.moveTo(0, 0);
			
			startRayCast(v1, v2);			
		}
		
		public function onLevelFailed(e:CaveSmashEvent):void 
		{	
			removeTweens
			isLevelComplete = true;
			clearAll();			
		}
		
		public function onLevelComplete(e:CaveSmashEvent):void 
		{		
			removeTweens();
			isLevelComplete = true;
			clearAll();
		}
		
		public function onLevelStarted(e:CaveSmashEvent):void{
			removeTweens
			initControllers();			
		}
		
		private function onLevelQuit(e:CaveSmashEvent):void 
		{
			removeTweens
			isLevelComplete = true;
			clearAll();
		}
	}

}