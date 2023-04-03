package components 
{
	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.ContactEvent;
	import Box2DAS.Dynamics.Joints.b2DistanceJoint;
	import Box2DAS.Dynamics.StepEvent;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import misc.Input;
	import misc.Scroller;
	import misc.ScrollerChild;
	import shapes.Box;
	import shapes.Circle;
	import wck.BodyShape;
	import wck.ContactList;
	import wck.Joint;
	/**
	 * ...
	 * @author ...
	 */
	public class RobotArm extends ScrollerChild
	{
		
		public var bodyPivot:Circle;
		public var pivotJoint:Joint;
		
		public var hook:Circle;
		
		public var wristJoint:Joint;
		public var handJoint:Joint;
		
		public var arm:Box;
		public var pivotJoint2:Joint;
		
		public var retract:Boolean = false;
		
		
		public var lastAngle:Number = 0;
		public var HookLastAngle:Number = 0;
		public var _hasShoot:Boolean = false;
		
		private var _handJointPos:Point =  new Point();
		private var _hookPos:Point =  new Point();
		
		
		//aim      
        var allow:int = 40;        
		
		public override function create():void {
			super.create();
			
			bodyPivot = getChildByName('bodyPivot') as Circle;
			pivotJoint = getChildByName('pivotJoint') as Joint;
			hook = getChildByName('hook') as Circle;
			handJoint = getChildByName('handJoint') as Joint;
			wristJoint = getChildByName('wristJoint') as Joint;			
			
			_handJointPos.x = this.handJoint.b2joint.m_userData.x; 
			_handJointPos.x = this.handJoint.b2joint.m_userData.y;
			
			_hookPos.x = hook.b2body.m_xf.position.v2.x;
			_hookPos.y = hook.b2body.m_xf.position.v2.y;
			
			//pivotJoint2 = getChildByName('pivotJoint2') as Joint;
			//arm = getChildByName('arm') as Box;		
			//bodyPivot.world.b2world.ClearForces();			
			
			
			bodyPivot.listenWhileVisible(bodyPivot.world, StepEvent.STEP, WorldStep, false, 10);
			hook.listenWhileVisible(hook.world, ContactEvent.BEGIN_CONTACT, HandleHookContact);
			listenWhileVisible(stage, MouseEvent.MOUSE_MOVE, this.mouseAimHandler);
			hook.reportBeginContact = true;
			hook.reportEndContact = true;
		}
		
		private function mouseAimHandler( e:MouseEvent ):void 
		{
			//var newPoint:Point = localToGlobal( new Point( this.mouseX, this.mouseY ) );
			//var newPoint2:Point = localToGlobal( new Point( this.pivotJoint.b2joint.m_userData.x, this.pivotJoint.b2joint.m_userData.y ) );			
			//
			//var distanceX:Number = newPoint.x;
			//var distanceY:Number =  newPoint.y;
			//if (distanceX*distanceX+distanceY*distanceY>10000) {
				//var birdAngle:Number=Math.atan2(distanceY,distanceX);
				//bird.x=100*Math.cos(birdAngle);
				//bird.y=100*Math.sin(birdAngle);
			//}
		}
		
		private function WorldStep( e:Event ):void 
		{	
			var newPoint:Point = localToGlobal( new Point( this.mouseX, this.mouseY ) );
			var newPoint2:Point = localToGlobal( new Point( this.pivotJoint.b2joint.m_userData.x, this.pivotJoint.b2joint.m_userData.y ) );			
			
			//if (!hook || !this || this.parent == null) 
			//{
				//return;	
			//}
			
			if ( wristJoint == null || hook == null ) {
				return;
			}			
			
			///var newPoint:Point = this.localToGlobal( new Point( this.parent.mouseX, this.parent.mouseY ) );
			
			//var dx:Number = newPoint.x - this.pivotJoint.b2joint.m_userData.x;
			//var dy:Number = newPoint.y - this.pivotJoint.b2joint.m_userData.y;
			
			//var dx:Number = mouseX - this.pivotJoint.b2joint.m_userData.x;
			//var dy:Number = mouseY - this.pivotJoint.b2joint.m_userData.y;
			
			var dx:Number = newPoint.x - newPoint2.x;
			var dy:Number = newPoint.y - newPoint2.y;
			var angle:Number = Math.atan2(dy, dx);			
			
			//hook.b2body.SetTransform(hook.b2body.m_xf.position.v2, angle + 90 );			
			hook.b2body.SetLinearVelocity(new V2(0, 0));
			
			if (hook.type == 'Static')
			{
				//hook.b2body.SetTransform(hook.b2body.m_xf.position.v2, HookLastAngle );
				
				bodyPivot.b2body.SetTransform(bodyPivot.b2body.m_xf.position.v2, lastAngle);
			}
			else
			{
				//hook.b2body.SetTransform(hook.b2body.m_xf.position.v2, hookAngle);
				//HookLastAngle = hookAngle;
				
				bodyPivot.b2body.SetTransform(bodyPivot.b2body.m_xf.position.v2, angle);				
				lastAngle = angle;				
				
				if ((wristJoint.b2joint as b2DistanceJoint).m_length == 10 )
				{
					retract = true;
				}
				else if ((wristJoint.b2joint as b2DistanceJoint).m_length < .005 && retract)
				{
					clearArm();
					
					retract = false;

					return;
				}
				
				if (retract)
				{
					(wristJoint.b2joint as b2DistanceJoint).m_length -= 1;
				}
				
			}
			
			//shoot arm
			var mClick:Boolean = Input.mouseIsDown;
			
			//if ( mClick ) {				
				//ShootArm();
			//}			
		}
		
		public function ShootArm():void
		{
			if ( !_hasShoot ) {
				_hasShoot = true;
				handJoint.destroy();
				handJoint = null;
				//handJoint.destroyJoint();				
				
				if ( wristJoint == null ) {
					wristJoint = getChildByName('wristJoint') as Joint;	
					//addChild( wristJoint );
				}
				
				(wristJoint.b2joint as b2DistanceJoint).m_length = 10;				
				hook.b2body.SetLinearVelocity(new V2(0, 0));
			}else {
				hook.x = _hookPos.x;
				hook.y = _hookPos.y;
				
				_hasShoot = false;
				handJoint = getChildByName('handJoint') as Joint;				
				//handJoint.createRevoluteJoint();
				//handJoint = new HeroJoint();
				//this.addChild( handJoint );				
				handJoint.x = _handJointPos.x;
				handJoint.y = _handJointPos.y;
				clearArm();
			}
		}
		
		public function clearArm():void 
		{
			//hook.destroy();
			hook = getChildByName('hook') as Circle;
			//if ( wristJoint != null ) {
				//wristJoint.destroyJoint();
				//wristJoint.destroy();
				//wristJoint = null;
			//}
		}
		
		public function HandleHookContact(e:ContactEvent):void
		{
			if (!handJoint && !wristJoint )
			{
			
				if ((e.contact.m_fixtureA.m_userData is Wall ||
					e.contact.m_fixtureB.m_userData is Wall) &&
					e.contact.m_fixtureB.m_userData is HookEnd ||
					e.contact.m_fixtureB.m_userData is HookEnd)
				{
					
					var newPoint:Point = localToGlobal( new Point( this.parent.x, this.parent.y ) );
					var newPoint2:Point = localToGlobal( new Point( hook.b2body.m_xf.position.v2.x, hook.b2body.m_xf.position.v2.y ) );
					
					//var a:Number = HeroContainer(this.parent).mainBody.b2body.m_xf.position.v2.y - (hook.b2body.m_xf.position.v2.y);
					//var b:Number = HeroContainer(this.parent).mainBody.b2body.m_xf.position.v2.x - (hook.b2body.m_xf.position.v2.x);
					var a:Number = newPoint.y - ( newPoint2.y);
					var b:Number = newPoint.x - (newPoint2.x);
					var c:Number;
					
					a *= a;
					b *= b;
					
					c = Math.sqrt(a + b);
					
					(wristJoint.b2joint as b2DistanceJoint).m_length = c;
					
					hook.type = 'Static';
				}
			}
				
		}
		
	}

}