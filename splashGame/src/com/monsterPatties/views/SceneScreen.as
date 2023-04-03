package com.monsterPatties.views
{
	import com.monsterPatties.controllers.GameDataController;
	import com.monsterPatties.events.GameEvent;
	import com.monsterPatties.ui.SoundGUI;
	import com.monsterPatties.utils.buttonManager.ButtonManager;
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
	public class SceneScreen extends Window
	{
		/*----------------------------------------------------------Constant---------------------------------------------------------------*/
		
		/*----------------------------------------------------------Properties---------------------------------------------------------------*/
		private var _mc:*;
		private var _bm:ButtonManager;
		private var _dm:DisplayManager;
		private var _gameEvent:GameEvent;
		private var _es:EventSatellite;
		
		private var _cover:Sprite;
		private var _gdc:GameDataController;
		private var scenes:Vector.<int>;
		private var len:int;
		
		private var _bgmSfxGUI:SoundGUI;
		/*----------------------------------------------------------Constructor---------------------------------------------------------------*/
		public function SceneScreen(windowName:String, winWidth:Number = 0, winHeight:Number = 0, hideWindowName:Boolean = false)
		{
			super(windowName, winWidth, winHeight);
		}
		
		/*----------------------------------------------------------Methods---------------------------------------------------------------*/
		private function setDisplay():void
		{
			if ( _mc == null ){
				_es = EventSatellite.getInstance();
				_gdc = GameDataController.getInstance();
				_gdc.setIsLockControlls( true );
				
				addCover();
				
				stage.focus = this;
				
				scenes =  _gdc.getCompletedScene();
				len = scenes.length;
				
				if ( len == 0 ) {
					_mc = new introMC();
					addChild(_mc);
					_mc.x = -0.4;
					_mc.y= 5.85;
					_gdc.updateCompletedScene(1);
					_gdc.setIsScenePlaying(true);
				}else if (len == 1 && _gdc.getCurrLevel() == 15) {
					trace("show bossscene1 please fuck!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
					_mc = new BossScene1();
					addChild(_mc);
					_mc.x = 4.8;
					_mc.y= -3.9;
					_gdc.updateCompletedScene(2);
					_gdc.setIsScenePlaying(true);
				}else if(len == 2 && _gdc.getCurrLevel() == 30){
					_mc = new BossScene2();
					addChild(_mc);
					_mc.x = 1.55;
					_mc.y= 2.95;
					_gdc.updateCompletedScene(3);
					_gdc.setIsScenePlaying(true);
				}else if(len == 3 && _gdc.getCurrLevel() == 45){
					_mc = new BossScene3();
					addChild(_mc);
					_mc.x = 0.4;
					_mc.y= 2;
					_gdc.updateCompletedScene(4);
					_gdc.setIsScenePlaying(true);
				}else if (len == 4 && _gdc.getCurrLevel() == 46 ) {
					_mc = new SceneEnding();
					addChild(_mc);
					_mc.x = 3.1;
					_mc.y= 5.35;
					_gdc.updateCompletedScene(5);
					_gdc.setIsScenePlaying(true);
					//load ending scene here!!!
					trace("play ending scene now!!!!!!!!!!!!!!!!");
				}
				
				_mc.addEventListener(MouseEvent.CLICK, onClickScene);
				_mc.addFrameScript( _mc.totalFrames - 2, skip );
				
				//_gameEvent = new GameEvent( GameEvent.GAME_PAUSED );
				//_es.dispatchESEvent( _gameEvent );
				addBgmSfxUI(len);
			}
		}
		
		private function onClickScene(e:MouseEvent):void{
			skip();
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
				//_bm.removeBtnListener(_mc.resumeBtn);
				//_bm.removeEventListener(ButtonEvent.CLICK_BUTTON, onClickBtn);
				//_bm.removeEventListener(ButtonEvent.ROLL_OVER_BUTTON, onRollOverBtn);
				//_bm.removeEventListener(ButtonEvent.ROLL_OUT_BUTTON, onRollOutBtn);
				//_bm.clearButtons();
				//_bm = null;
				
				if (this.contains(_mc)) {
					_mc.removeEventListener(MouseEvent.CLICK, onClickScene);
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
		
		
		private function skip():void {
			_mc.addFrameScript( _mc.totalFrames - 2, null );
			_gdc.setIsLockControlls( false );
			removeCover();
			_dm.removeSubScreen(DisplayManagerConfig.SCENE_SCREEN);
			_gdc.setIsScenePlaying(false);
			//_gameEvent = new GameEvent(GameEvent.GAME_UNPAUSED);
			//_es.dispatchESEvent(_gameEvent);
			
			if ( len == 0 ) {
				_bgmSfxGUI.playSceneBGM( 6 );
				_dm.loadScreen( DisplayManagerConfig.MAP_SCREEN );
			}else if (len == 1 && _gdc.getCurrLevel() == 15) {
				_dm.loadScreen( DisplayManagerConfig.GAME_SCREEN );
			}else if (len == 2 && _gdc.getCurrLevel() == 30) {
				_dm.loadScreen( DisplayManagerConfig.GAME_SCREEN );
			}else if (len == 3 && _gdc.getCurrLevel() == 45) {
				_dm.loadScreen( DisplayManagerConfig.GAME_SCREEN );
			}else if (len == 4 && _gdc.getCurrLevel() == 46) {
				//after playing ending scene				
				_gdc.setLevel(45);
				_gdc.setCurrLevel(45);
				
				_bgmSfxGUI.playSceneBGM( 6 );
				_dm.loadScreen( DisplayManagerConfig.TITLE_SCREEN );
			}else {
				_bgmSfxGUI.playSceneBGM( 6 );
				_dm.loadScreen( DisplayManagerConfig.MAP_SCREEN );
			}
		}
		
		private function addBgmSfxUI(scene:int):void
		{
			_bgmSfxGUI = SoundGUI.getIntance();
			_bgmSfxGUI.setXYPos( 496, 8 );
			_bgmSfxGUI.init();
			addChild( _bgmSfxGUI );
			_bgmSfxGUI.visible = false;
			_bgmSfxGUI.playSceneBGM( scene );
		}
		
		private function removeBgmSfxUI():void
		{
			if ( _bgmSfxGUI != null ) {
				if ( this.contains( _bgmSfxGUI ) ) {
					this.removeChild( _bgmSfxGUI )
					_bgmSfxGUI.destroy();
					_bgmSfxGUI = null;
				}
			}
		}
		
		/*----------------------------------------------------------Setters---------------------------------------------------------------*/
		
		/*----------------------------------------------------------Getters---------------------------------------------------------------*/
		
		/*----------------------------------------------------------EventHandlers---------------------------------------------------------------*/
		/*
		private function onRollOutBtn(e:ButtonEvent):void
		{
			var btnName:String = e.obj.name;
			
			switch (btnName)
			{
				case "resumeBtn":
					_mc.resumeBtn.gotoAndStop(1);
					break;
				
				default:
					break;
			}
		}
		
		private function onRollOverBtn(e:ButtonEvent):void
		{
			var btnName:String = e.obj.name;
			
			switch (btnName)
			{
				case "resumeBtn":
					_mc.resumeBtn.gotoAndStop(2);
					break;
				
				default:
					break;
			}
		}
		
		private function onClickBtn(e:ButtonEvent):void
		{
			var btnName:String = e.obj.name;
			switch (btnName)
			{
				case "resumeBtn":
					_gdc.setIsLockControlls( false );
					_mc.resumeBtn.gotoAndStop(3);
					removeCover();
					_dm.removeSubScreen(DisplayManagerConfig.SETTING_SCREEN);
					_gameEvent = new GameEvent(GameEvent.GAME_UNPAUSED);
					_es.dispatchESEvent(_gameEvent);
				break;
				
				default:
					break;
			}
		}
	*/
		
	
	}

}