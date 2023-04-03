package OurWCKObjs
{
	import Box2DAS.Collision.AABB;
	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.StepEvent;
	import Box2DAS.Dynamics.b2Body;
	import Box2DAS.Dynamics.b2Fixture;
	
	import com.OverlayStuff.DialoguePopUp;
	import com.greensock.TweenMax;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import shapes.Box;
	
	public class L5Boss extends Box
	{
		public var anim:MovieClip;
		
		public var whenToSummonTimer:Timer = new Timer(3000);
		
		public var canCast:Boolean = false;
		
		public function L5Boss()
		{
			super();
			whenToSummonTimer.addEventListener(TimerEvent.TIMER, timeListen);
		}
		
		public override function create():void
		{
			//whenToSummonTimer.start();
			
			type = 'Static';
			isSensor = true;
			super.create();
			listenWhileVisible(world, StepEvent.STEP, DoStuff, false, 10);
		}
		
		public function DoStuff(e:Event):void
		{
			if (!this._active) return;
			
			if (canCast)
			{
				var heroX:Number = 
					(world.getChildByName("Hero") as HeroContainer).mainBody.b2body.GetPosition().x;
								
				Explosion(-6.5, -4.5, 2, Math.abs(heroX + 5.0) / 2.0);
				Explosion(6.5, -4.5, 2, Math.abs(heroX - 5.0) / 2.0);
				
				canCast = false;
			}
		}
		
		public function timeListen(e:TimerEvent):void
		{
			canCast = true;
			whenToSummonTimer.delay = (12 - L5CP.deathCount) * 80 + 700;
			
			if (L5CP.deathCount == 12)
			{
				whenToSummonTimer.removeEventListener(TimerEvent.TIMER, timeListen);
				DoDeathStuff();
			}
		}
		
		public function DoDeathStuff():void
		{
			anim.gotoAndStop(2);
			
			TweenMax.to(this, 1.5, {x:x, onComplete:Trigger})
			
		}
		
		public function AddBossDrop():void
		{
			var bossDrop:PsychPick = new PsychPick();
			
			bossDrop.x = 0;
			bossDrop.y = -10;
			
			world.addChild(bossDrop);
		}
			
			
		
		public function Trigger():void
		{
			DialoguePopUp(this.parent.parent.parent["diag"]).TweenIn("BeatBoss");
		}
		
		public function Explosion(x:Number, y:Number, radius:Number,
								  force:Number):void
		{
			var explosionPos:V2 = new V2(x, y);
			var body:b2Body;
			var bodyPos:V2;
			var distance:Number;
			
			var newAABB:AABB = new AABB(new V2(x - radius, y - radius), new V2(x + radius, y + radius));
			
			world.b2world.QueryAABB(
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