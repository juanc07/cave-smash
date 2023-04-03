package components.effects {

	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	import misc.*;
	
	public class Effects extends MovieClip {
		
		public var onDone:Function = null;
		
		public function Effects() {
			mouseEnabled = false;
			mouseChildren = false;
			addEventListener(Event.ENTER_FRAME, checkDone);
		}
		
		public function checkDone(e:Event):void {
			if(isDone()) {
				Util.remove(this);
				removeEventListener(Event.ENTER_FRAME, checkDone);
				dispatchEvent( new Event( Event.COMPLETE ) );
				if(onDone != null){
					onDone();
				}
			}
		}
		
		public function isDone():Boolean {
			return (currentFrame == totalFrames);
		}
	}
}