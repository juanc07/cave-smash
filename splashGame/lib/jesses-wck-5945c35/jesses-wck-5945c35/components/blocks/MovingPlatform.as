package components.blocks {	
	
	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.b2Fixture;
	import Box2DAS.Dynamics.ContactEvent;
	import Box2DAS.Dynamics.StepEvent;
	import com.monsterPatties.config.GameConfig;
	import components.config.CSObjects;
	import components.players.Player2;
	import flash.display.CapsStyle;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import wck.*;
	
	public class MovingPlatform extends BodyShape {		
	
		/*------------------------------------------------------------------Constant----------------------------------------------------------------------*/		
		public static const DIRECTION_RIGHT:int = 0;
		public static const DIRECTION_LEFT:int = 1;
		public static const DIRECTION_UP:int = 2;
		public static const DIRECTION_DOWN:int = 3;
		
		public static const MOVE_POWER:Number = 2;		
		
		public static const HORIZONTAL:Number = 0;
		public static const VERTICAL:Number = 1;
		/*------------------------------------------------------------------Properties--------------------------------------------------------------------*/
		public var currentDirection:int = DIRECTION_RIGHT;
		public var PlatformType:int= HORIZONTAL;
		public var blockType:String = BlockConfig.MOVING_PLATFORM;		
		public var contacts:ContactList;
		
		//raycast things
		public var rot:Number = 0;
		private const RAY_CAST_ALPHA:int = 1;		
		private var player:Player2;
		//length of raycast
        protected var magnitude:Number = 100;
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
		
		/*------------------------------------------------------------------Constructor----------------------------------------------------------------------*/		
		public override function shapes():void {			
			
		}
		
		override public function create():void 
		{
			super.create();
			
			type = "Kinematic";
			reportBeginContact = true;
			reportEndContact = true;
			fixedRotation = true;
			//bullet = true;
			applyGravity = false;
			
			listenWhileVisible(world, StepEvent.STEP, parseInput, false, 10);
			listenWhileVisible(this, ContactEvent.BEGIN_CONTACT, handleContact);
			listenWhileVisible(this, ContactEvent.END_CONTACT, endContact);
			contacts = new ContactList();
			contacts.listenTo(this);		
			
			if ( GameConfig.showCollider ){
				this.collider.alpha = 1;
			}			
		}
		/*------------------------------------------------------------------Methods----------------------------------------------------------------------*/
		private function moveLeft(  ):void 
		{
			if( this != null ){
				//trace( "[MovingPlatform]: move left!!!!!!!!!!" );				
				b2body.SetLinearVelocity( new V2( -MOVE_POWER, 0) );
			}
		}		
		
		private function moveRight(  ):void 
		{
			//trace( "[MovingPlatform]: move right!!!!!!!!!!" );
			if( this != null ){				
				b2body.SetLinearVelocity( new V2( MOVE_POWER, 0) );
			}		
		}
		
		private function moveUp(  ):void 
		{
			if( this != null ){
				//trace( "[MovingPlatform]: move up!!!!!!!!!!" );
				b2body.SetLinearVelocity( new V2( 0, -MOVE_POWER) );
			}
		}
		
		private function moveDown(  ):void 
		{
			if( this != null ){
				//trace( "[MovingPlatform]: move down!!!!!!!!!!" );
				b2body.SetLinearVelocity( new V2( 0, MOVE_POWER) );
			}
		}
		
		
		private function checkX():void 
		{
			if( this != null ){
				var speedX:Number = this.b2body.m_linearVelocity.x;
				var limit:Number = MOVE_POWER;
				var clipped_linear_velocity:V2 = this.b2body.GetLinearVelocity().normalize();			
				
				if ( speedX < 0 ) {
					speedX *= -1;
				}				
				
				if ( speedX >= limit ){
					this.b2body.SetLinearVelocity(clipped_linear_velocity.multiplyN(limit));
				}
			}
		}
		
		public function getPosXY():V2 
		{
			return b2body.GetLinearVelocity();
		}
		
		private function switchDirection():void 
		{
			if( PlatformType == HORIZONTAL ){
				if ( currentDirection == DIRECTION_RIGHT ) {
					currentDirection = DIRECTION_LEFT;
				}else {
					currentDirection = DIRECTION_RIGHT;
				}
			}else if ( PlatformType == VERTICAL ) {
				if ( currentDirection == DIRECTION_UP ) {
					currentDirection = DIRECTION_DOWN;
				}else {
					currentDirection = DIRECTION_UP;
				}
			}
		}
		
		//raycast
		protected function updateVector(  ):void {
			if( this != null ){
				//convert start and end locations to world.			
				p1 = new Point(0, 0 );
				if( currentDirection == DIRECTION_RIGHT ){
					p2 = new Point(magnitude, 0); //assumes that art is facing right at 0º
				}else if( currentDirection == DIRECTION_LEFT ){
					p2 = new Point( -( magnitude - magnitudeOffset ), 0 );
				}else if( currentDirection == DIRECTION_UP ){
					p2 = new Point( 0, -( magnitude - magnitudeOffset ) );
				}else if( currentDirection == DIRECTION_DOWN ){
					p2 = new Point(0, magnitude );
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
			if( this != null ){
				valid = false;

				world.b2world.RayCast(rcCallback, v1, v2); //see onRayCast();

				if(valid){
					var body:BodyShape = fixture.m_userData.body;
					
					var blocksLen:int = CSObjects.BLOCKS.length;
					for (var i:int = 0; i < blocksLen; i++) 
					{
						if (  fixture.GetBody().GetUserData() is CSObjects.BLOCKS[ i ] ){						
							switchDirection();
							break;
						}
					}			
				}else {//if none were found
					//isDetectPlayer = false;
					point=v2; //full length
					drawLaser();
					//trace( "not valid" );
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
			if( this != null ){
				var pt:Point = new Point(point.x*world.scale, point.y*world.scale);
				pt = globalToLocal(world.localToGlobal(pt));
				graphics.lineTo(pt.x, pt.y);			
			}
		}
		//raycast	
		/*------------------------------------------------------------------Setters----------------------------------------------------------------------*/
		
		/*------------------------------------------------------------------Getters----------------------------------------------------------------------*/
		
		/*------------------------------------------------------------------EventHandlers----------------------------------------------------------------*/
		public function endContact(e:ContactEvent):void {
			if( this != null ){
				if ( e.other.GetBody().GetUserData() is Player ){
					//player = null;
				}			
				e.contact.SetEnabled(true);
			}
		}
		public function handleContact(e:ContactEvent):void {	
			if( this != null ){
				//for player to enter from below this moving platform prevent sticky power
				if(e.normal) {
					var m:Matrix = matrix.clone();
					m.tx = 0;
					m.ty = 0;
					m.invert();
					var n:V2 = b2body.GetLocalVector(e.normal);
					var p:Point = m.transformPoint(n.toP());
					e.contact.SetEnabled(p.y < -0.8);
				}
				
				var blocksLen:int = CSObjects.BLOCKS.length;
				for (var i:int = 0; i < blocksLen; i++)
				{
					if (  e.other.GetBody().GetUserData() is CSObjects.BLOCKS[ i ] ){
						switchDirection();
						break;
					}
				}
			}
		}
		
		public function parseInput(e:Event):void {
			//trace( "[ MovingPlatform ]: parse!!");
			if (!world  || this == null ) return;			
			
			updateVector();			
			graphics.clear();
			graphics.lineStyle(3, 0xff0000, RAY_CAST_ALPHA, false, "normal", CapsStyle.NONE);
			graphics.moveTo(0, 0);
			
			startRayCast(v1, v2);			
			
			if( currentDirection == DIRECTION_RIGHT ){
				moveRight(  );
			}else if( currentDirection == DIRECTION_LEFT ){
				moveLeft(  );
			}else if ( currentDirection == DIRECTION_UP ) {
				moveUp();
			}else if ( currentDirection == DIRECTION_DOWN ) {
				moveDown();
			}
			checkX();			
		}
	}
}