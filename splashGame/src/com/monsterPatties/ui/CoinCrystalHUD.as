package com.monsterPatties.ui 
{
	import com.monsterPatties.controllers.GameDataController;
	import com.monsterPatties.events.CaveSmashEvent;
	import com.monsterPatties.utils.eventSatellite.EventSatellite;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author jc
	 */
	public class CoinCrystalHUD extends Sprite
	{
		private var _mc:CoinCrystalHUDMC;
		private  var _gdc:GameDataController;
		private var _es:EventSatellite;
		
		public function CoinCrystalHUD(){
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onDestroy);
			setDisplay();
		}
		
		private function onDestroy(e:Event):void{
			removeEventListener(Event.REMOVED_FROM_STAGE, onDestroy);
			removeDisplay();
		}		
		
		private function setDisplay():void {
			_es = EventSatellite.getInstance();
			_es.addEventListener(CaveSmashEvent.ON_BUY_ITEM, onBuyItem);
			_gdc = GameDataController.getInstance();
			_mc = new CoinCrystalHUDMC();
			addChild(_mc);
			
			updateCoinCystal();
		}
		
		private function updateCoinCystal():void{
			_mc.txtCoin.text = _gdc.getTotalGold().toString();
			_mc.txtCrystal.text = _gdc.getTotalCollectedCrystal().toString();
		}
		
		private function onBuyItem(e:CaveSmashEvent):void{
			updateCoinCystal();
		}
		
		private function removeDisplay():void{
			if (_mc != null) {
				_es.removeEventListener(CaveSmashEvent.ON_BUY_ITEM, onBuyItem);
				if (this.contains(_mc)) {
					this.removeChild(_mc);
					_mc = null;
				}
			}
		}
		
	}

}