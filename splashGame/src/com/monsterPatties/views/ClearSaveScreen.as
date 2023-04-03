package com.monsterPatties.views
{
	import com.greensock.TweenLite;
	import com.monsterPatties.config.SoundConfig;
	import com.monsterPatties.controllers.GameDataController;
	import com.monsterPatties.events.CaveSmashEvent;
	import com.monsterPatties.events.GameEvent;
	import com.monsterPatties.utils.buttonManager.ButtonManager;
	import com.monsterPatties.utils.buttonManager.events.ButtonEvent;
	import com.monsterPatties.utils.displayManager.config.DisplayManagerConfig;
	import com.monsterPatties.utils.displayManager.DisplayManager;
	import com.monsterPatties.utils.displayManager.Window;
	import com.monsterPatties.utils.eventSatellite.EventSatellite;
	import com.monsterPatties.utils.Helper;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author jc
	 */
	public class ClearSaveScreen extends Window
	{
		/*----------------------------------------------------------Constant---------------------------------------------------------------*/
		
		/*----------------------------------------------------------Properties---------------------------------------------------------------*/
		private var _mc:ClearSaveMC;
		private var _bm:ButtonManager;
		private var _dm:DisplayManager;
		private var _gameEvent:GameEvent;
		private var _es:EventSatellite;		
		
		private var _cover:Sprite;
		private var _gdc:GameDataController;
		private var _caveSmashEvent:CaveSmashEvent;
		/*----------------------------------------------------------Constructor---------------------------------------------------------------*/
		public function ClearSaveScreen(windowName:String, winWidth:Number = 0, winHeight:Number = 0, hideWindowName:Boolean = false)
		{
			super(windowName, winWidth, winHeight);
		}
		
		/*----------------------------------------------------------Methods---------------------------------------------------------------*/
		private function setDisplay():void
		{		
			if ( _mc == null ) {
				_es = EventSatellite.getInstance();
				_gdc = GameDataController.getInstance();			
				addCover();
				
				stage.focus = this;
				
				_mc = new ClearSaveMC();
				addChild(_mc);
				
				_mc.x = ( (stage.stageWidth * 0.5) - (_mc.width*0.5)) + 15; 
				_mc.y = (stage.stageHeight * 0.5) - (_mc.height * 0.5); 
				
				/*
				_mc.yesButton.addEventListener(MouseEvent.CLICK, onClickYesBtn);
				_mc.noButton.addEventListener(MouseEvent.CLICK, onClickNoBtn);
				*/
				
				
				_bm = new ButtonManager();
				//_bm.addBtnListener(_mc.closeBtn);				
				_bm.addBtnListener(_mc.yesBtn);
				_bm.addBtnListener(_mc.noBtn);
				_bm.addEventListener(ButtonEvent.CLICK_BUTTON, onClickBtn);
				_bm.addEventListener(ButtonEvent.ROLL_OVER_BUTTON, onRollOverBtn);
				_bm.addEventListener(ButtonEvent.ROLL_OUT_BUTTON, onRollOutBtn);				
			}
			
			_caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.PLAY_SFX );
			_caveSmashEvent.obj.id = SoundConfig.WARNING_SFX;
			_es.dispatchESEvent( _caveSmashEvent );
		}
		
		
		private function addCover():void 
		{
			if( _cover == null ){
				_cover = Helper.getCover();
				addChild( _cover );
				_cover.alpha = 0.5;
			}
		}
		
		private function removeCover():void 
		{
			if ( _cover != null ) {
				if ( this.contains( _cover ) ) {
					this.removeChild( _cover );
					_cover = null;
				}
			}
		}		
		
		private function removeDisplay():void
		{
			if (_mc != null){				
				removeCover();				
				
				/*
				_mc.yesButton.removeEventListener(MouseEvent.CLICK, onClickYesBtn);
				_mc.noButton.removeEventListener(MouseEvent.CLICK, onClickNoBtn);
				*/
				
				//_bm.removeBtnListener(_mc.closeBtn);
				_bm.removeBtnListener(_mc.yesBtn);
				_bm.removeBtnListener(_mc.noBtn);
				_bm.removeEventListener(ButtonEvent.CLICK_BUTTON, onClickBtn);
				_bm.removeEventListener(ButtonEvent.ROLL_OVER_BUTTON, onRollOverBtn);
				_bm.removeEventListener(ButtonEvent.ROLL_OUT_BUTTON, onRollOutBtn);
				_bm.clearButtons();
				_bm = null;
				
				if (this.contains(_mc))
				{
					this.removeChild(_mc);
					_mc = null;
				}
			}
		}
		
		override public function initWindow():void
		{
			super.initWindow();
			initControllers();
			setDisplay();
			trace(windowName + " init!!");
		}
		
		override public function clearWindow():void
		{
			super.clearWindow();
			removeDisplay();
			trace(windowName + " destroyed!!");
		}
		
		private function initControllers():void
		{
			_dm = DisplayManager.getInstance();
		}		
		
		/*----------------------------------------------------------Setters---------------------------------------------------------------*/
		
		/*----------------------------------------------------------Getters---------------------------------------------------------------*/
		
		/*----------------------------------------------------------EventHandlers---------------------------------------------------------------*/
		private function onRollOutBtn(e:ButtonEvent):void
		{
			var btnName:String = e.obj.name;
			
			switch (btnName)
			{
				//case "closeBtn": 					
					//_mc.closeBtn.gotoAndStop(1);
				//break;
				
				case "yesBtn": 					
					_mc.yesBtn.gotoAndStop(1);
				break;
				
				case "noBtn": 					
					_mc.noBtn.gotoAndStop(1);
				break;			
			}
		}
		
		private function onRollOverBtn(e:ButtonEvent):void
		{
			var btnName:String = e.obj.name;
			
			switch (btnName)
			{
				//case "closeBtn": 					
					//_mc.closeBtn.gotoAndStop(2);
				//break;
				
				case "yesBtn": 					
					_mc.yesBtn.gotoAndStop(2);
				break;
				
				case "noBtn": 					
					_mc.noBtn.gotoAndStop(2);
				break;				
			}
		}
		
		private function onClickBtn(e:ButtonEvent):void
		{
			_caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.PLAY_SFX );
			_caveSmashEvent.obj.id = SoundConfig.CLICK_SFX;
			_es.dispatchESEvent( _caveSmashEvent );
			
			var btnName:String = e.obj.name;			
			switch (btnName)
			{
				//case "closeBtn": 					
					//_mc.closeBtn.gotoAndStop(3);					
					//_dm.removeSubScreen(DisplayManagerConfig.CLEAR_SAVE_SCREEN);					
				//break;			
				
				
				case "yesBtn":
					_gdc.deleteData();
					_mc.yesBtn.gotoAndStop(3);
					_dm.removeSubScreen(DisplayManagerConfig.CLEAR_SAVE_SCREEN);
				break;
				
				case "noBtn": 					
					_mc.noBtn.gotoAndStop(3);
					_dm.removeSubScreen(DisplayManagerConfig.CLEAR_SAVE_SCREEN);
				break;				
			}
		}
		
		/*
		private function onClickNoBtn(e:MouseEvent):void 
		{
			_caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.PLAY_SFX );
			_caveSmashEvent.obj.id = SoundConfig.CLICK_SFX;
			_es.dispatchESEvent( _caveSmashEvent );
			
			_dm.removeSubScreen(DisplayManagerConfig.CLEAR_SAVE_SCREEN);			
		}
		
		private function onClickYesBtn(e:MouseEvent):void 
		{
			_caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.PLAY_SFX );
			_caveSmashEvent.obj.id = SoundConfig.CLICK_SFX;
			_es.dispatchESEvent( _caveSmashEvent );
			
			_gdc.deleteData();			
			_dm.removeSubScreen(DisplayManagerConfig.CLEAR_SAVE_SCREEN);
		}*/
	
	}

}