package com.monsterPatties.views
{
	import com.greensock.TweenLite;
	import com.monsterPatties.config.GameConfig;
	import com.monsterPatties.config.SoundConfig;
	import com.monsterPatties.controllers.GameDataController;
	import com.monsterPatties.events.CaveSmashEvent;
	import com.monsterPatties.ui.SoundGUI;
	import com.monsterPatties.utils.buttonManager.ButtonManager;
	import com.monsterPatties.utils.buttonManager.events.ButtonEvent;
	import com.monsterPatties.utils.displayManager.config.DisplayManagerConfig;
	import com.monsterPatties.utils.displayManager.DisplayManager;
	import com.monsterPatties.utils.displayManager.event.DisplayManagerEvent;
	import com.monsterPatties.utils.displayManager.Window;
	import com.monsterPatties.utils.eventSatellite.EventSatellite;
	import com.monsterPatties.utils.gotoUrl.UrlNavigator;
	import com.monsterPatties.utils.spil.SpilManager;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author jc
	 */
	public class TitleScreen extends Window
	{
		/*----------------------------------------------------------Constant---------------------------------------------------------------*/
		
		/*----------------------------------------------------------Properties---------------------------------------------------------------*/
		private var _mc:TitleScreenMC;
		private var _bm:ButtonManager;
		private var _dm:DisplayManager;
		private var _es:EventSatellite;
		private var _gdc:GameDataController;
		private var _bgmSfxGUI:SoundGUI;
		private var _caveSmashEvent:CaveSmashEvent;
		
		private var spilManager:SpilManager;
		/*----------------------------------------------------------Constructor---------------------------------------------------------------*/
		public function TitleScreen( windowName:String, winWidth:Number = 0, winHeight:Number = 0 , hideWindowName:Boolean = false )
		{
			super( windowName , winWidth, winHeight );
		}
		
		/*----------------------------------------------------------Methods---------------------------------------------------------------*/
		private function setDisplay():void
		{			
			_mc = new TitleScreenMC();
			addChild( _mc );
			_mc.x = -182;
			_mc.y = -56;
			
			/*_mc.startButton.addEventListener(MouseEvent.CLICK, onClickStartGameBtn);
			_mc.howToPlayButton.addEventListener(MouseEvent.CLICK, onClickHowToPlayBtn);
			_mc.moreGamesButton.addEventListener(MouseEvent.CLICK, onClickMoreGamesBtn);
			_mc.creditsButton.addEventListener(MouseEvent.CLICK, onClickCreditsBtn);
			_mc.AddToWebsiteButton.addEventListener(MouseEvent.CLICK, onClickAddToWebsiteBtn);
			_mc.clearDataButton.addEventListener(MouseEvent.CLICK, onClickClearDataBtn);*/
			
			_bm = new ButtonManager();
			_bm.addBtnListener( _mc.startBtn );
			_bm.addBtnListener( _mc.howToPlayBtn );
			_bm.addBtnListener( _mc.moreGamesBtn );
			_bm.addBtnListener( _mc.clearBtn );
			_bm.addBtnListener( _mc.creditBtn );
			_bm.addEventListener( ButtonEvent.CLICK_BUTTON, onClickBtn );
			_bm.addEventListener( ButtonEvent.ROLL_OVER_BUTTON, onRollOverBtn );
			_bm.addEventListener( ButtonEvent.ROLL_OUT_BUTTON, onRollOutBtn );			
			
			addBgmSfxUI();			
		}		
		
		private function removeDisplay():void
		{
			if ( _mc != null ) {
				removeBgmSfxUI();
				
				/*
				_mc.startButton.removeEventListener(MouseEvent.CLICK, onClickStartGameBtn);
				_mc.howToPlayButton.removeEventListener(MouseEvent.CLICK, onClickHowToPlayBtn);
				_mc.moreGamesButton.removeEventListener(MouseEvent.CLICK, onClickMoreGamesBtn);
				_mc.creditsButton.removeEventListener(MouseEvent.CLICK, onClickCreditsBtn);
				_mc.clearDataButton.removeEventListener(MouseEvent.CLICK, onClickClearDataBtn);
				*/
				
				_bm.removeBtnListener( _mc.startBtn );
				_bm.removeBtnListener( _mc.howToPlayBtn );
				_bm.removeBtnListener( _mc.moreGamesBtn );
				_bm.removeBtnListener( _mc.clearBtn );
				_bm.removeBtnListener( _mc.creditBtn );
				_bm.removeEventListener( ButtonEvent.CLICK_BUTTON, onClickBtn );
				_bm.removeEventListener( ButtonEvent.ROLL_OVER_BUTTON, onRollOverBtn );
				_bm.removeEventListener( ButtonEvent.ROLL_OUT_BUTTON, onRollOutBtn );
				_bm.clearButtons();
				_bm = null;				
				
				if ( this.contains( _mc ) ) {
					this.removeChild( _mc );
					_mc = null;
				}
			}
		}
		
		override public function initWindow():void
		{
			super.initWindow();
			spilManager = SpilManager.getInstance();
			//spilManager.showHideLanguageSelector(false);
			
			initControllers();
			setDisplay(  );
			trace( windowName + " init!!" );
		}
		
		override public function clearWindow():void
		{
			super.clearWindow();
			_es.removeEventListener(DisplayManagerEvent.REMOVE_POP_UP_WINDOW, onRemovePopUpWindow);
			removeDisplay();
			trace( windowName + " destroyed!!" );
		}
		
		private function initControllers():void
		{
			_dm = DisplayManager.getInstance();
			_gdc = GameDataController.getInstance();
			_es = EventSatellite.getInstance();
			_es.addEventListener(DisplayManagerEvent.REMOVE_POP_UP_WINDOW, onRemovePopUpWindow);
		}
		
		private function onRemovePopUpWindow(e:DisplayManagerEvent):void{
			TweenLite.to(this, 1, {blurFilter:{blurX:0, blurY:0}});
		}
		
		private function addBgmSfxUI():void
		{
			_bgmSfxGUI = SoundGUI.getIntance();
			_bgmSfxGUI.setXYPos( 496, 8 );
			_bgmSfxGUI.init();
			addChild( _bgmSfxGUI );
			_bgmSfxGUI.visible = false;
			_bgmSfxGUI.playBgMusic( 2 );
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
		
		
		private function onRollOutBtn(e:ButtonEvent):void
		{
			var btnName:String = e.obj.name;
			
			switch ( btnName )
			{
				case "startBtn":
					//_mc.startButton.gotoAndStop( 1 );
				break;

				case "howToPlayBtn":
					//_mc.howToPlayButton.gotoAndStop( 1 );
				break;
				case "moreGamesBtn":
					//_mc.moreGamesBtn.gotoAndStop( 1 );
				break;
				
				case "clearBtn":
					//_mc.clearBtn.gotoAndStop( 1 );
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
				case "startBtn":
					//_mc.startButton.gotoAndStop( 2 );
				break;
				
				case "howToPlayBtn":
					//_mc.howToPlayButton.gotoAndStop( 2 );
				break;
				case "moreGamesBtn":
					//_mc.moreGamesBtn.gotoAndStop( 2 );
				break;
				
				case "clearBtn":
					//_mc.clearBtn.gotoAndStop( 2 );
				break;
				
				default:
				break;
			}
		}
		
		private function onClickBtn(e:ButtonEvent):void
		{
			_caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.PLAY_SFX );
			_caveSmashEvent.obj.id = SoundConfig.CLICK_SFX;
			
			
			var btnName:String = e.obj.name;
			
			switch ( btnName )
			{
				case "startBtn":
					_es.dispatchESEvent( _caveSmashEvent );
					
					//_mc.startButton.gotoAndStop( 3 );
					//_dm.loadScreen( DisplayManagerConfig.LEVEL_SELECTION_SCREEN );
					var scenes:Vector.<int> =  _gdc.getCompletedScene();
					var len:int = scenes.length;
					
					if(len == 0){
						_dm.loadSubScreen( DisplayManagerConfig.SCENE_SCREEN );
					}else{
						_dm.loadScreen( DisplayManagerConfig.MAP_SCREEN );
					}
				break;

				case "howToPlayBtn":
					_es.dispatchESEvent( _caveSmashEvent );
					//_mc.howToPlayButton.gotoAndStop( 3 );
					//_dm.loadScreen( DisplayManagerConfig.HOW_TO_PLAY_SCREEN );
					_dm.loadSubScreen( DisplayManagerConfig.HOW_TO_PLAY_SCREEN );
				break;
				
				case "moreGamesBtn":
					_es.dispatchESEvent( _caveSmashEvent );
					//_mc.moreGamesBtn.gotoAndStop( 3 );					
				break;
				
				case "creditBtn":
					_es.dispatchESEvent( _caveSmashEvent );
					//_mc.moreGamesBtn.gotoAndStop( 3 );
					_dm.loadSubScreen( DisplayManagerConfig.CREDIT_SCREEN );
				break;
				
				case "clearBtn":
					//_mc.clearBtn.gotoAndStop( 3 );
					_dm.loadSubScreen( DisplayManagerConfig.CLEAR_SAVE_SCREEN );
					TweenLite.to(this, 1, {blurFilter:{blurX:10, blurY:10}});
				break;				
				
				default:
				break;
			}
		}
		
		
		/*
		private function onClickHowToPlayBtn(e:MouseEvent):void {
			_caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.PLAY_SFX );
			_caveSmashEvent.obj.id = SoundConfig.CLICK_SFX;
			_es.dispatchESEvent( _caveSmashEvent );					
			_dm.loadSubScreen( DisplayManagerConfig.HOW_TO_PLAY_SCREEN );			
		}
		
		private function onClickStartGameBtn(e:MouseEvent):void{
			_caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.PLAY_SFX );
			_caveSmashEvent.obj.id = SoundConfig.CLICK_SFX;
			_es.dispatchESEvent( _caveSmashEvent );
			
			var scenes:Vector.<int> =  _gdc.getCompletedScene();
			var len:int = scenes.length;
			
			if(len == 0){
				_dm.loadSubScreen( DisplayManagerConfig.SCENE_SCREEN );
			}else{
				_dm.loadScreen( DisplayManagerConfig.MAP_SCREEN );
			}
		}
		
		private function onClickClearDataBtn(e:MouseEvent):void{
			_dm.loadSubScreen( DisplayManagerConfig.CLEAR_SAVE_SCREEN );
			TweenLite.to(this, 1, {blurFilter:{blurX:10, blurY:10}});
		}
		
		private function onClickCreditsBtn(e:MouseEvent):void {
			_caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.PLAY_SFX );
			_caveSmashEvent.obj.id = SoundConfig.CLICK_SFX;
			_es.dispatchESEvent( _caveSmashEvent );					
			_dm.loadSubScreen( DisplayManagerConfig.CREDIT_SCREEN );
		}
		
		private function onClickMoreGamesBtn(e:MouseEvent):void {
			var moregamesURL:String = spilManager.brandingManager.getMoreGamesLink();
			UrlNavigator.gotoUrl(moregamesURL);
			//UrlNavigator.gotoUrl(GameConfig.SPONSOR_LINK);
		}
		
		private function onClickAddToWebsiteBtn(e:MouseEvent):void {
			var addSiteURL:String = spilManager.brandingManager.getAddToSiteLink();
			UrlNavigator.gotoUrl(addSiteURL);
		}*/
	}
}