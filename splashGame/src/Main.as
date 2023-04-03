package
{
	import com.greensock.plugins.BlurFilterPlugin;
	import com.greensock.plugins.TintPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.monsterPatties.config.GameConfig;
	import com.monsterPatties.controllers.GameDataController;
	import com.monsterPatties.utils.displayManager.config.DisplayManagerConfig;
	import com.monsterPatties.utils.displayManager.DisplayManager;
	import com.monsterPatties.utils.frameRateViewer.FrameRateViewer;
	import com.monsterPatties.utils.memoryProfiler.MemoryProfiler;
	import com.monsterPatties.utils.spil.SpilManager;
	import com.monsterPatties.views.ClearSaveScreen;
	import com.monsterPatties.views.CreditScreen;
	import com.monsterPatties.views.GameCompleteScreen;
	import com.monsterPatties.views.GameScreen;
	import com.monsterPatties.views.HowToPlayScreen;
	import com.monsterPatties.views.LevelClearPopUp;
	import com.monsterPatties.views.LevelCompleteScreen;
	import com.monsterPatties.views.LevelEditorScreen;
	import com.monsterPatties.views.LevelSelectScreen;
	import com.monsterPatties.views.LostFocusScreen;
	import com.monsterPatties.views.MapScreen;
	import com.monsterPatties.views.MessagePopUp;
	import com.monsterPatties.views.PausedScreen;
	import com.monsterPatties.views.SceneScreen;
	import com.monsterPatties.views.ScoreBoardScreen;
	import com.monsterPatties.views.SettingScreen;
	import com.monsterPatties.views.ShopScreen;
	import com.monsterPatties.views.TitleScreen;
	import com.monsterPatties.views.TutorialPopUp;
	import com.monsterPatties.views.WarningMessageScreen;
	import com.sociodox.theminer.TheMiner;
	import com.spilgames.api.SpilGamesServices;
	import FGL.Ads.FGLAds;
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * ...
	 * @author monsterpatties
	 */
	[Frame(factoryClass="Preloader2")]
	public class Main extends Sprite
	{
		/*-------------------------------------------------Constant---------------------------------------------------------------*/
		
		/*-------------------------------------------------Properties---------------------------------------------------------------*/
		//private var _spilManager:SpilManager;
		private var _dm:DisplayManager;
		private var _frameRateViewer:FrameRateViewer;
		private var _memoryProfiler:MemoryProfiler;
		private var _gdc:GameDataController;
		
		private var _screenHolder:Sprite;
		private var _mainGUIHolder:Sprite;
		private var ads:FGLAds;
		
		//new
		//private var _spilManager:SpilManager;
		//private var _lowerBG:LowerBGMC;
		/*-------------------------------------------------Constructor---------------------------------------------------------------*/
		public function Main():void
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener( Event.REMOVED_FROM_STAGE, destroy );			
			
			//_spilManager = SpilManager.getInstance();			
			
			addHolders();
			
			addGamedataController();
			addDisplayManager();
			initTweenPlugin();
			addProfiler();
			addFGLads();
			// entry point
			
			//addLowerBg();
			//_spilManager.addSpilLogo(this);
			//_spilManager.addLanguageSelector(this);
		}
		
		/*
		private function addLowerBg():void {
			_lowerBG = new LowerBGMC();
			addChild(_lowerBG);
			_lowerBG.x = 0;
			_lowerBG.y = 480;
		}
		
		private function removeLowerBg():void{
			if (_lowerBG != null) {
				if (this.contains(_lowerBG)) {
					this.removeChild(_lowerBG);
					_lowerBG = null;
				}
			}
		}
		*/		
		
		private function initTweenPlugin():void {
			TweenPlugin.activate([TintPlugin]);
			TweenPlugin.activate([BlurFilterPlugin]);
		}
		
		private function destroy(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			//removeLowerBg();
			removeHolders();
		}
		/*-------------------------------------------------Methods---------------------------------------------------------------*/
		
		private function addHolders():void
		{
			_screenHolder = new Sprite();
			addChild( _screenHolder );
			
			_mainGUIHolder = new Sprite();
			addChild( _mainGUIHolder );
		}
		
		private function removeHolders():void
		{
			if ( _screenHolder != null ) {
				if ( this.contains( _screenHolder ) ) {
					this.removeChild( _screenHolder );
					_screenHolder = null;
				}
			}
			
			if ( _mainGUIHolder != null ) {
				if ( this.contains( _mainGUIHolder ) ) {
					this.removeChild( _mainGUIHolder );
					_mainGUIHolder = null;
				}
			}
		}
		
		private function addGamedataController():void
		{
			_gdc = GameDataController.getInstance();
			_gdc.init();
		}
		
		private function addDisplayManager():void
		{
			//addChild( new StarDustTest() );
			//addChild( new ParalaxTest() );
			//addChild( new TypeWriterEffect() );
			
			
			_dm = DisplayManager.getInstance();
			_screenHolder.addChild( _dm );
			
			_dm.addScreen( new TitleScreen( DisplayManagerConfig.TITLE_SCREEN, GameConfig.GAME_WIDTH, GameConfig.GAME_HEIGHT ) );
			_dm.addScreen( new SceneScreen( DisplayManagerConfig.SCENE_SCREEN, GameConfig.GAME_WIDTH, GameConfig.GAME_HEIGHT ) );
			_dm.addScreen( new CreditScreen( DisplayManagerConfig.CREDIT_SCREEN, GameConfig.GAME_WIDTH, GameConfig.GAME_HEIGHT ) );
			_dm.addScreen( new HowToPlayScreen( DisplayManagerConfig.HOW_TO_PLAY_SCREEN, GameConfig.GAME_WIDTH, GameConfig.GAME_HEIGHT ) );
			_dm.addScreen( new ClearSaveScreen( DisplayManagerConfig.CLEAR_SAVE_SCREEN, GameConfig.GAME_WIDTH, GameConfig.GAME_HEIGHT ) );
			_dm.addScreen( new WarningMessageScreen( DisplayManagerConfig.WARNING_MESSAGE_SCREEN, GameConfig.GAME_WIDTH, GameConfig.GAME_HEIGHT ) );
			_dm.addScreen( new ShopScreen( DisplayManagerConfig.SHOP_WINDOW, GameConfig.GAME_WIDTH, GameConfig.GAME_HEIGHT ) );
			_dm.addScreen( new LevelEditorScreen( DisplayManagerConfig.LEVEL_EDITOR_SCREEN, GameConfig.GAME_WIDTH, GameConfig.GAME_HEIGHT ) );
			_dm.addScreen( new LevelSelectScreen( DisplayManagerConfig.LEVEL_SELECTION_SCREEN, GameConfig.GAME_WIDTH, GameConfig.GAME_HEIGHT ) );
			_dm.addScreen( new MapScreen( DisplayManagerConfig.MAP_SCREEN, GameConfig.GAME_WIDTH, GameConfig.GAME_HEIGHT ) );
            _dm.addScreen( new GameScreen( DisplayManagerConfig.GAME_SCREEN, GameConfig.GAME_WIDTH, GameConfig.GAME_HEIGHT ) );
            _dm.addScreen( new MessagePopUp( DisplayManagerConfig.POP_UP_WINDOW_MESSAGE, GameConfig.GAME_WIDTH, GameConfig.GAME_HEIGHT ) );
			_dm.addScreen( new PausedScreen( DisplayManagerConfig.PAUSED_SCREEN, GameConfig.GAME_WIDTH, GameConfig.GAME_HEIGHT ) );
			_dm.addScreen( new SettingScreen( DisplayManagerConfig.SETTING_SCREEN, GameConfig.GAME_WIDTH, GameConfig.GAME_HEIGHT ) );
			_dm.addScreen( new LostFocusScreen( DisplayManagerConfig.LOST_FOCUS_SCREEN, GameConfig.GAME_WIDTH, GameConfig.GAME_HEIGHT ) );
            _dm.addScreen( new TutorialPopUp( DisplayManagerConfig.TUTORIAL_WINDOW, GameConfig.GAME_WIDTH, GameConfig.GAME_HEIGHT ) );
            _dm.addScreen( new LevelCompleteScreen( DisplayManagerConfig.LEVEL_COMPLETE_SCREEN, GameConfig.GAME_WIDTH, GameConfig.GAME_HEIGHT ) );
            //_dm.addScreen( new GameCompleteScreen( DisplayManagerConfig.GAME_COMPLETE_SCREEN, GameConfig.GAME_WIDTH, GameConfig.GAME_HEIGHT ) );
            _dm.addScreen( new ScoreBoardScreen( DisplayManagerConfig.SCORE_BOARD_WINDOW, GameConfig.GAME_WIDTH, GameConfig.GAME_HEIGHT ) );
			_dm.addScreen( new LevelClearPopUp( DisplayManagerConfig.LEVEL_CLEAR_WINDOW, GameConfig.GAME_WIDTH, GameConfig.GAME_HEIGHT ) );
			_dm.loadScreen( DisplayManagerConfig.TITLE_SCREEN  );
		}
		
		private function addProfiler():void
		{
			if( GameConfig.isDebug ){
				_frameRateViewer = new FrameRateViewer();
				_mainGUIHolder.addChild( _frameRateViewer );
				
				_memoryProfiler = new MemoryProfiler();
				_mainGUIHolder.addChild( _memoryProfiler );
				
				//addMiner();
			}
		}
		
		
		private function  addMiner():void
		{
			addChild( new TheMiner() );
		}
		
		private function addFGLads():void {			
			ads = new FGLAds(stage, "FGL-282");			
			//When the API is ready, show the ad!
			ads.addEventListener(FGLAds.EVT_API_READY, showStartupAd);	
		}
		/*-------------------------------------------------Getters---------------------------------------------------------------*/
		
		/*-------------------------------------------------Setters---------------------------------------------------------------*/
		
		/*-------------------------------------------------EventHandlers---------------------------------------------------------------*/
		private function showStartupAd(e:Event):void{
			ads.showAdPopup();
		}
	}

}