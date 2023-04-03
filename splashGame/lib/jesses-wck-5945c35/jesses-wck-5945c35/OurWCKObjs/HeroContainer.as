package OurWCKObjs
{
	import Box2DAS.Collision.AABB;
	import Box2DAS.Collision.Shapes.b2MassData;
	import Box2DAS.Collision.b2AABB;
	import Box2DAS.Collision.b2WorldManifold;
	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.ContactEvent;
	import Box2DAS.Dynamics.Joints.b2DistanceJoint;
	import Box2DAS.Dynamics.Joints.b2RevoluteJoint;
	import Box2DAS.Dynamics.StepEvent;
	import Box2DAS.Dynamics.b2Body;
	import Box2DAS.Dynamics.b2Fixture;
	
	import com.GeneralManagers.LevelManager;
	import com.OverlayStuff.DialoguePopUp;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	
	import misc.Input;
	
	import shapes.Box;
	import shapes.Circle;
	
	import wck.BodyShape;
	import wck.ContactList;
	import wck.Joint;
	import wck.World;
	
	public class HeroContainer extends MovieClip
	{
		//Contacts of our main body.
		public var contacts:ContactList;
		
		public var mainBody:HeroBody;
		
		//When we attach the grapple arm.
		public var grappleArm:HeroGrapple = null;
		
		public static var enableArm:Boolean = false;
		
		public function HeroContainer()
		{
			super();
			//Hmm what is the 10 for?
		}
		
		var lastMClick:Boolean = false;
		
		public function AllBodyInput(e:Event):void
		{
			
			if (enableArm)
			{
				MakeGrapArm();
				enableArm = false;
			}
			
			if (HeroBody.setPositionWhenPossible)
			{
				HeroBody.setPositionWhenPossible = false;
				var curPos:V2;
				
				if (LevelManager.curLSensor == null)
				{
					curPos = new V2(-3,2);
				}
				else
				{
					trace(LevelManager.curLSensor.b2body + "-should");
					curPos = LevelManager.curLSensor.b2body.GetPosition();
					
					switch (LevelManager.curLSensor.name)
					{
						case "Right":
							curPos.x -= 2;
							break;
						case "Left":
							trace("isright");
							curPos.x += 2;
							break;
					}
					
					
					LevelManager.curLSensor = null;
				}
				
				mainBody.b2body.SetTransform(curPos, 0);

			}
			
			var manifold:b2WorldManifold = null;
			var dot:Number = -1;
			
			var maxSpeed:int = 5;
			
			if (WheelPickUp.hasBeenPickedUp)
			{
				maxSpeed = 10;
			}
			
			if (grappleArm && grappleArm.hook.type == 'Static')
			{
				maxSpeed = 2.5;
			}
			
			//Temp velocity
			var v:V2;
			
			//This chunk of code is for figuring out whether we can jump off a platform,
			//checks normals.
			if(!contacts.isEmpty()) 
			{
				contacts.forEach(function(keys:Array, c:ContactEvent) 
				{
					var wm:b2WorldManifold = c.getWorldManifold();
					if(wm.normal && wm.normal.y > .5) { 
						var d:Number = wm.normal.dot(mainBody.gravity);
						if(!manifold || d > dot) {
							manifold = wm;
							dot = d;
						}
					}
				});
				contacts.clean();
			}
		
			//Buttons.
			var left:Boolean = Input.kd('A', 'LEFT');
			var right:Boolean = Input.kd('D', 'RIGHT');
			var down:Boolean = Input.kd('S', 'DOWN');
			var jump:Boolean = Input.kp('W', 'UP');
			
			var up:Boolean = Input.kd('W', 'UP');
			
			var mClick:Boolean = Input.mouseIsDown;
			
			//Single press test
			var testBut:Boolean = Input.kp('P');
			
			//Single press test
			var Bomb:Boolean = Input.kp(' ');
			
			var testButDown:Boolean = Input.kp('O');
			
			
			//if(true)
			if (LevelManager.curWorld && !DialoguePopUp(LevelManager.curWorld.parent.parent["diag"]).visible)
			{
	
				if(jump && manifold && (!grappleArm || grappleArm.hook.type != 'Static')) 
				{
					if (grappleArm)
					{
						v = manifold.normal.clone().multiplyN(mainBody.b2body.GetMass() * -8.6585);
					}
					else
					{
						v = manifold.normal.clone().multiplyN(mainBody.b2body.GetMass() * -6.2069);
					}
					mainBody.b2body.ApplyImpulse(v, mainBody.b2body.GetWorldCenter());
				}
				
				if (up && grappleArm && grappleArm.hook.type == 'Static')
				{
					if ((grappleArm.wristJoint.b2joint as b2DistanceJoint).m_length > 1)
					{
						(grappleArm.wristJoint.b2joint as b2DistanceJoint).m_length -= .1;
					}
				}
				
				if (down &&  grappleArm && grappleArm.hook.type == 'Static')
				{
					if ((grappleArm.wristJoint.b2joint as b2DistanceJoint).m_length < 7)
					{
						(grappleArm.wristJoint.b2joint as b2DistanceJoint).m_length += .1;
					}
				}
	
				if(left) 
				{
					if (mainBody.jakClip.scaleX > 0)
					{
						mainBody.jakClip.scaleX *= -1;
					}
					
					if (mainBody.b2body.GetLinearVelocity().x > -maxSpeed)
					{
						mainBody.b2body.ApplyImpulse(new V2(-(mainBody.b2body.GetMass() * mainBody.b2body.GetMass()), 0), mainBody.b2body.GetWorldCenter());
					}
				}
				if(right) 
				{
					if (mainBody.b2body.GetLinearVelocity().x < maxSpeed)
					{
						mainBody.b2body.ApplyImpulse(new V2(mainBody.b2body.GetMass() * mainBody.b2body.GetMass(), 0), mainBody.b2body.GetWorldCenter());
					}
					
					if (mainBody.jakClip.scaleX < 0)
					{
						mainBody.jakClip.scaleX *= -1;
					}
				}
				
				if (testBut)
				{
					PsychicPickUp.hasBeenPickedUp = true;
					GrapplePickUp.hasBeenPickedUp = true;
				}
				
				if (Bomb && PsychicPickUp.hasBeenPickedUp)
				{
					var tempExplosion:ExplosionObj = new ExplosionObj();
					
					var newPoint:Point = new Point(mouseX, mouseY);
					
					newPoint = mainBody.world.globalToLocal(newPoint);
	
					tempExplosion.x = this.mainBody.x + x;
					tempExplosion.y = this.mainBody.y + y;
		
					mainBody.world.addChild(tempExplosion);
				}
				
				
				
				if (mClick && !lastMClick)
				{
					if (grappleArm && grappleArm.hook.type != 'Static')
					{
						grappleArm.ShootArm();
					}
					
					if (grappleArm && grappleArm.hook.type == 'Static')
					{
						grappleArm.ClearArm();
						//addEventListener(Event.ENTER_FRAME, OneFrameThenShoot);
						
					}
				}
			}
//				if (handJoint)
//				{
//					handJoint.destroy();
//				}
//				if ((wristJoint.b2joint as b2DistanceJoint).m_length < 1)
//				{
//					(wristJoint.b2joint as b2DistanceJoint).m_length = 5;
//				}
//				else
//				{
//					(wristJoint.b2joint as b2DistanceJoint).m_length = .08;
//				}
//			}
//			if ((wristJoint.b2joint as b2DistanceJoint).m_length > .1)
//			{
//				(wristJoint.b2joint as b2DistanceJoint).m_length -= .05;
//			}
//			
//			if ((wristJoint.b2joint as b2DistanceJoint).m_length < 2)
//			{
//				(wristJoint.b2joint as b2DistanceJoint).m_length = 0;
//			}
//			
//			trace((wristJoint.b2joint as b2DistanceJoint).m_length);
			
			
			
			//var speed:Number = 
						
			//pivotJoint.motorSpeed = (((pivotJoint.b2joint as b2RevoluteJoint).GetJointAngle() * (180.0 / Math.PI) - angle) * -1) / 2;
						
					
			//trace(angle);
			
			if (Math.abs(mainBody.linearVelocityX) < .01)
			{
				mainBody.jakClip.stop();
			}
			else
			{
				mainBody.jakClip.play();
			}
			
			lastMClick = mClick;
		}
		
		public function OneFrameThenShoot(e:Event):void
		{
			
			grappleArm.ShootArm();
			removeEventListener(Event.ENTER_FRAME, OneFrameThenShoot);
		}
		
		public function MakeGrapArm():void
		{
			GrapplePickUp.hasBeenPickedUp = true;
			
			var tempClass:Class = getDefinitionByName("GrappleArm") as Class;
			grappleArm = new tempClass();
			
			grappleArm.x = mainBody.x;
			grappleArm.y = mainBody.y;
			
			addChild(grappleArm);
		}
		
		public function WaitFrameToCreate(e:Event):void
		{
			MakeGrapArm();
			removeEventListener(Event.ENTER_FRAME, WaitFrameToCreate);
		}
		
		public function Explosion(x:Number, y:Number, radius:Number,
								  force:Number):void
		{
			var explosionPos:V2 = new V2(x, y);
			var body:b2Body;
			var bodyPos:V2;
			var distance:Number;
			
			var newAABB:AABB = new AABB(new V2(x - radius, y - radius), new V2(x + radius, y + radius));
			
			mainBody.world.b2world.QueryAABB(
				function(fixture:b2Fixture):Boolean
				{
					if (!fixture.m_body.IsStatic() && (fixture.m_body != body))
					{
						body = fixture.m_body;
						bodyPos = body.GetWorldCenter();
						distance = explosionPos.distance(bodyPos);
						if (distance < radius)
							body.ApplyImpulse(bodyPos.subtract(explosionPos).multiplyN((radius - distance) * force), body.GetWorldCenter());
					}
					
					return true;
				}, newAABB);
		}
	}
}