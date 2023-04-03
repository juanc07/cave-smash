package com.monsterPatties.ui 
{
	import com.monsterPatties.events.GameEvent;
	import com.monsterPatties.utils.buttonManager.ButtonManager;
	import com.monsterPatties.utils.buttonManager.events.ButtonEvent;
	import com.monsterPatties.utils.eventSatellite.EventSatellite;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author jc
	 */
	public class NavigationUI extends Sprite
	{		
		private var _mc:NavigationMC;
		private var _bm:ButtonManager;
		private var _xpos:Number;
		private var _ypos:Number;
		
		private var _gameEvent:GameEvent;
		private var _es:EventSatellite;
		
		public function NavigationUI(xpos:Number, ypos:Number){
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
			_es = EventSatellite.getInstance();
			
			_mc = new NavigationMC();
			addChild(_mc);
			//_mc.scaleX = 0.7;
			//_mc.scaleY = 0.7;
			
			_mc.x = _xpos;
			_mc.y = _ypos;
			
			_bm = new ButtonManager();			
			_bm.addBtnListener( _mc.homeBtn );
			_bm.addBtnListener( _mc.helpBtn );			
			_bm.addEventListener( ButtonEvent.CLICK_BUTTON, onClickBtn );
			_bm.addEventListener( ButtonEvent.ROLL_OVER_BUTTON, onRollOverBtn );
			_bm.addEventListener( ButtonEvent.ROLL_OUT_BUTTON, onRollOutBtn );
		}
		
		private function removeDisplay():void{
			if (_mc != null) {
				_bm.removeBtnListener( _mc.homeBtn );
				_bm.removeBtnListener( _mc.helpBtn );				
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
				case "homeBtn":
					_gameEvent = new GameEvent(GameEvent.HOME_BTN_CLICK);
					_es.dispatchESEvent(_gameEvent);
					trace("homeBtn click!!");
				break;
				
				case "helpBtn":
					_gameEvent = new GameEvent(GameEvent.HELP_BTN_CLICK);
					_es.dispatchESEvent(_gameEvent);
					trace("helpBtn click!!");
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
				case "homeBtn":					
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
				case "homeBtn":					
				break;
				
				default:
				break;
			}
		}
		
	}

}