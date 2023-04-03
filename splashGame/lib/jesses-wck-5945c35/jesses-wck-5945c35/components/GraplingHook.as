package components 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	/**
	 * ...
	 * @author ...
	 */
	public class GraplingHook extends MovieClip
	{
		
		private var _mc:GraplingMC;
		
		public function GraplingHook() 
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
			_mc = new GraplingMC();
			addChild( _mc );
		}
		
	}

}