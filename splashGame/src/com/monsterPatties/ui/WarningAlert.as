package com.monsterPatties.ui 
{
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author jc
	 */
	public class WarningAlert extends Sprite
	{
		/*-------------------------------------------------Properties-------------------------------------------------*/
		private var _mc:WarningAlertMC;
		private var _id:int;
		
		/*-------------------------------------------------Constructor-------------------------------------------------*/
		
		public function WarningAlert() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		/*-------------------------------------------------EventHandlers-------------------------------------------------*/
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onDestroy);
			setDisplay();
		}
		
		private function onDestroy(e:Event):void{
			removeEventListener(Event.REMOVED_FROM_STAGE, onDestroy);
			removeDisplay();
		}
		
		/*-------------------------------------------------Methods-------------------------------------------------*/
		
		private function setDisplay():void{
			_mc = new WarningAlertMC();
			addChild(_mc);
		}
		
		private function removeDisplay():void{
			if (_mc != null) {
				if (this.contains(_mc)) {
					this.removeChild(_mc);
					_mc = null;
				}
			}
		}		
		
		
		/*-------------------------------------------------Getters-------------------------------------------------*/
		public function get id():int 
		{
			return _id;
		}
		
		/*-------------------------------------------------Setters-------------------------------------------------*/
		public function set id(value:int):void 
		{
			_id = value;
		}
	}

}