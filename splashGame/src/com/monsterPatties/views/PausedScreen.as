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
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author jc
	 */
	public class PausedScreen extends Window
	{
		/*----------------------------------------------------------Constant---------------------------------------------------------------*/
		
		/*----------------------------------------------------------Properties---------------------------------------------------------------*/
		private var _mc:PausedWindowMC;
		private var _bm:ButtonManager;
		private var _dm:DisplayManager;
		private var _gameEvent:GameEvent;
		private var _es:EventSatellite;
		private var _caveSmashevent:CaveSmashEvent;
		private var caveSmashEvent:CaveSmashEvent;
		private var _cover:Sprite;		
		private var _gdc:GameDataController;
		
		/*----------------------------------------------------------Constructor---------------------------------------------------------------*/
		public function PausedScreen(windowName:String, winWidth:Number = 0, winHeight:Number = 0, hideWindowName:Boolean = false)
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
				
				
				_mc = new PausedWindowMC();
				addChild(_mc);
				
				_mc.x = stage.stageWidth * 0.5; 
				_mc.y = stage.stageHeight * 0.5; 
				
				_mc.scaleX = 0;
				_mc.scaleY = 0;
				
				/*_mc.resumeBtn.addEventListener(MouseEvent.CLICK, onClickResumeBtn);
				_mc.retryBtn.addEventListener(MouseEvent.CLICK, onClickRetryBtn);
				_mc.shopBtn.addEventListener(MouseEvent.CLICK, onClickShopBtn);
				_mc.levelSelectBtn.addEventListener(MouseEvent.CLICK, onClickLevelSelectBtn);
				_mc.quitBtn.addEventListener(MouseEvent.CLICK, onClickQuitBtn);
				*/				
				
				_bm = new ButtonManager();
				_bm.addBtnListener(_mc.resumeBtn);
				_bm.addBtnListener(_mc.shopBtn);
				_bm.addBtnListener(_mc.retryBtn);
				_bm.addBtnListener(_mc.levelSelectBtn);
				_bm.addBtnListener(_mc.quitBtn);
				_bm.addEventListener(ButtonEvent.CLICK_BUTTON, onClickBtn);
				
				TweenLite.to( _mc ,0.85, { scaleX:1, scaleY:1,ease:Elastic.easeOut,onComplete:callPaused} );
				//TweenLite.delayedCall( 0.1, callPaused );
			}
		}		
		
		private function callPaused():void 
		{
			TweenLite.killDelayedCallsTo( callPaused );
			_gameEvent = new GameEvent( GameEvent.GAME_PAUSED );
			_es.dispatchESEvent( _gameEvent );			
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
			if (_mc != null)
			{
				TweenLite.killTweensOf( _mc );
				removeCover();
				
				/*
				_mc.resumeBtn.removeEventListener(MouseEvent.CLICK, onClickResumeBtn);
				_mc.retryBtn.removeEventListener(MouseEvent.CLICK, onClickRetryBtn);
				_mc.shopBtn.removeEventListener(MouseEvent.CLICK, onClickShopBtn);
				_mc.levelSelectBtn.removeEventListener(MouseEvent.CLICK, onClickLevelSelectBtn);
				_mc.quitBtn.removeEventListener(MouseEvent.CLICK, onClickQuitBtn);				
				*/				
				
				_bm.removeBtnListener(_mc.resumeBtn);
				_bm.removeBtnListener(_mc.shopBtn);
				_bm.removeBtnListener(_mc.retryBtn);
				_bm.removeBtnListener(_mc.levelSelectBtn);
				_bm.removeBtnListener(_mc.quitBtn);
				_bm.removeEventListener(ButtonEvent.CLICK_BUTTON, onClickBtn);				
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
			
		
		/*
		private function onClickQuitBtn(e:MouseEvent):void{
			playClickSfx();
			setupLock();
			
			caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.LEVEL_QUIT );
			_es.dispatchESEvent( caveSmashEvent );
			
			_gameEvent = new GameEvent(GameEvent.GAME_UNPAUSED);
			_es.dispatchESEvent(_gameEvent);
			_dm.removeSubScreen(DisplayManagerConfig.PAUSED_SCREEN);
			_dm.loadScreen( DisplayManagerConfig.TITLE_SCREEN ); 
		}
		
		private function onClickLevelSelectBtn(e:MouseEvent):void{
			playClickSfx();
			setupLock();
			
			caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.LEVEL_QUIT );
			_es.dispatchESEvent( caveSmashEvent );
			
			_gameEvent = new GameEvent(GameEvent.GAME_UNPAUSED);
			_es.dispatchESEvent(_gameEvent);
			_dm.removeSubScreen(DisplayManagerConfig.PAUSED_SCREEN);
			//_dm.loadScreen( DisplayManagerConfig.LEVEL_SELECTION_SCREEN ); 
			_dm.loadScreen( DisplayManagerConfig.MAP_SCREEN ); 
		}
		
		private function onClickShopBtn(e:MouseEvent):void{
			playClickSfx();
			setupLock();
			
			caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.LEVEL_QUIT );
			_es.dispatchESEvent( caveSmashEvent );
			
			_gameEvent = new GameEvent(GameEvent.GAME_UNPAUSED);
			_es.dispatchESEvent(_gameEvent);
			_dm.removeSubScreen(DisplayManagerConfig.PAUSED_SCREEN);
			_gdc.setIsGoingToShop(true);
			_dm.loadScreen( DisplayManagerConfig.GAME_SCREEN );
		}
		
		private function onClickRetryBtn(e:MouseEvent):void{
			playClickSfx();
			setupLock();
			
			_dm.removeSubScreen(DisplayManagerConfig.PAUSED_SCREEN);
					
			_gameEvent = new GameEvent(GameEvent.GAME_UNPAUSED);
			_es.dispatchESEvent(_gameEvent);
			
			_caveSmashevent = new CaveSmashEvent( CaveSmashEvent.RELOAD_LEVEL );
			_es.dispatchESEvent( _caveSmashevent );
		}
		
		private function onClickResumeBtn(e:MouseEvent):void {
			playClickSfx();
			setupLock();
			_gameEvent = new GameEvent(GameEvent.GAME_UNPAUSED);
			_es.dispatchESEvent(_gameEvent);
			_dm.removeSubScreen(DisplayManagerConfig.PAUSED_SCREEN);
		}
		
		private function playClickSfx():void{
			caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.PLAY_SFX );
			caveSmashEvent.obj.id = SoundConfig.CLICK_SFX;
			_es.dispatchESEvent( caveSmashEvent );
		}
		
		private function setupLock():void {
			removeCover();
			_gdc.setIsLockControlls( false );
		}
		*/
		
		
		private function onClickBtn(e:ButtonEvent):void
		{
			caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.PLAY_SFX );
			caveSmashEvent.obj.id = SoundConfig.CLICK_SFX;
			_es.dispatchESEvent( caveSmashEvent );
			
			var btnName:String = e.obj.name;
			removeCover();
			_gdc.setIsLockControlls( false );
			
			switch (btnName)
			{
				case "resumeBtn":
					_gameEvent = new GameEvent(GameEvent.GAME_UNPAUSED);
					_es.dispatchESEvent(_gameEvent);
					_dm.removeSubScreen(DisplayManagerConfig.PAUSED_SCREEN);
					break;
				
				case "shopBtn": 					
					caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.LEVEL_QUIT );
					_es.dispatchESEvent( caveSmashEvent );
					
					_gameEvent = new GameEvent(GameEvent.GAME_UNPAUSED);
					_es.dispatchESEvent(_gameEvent);
					_dm.removeSubScreen(DisplayManagerConfig.PAUSED_SCREEN);
					_gdc.setIsGoingToShop(true);
					_dm.loadScreen( DisplayManagerConfig.GAME_SCREEN );
					break;
				
				case "retryBtn":
					_dm.removeSubScreen(DisplayManagerConfig.PAUSED_SCREEN);
					
					_gameEvent = new GameEvent(GameEvent.GAME_UNPAUSED);
					_es.dispatchESEvent(_gameEvent);
					
					_caveSmashevent = new CaveSmashEvent( CaveSmashEvent.RELOAD_LEVEL );
					_es.dispatchESEvent( _caveSmashevent );
					break;
				
				case "levelSelectBtn":
					caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.LEVEL_QUIT );
					_es.dispatchESEvent( caveSmashEvent );
					
					_gameEvent = new GameEvent(GameEvent.GAME_UNPAUSED);
					_es.dispatchESEvent(_gameEvent);
					_dm.removeSubScreen(DisplayManagerConfig.PAUSED_SCREEN);
					//_dm.loadScreen( DisplayManagerConfig.LEVEL_SELECTION_SCREEN ); 
					_dm.loadScreen( DisplayManagerConfig.MAP_SCREEN ); 
					break;
					
				case "quitBtn":
					caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.LEVEL_QUIT );
					_es.dispatchESEvent( caveSmashEvent );
					
					_gameEvent = new GameEvent(GameEvent.GAME_UNPAUSED);
					_es.dispatchESEvent(_gameEvent);
					_dm.removeSubScreen(DisplayManagerConfig.PAUSED_SCREEN);
					_dm.loadScreen( DisplayManagerConfig.TITLE_SCREEN ); 
					break;	
					
				default: 
					break;
			}
		}		
	}
}