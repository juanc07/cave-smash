package com.monsterPatties.ui 
{
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author jc
	 */
	public class LevelStat extends Sprite
	{
		/*----------------------------------Properties----------------------------------------------------*/
		private var _mc:LevelStatMC;
		private var _crystal:int;
		/*----------------------------------Constants----------------------------------------------------*/
		/*----------------------------------Constructor----------------------------------------------------*/
		public function LevelStat(crystal:int){
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);			
			this._crystal = crystal;
		}
		
		
		/*----------------------------------Methods----------------------------------------------------*/
		private function setDisplay ():void{
			_mc = new LevelStatMC();
			addChild(_mc);
			_mc.hud.gotoAndStop(_crystal+1);
			_mc.alpha = 0;
			TweenLite.to(_mc, 0.5, {alpha:1});
		}
		
		private function removeDisplay():void {
			if (_mc != null) {
				TweenLite.killTweensOf(_mc);
				if (this.contains(_mc)) {
					this.removeChild(_mc);
					_mc = null;
				}
			}			
		}
		/*----------------------------------Setters----------------------------------------------------*/
		/*----------------------------------Getters----------------------------------------------------*/
		
		
		/*----------------------------------Events----------------------------------------------------*/
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onDestroy);
			setDisplay();
		}
		
		private function onDestroy(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onDestroy);
			removeDisplay();
		}
		
	}

}