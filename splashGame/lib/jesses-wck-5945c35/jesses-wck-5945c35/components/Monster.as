package components{
	
	import Box2DAS.*;
	import Box2DAS.Collision.*;
	import Box2DAS.Collision.Shapes.*;
	import Box2DAS.Common.*;
	import Box2DAS.Dynamics.*;
	import Box2DAS.Dynamics.Contacts.*;
	import Box2DAS.Dynamics.Joints.*;
	import cmodule.Box2D.*;
	import com.greensock.TweenLite;
	import extras.*;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.utils.*;
	import misc.*;
	import shapes.*;
	import wck.*;
	
	public class Monster extends BodyShape {	
        
		private static const DIRECTION_RIGHT:int = 0;
		private static const DIRECTION_LEFT:int = 1;
		
		private static const LABEL_RIGHT:String = "right";
		private static const LABEL_LEFT:String = "left";
		private static const LABEL_JUMP:String = "jump";
		private static const LABEL_HIT:String = "hit";
		private static const LABEL_DAMAGE:String = "damage";
		private static const LABEL_ATTACK:String = "attack";
		private static const LABEL_WALK:String = "walk";
		private static const LABEL_IDLE:String = "idle";
		
		private var currentDirection:int = DIRECTION_RIGHT;
		private var isJumping:Boolean = false;
		private var isAttacking:Boolean = false;
		private var isFalling:Boolean = false;
		private var isMovingRight:Boolean = false;
		private var isMovingLeft:Boolean = false;
		private var isHit:Boolean = false;
		private var hitDelay:Number = 0.5;
		private var isDetectPlayer:Boolean = false;
		
		//type
		private var isDigger:Boolean = false;
		//
		
		private static const JUMP_POWER:Number = -1.5;
		private static const RIGHT_MOVE_POWER:Number = 0.1;
		private static const LEFT_MOVE_POWER:Number = -0.1;
		
		public override function shapes():void{
		}
		
		public var contacts:ContactList;
		
		//raycast things
		public var rot:Number = 0;
		private const RAY_CAST_ALPHA:int = 1;
		private var jump:Boolean;
		//length of raycast
        protected var magnitude:Number = 40;
		protected var magnitudeOffset:Number = 5;

		protected var p1:Point //start point
		protected var p2:Point //end point
		protected var v1:V2 //start point in world.scale
		protected var v2:V2 //end point in world.scale

		//stored by raycast callback.
		protected var valid:Boolean;
		protected var fixture:b2Fixture;
		protected var point:V2;	
		//raycast things
		
		public override function create():void {
			trace( "[monster] create monster" );			
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
		}
		
		
		/*-----------------------------------------[ for raycasting methods ] ----------------------------------------------------------------------------*/ 
		protected function updateVector(  ):void{
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
		
		protected function startRayCast(v1:V2, v2:V2):void{
			valid = false;

			world.b2world.RayCast(rcCallback, v1, v2); //see onRayCast();

			if(valid){
				var body:BodyShape = fixture.m_userData.body //tip for finding the wck body.
				//trace( "raycast hit" ,fixture.m_userData );
				//trace( "monster raycast hit", fixture.GetBody().GetUserData() );
				if ( fixture.GetBody().GetUserData() is Player ){
					isDetectPlayer = true;                    
                    rest();
					attack();
					if( this.mc.currentLabel == LABEL_DAMAGE ){
						var player:Player2 = fixture.GetBody().m_userData as Player2;						
						player.hit();
					}
				}else if ( fixture.GetBody().GetUserData() is SPlatForm ){
					isDetectPlayer = false;
					if( isDigger ){
						attack();
						if( this.mc.currentLabel == LABEL_DAMAGE ){
							var p:SPlatForm = fixture.GetBody().m_userData as SPlatForm;
							if ( p ){
								Util.addChildAtPosOf(world, new FX1(), p);
								p.remove();
							}
						}
					}else {
						switchWhereToLook();
					}
				}else if (  fixture.GetBody().GetUserData() is Divider || fixture.GetBody().GetUserData() is Monster ){
					isDetectPlayer = false;					
					switchWhereToLook();					
				}				
				drawLaser();
			}else {//if none were found
				isDetectPlayer = false;
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
		
		protected function drawLaser():void{
			var pt:Point = new Point(point.x*world.scale, point.y*world.scale);
			pt = globalToLocal(world.localToGlobal(pt));

			graphics.lineTo(pt.x, pt.y);			
		}
		/*-----------------------------------------[ for raycasting methods ] ----------------------------------------------------------------------------*/
		
		private function attack():void 
		{
			if( this.mc.currentLabel != LABEL_ATTACK && !isHit  && !isAttacking ){
				this.mc.gotoAndPlay( LABEL_ATTACK );
				isAttacking = true;
				TweenLite.delayedCall( 0.5, activateAttack );
			}
		}		
		
		private function activateAttack():void 
		{
			isAttacking = false;
		}
		
		public function hit():void 
		{
			if ( this.mc.currentLabel != LABEL_HIT && !isHit ) {
				isHit = true;
				this.mc.gotoAndPlay( LABEL_HIT );
				TweenLite.delayedCall( hitDelay,resetHit  );				
			}
		}
		
		private function resetHit():void 
		{
			isHit = false;
		}	
		
		public function endContact(e:ContactEvent):void{
			
		}
		
		public function handleContact(e:ContactEvent):void {						
			//trace( "[ Monster ]: begin contact with: === >" + e.other.GetBody().GetUserData() );
			if ( e.other.GetBody().GetUserData() is Player && !isDetectPlayer ) {
				switchWhereToLook();
			}
			//else if ( e.other.GetBody().GetUserData() is SPlatForm || fixture.GetBody().GetUserData() is Divider ) {
				//switchWhereToLook();
			//}
		}
		
		private function switchWhereToLook():void 
		{
			if( currentDirection == DIRECTION_RIGHT ){
				lookLeft();
			}else if( currentDirection == DIRECTION_LEFT ){
				lookRight();
			}
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
            if ( this.mc.currentLabel != LABEL_IDLE && !isHit  && !isAttacking ) {
                this.mc.gotoAndPlay( LABEL_IDLE );				
            }
        }       
		
		public function parseInput(e:Event):void {
			if(!world)return;

			updateVector();			
			graphics.clear();
			graphics.lineStyle(3, 0xff0000, RAY_CAST_ALPHA, false, "normal", CapsStyle.NONE);
			graphics.moveTo(0,0);

			startRayCast(v1, v2);
			
			
			var manifold:b2WorldManifold = null;
			var dot:Number = -1;
			
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
			
			
			var left:Boolean;
			var right:Boolean;
			jump;
			var attack:Boolean;
			var v:V2;			
			
			//var speedX:Number = this.b2body.m_linearVelocity.x;
			//trace( "[Monster]: speedX " + speedX );
			if ( currentDirection == DIRECTION_RIGHT ){
				//b2body.ApplyImpulse(new V2( RIGHT_MOVE_POWER, 0), b2body.GetWorldCenter());
				if( this.mc.currentLabel != LABEL_WALK && !isHit && !isDetectPlayer ){
					this.mc.gotoAndPlay( LABEL_WALK );					
				}	
				b2body.ApplyImpulse(new V2( RIGHT_MOVE_POWER, 0), b2body.GetWorldCenter());
				//b2body.m_linearVelocity.x += 0.5;								
				//trace( "[Monster]: move right" );
				isMovingRight = true;
				isMovingLeft = false;
			}else if ( currentDirection == DIRECTION_LEFT ){
				//b2body.ApplyImpulse(new V2( LEFT_MOVE_POWER, 0), b2body.GetWorldCenter());
				if( this.mc.currentLabel != LABEL_WALK && !isHit && !isDetectPlayer ){
					this.mc.gotoAndPlay( LABEL_WALK );					
				}
				b2body.ApplyImpulse(new V2( LEFT_MOVE_POWER, 0), b2body.GetWorldCenter());
				//b2body.m_linearVelocity.x += -0.5;				
				//trace( "[Monster]: move Left" );
				isMovingLeft = true;
				isMovingRight = false;
			}
			
			// Here we could add a dot product threshold for disallowing the player from jumping
			// off of walls, ceilings, etc. For example:
			// if(jump && manifold && dot > 0) {
			if(jump && manifold) {			
				//v = manifold.normal.clone().multiplyN(-2);
				//b2body.ApplyImpulse(v, b2body.GetWorldCenter());												
				b2body.ApplyImpulse(new V2(0, JUMP_POWER ), b2body.GetWorldCenter());				
				if ( !isJumping ){
					isJumping = true;
				}
				//trace( "[ Player2 jump ] isjumping " + isJumping );
			}else{
				if( this.mc.currentLabel != LABEL_IDLE && this.mc.currentLabel != LABEL_ATTACK && !isHit && this.mc.currentLabel != LABEL_DAMAGE && this.mc.currentLabel != LABEL_WALK ){
					this.mc.gotoAndPlay( LABEL_IDLE );
				}
			}			
			
			if( !right && !left && !isMovingRight && !isMovingLeft ){
				b2body.m_linearVelocity.x *= 0.25;
			}			
            
			var speed:Number = this.b2body.m_linearVelocity.y;
			var limitY:Number = 0.25;
			
			var speedX:Number = this.b2body.m_linearVelocity.x;
			//trace( "[ Monster ]: speedX " + speedX + " speed " + speed );
			var limitX:Number = 2;			
            
			if ( ( speed  == 0 || speed == 0.5 ) && ( isMovingLeft || isMovingRight ) ){
				
				if ( speedX < 0 ) {
					speedX *= -1;
				}
				
				if (speedX > 2  )
				{					
					var clipped_linear_velocity:V2 = this.b2body.GetLinearVelocity().normalize();					
					this.b2body.SetLinearVelocity(clipped_linear_velocity.multiplyN(limitX));
					//trace( "[Monster]: on ground limit speed now!!! " ); 
				}			
			}		
            
			if ( speed  == 0 ) {			
				if ( isJumping ){
					isJumping = false;
					//trace( "[Monster]: on ground " ); 
				}				
					
				if (speed > 0.25  )
				{					
					var clipped_linear_velocity:V2 = this.b2body.GetLinearVelocity().normalize();					
					this.b2body.SetLinearVelocity(clipped_linear_velocity.multiplyN(limitY));					
				}			
			}else {
				if ( !isJumping ){
					isJumping = true;
					//trace( "[Monster]: is falling.... " );
				}				
			}
		}
	}
}