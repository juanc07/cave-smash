package com.OurWCKObjs
{
	import Box2DAS.Collision.AABB;
	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.b2Body;
	import Box2DAS.Dynamics.b2Fixture;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class ExplosionClip extends MovieClip
	{
		public var anim:MovieClip;
		public var sense:ExplosionSensor;
		
		public function ExplosionClip()
		{
			super();
			
			addEventListener(Event.ENTER_FRAME, MonitorAnim);
		}
		
		public function MonitorAnim(e:Event):void
		{
			if (anim.currentFrameLabel == "ended")
			{
				var tempPos:V2 = sense.b2body.GetPosition();
				Explosion(tempPos.x, tempPos.y, 4, 6);
				removeEventListener(Event.ENTER_FRAME, MonitorAnim);
				this.parent.removeChild(this);
			}
		}
		
		public function Explosion(x:Number, y:Number, radius:Number,
								  force:Number):void
		{
			var explosionPos:V2 = new V2(x, y);
			var body:b2Body;
			var bodyPos:V2;
			var distance:Number;
			
			var newAABB:AABB = new AABB(new V2(x - radius, y - radius), new V2(x + radius, y + radius));
			
			sense.world.b2world.QueryAABB(
				function(fixture:b2Fixture):Boolean
				{
					if (!fixture.m_body.IsStatic() && (fixture.m_body != body))
					{

						body = fixture.m_body;
						
						if (body.m_userData is HeroBody)
						{
							
						}
						else
						{
						
						bodyPos = body.GetWorldCenter();
						distance = explosionPos.distance(bodyPos);
						if (distance < radius)
							body.ApplyImpulse(bodyPos.subtract(explosionPos).multiplyN((radius - distance) * force), body.GetWorldCenter());
						}
					}
					
					return true;
				}, newAABB);
		}
	}
}