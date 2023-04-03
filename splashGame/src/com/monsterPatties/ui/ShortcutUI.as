package com.monsterPatties.ui 
{
	import com.monsterPatties.events.CaveSmashEvent;
	import com.monsterPatties.events.GameEvent;
	import com.monsterPatties.utils.buttonManager.ButtonManager;
	import com.monsterPatties.utils.buttonManager.events.ButtonEvent;
	import com.monsterPatties.utils.displayManager.config.DisplayManagerConfig;
	import com.monsterPatties.utils.displayManager.DisplayManager;
	import com.monsterPatties.utils.eventSatellite.EventSatellite;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author jc
	 */
	public class ShortcutUI extends Sprite
	{		
		private var _mc:ShortcutMC;
		private var _bm:ButtonManager;
		private var _xpos:Number;
		private var _ypos:Number;
		
		private var _gameEvent:GameEvent;
		private var _es:EventSatellite;
		private var _caveSmashEvent:CaveSmashEvent;
		
		private var _dm:DisplayManager;
		
		public function ShortcutUI(xpos:Number, ypos:Number) {
			this._xpos = xpos;
			this._ypos = ypos;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
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
		
		private function setDisplay():void {
			_dm = DisplayManager.getInstance();
			_es =EventSatellite.getInstance();
			
			_mc = new ShortcutMC();
			addChild(_mc);
			_mc.scaleX = 0.7;
			_mc.scaleY = 0.7;
			
			_mc.x = _xpos;
			_mc.y = _ypos;
			
			_bm = new ButtonManager();			
			_bm.addBtnListener( _mc.pauseBtn );
			_bm.addBtnListener( _mc.muteBtn );
			_bm.addBtnListener( _mc.settingBtn );
			_bm.addBtnListener( _mc.shopBtn );
			_bm.addBtnListener( _mc.mapBtn );
			_bm.addEventListener( ButtonEvent.CLICK_BUTTON, onClickBtn );
			_bm.addEventListener( ButtonEvent.ROLL_OVER_BUTTON, onRollOverBtn );
			_bm.addEventListener( ButtonEvent.ROLL_OUT_BUTTON, onRollOutBtn );
		}
		
		private function removeDisplay():void{
			if (_mc != null) {				
				_bm.removeBtnListener( _mc.pauseBtn );
				_bm.removeBtnListener( _mc.muteBtn );
				_bm.removeBtnListener( _mc.settingBtn );
				_bm.removeBtnListener( _mc.shopBtn );
				_bm.removeBtnListener( _mc.mapBtn );
				_bm.removeEventListener( ButtonEvent.CLICK_BUTTON, onClickBtn );
				_bm.removeEventListener( ButtonEvent.ROLL_OVER_BUTTON, onRollOverBtn );
				_bm.removeEventListener( ButtonEvent.ROLL_OUT_BUTTON, onRollOutBtn );
				_bm.clearButtons();
				_bm = null;	
				
				if (this.contains(_mc)) {
					this.removeChild(_mc);
					_mc = null;					
				}
			}
		}
		
		private function onClickBtn(e:ButtonEvent):void{			
			var btnName:String = e.obj.name;
			
			switch ( btnName ) 
			{                  
				case "pauseBtn":
					_gameEvent = new GameEvent(GameEvent.PAUSE_BTN_CLICK);
					_es.dispatchESEvent(_gameEvent);
					trace("pauseBtn click!!");
				break;
				
				case "muteBtn":
					_gameEvent = new GameEvent(GameEvent.MUTE_BTN_CLICK);
					_es.dispatchESEvent(_gameEvent);
					trace("muteBtn click!!");
				break;
				
				case "settingBtn":
					_gameEvent = new GameEvent(GameEvent.SETTING_BTN_CLICK);
					_es.dispatchESEvent(_gameEvent);
					trace("settingBtn click!!");
				break;
				
				case "shopBtn":
					_gameEvent = new GameEvent(GameEvent.SHOP_BTN_CLICK);
					_es.dispatchESEvent(_gameEvent);
					trace("shopBtn click!!");
				break;
				
				case "mapBtn":
					_dm.loadScreen( DisplayManagerConfig.MAP_SCREEN );
					_caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.LEVEL_QUIT );
					_es.dispatchESEvent( _caveSmashEvent );
				break;
				
				default:
				break;
			}
		}
		
		private function onRollOutBtn(e:ButtonEvent):void 
		{
			var btnName:String = e.obj.name;
			
			switch ( btnName ) 
			{				
				case "pauseBtn":					
				break;			
				
				default:
				break;
			}
		}
		
		private function onRollOverBtn(e:ButtonEvent):void 
		{
			var btnName:String = e.obj.name;
			
			switch ( btnName ) 
			{			
				case "pauseBtn":					
				break;
				
				default:
				break;
			}
		}
		
	}

}