package com.monsterPatties.views
{
	import com.greensock.easing.Elastic;
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
	import flash.display.StageQuality;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author jc
	 */
	public class SettingScreen extends Window
	{
		/*----------------------------------------------------------Constant---------------------------------------------------------------*/
		
		/*----------------------------------------------------------Properties---------------------------------------------------------------*/
		private var _mc:SettingsWindowMC;
		private var _bm:ButtonManager;
		private var _dm:DisplayManager;
		private var _gameEvent:GameEvent;
		private var _es:EventSatellite;
		
		private var _isLow:Boolean = false;
		private var _isHigh:Boolean = true;
		private var _isMedium:Boolean = false;
		private var _cover:Sprite;
		private var _gdc:GameDataController;
		private var _caveSmashEvent:CaveSmashEvent;
		/*----------------------------------------------------------Constructor---------------------------------------------------------------*/
		public function SettingScreen(windowName:String, winWidth:Number = 0, winHeight:Number = 0, hideWindowName:Boolean = false)
		{
			super(windowName, winWidth, winHeight);
		}
		
		/*----------------------------------------------------------Methods---------------------------------------------------------------*/
		private function setDisplay():void
		{		
			if ( _mc == null ) {
				_es = EventSatellite.getInstance();
				_gdc = GameDataController.getInstance();
				_gdc.setIsLockControlls( true );
				
				addCover();
				
				stage.focus = this;
				
				_mc = new SettingsWindowMC();
				addChild(_mc);
				
				_mc.x = stage.stageWidth * 0.5; 
				_mc.y = stage.stageHeight * 0.5; 
				
				_mc.scaleX = 0;
				_mc.scaleY = 0;
				
				_mc.resumeBtn.addEventListener(MouseEvent.CLICK, onClickResumeBtn);
				_mc.resumeBtn.buttonMode = true;
				
				
				_bm = new ButtonManager();
				//_bm.addBtnListener(_mc.resumeBtn);
				_bm.addBtnListener(_mc.highBtn);
				_bm.addBtnListener(_mc.mediumBtn);
				_bm.addBtnListener(_mc.lowBtn);
				_bm.addEventListener(ButtonEvent.CLICK_BUTTON, onClickBtn);
				_bm.addEventListener(ButtonEvent.ROLL_OVER_BUTTON, onRollOverBtn);
				_bm.addEventListener(ButtonEvent.ROLL_OUT_BUTTON, onRollOutBtn);
				
				checkVideoSettings();			
				TweenLite.to( _mc ,0.85, { scaleX:1, scaleY:1,ease:Elastic.easeOut,onComplete:callPaused} );			
				//TweenLite.delayedCall( 0.1, callPaused );			
			}
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
		
		private function callPaused():void 
		{
			TweenLite.killDelayedCallsTo( callPaused );
			_gameEvent = new GameEvent( GameEvent.GAME_PAUSED );
			_es.dispatchESEvent( _gameEvent );			
		}
		
		private function removeDisplay():void
		{
			if (_mc != null)
			{
				TweenLite.killTweensOf( _mc );
				removeCover();
				//_bm.removeBtnListener(_mc.resumeBtn);
				_mc.resumeBtn.removeEventListener(MouseEvent.CLICK, onClickResumeBtn);
				_bm.removeBtnListener(_mc.highBtn);
				_bm.removeBtnListener(_mc.mediumBtn);
				_bm.removeBtnListener(_mc.lowBtn);
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
		
		private function checkVideoSettings():void 
		{
			if ( _isHigh ) {
				_mc.highBtn.gotoAndStop(2);
				_mc.mediumBtn.gotoAndStop(1);
				_mc.lowBtn.gotoAndStop(1);
			}else if ( _isMedium ) {
				_mc.highBtn.gotoAndStop(1);
				_mc.mediumBtn.gotoAndStop(2);
				_mc.lowBtn.gotoAndStop(1);
			}else{ 
				_mc.highBtn.gotoAndStop(1);
				_mc.mediumBtn.gotoAndStop(1);
				_mc.lowBtn.gotoAndStop(2);
			}
		}
		
		/*----------------------------------------------------------Setters---------------------------------------------------------------*/
		
		/*----------------------------------------------------------Getters---------------------------------------------------------------*/
		
		/*----------------------------------------------------------EventHandlers---------------------------------------------------------------*/
		private function onRollOutBtn(e:ButtonEvent):void
		{
			var btnName:String = e.obj.name;
			
			switch (btnName)
			{
				//case "resumeBtn": 
					//_mc.resumeBtn.gotoAndStop(1);
					//break;
				
				default: 
					break;
			}
		}
		
		private function onRollOverBtn(e:ButtonEvent):void
		{
			var btnName:String = e.obj.name;
			
			switch (btnName)
			{
				//case "resumeBtn": 
					//_mc.resumeBtn.gotoAndStop(2);
					//break;
				
				default: 
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
				/*case "resumeBtn": 
					_gdc.setIsLockControlls( false );
					_mc.resumeBtn.gotoAndStop(3);
					removeCover();
					_dm.removeSubScreen(DisplayManagerConfig.SETTING_SCREEN);
					_gameEvent = new GameEvent(GameEvent.GAME_UNPAUSED);					
					_es.dispatchESEvent(_gameEvent);
					break;*/
				
				case "highBtn": 
					if ( !_isHigh ) {
						_isHigh = true;
						_isMedium = false;
						_isLow = false;
						stage.quality = StageQuality.HIGH;
					}else {
						_isHigh = false;						
					}
					checkVideoSettings();
					break;
				
				case "mediumBtn": 
					if (!_isMedium){						
						stage.quality = StageQuality.MEDIUM;
						_isMedium = true;
						_isHigh = false;
						_isLow = false;
					}else{						
						_isMedium = false;
					}
					checkVideoSettings();
					break;
				
				case "lowBtn": 
					if (!_isLow){						
						stage.quality = StageQuality.LOW;
						_isLow = true;
						_isMedium = false;
						_isHigh = false;						
					}else{						
						_isLow = false;
					}
					checkVideoSettings();
					break;
				
				default: 
					break;
			}
		}
		
		private function onClickResumeBtn(e:MouseEvent):void{
			_caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.PLAY_SFX );
			_caveSmashEvent.obj.id = SoundConfig.CLICK_SFX;
			_es.dispatchESEvent( _caveSmashEvent );
			
			
			_gdc.setIsLockControlls( false );
			//_mc.resumeBtn.gotoAndStop(3);
			removeCover();
			_dm.removeSubScreen(DisplayManagerConfig.SETTING_SCREEN);
			_gameEvent = new GameEvent(GameEvent.GAME_UNPAUSED);					
			_es.dispatchESEvent(_gameEvent);
		}
	
	}

}