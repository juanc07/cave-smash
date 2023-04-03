package OurWCKObjs
{
	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.ContactEvent;
	import Box2DAS.Dynamics.Joints.b2DistanceJoint;
	import Box2DAS.Dynamics.Joints.b2MouseJoint;
	import Box2DAS.Dynamics.StepEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	
	import misc.Input;
	
	import shapes.Circle;
	
	import wck.ContactList;
	import wck.Joint;
	
	public class HeroGrapple extends MovieClip
	{
		public var bodyPivot:Circle;
		public var pivotJoint:Joint;
		
		public var hook:Circle;
		
		public var wristJoint:Joint;
		public var handJoint:Joint;
		
		public var retract:Boolean = false;
		

		
		public function HeroGrapple()
		{
			super();
			addEventListener(Event.ENTER_FRAME, waitForArm);
		}
		
		public function waitForArm(e:Event):void
		{
			if (bodyPivot.visible)
			{
				bodyPivot.listenWhileVisible(bodyPivot.world, StepEvent.STEP, modThing, false, 10);
				

				hook.listenWhileVisible(hook.world, ContactEvent.BEGIN_CONTACT, HandleHookContact);
				
				hook.reportBeginContact = true;
				hook.reportEndContact = true;
				
				removeEventListener(Event.ENTER_FRAME, waitForArm);
			}
		}
		
		public function HandleHookContact(e:ContactEvent):void
		{
			if (!handJoint)
			{
			
				if ((e.contact.m_fixtureA.m_userData is NormalBounds ||
					e.contact.m_fixtureB.m_userData is NormalBounds) &&
					e.contact.m_fixtureB.m_userData is HookEnd ||
					e.contact.m_fixtureB.m_userData is HookEnd)
				{
					
					var a:Number = HeroContainer(this.parent).mainBody.b2body.m_xf.position.v2.y - (hook.b2body.m_xf.position.v2.y);
					var b:Number = HeroContainer(this.parent).mainBody.b2body.m_xf.position.v2.x - (hook.b2body.m_xf.position.v2.x);
					var c:Number;
					
					a *= a;
					b *= b;
					
					c = Math.sqrt(a + b);
					
					(wristJoint.b2joint as b2DistanceJoint).m_length = c;
					
					hook.type = 'Static';
				}
			}
				
		}
		
		public function TryToGrapply(e:Event):void
		{

		}

		public var lastAngle:Number = 0;
		
		public function modThing(e:Event)
		{
			if (!hook || !this || this.parent == null) 
			{
				return;	
			}
			
			var curPoint:Point = new Point(mouseX, mouseY);
			
			curPoint = this.parent.globalToLocal(curPoint);
						
			var dx:Number = mouseX - this.pivotJoint.b2joint.m_userData.x;
			var dy:Number = mouseY - this.pivotJoint.b2joint.m_userData.y;
			
			var angle:Number = Math.atan2(dy, dx);
			
			hook.b2body.SetLinearVelocity(new V2(0,0));

			if (hook.type == 'Static')
			{
				bodyPivot.b2body.SetTransform(bodyPivot.b2body.m_xf.position.v2, lastAngle);
			}
			else
			{
				bodyPivot.b2body.SetTransform(bodyPivot.b2body.m_xf.position.v2, angle);
				lastAngle = angle;
				
				if ((wristJoint.b2joint as b2DistanceJoint).m_length == 10)
				{
					retract = true;
				}
				else if ((wristJoint.b2joint as b2DistanceJoint).m_length < .005 && retract)
				{
					ClearArm();
					
					retract = false;

					return;
				}
				
				if (retract)
				{
					(wristJoint.b2joint as b2DistanceJoint).m_length -= 1;
				}
			}
		}
		
		public function ClearArm(recreate:Boolean = true):void
		{
			var tempRef:HeroContainer = this.parent as HeroContainer;
			
			bodyPivot.visible = false;
			
			removeEventListener(Event.ENTER_FRAME, waitForArm);
			
			this.parent.removeChild(this);
		
			if (recreate)
			{				
				tempRef.MakeGrapArm();
			}
			else
			{
				bodyPivot.destroy();
				pivotJoint.destroy();
				
				hook.destroy();
				
				wristJoint.destroy();
				handJoint.destroy();
			}
		}
		
		public function ShootArm():void
		{
			handJoint.destroyJoint();
			handJoint = null;
			
			//hook.isSensor = false;
			(wristJoint.b2joint as b2DistanceJoint).m_length = 10;
		}
	}
}