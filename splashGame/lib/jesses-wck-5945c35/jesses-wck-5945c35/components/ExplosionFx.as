package components 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	/**
	 * ...
	 * @author ...
	 */
	public class ExplosionFx extends MovieClip
	{
		
		private var _mc:ExplosionMC;
		
		public function ExplosionFx() 
		{
			addEventListener( Event.ADDED_TO_STAGE, init );
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			setDisplay();
		}
		
		private function setDisplay():void 
		{
			_mc = new ExplosionMC();
			addChild( _mc );
			_mc.addFrameScript( _mc.totalFrames - 2, removeDisplay );
		}
		
		private function removeDisplay():void 
		{
			if ( _mc != null ) {
				if ( this.contains( _mc ) ){
					this.removeChild( _mc );
					_mc = null;					
				}
			}
		}
		
	}

}