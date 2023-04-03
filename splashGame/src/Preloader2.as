package
{
	import com.monsterPatties.config.GameConfig;
	import com.monsterPatties.controllers.MochiController;	
	import com.monsterPatties.controllers.PlaytomicController;
	import com.monsterPatties.events.GameEvent;
	import com.monsterPatties.utils.eventSatellite.EventSatellite;
	import com.monsterPatties.utils.kongregateApi.Kong;
	import com.monsterPatties.utils.siteLocker.SiteLocker;
	import com.monsterPatties.utils.spil.SpilManager;
	import FGL.Ads.FGLAds;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.system.Security;
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author monsterpatties
	 */
	//just change mc and ur on or use monsterpatties swc preloadeGraphics
	[SWF(width="640",height="480",frameRate="30",backgroundColor="#FFFFFF")]
	
	public class Preloader2 extends MovieClip
	{
		
		/*---------------------------------------------------------Constant-----------------------------------------------*/
		
		/*---------------------------------------------------------Properties-----------------------------------------------*/
		private var _preloader:PreloaderMC;				
		//private var _preloader:Preloader;
		private const CENTER:Boolean = true;		
		private var _kong:Kong;
		private var _siteLocker:SiteLocker;
		private var _mochiController:MochiController;
		private var _playtomic:PlaytomicController;
		//private var _spilManager:SpilManager;
		private var _es:EventSatellite;
		private var ads:FGLAds;
		/*---------------------------------------------------------Constructor-----------------------------------------------*/
		
		public function Preloader2()
		{
			Security.allowDomain("www.mochiads.com");
			Security.allowDomain("www.mochiads.com/static/lib/services/mochiLC.swf");
			Security.allowDomain("http://www.mochiads.com/static/lib/services/mochiLC.swf");
			Security.allowDomain("http://www.mochiads.com/static/lib/services/services.swf");
			Security.allowDomain("http://www.mochiads.com/static/lib/services/services.swf?api%5Fversion=3%2E9%2E4%20as3&listenLC=%5F%5Fms%5F1323016260010%5F14763&mochiad%5Foptions=undefined");
			Security.allowDomain("127.0.0.1");
			
			if (stage){				
				//stage.scaleMode = StageScaleMode.NO_SCALE;
				
				//spil api integration
				//_spilManager = SpilManager.getInstance();
				//_spilManager.init(stage);
				_es = EventSatellite.getInstance();
				//_es.addEventListener(GameEvent.SPIL_BRANDING_READY, onSpilBrandingReady);
				
				stage.align = StageAlign.TOP_LEFT;				
			}
			
			if( GameConfig.isSiteLock ){
				_siteLocker = new SiteLocker();				
				var siteArray:Array = [ "http://www.flashgamelicense.com", "https://flashgamelicense.com", "http://monsterpatties.net", "http://kongregate.com", "http://www.mochimedia.com", "https://www.mochimedia.com" ]
				var valid:Boolean = _siteLocker.locked( siteArray, this.root.loaderInfo )
				
				if ( valid ) {
					initGamePreloader();
					trace( "[Preloader] this game is running on authorized machine=========================================================>>>" );					
				}else {
					trace( "[Preloader] warning: this game is running on a not authorized machine=========================================================>>>" );
				}
			}else {
				initGamePreloader();
			}			
		}		
		
		/*---------------------------------------------------------Methods-----------------------------------------------*/		
		private function initGamePreloader():void
		{
			// TODO show loader
			addPlaytomicTracker();
			trace("preloader started....");
			
			setDisplay();
			
			
			addEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			if (GameConfig.isLive)
			{
				_mochiController = MochiController.getInstance();
				_mochiController.addMochibot(this, GameConfig.MOCHI_BOT_ID );
			
				if ( GameConfig.isMochimedia ){				
					_mochiController.connectMochi(root, GameConfig.MOCHI_ADS_ID, GameConfig.MOCHI_LEADER_BOARD_ID  );					
					_mochiController.startGamePlay();
				}				
				
				if (GameConfig.isKongregate)
				{
					_kong = Kong.getInstance();
					Kong.connectToKong(stage, kongLoadComplete);
				}
			}
		}
		
		private function kongLoadComplete():void
		{
			Kong.getPlayerInfo();
			trace("kong load complete!");
		}
		
		private function setDisplay():void
		{
			_preloader = new PreloaderMC();
			//_preloader = new Preloader();
			addChild(_preloader);
			_preloader.bar.scaleX = 0;
			_preloader.y -= 25; 
			
			if (CENTER){
				_preloader.x = GameConfig.GAME_WIDTH / 2 - _preloader.width / 2;
				_preloader.y = GameConfig.GAME_HEIGHT / 2 - _preloader.height / 2;
			}			
			
			addFGLads();
		}
		
		private function removeDisplay():void
		{
			if (_preloader != null)
			{
				if (this.contains(_preloader))
				{
					this.removeChild(_preloader);
					_preloader = null;
				}
			}
		}
		
		private function loadingFinished():void
		{
			removeEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			// TODO hide loader
			removeDisplay();
			startup();
			trace("preloader ended....");
		}
		
		private function startup():void
		{
			var mainClass:Class = getDefinitionByName("Main") as Class;
			addChild(new mainClass() as DisplayObject);
		}
		
		
		private function addPlaytomicTracker():void 
		{
			if( GameConfig.isPlaytomic ){
				_playtomic = PlaytomicController.getInstance();
				_playtomic.init( 6969, "063cfcbcb2ae44cf", "517078b3ab1344789239f1e6fa4db9", root );
				_playtomic.trackPreloader();
			}
		}
		
		private function addFGLads():void{
			ads = new FGLAds(stage, "FGL-282");
			//When the API is ready, show the ad!
			ads.addEventListener(FGLAds.EVT_API_READY, showStartupAd);	
		}
		
		/*---------------------------------------------------------Setters-----------------------------------------------*/
		
		/*---------------------------------------------------------Getters-----------------------------------------------*/
		
		/*---------------------------------------------------------EventHandlers-----------------------------------------------*/
		
		private function ioError(e:IOErrorEvent):void
		{
			trace(e.text);
		}
		
		private function progress(e:ProgressEvent):void
		{			
			// TODO update loader
			var percent:Number = e.bytesLoaded / e.bytesTotal;
			_preloader.bar.scaleX = percent;
			_preloader.txtLoading.text = "Loading " + Math.floor(percent * 100) + " %";			
			_preloader.bar.scaleX = percent;
			trace( "loading Game... " + percent );		
		}
		
		private function checkFrame(e:Event):void
		{
			//if(_preloader.bar.scaleX == 1 && _spilManager.isBrandingReady && _spilManager.isServiceReady)
			if (currentFrame == totalFrames){
				stop();
				loadingFinished();
			}
		}
		
		private function showStartupAd(e:Event):void{
			ads.showAdPopup();
		}
		
		/*private function onSpilBrandingReady(e:GameEvent):void{ 
			_spilManager.addSpilLogo(this, 1);
			trace("show spil logo now!! fck!");
		}*/	
	}
}