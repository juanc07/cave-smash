package components 
{
	import Box2DAS.Dynamics.StepEvent;
	import flash.display.MovieClip;
	import flash.events.Event;
	import shapes.Circle;
	/**
	 * ...
	 * @author ...
	 */
	public class RotCircle extends MovieClip
	{
		
		public var lastAngle:Number = 0;
		
		override public function create():void 
		{
			super.create();
			listenWhileVisible(bodyPivot.world, StepEvent.STEP, WorldStep, false, 10);
		}
		
		private function WorldStep( e:Event ):void 
		{
			var dx:Number = mouseX - bodyPivot.pivotJoint.b2joint.m_userData.x;
			var dy:Number = mouseY - bodyPivot.pivotJoint.b2joint.m_userData.y;
			
			var angle:Number = Math.atan2(dy, dx);
			
			if (hook.type == 'Static')
			{
				bodyPivot.b2body.SetTransform(bodyPivot.b2body.m_xf.position.v2, lastAngle);
			}
			else
			{
				bodyPivot.b2body.SetTransform(bodyPivot.b2body.m_xf.position.v2, angle);
				lastAngle = angle;
			}
		}
		
	}

}