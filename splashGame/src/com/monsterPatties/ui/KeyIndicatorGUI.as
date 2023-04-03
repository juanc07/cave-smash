package com.monsterPatties.ui 
{
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author jc
	 */
	public class KeyIndicatorGUI extends Sprite
	{
		private var _mc:KeyIndicatorMC;
		private var _xpos:Number = 0;
		private var _ypos:Number = 0;
		
		public function KeyIndicatorGUI( xpos:Number , ypos:Number ) 
		{
			_xpos = xpos;
			_ypos = ypos;
			addEventListener( Event.ADDED_TO_STAGE, init );
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener( Event.REMOVED_FROM_STAGE, destroy );
			setDisplay();
		}
		
		private function destroy(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			removeDisplay();
		}
		
		
		private function setDisplay():void 
		{
			_mc = new KeyIndicatorMC();
			addChild( _mc );
			_mc.x = _xpos;
			_mc.y = _ypos;
			setKey();
		}
		
		private function removeDisplay():void 
		{
			if ( _mc != null ) {
				if ( this.contains( _mc ) ) {
					this.removeChild( _mc );
					_mc = null;
				}
			}
		}
		
		public function setKey( val:Boolean = false ):void 
		{
			if ( val  ) {
				_mc.gotoAndStop( 2 );
			}else {
				_mc.gotoAndStop( 1 );
			}
		}
		
	}

}