package com.monsterPatties.views 
{	
	import com.monsterPatties.events.GameEvent;
	import com.monsterPatties.ui.SoundGUI;
	import com.monsterPatties.utils.buttonManager.ButtonManager;
	import com.monsterPatties.utils.buttonManager.events.ButtonEvent;
	import com.monsterPatties.utils.displayManager.config.DisplayManagerConfig;
	import com.monsterPatties.utils.displayManager.DisplayManager;
	import com.monsterPatties.utils.displayManager.Window;
	import com.monsterPatties.utils.eventSatellite.EventSatellite;
	import com.monsterPatties.utils.spil.SpilManager;
	/**
	 * ...
	 * @author jc
	 */
	public class HowToPlayScreen extends Window
	{
		/*----------------------------------------------------------Constant---------------------------------------------------------------*/
		
		/*----------------------------------------------------------Properties---------------------------------------------------------------*/				
		private var _mc:HowToPlayMC;
		private var _bm:ButtonManager;
		private var _dm:DisplayManager;
		private var _bgmSfxGUI:SoundGUI;
		private var _gameEvent:GameEvent;
		private var _es:EventSatellite;
		//private var spilManager:SpilManager;
		/*----------------------------------------------------------Constructor---------------------------------------------------------------*/
		public function HowToPlayScreen( windowName:String, winWidth:Number = 0, winHeight:Number = 0 , hideWindowName:Boolean = false ) 
		{			
			super( windowName , winWidth, winHeight );
		}		
		
		/*----------------------------------------------------------Methods---------------------------------------------------------------*/
		private function setDisplay():void 
		{				
			_mc = new HowToPlayMC();
			addChild( _mc );			
			
			_bm = new ButtonManager();			
			_bm.addBtnListener( _mc.closeBtn );			
			_bm.addEventListener( ButtonEvent.CLICK_BUTTON, onClickBtn );
			_bm.addEventListener( ButtonEvent.ROLL_OVER_BUTTON, onRollOverBtn );
			_bm.addEventListener( ButtonEvent.ROLL_OUT_BUTTON, onRollOutBtn );
			//addBgmSfxUI();
		}		
		
		private function removeDisplay():void 
		{				
			if ( _mc != null ) {
				//removeBgmSfxUI();
				_bm.removeBtnListener( _mc.closeBtn );				
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
			initControllers();
			setDisplay(  );				
			trace( windowName + " init!!" );
		}
		
		override public function clearWindow():void 
		{			
			super.clearWindow();			
			removeDisplay();
			trace( windowName + " destroyed!!" );
		}
		
		private function initControllers():void 
		{
			//spilManager = SpilManager.getInstance();
			//spilManager.showHideLanguageSelector(false);
			
			_dm = DisplayManager.getInstance();			
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
				case "closeBtn":
					_mc.closeBtn.gotoAndStop( 1 );
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
				case "closeBtn":
					_mc.closeBtn.gotoAndStop( 2 );
				break;
				
				default:
				break;
			}
		}
		
		private function onClickBtn(e:ButtonEvent):void 
		{			
			var btnName:String = e.obj.name;
			
			switch ( btnName ) 
			{                  
				case "closeBtn":
					_mc.closeBtn.gotoAndStop( 3 );
					//_dm.loadScreen( DisplayManagerConfig.TITLE_SCREEN );
					_gameEvent = new GameEvent(GameEvent.PAUSE_BTN_CLICK);					
					_es = EventSatellite.getInstance();
					_es.dispatchESEvent(_gameEvent);
					
					_dm.removeSubScreen(DisplayManagerConfig.HOW_TO_PLAY_SCREEN);
					//spilManager.showHideLanguageSelector(true);
				break;			
				
				default:
				break;
			}
		}
		
	}

}