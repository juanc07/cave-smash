package com.monsterPatties.views 
{	
	import com.greensock.TweenLite;
	import com.monsterPatties.config.GameConfig;
	import com.monsterPatties.controllers.GameDataController;
	import com.monsterPatties.controllers.GameKeyInput;
	import com.monsterPatties.events.GameEvent;
	import com.monsterPatties.ui.CoinCrystalHUD;
	import com.monsterPatties.ui.LevelStat;
	import com.monsterPatties.ui.NavigationUI;
	import com.monsterPatties.ui.SoundGUI;
	import com.monsterPatties.utils.buttonManager.ButtonManager;
	import com.monsterPatties.utils.buttonManager.events.ButtonEvent;
	import com.monsterPatties.utils.displayManager.config.DisplayManagerConfig;
	import com.monsterPatties.utils.displayManager.DisplayManager;
	import com.monsterPatties.utils.displayManager.event.DisplayManagerEvent;
	import com.monsterPatties.utils.displayManager.Window;
	import com.monsterPatties.utils.eventSatellite.EventSatellite;	
	import components.config.LiveData;
	import FGL.Ads.FGLAds;
	import flash.events.Event;
	import flash.geom.Point;
	/**
	 * ...
	 * @author jc
	 */
	public class MapScreen extends Window
	{
		/*----------------------------------------------------------Constant---------------------------------------------------------------*/
		
		/*----------------------------------------------------------Properties---------------------------------------------------------------*/				
		private var _mc:MapMainMC;
		private var _bm:ButtonManager;
		private var _dm:DisplayManager;
		private var _gdc:GameDataController;
		private var _mapArrow:MapArrowMC;
		private var levelStat:LevelStat;
		private var totalCrystal:int;
		private var totalGold:int;
		private var _es:EventSatellite;
		private var coinCrystalHUD:CoinCrystalHUD;
		private var _bgmSfxGUI:SoundGUI;
		private var _gameKeyInput:GameKeyInput;
		
		private var scenes:Vector.<int>;
		private var len:int;
		private var _navigationUI:NavigationUI;
		private var ads:FGLAds;
		//private var spilManager:SpilManager;
		/*----------------------------------------------------------Constructor---------------------------------------------------------------*/
		public function MapScreen( windowName:String, winWidth:Number = 0, winHeight:Number = 0 , hideWindowName:Boolean = false ) 
		{			
			super( windowName , winWidth, winHeight );
		}		
		
		/*----------------------------------------------------------Methods---------------------------------------------------------------*/
		private function setDisplay():void 
		{	
			_gdc = GameDataController.getInstance();
			
			_mc = new MapMainMC();
			addChild( _mc );
			_mc.scaleX = .6;
			_mc.scaleY = .6;
			_mc.x = 320.05;
			_mc.y = 232.2;
			
			//hack
			if (GameConfig.isCheat) {
				totalCrystal = 9999;
			}else {
				totalCrystal = _gdc.getTotalCollectedCrystal();
			}
			
			
			trace("total crystal " + totalCrystal);
			
			//totalCrystal = _gdc.getTotalCollectedCrystal();//( _gdc.getTotalCollectedCrystalByMap( 1 ) + _gdc.getTotalCollectedCrystalByMap( 2 ) + _gdc.getTotalCollectedCrystalByMap( 3 ) );
			//totalGold = _gdc.getTotalGold();
			//_mc.txtCrystal.text = totalCrystal.toString();
			//_mc.txtCoin.text = totalGold.toString();
			
			_bm = new ButtonManager();
			
			var map:int = _gdc.getMap();
			var level:int = _gdc.getLevel();
			
			if ( level == 0 ) {
				level = 1;
			}
			
			
			scenes =  _gdc.getCompletedScene();
			len = scenes.length;
				
			if (len >= 5 && _gdc.getCurrLevel() >= 46){				
				_gdc.setLevel(45);
				_gdc.setCurrLevel(45);
			}
			
			var lvl:int;
			var child:*;
			
			for (var i:int = 1; i <= 45; i++) 
			{
				if( i >= 1 && i <= 15 ){
					child = _mc.map1.getChildByName("level" + i);
				}else if( i >= 16 && i <= 30 ){
					child = _mc.map2.getChildByName("level" + i);
				}else if( i >= 31 && i <= 45 ){
					child = _mc.map3.getChildByName("level" + i);
				}
				
				if ( i == 15 || i == 30 || i == 45 ) {
					child.bossIcon.visible = true;
				}else {
					child.bossIcon.visible = false;
				}
				
				if ( child != null ){					
					lvl = getLevelFromString(child.name);
					//trace( "check child " + child.name + " lvl "  + lvl + " level " + level + " map " + map );					
					if ( level == lvl ){
						addMapArrow( child );
					}
					
					if ( level >= lvl ) {
						child.gotoAndStop(1);						
						_bm.addBtnListener( child );
					}else {
						child.gotoAndStop(2);
						if(GameConfig.isCheat){
							_bm.addBtnListener( child );
						}
					}				
				}				
			}		
			
			_bm.addBtnListener(_mc.map4);
			_bm.addEventListener( ButtonEvent.CLICK_BUTTON, onClickBtn );
			_bm.addEventListener( ButtonEvent.ROLL_OVER_BUTTON, onRollOverBtn );
			_bm.addEventListener( ButtonEvent.ROLL_OUT_BUTTON, onRollOutBtn );
			
			addCoinCrystalHud();
			addBgmSfxUI();
			setUpKeyboard();
			addNavigationUI();
			addFGLads();
		}
		
		private function addFGLads():void{
			ads = new FGLAds(stage, "FGL-282");
			//When the API is ready, show the ad!
			ads.addEventListener(FGLAds.EVT_API_READY, showStartupAd);	
			trace("show fgl add on map");
		}
		
		
		private function removeMapBtnListeners():void 
		{
			var map:int = _gdc.getMap();
			var level:int = _gdc.getLevel();
			if ( level == 0 ) {
				level = 1;
			}
			
			var lvl:int;
			var child:*;
			
			for (var i:int = 1; i <= 45; i++) 
			{
				if( i >= 1 && i <= 15 ){
					child = _mc.map1.getChildByName("level" + i);
				}else if( i >= 16 && i <= 30 ){
					child = _mc.map2.getChildByName("level" + i);
				}else if( i >= 31 && i <= 45 ){
					child = _mc.map3.getChildByName("level" + i);
				}
				
				if ( child != null ){					
					lvl = getLevelFromString(child.name);					
					if ( level >= lvl ){						
						_bm.removeBtnListener( child );
					}else {
						_bm.removeBtnListener( child );
					}
				}				
			}
		}
		
		private function addMapArrow( child:* ):void 
		{	
			var pt:Point			
			if( _mapArrow == null ){				
				_mapArrow = new MapArrowMC();
				addChild( _mapArrow );
				_mapArrow.mouseChildren = false;
				_mapArrow.mouseEnabled = false;
				pt = child.localToGlobal( new Point( _mapArrow.x + 7,_mapArrow.y - _mapArrow.height ) );
				
				_mapArrow.scaleX = 0.7;
				_mapArrow.scaleY = 0.7;
				_mapArrow.x = pt.x;
				_mapArrow.y = pt.y;
			}else {
				pt = child.localToGlobal( new Point( _mapArrow.x + 7,_mapArrow.y - _mapArrow.height ) );				
				_mapArrow.x = pt.x;
				_mapArrow.y = pt.y;
			}
		}
		
		private function removeMapArrow():void 
		{
			if ( _mapArrow != null ) {
				if ( this.contains(_mapArrow) ) {
					this.removeChild( _mapArrow );
					_mapArrow = null;
				}
			}
		}
		
		private function addNavigationUI():void{
			_navigationUI = new NavigationUI( 568, 20);
			addChild(_navigationUI);
		}
		
		private function removeNavigationUI():void 
		{
			if ( _navigationUI != null ) {
				if ( this.contains(_navigationUI) ) {
					this.removeChild( _navigationUI );
					_navigationUI = null;
				}
			}
		}
		
		private function getLevelFromString(mcName:String):int 
		{			
			var lvl:int;
			lvl = int( mcName.substring(5, mcName.length) );
			
			return lvl;
		}
		
		private function removeDisplay():void 
		{				
			if ( _mc != null ) {
				removeControllers();
				removeNavigationUI();
				removeKeyboard();
				removeCoinCystalHUD();
				removeLevelStat();
				_es.removeEventListener(DisplayManagerEvent.REMOVE_POP_UP_WINDOW, onRemovePopUp );
				_bm.removeBtnListener(_mc.map4);
				removeMapArrow();
				removeMapBtnListeners();
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
		
		override public function initWindow():void {
			super.initWindow();
			
			//spilManager = SpilManager.getInstance();
			//spilManager.showHideLanguageSelector(false);
			
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
			_dm = DisplayManager.getInstance();	
			_es = EventSatellite.getInstance();
			_es.addEventListener(DisplayManagerEvent.REMOVE_POP_UP_WINDOW, onRemovePopUp );
			_es.addEventListener(GameEvent.HOME_BTN_CLICK, onClickHome );
			_es.addEventListener(GameEvent.HELP_BTN_CLICK, onClickHelp );
		}
		
		private function removeControllers():void{
			_es.removeEventListener(DisplayManagerEvent.REMOVE_POP_UP_WINDOW, onRemovePopUp );
			_es.removeEventListener(GameEvent.HOME_BTN_CLICK, onClickHome );
			_es.removeEventListener(GameEvent.HELP_BTN_CLICK, onClickHelp );
		}	
		
		private function onRemovePopUp(e:DisplayManagerEvent):void{
			TweenLite.to(this, 1, {blurFilter:{blurX:0, blurY:0}});
		}
        
		
		private function showLevelStat(obj:Object, level:int):void {
			var crystal:int = 0;
			
			if ( level >=1  && level <= 15 ){
				crystal = _gdc.getCollectedCrystalByMapAndLevel(1,level);
			}else if ( level >= 16 && level <= 30 ){
				crystal = _gdc.getCollectedCrystalByMapAndLevel(2,level);
			}else if ( level >= 31 && level <= 45 ){
				crystal = _gdc.getCollectedCrystalByMapAndLevel(3,level);
			}
			//hack
			if (GameConfig.isCheat){
				crystal = 9999;
			}
			
			trace( "check crytals " + crystal );
			levelStat = new LevelStat(crystal);
			addChild(levelStat);			
			var pt:Point = obj.localToGlobal( new Point( levelStat.x + 7,levelStat.y - levelStat.height ) );			
			levelStat.x = pt.x;
			levelStat.y = pt.y;
		}
		
		private function removeLevelStat():void{
			if (levelStat != null){				
				if (this.contains(levelStat)) {
					this.removeChild(levelStat);
					levelStat = null;
				}
			}
		}
		
		
		private function addCoinCrystalHud():void{
			coinCrystalHUD = new CoinCrystalHUD();
			addChild(coinCrystalHUD);
			coinCrystalHUD.x = 510;
			coinCrystalHUD.y = 375;
		}
		
		private function removeCoinCystalHUD():void{ 
			if (coinCrystalHUD != null){				
				if (this.contains(coinCrystalHUD)) {
					this.removeChild(coinCrystalHUD);
					coinCrystalHUD = null;
				}
			}
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
		
		
		private function setUpKeyboard():void
		{
			if( _gameKeyInput == null ){
				_gameKeyInput = GameKeyInput.getIntance(  );
				_gameKeyInput.initKeyboardListener( stage );
				_es.addEventListener( GameEvent.PRESS_WHAT, onPressWhat );
				trace( "[GameScreen]: setUpKeyboard..." );
			}
		}
		
		
		private function removeKeyboard():void
		{
			if ( _gameKeyInput != null ) {
				_es.removeEventListener( GameEvent.PRESS_WHAT, onPressWhat );
				_gameKeyInput.clearKeyboardListener();
				_gameKeyInput = null;
				trace( "[GameScreen]: removeKeyboard..." );
			}
		}
		/*----------------------------------------------------------Setters---------------------------------------------------------------*/
		
		/*----------------------------------------------------------Getters---------------------------------------------------------------*/		
		
		
		/*----------------------------------------------------------EventHandlers---------------------------------------------------------------*/		
		private function onRollOutBtn(e:ButtonEvent):void 
		{
			removeLevelStat();
			
			var btnName:String = e.obj.name;			
			switch ( btnName ) 
			{				
				case "level2":
					trace("onRollOutBtn level2");
				break;
				
				case "map4":
					_mc.map4.gotoAndStop(1);
				break;
				
				default:
				break;
			}
		}
		
		private function onRollOverBtn(e:ButtonEvent):void 
		{
			var btnName:String = e.obj.name;			
			var level:int = getLevelFromString( btnName );			
			var currentLevel:int = _gdc.getLevel();
			trace("onRollOverBtn btnName " + btnName + " currentLevel " + currentLevel + " level " + level );
			if(btnName != "map4" && currentLevel > level){				
				showLevelStat(e.obj.currentTarget, level);
				trace("showLevelStat==>  " + btnName );
			}else {
				trace("dont showLevelStat==>  " + btnName );
			}
			
			switch ( btnName ) 
			{			
				case "level1":
					trace("rolloever level1");
				break; 			
				
				case "map4":
					_mc.map4.gotoAndStop(2);
				break;
				
				default:
				break;
			}
		}
		
		private function onClickBtn(e:ButtonEvent):void 
		{			
			var btnName:String = e.obj.name;
			trace("onClickBtn btnName " + btnName );
			var level:int = getLevelFromString( btnName );
			_gdc.setCurrentSelectedLevel(level);
			LiveData.isBossLevel = false;
			var allowed:Boolean = false;
			
			//check what map to load based on map and level
			if ( level >= 31  ) {
				if (GameConfig.isCheat){
					_gdc.setIsGoingToShop(false);
					_gdc.setCurrentMap(3);
					_gdc.setMap( 3 );
					allowed = true;
				}else {
					if( totalCrystal >= 60 ){
						_gdc.setIsGoingToShop(false);
						_gdc.setCurrentMap(3);
						_gdc.setMap( 3 );
						allowed = true;
					}else {
						_dm.loadSubScreen( DisplayManagerConfig.WARNING_MESSAGE_SCREEN );
						TweenLite.to(this, 1, { blurFilter: { blurX:10, blurY:10 }} );
					}	
				}				
			}else if ( level >= 16 && level <= 30 ) {
				if (GameConfig.isCheat){
					_gdc.setIsGoingToShop(false);
					_gdc.setCurrentMap(2);
					_gdc.setMap( 2 );
					allowed = true;
				}else {
					if( totalCrystal >= 30 ){
						_gdc.setIsGoingToShop(false);
						_gdc.setCurrentMap(2);
						_gdc.setMap( 2 );
						allowed = true;
					}else {				
						_dm.loadSubScreen( DisplayManagerConfig.WARNING_MESSAGE_SCREEN );
						TweenLite.to(this, 1, { blurFilter: { blurX:10, blurY:10 }} );
					}
				}				
			}else if ( level >= 1 && level <= 15 ){
				_gdc.setIsGoingToShop(false);
				_gdc.setCurrentMap(1);
				_gdc.setMap( 1 );
				allowed = true;
			}else if ( btnName == "map4" ) {
				_gdc.setIsGoingToShop(true);
				allowed = true;
			}
			
			
			
			if(allowed){
				var scenes:Vector.<int> =  _gdc.getCompletedScene();
				var len:int = scenes.length;
				_gdc.setCurrLevel( level );
				
				if(len == 1 && level == 15){
					_dm.loadSubScreen( DisplayManagerConfig.SCENE_SCREEN );
				}else if(len == 2 && level == 30){
					_dm.loadSubScreen( DisplayManagerConfig.SCENE_SCREEN );
				}else if(len == 3 && level == 45){
					_dm.loadSubScreen( DisplayManagerConfig.SCENE_SCREEN );
				}else{				
					_dm.loadScreen( DisplayManagerConfig.GAME_SCREEN );
				}		
			}
		}
		
		
		private function onPressWhat(e:GameEvent):void{
			if ( e.obj.key == GameKeyInput.SPACE && !_gdc.getIsScenePlaying() ) {	
				var level:int = _gdc.getLevel();
				trace("pressing space map screen!!! ccheck level "+ level);
				if (level == 0) {
					level = 1;
				}
				_gdc.setCurrentSelectedLevel(level);
				LiveData.isBossLevel = false;
				var allowed:Boolean = false;
				
				//check what map to load based on map and level
				if ( level >= 31  ) {
					if( totalCrystal >= 60 ){
						_gdc.setIsGoingToShop(false);
						_gdc.setCurrentMap(3);
						_gdc.setMap( 3 );
						allowed = true;
					}else {
						_dm.loadSubScreen( DisplayManagerConfig.WARNING_MESSAGE_SCREEN );
						TweenLite.to(this, 1, { blurFilter: { blurX:10, blurY:10 }} );
					}
				}else if ( level >= 16 && level <= 30 ) {
					if( totalCrystal >= 30 ){
						_gdc.setIsGoingToShop(false);
						_gdc.setCurrentMap(2);
						_gdc.setMap( 2 );
						allowed = true;
					}else {				
						_dm.loadSubScreen( DisplayManagerConfig.WARNING_MESSAGE_SCREEN );
						TweenLite.to(this, 1, { blurFilter: { blurX:10, blurY:10 }} );
					}
				}else if ( level >= 1 && level <= 15 ){
					_gdc.setIsGoingToShop(false);
					_gdc.setCurrentMap(1);
					_gdc.setMap( 1 );
					allowed = true;
				}
				
				if(allowed){
					var scenes:Vector.<int> =  _gdc.getCompletedScene();
					var len:int = scenes.length;
					_gdc.setCurrLevel( level );
					
					if(len == 1 && level == 15){
						_dm.loadSubScreen( DisplayManagerConfig.SCENE_SCREEN );
					}else if(len == 2 && level == 30){
						_dm.loadSubScreen( DisplayManagerConfig.SCENE_SCREEN );
					}else if(len == 3 && level == 45){
						_dm.loadSubScreen( DisplayManagerConfig.SCENE_SCREEN );
					}else{				
						_dm.loadScreen( DisplayManagerConfig.GAME_SCREEN );
					}		
				}
			}else if (e.obj.key == GameKeyInput.T && !_gdc.getIsScenePlaying() ) {
				_gdc.setIsGoingToShop(true);
				_dm.loadScreen( DisplayManagerConfig.GAME_SCREEN );
			}else if (e.obj.key == GameKeyInput.Q && !_gdc.getIsScenePlaying()  ) {
				_gdc.setIsGoingToShop(false);
				_dm.loadScreen( DisplayManagerConfig.TITLE_SCREEN );
			}
		}
		
		private function onClickHelp(e:GameEvent):void{
			//_dm.loadScreen( DisplayManagerConfig.HOW_TO_PLAY_SCREEN );
			_dm.loadSubScreen( DisplayManagerConfig.HOW_TO_PLAY_SCREEN );
		}
		
		private function onClickHome(e:GameEvent):void{
			_dm.loadScreen( DisplayManagerConfig.TITLE_SCREEN );
		}
		
		private function showStartupAd(e:Event):void{
			ads.showAdPopup();
		}
	}

}