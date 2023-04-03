package com.OurWCKObjs
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class L5Splat extends MovieClip
	{
		public function L5Splat()
		{
			super();
			
			addEventListener(Event.ENTER_FRAME, checkForEnd);
		}
		
		public function checkForEnd(e:Event):void
		{
			if (this.currentFrameLabel == "ended")
			{
				this.parent.removeChild(this);
				removeEventListener(Event.ENTER_FRAME, checkForEnd);
			}
		}
	}
}