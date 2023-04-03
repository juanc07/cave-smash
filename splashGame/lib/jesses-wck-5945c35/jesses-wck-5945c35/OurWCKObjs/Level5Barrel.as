package com.OurWCKObjs
{
	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.StepEvent;
	
	import flash.events.Event;
	
	import shapes.Box;
	
	public class Level5Barrel extends Box
	{
		
		public var startX:Number;
		
		public var needReset:Boolean = false;
		
		public function Level5Barrel()
		{
			super();
		}
		
		public override function create():void
		{
			reportBeginContact = true;
			reportEndContact = true;
			
			super.create();
			
			listenWhileVisible(world, StepEvent.STEP, ResetCheck, false, 10);
			
			startX = b2body.GetPosition().x;
		}
		
		public function ResetCheck(e:Event):void
		{
			if (needReset)
			{
				var tempSplat:BioSplat = new BioSplat();
				tempSplat.x = this.b2body.m_userData.x;
				tempSplat.y = this.b2body.m_userData.y;
				world.addChild(tempSplat);
				b2body.SetTransform(new V2(startX, -7.0), 0);
				needReset = false;
			}
		}
		
	}
}
