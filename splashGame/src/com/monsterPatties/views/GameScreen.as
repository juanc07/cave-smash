package com.monsterPatties.views
{
	import com.greensock.TweenLite;
	import com.monsterPatties.controllers.AwardController;
	import com.monsterPatties.controllers.GameDataController;
	import com.monsterPatties.controllers.GameKeyInput;
	import com.monsterPatties.data.ShopItem;
	import com.monsterPatties.engine.World;
	import com.monsterPatties.events.CaveSmashEvent;
	import com.monsterPatties.events.GameEvent;
	import com.monsterPatties.ui.BossLifeGUI;
	import com.monsterPatties.ui.CoinCrystalHUD;
	import com.monsterPatties.ui.CrystalHudGUI;
	import com.monsterPatties.ui.KeyIndicatorGUI;
	import com.monsterPatties.ui.LevelSet;
	import com.monsterPatties.ui.LifeHudGUI;
	import com.monsterPatties.ui.MessageGUI;
	import com.monsterPatties.ui.NavigationUI;
	import com.monsterPatties.ui.ScoreHudGUI;
	import com.monsterPatties.ui.ShortcutUI;
	import com.monsterPatties.ui.SoundGUI;
	import com.monsterPatties.utils.displayManager.config.DisplayManagerConfig;
	import com.monsterPatties.utils.displayManager.DisplayManager;
	import com.monsterPatties.utils.displayManager.event.WindowEvent;
	import com.monsterPatties.utils.displayManager.Window;
	import com.monsterPatties.utils.eventSatellite.EventSatellite;
	import com.monsterPatties.utils.Helper;
	import components.items.ItemConfig;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;
	/**
	 * ...
	 * @author jc
	 */
	public class GameScreen extends Window
	{
		/*----------------------------------------------------------Constant---------------------------------------------------------------*/
		
		/*----------------------------------------------------------Properties---------------------------------------------------------------*/
		private var _world:World;
		private var _lifeHUDGUI:LifeHudGUI;
		private var _bossLifeGUI:BossLifeGUI;
		private var _messageGUI:MessageGUI;
		private var _scoreGUI:ScoreHudGUI;
		private var _bgmSfxGUI:SoundGUI;
		
		private var _es:EventSatellite;
		private var _gdc:GameDataController;
		private var _dm:DisplayManager;
		private var _worldHolder:Sprite;
		private var txtPause:TextField;
		private var txtMute:TextField;
		private var txtSettings:TextField;
		private var txtMap:TextField;
		private var txtShop:TextField;
		private var txtLevel:TextField;
		private var txtGold:TextField;
		private var txtCrystal:TextField;
		private var _gameKeyInput:GameKeyInput;
		private var _gameEvent:GameEvent;
		private var _isKeyboardLock:Boolean= false;
		private var _isShortcutKeyLock:Boolean = false;
		private var _caveSmashEvent:CaveSmashEvent;
		private var _keyIndicatorGUI:KeyIndicatorGUI;
		private var _crystalHUDGUI:CrystalHudGUI;
		private var coinCrystalHUD:CoinCrystalHUD;
		private var _shortcutUI:ShortcutUI;
		private var _navigationUI:NavigationUI;
		private var _isLevelDone:Boolean = false;
		
		//new		
		private var _awardController:AwardController;
		/*----------------------------------------------------------Constructor---------------------------------------------------------------*/
		public function GameScreen( windowName:String, winWidth:Number = 0, winHeight:Number = 0 , hideWindowName:Boolean = false )
		{
			super( windowName , winWidth, winHeight );
		}
		
		/*----------------------------------------------------------Methods---------------------------------------------------------------*/
		private function setDisplay():void
		{			
			_gdc = GameDataController.getInstance();
			_es = EventSatellite.getInstance();
			_dm = DisplayManager.getInstance();
			
			_awardController = AwardController.getInstance();
			_awardController.init();
			
			_es.addEventListener( GameEvent.GAME_PAUSED, onGamePaused );
			_es.addEventListener( GameEvent.GAME_UNPAUSED, onGameUnPaused );
			_es.addEventListener( GameEvent.SHOW_GAME_SETTING, onShowGameSetting );
			_es.addEventListener( GameEvent.SHOW_PAUSED_SCREEN, onShowPausedScreen );
			_es.addEventListener( GameEvent.LOCK_SHORCUT_KEYS, onLockShortcutKeys );
			
			_es.addEventListener( GameEvent.PAUSE_BTN_CLICK, onClickPause );
			_es.addEventListener( GameEvent.SETTING_BTN_CLICK, onShowGameSetting );
			_es.addEventListener( GameEvent.MUTE_BTN_CLICK, onMute );
			_es.addEventListener( GameEvent.SHOP_BTN_CLICK, onGotoShop);
			_es.addEventListener( GameEvent.HOME_BTN_CLICK, onGotoHome);
			_es.addEventListener( GameEvent.HELP_BTN_CLICK, onGotoHelp);
			
			_es.addEventListener( CaveSmashEvent.ON_SHOW_COIN_INFO, onShowInfo );
			_es.addEventListener( CaveSmashEvent.ON_SHOW_CRYSTAL_INFO, onShowInfo );
			_es.addEventListener( CaveSmashEvent.ON_REMOVE_INFO, onRemoveInfo );
			_es.addEventListener( CaveSmashEvent.ON_COLLECT_KEY, onCollectKey );
			
			_worldHolder = new Sprite();
			addChild( _worldHolder );
			
			
			addBossLifeHudGUI();
			addWorld();
			addLifeHudGUI();
			addCrystalHudGUI();
			addScoreHudGUI();
			addMessageGUI();
			addBgmSfxUI();
			//addInGameTxtMenu();
			addGameCaption();
			addKeyIndicatorGUI();
			addShortcutUI();
			addNavigationUI();
			
			if (_gdc.getIsGoingToShop()) {
				addCoinCrystalHud();
			}
			
			this.addEventListener( WindowEvent.MOUSE_LEAVE_WINDOW, onMouseLeaveWindow );
			this.addEventListener( WindowEvent.ON_CLICK_WINDOW, onClickWindow );
			
			
			//this.stage.focus = this;
			//_dm.loadSubScreen( DisplayManagerConfig.LOST_FOCUS_SCREEN );
			//gamePaused();
			//gameUnPaused();
			
			
			//new
			_keyIndicatorGUI.setKey( false );
			_isKeyboardLock = false;
			_isShortcutKeyLock = false;
		}
		
		private function onGotoShop(e:GameEvent):void{
			goToShop();
		}
		
		private function onMute(e:GameEvent):void{
			goMute();
		}
		
		private function addKeyIndicatorGUI():void
		{
			_keyIndicatorGUI = new KeyIndicatorGUI( 555, 60 );
			addChild( _keyIndicatorGUI );
			
			if ( _gdc.getIsGoingToShop() ) {
				_keyIndicatorGUI.visible = false;
			}else{
				_keyIndicatorGUI.visible = true;
			}
		}
		
		private function removeDisplay():void
		{
			if (_gdc.getIsGoingToShop()) {
				removeCoinCystalHUD();
			}
			
			removeGameCaption();
			this.removeEventListener( WindowEvent.MOUSE_LEAVE_WINDOW, onMouseLeaveWindow );
			this.removeEventListener( WindowEvent.ON_CLICK_WINDOW, onClickWindow );
			
			_es.removeEventListener( GameEvent.GAME_PAUSED, onGamePaused );
			_es.removeEventListener( GameEvent.GAME_UNPAUSED, onGameUnPaused );
			_es.removeEventListener( GameEvent.SHOW_GAME_SETTING, onShowGameSetting );
			_es.removeEventListener( GameEvent.SHOW_PAUSED_SCREEN, onShowPausedScreen );
			_es.removeEventListener( GameEvent.LOCK_SHORCUT_KEYS, onLockShortcutKeys );
			
			_es.removeEventListener( GameEvent.PAUSE_BTN_CLICK, onClickPause );
			_es.removeEventListener( GameEvent.SETTING_BTN_CLICK, onShowGameSetting );
			_es.removeEventListener( GameEvent.MUTE_BTN_CLICK, onMute );
			_es.removeEventListener( GameEvent.SHOP_BTN_CLICK, onGotoShop);
			_es.removeEventListener( GameEvent.HOME_BTN_CLICK, onGotoHome);
			_es.removeEventListener( GameEvent.HELP_BTN_CLICK, onGotoHelp);
			
			_es.removeEventListener( CaveSmashEvent.ON_SHOW_COIN_INFO, onShowInfo );
			_es.removeEventListener( CaveSmashEvent.ON_SHOW_CRYSTAL_INFO, onShowInfo );
			_es.removeEventListener( CaveSmashEvent.ON_REMOVE_INFO, onRemoveInfo );
			_es.removeEventListener( CaveSmashEvent.ON_COLLECT_KEY, onCollectKey );
			
			//removeInGameTxtMenu();
			removeWorld();
			removeBgmSfxUI();
			removeGUI( this, _lifeHUDGUI );
			removeGUI( this, _crystalHUDGUI );
			removeGUI( this, _scoreGUI );
			removeGUI( this, _bossLifeGUI );
			removeGUI( this, _messageGUI );
			removeGUI( this, _keyIndicatorGUI );
			removeGUI( this, _shortcutUI );
			removeGUI( this, _navigationUI );
		}
		
		private function onGotoHelp(e:GameEvent):void{
			_gdc.setIsGoingToShop(false);
			//_dm.loadScreen( DisplayManagerConfig.HOW_TO_PLAY_SCREEN );
			pauseGame();
			_dm.loadSubScreen( DisplayManagerConfig.HOW_TO_PLAY_SCREEN );
		}
		
		private function onGotoHome(e:GameEvent):void{
			_gdc.setIsGoingToShop(false);
			_dm.loadScreen( DisplayManagerConfig.TITLE_SCREEN );
		}
		
		override public function initWindow():void{
			super.initWindow();
			
			addGameEventListeners();
			setDisplay(  );
			initLocks();
			//addGameEventListeners();
			setUpKeyboard();
			trace( windowName + " init!!" );
			trace( "[GameScreen]: init check locks: _isKeyboardLock " + _isKeyboardLock + " _isShortcutKeyLock " + _isShortcutKeyLock );
		}
		
		private function initLocks():void
		{
			_isKeyboardLock = false;
			_isShortcutKeyLock = false;
			_gdc.setIsLockControlls( false );
		}
		
		private function addGameEventListeners():void
		{
			_es = EventSatellite.getInstance();
			_es.addEventListener( CaveSmashEvent.LEVEL_STARTED, onLevelStarted );
			_es.addEventListener( CaveSmashEvent.LEVEL_COMPLETE, onLevelComplete );
			_es.addEventListener( CaveSmashEvent.LEVEL_FAILED, onLevelFailed );
			_es.addEventListener( CaveSmashEvent.LOAD_LEVEL, onLoadLevel );
			_es.addEventListener( CaveSmashEvent.RELOAD_LEVEL, onReloadLevel );
			_es.addEventListener( CaveSmashEvent.MINI_DARK_BOSS_DIED, onMiniDarkBossDied );
			_es.addEventListener( CaveSmashEvent.DARK_BOSS_SUMMON_COMPLETE, onDarkBossSummonComplete );
		}
		
		private function removeGameEventListeners():void
		{
			_es = EventSatellite.getInstance();
			_es.removeEventListener( CaveSmashEvent.LEVEL_STARTED, onLevelStarted );
			_es.removeEventListener( CaveSmashEvent.LEVEL_COMPLETE, onLevelComplete );
			_es.removeEventListener( CaveSmashEvent.LEVEL_FAILED, onLevelFailed );
			_es.removeEventListener( CaveSmashEvent.LOAD_LEVEL, onLoadLevel );
			_es.removeEventListener( CaveSmashEvent.RELOAD_LEVEL, onReloadLevel );
			_es.removeEventListener( CaveSmashEvent.MINI_DARK_BOSS_DIED, onMiniDarkBossDied );
			_es.removeEventListener( CaveSmashEvent.DARK_BOSS_SUMMON_COMPLETE, onDarkBossSummonComplete );
		}
		
		override public function clearWindow():void
		{
			super.clearWindow();
			removeKeyboard();
			removeGameEventListeners();
			removeDisplay();
			trace( windowName + " destroyed!!" );
		}

		private function addWorld():void
		{
			_world = new World();
			_worldHolder.addChild( _world );
		}
		
		private function removeWorld():void
		{
			if ( _world != null ) {
				if ( _worldHolder.contains( _world ) ) {
					_worldHolder.removeChild( _world );
					_world = null;
				}
			}
		}
		
		private function addShortcutUI():void{
			_shortcutUI = new ShortcutUI( 10, 440);
			addChild(_shortcutUI);
		}
		
		private function addNavigationUI():void {
			if(!_gdc.getIsGoingToShop()){
				_navigationUI = new NavigationUI( 555, 435);
				addChild(_navigationUI);
			}
		}
		
		private function addLifeHudGUI():void
		{
			_lifeHUDGUI = new LifeHudGUI( 15,8.5 );
			addChild( _lifeHUDGUI );
		}
		
		private function addCrystalHudGUI():void
		{
			_crystalHUDGUI = new CrystalHudGUI( 520,8.5 );
			addChild( _crystalHUDGUI );
			
			if ( _gdc.getIsGoingToShop() ) {
				_crystalHUDGUI.visible = false;
			}else{
				_crystalHUDGUI.visible = true;
			}
		}
		
		private function addScoreHudGUI():void
		{
			_scoreGUI = new ScoreHudGUI( 194.75 ,9.55);
			addChild( _scoreGUI );
			
			if ( _gdc.getIsGoingToShop() ) {
				_scoreGUI.visible = false;
			}else{
				_scoreGUI.visible = true;
			}
		}
		
		private function addBossLifeHudGUI():void
		{
			_bossLifeGUI = new BossLifeGUI( 140,30 );
			addChild( _bossLifeGUI );
		}
		
		private function addMessageGUI():void
		{
			_messageGUI = new MessageGUI(  );
			addChild( _messageGUI );
		}
		
		private function removeGUI( parent:Sprite, child:Sprite  ):void
		{
			if ( child != null ) {
				if ( parent.contains( child ) ) {
					parent.removeChild( child )
					child = null;
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
			checkWhatBgmToPlay();
		}
		
		private function checkWhatBgmToPlay():void 
		{
			var currentLevel:int = _gdc.getCurrLevel();
			trace("check level game screen on level started " + currentLevel );
			
			if (_bgmSfxGUI != null) {
				
				if( currentLevel >=1 && currentLevel <=14 ){
					_bgmSfxGUI.playBgMusic(0);
				}else if ( currentLevel >= 16 && currentLevel <= 29 ) {
					_bgmSfxGUI.playBgMusic(9);
				}else if ( currentLevel >= 31 && currentLevel <= 44) {
					_bgmSfxGUI.playBgMusic(10);
				}else if ( currentLevel == 15 ){
					_bgmSfxGUI.playBgMusic(5);
				}else if ( currentLevel == 30 ){
					_bgmSfxGUI.playBgMusic(6);
				}else if ( currentLevel == 45 ){
					_bgmSfxGUI.playBgMusic(7);
				}else{
					_bgmSfxGUI.playBgMusic(0);
				}
				
				if (_gdc.getIsGoingToShop()){
					_bgmSfxGUI.playBgMusic(8);
				}
			}
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
		
		private function gamePaused():void
		{
			this.root.stage.frameRate = 0;
			_gdc.setPausedGame( true );
		}
		
		private function gameUnPaused():void
		{
			stage.focus = this;
			_isKeyboardLock = false;
			this.root.stage.frameRate = 30;
			_gdc.setPausedGame( false );
		}
		
		
		private function addInGameTxtMenu():void
		{
			txtPause = Helper.createTextField("[P]AUSE", 16, 80, 20,0xFFFFFF, "JasmineUPC", TextFormatAlign.CENTER, false, true );
			addChild( txtPause );
			//txtPause.x = ( ( stage.stageWidth * 0.5 ) - ( txtPause.width * 0.5 ) )+ 100;
			txtPause.x = -10;
			txtPause.y = ( stage.stageHeight * 0.95 );
			txtPause.mouseEnabled = true;
			txtPause.addEventListener( MouseEvent.CLICK, onClickPause );
			
			txtMute = Helper.createTextField("[M]UTE", 16, 80, 20,0xFFFFFF, "JasmineUPC", TextFormatAlign.CENTER, false, true );
			addChild( txtMute );
			txtMute.x = txtPause.x + txtPause.width + 0;
			txtMute.y = ( stage.stageHeight * 0.95 );
			txtMute.mouseEnabled = true;
			txtMute.addEventListener( MouseEvent.CLICK, onClickMute );
			
			txtSettings = Helper.createTextField("S[E]TTINGS", 16, 80, 20,0xFFFFFF, "JasmineUPC", TextFormatAlign.CENTER, false, true );
			addChild( txtSettings );
			txtSettings.x = txtMute.x + txtMute.width + 10;
			txtSettings.y = ( stage.stageHeight * 0.95 );
			txtSettings.mouseEnabled = true;
			txtSettings.addEventListener( MouseEvent.CLICK, onClickSetting );
			
			txtMap = Helper.createTextField("[R]MAP", 16, 80, 20,0xFFFFFF, "JasmineUPC", TextFormatAlign.CENTER, false, true );
			addChild( txtMap );
			txtMap.x = txtSettings.x + txtSettings.width + 10;
			txtMap.y = ( stage.stageHeight * 0.95 );
			txtMap.mouseEnabled = true;
			
			
			txtShop = Helper.createTextField("[T]SHOP", 16, 80, 20,0xFFFFFF, "JasmineUPC", TextFormatAlign.CENTER, false, true );
			addChild( txtShop );
			txtShop.x = txtMap.x + txtMap.width + 10;
			txtShop.y = ( stage.stageHeight * 0.95 );
			txtShop.mouseEnabled = true;
		}
		
		private function addGameCaption():void
		{
			if( txtLevel == null ){
				txtLevel = Helper.createTextField("Level: " + _gdc.getCurrLevel() , 25, 80, 20,0xFFFFFF, "JasmineUPC", TextFormatAlign.CENTER, false, true );
				addChild( txtLevel );
				txtLevel.x = 5;
				//txtLevel.y = ( stage.stageHeight * 0.87 );
				txtLevel.y = ( stage.stageHeight * 0.75 );
			}
			
			if ( _gdc.getIsGoingToShop() ){
				txtLevel.visible = false;
			}else {
				txtLevel.visible = true;
			}
			/*
			if( txtCrystal == null ){
				txtCrystal = Helper.createTextField("Crystals: " + _gdc.getTotalCollectedCrystalByMap( _gdc.getCurrentMap() ), 20, 100, 30,0xFFFFFF, "JasmineUPC", TextFormatAlign.CENTER, false, true );
				addChild( txtCrystal );
				txtCrystal.x = 0;
				txtCrystal.y = 55;
				//txtCrystal.visible = false;
			}
			
			if( txtGold == null ){
				txtGold = Helper.createTextField("Gold: " + _gdc.getTotalGold(), 20, 150, 50,0xFFFFFF, "JasmineUPC", TextFormatAlign.CENTER, false, true );
				addChild( txtGold );
				txtGold.x = 60;
				txtGold.y = 55;
				//txtGold.visible = false;
			}*/
		}
		
		private function removeGameCaption():void
		{
			if ( txtLevel != null ) {
				if ( this.contains( txtLevel ) ) {
					this.removeChild( txtLevel );
					txtLevel = null;
				}
			}
			
			/*
			if ( txtGold != null ) {
				if ( this.contains( txtGold ) ) {
					this.removeChild( txtGold );
					txtGold = null;
				}
			}
			
			if ( txtCrystal != null ) {
				if ( this.contains( txtCrystal ) ) {
					this.removeChild( txtCrystal );
					txtCrystal = null;
				}
			}*/
		}
		
		private function removeInGameTxtMenu():void
		{
			if ( txtPause != null ) {
				if ( this.contains( txtPause ) ) {
					txtPause.removeEventListener( MouseEvent.CLICK, onClickPause );
					this.removeChild( txtPause );
					txtPause = null;
				}
			}
			
			if ( txtMute != null ) {
				if ( this.contains( txtMute ) ) {
					txtMute.removeEventListener( MouseEvent.CLICK, onClickMute );
					this.removeChild( txtMute );
					txtMute = null;
				}
			}
			
			if ( txtSettings != null ) {
				if ( this.contains( txtSettings ) ) {
					txtSettings.removeEventListener( MouseEvent.CLICK, onClickSetting );
					this.removeChild( txtSettings );
					txtSettings = null;
				}
			}
			
			if ( txtMap != null ) {
				if ( this.contains( txtMap ) ){
					this.removeChild( txtMap );
					txtMap = null;
				}
			}
			
			if ( txtShop != null ) {
				if ( this.contains( txtShop ) ){
					this.removeChild( txtShop );
					txtShop = null;
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
		
		private function pauseGame():void
		{
			trace( "txtPauseCLicked!!!" );
			if ( !_isKeyboardLock ){
				_isKeyboardLock = true;
				_gameEvent = new GameEvent( GameEvent.SHOW_PAUSED_SCREEN );
				_es.dispatchESEvent( _gameEvent );
			}else {
				_gdc.setIsLockControlls( false );
				_isKeyboardLock = false;
				_gameEvent = new GameEvent(GameEvent.GAME_UNPAUSED);
				_es.dispatchESEvent(_gameEvent);
				_dm.removeSubScreen(DisplayManagerConfig.PAUSED_SCREEN);
			}
		}
		
		private function showSettings():void
		{
			if( !_isKeyboardLock  ){
				_isKeyboardLock = true;
				_gameEvent = new GameEvent( GameEvent.SHOW_GAME_SETTING );
				_es.dispatchESEvent( _gameEvent );
			}else{
				_gdc.setIsLockControlls( false );
				_dm.removeSubScreen(DisplayManagerConfig.SETTING_SCREEN);
				_gameEvent = new GameEvent(GameEvent.GAME_UNPAUSED);
				_es.dispatchESEvent(_gameEvent);
			}
		}
		
		private function goMute():void
		{
			trace( "txtMuteCLicked!!!" );
			_gameEvent = new GameEvent( GameEvent.TOGGLE_MUSIC );
			_es.dispatchESEvent( _gameEvent );
		}
		
		
		private function resetLevelTint():void{
			TweenLite.to( this, 0, { alpha:1,tint:null} );
		}
		
		private function goToShop():void{
			_gdc.setIsGoingToShop(true);
			_dm.loadScreen( DisplayManagerConfig.GAME_SCREEN );
		}
		/*----------------------------------------------------------Setters---------------------------------------------------------------*/
		
		/*----------------------------------------------------------Getters---------------------------------------------------------------*/
		
		
		/*----------------------------------------------------------EventHandlers---------------------------------------------------------------*/
		private function onPressWhat(e:GameEvent):void
		{
			//trace( "[GameScreen]: press what: " + e.obj.key + " _isKeyboardLock " + _isKeyboardLock + " _isShortcutKeyLock " + _isShortcutKeyLock );
			if (e.obj.key == GameKeyInput.P && !_isShortcutKeyLock && !_isLevelDone ) {
				pauseGame();
			}else if ( e.obj.key == GameKeyInput.M && !_isShortcutKeyLock && !_isLevelDone ){
				goMute();
			}else if ( e.obj.key == GameKeyInput.E && !_isShortcutKeyLock && !_isLevelDone ){
				showSettings();
			}else if ( e.obj.key == GameKeyInput.R && !_isShortcutKeyLock && !_isLevelDone ){
				_dm.loadScreen( DisplayManagerConfig.MAP_SCREEN );
				_caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.LEVEL_QUIT );
				_es.dispatchESEvent( _caveSmashEvent );
			}else if ( e.obj.key == GameKeyInput.T && !_isShortcutKeyLock && !_isLevelDone ) {
				goToShop();
			}else if ( e.obj.key == GameKeyInput.SPACE ) {
				
				var item:ShopItem = _gdc.getCurrentSelectedItem();
				if ( item != null ){
					trace( "item selected item desc" + item.desc + " item.price " + item.price + " item.type " + item.type );
					if ( _gdc.getTotalGold() >= item.price ) {
						switch (item.type)
						{
							case ItemConfig.SHOP_SHOES:
								if ( !_gdc.hasDoubleJump() ) {
									_gdc.updateTotalGold(-item.price);
									_gdc.setDoubleJump(true);
									_caveSmashEvent = new CaveSmashEvent(CaveSmashEvent.ON_BUY_ITEM);
									_es.dispatchESEvent(_caveSmashEvent);
									_gdc.saveData();
									
									GetShopAward();
									
									trace( "buy item successful" + item.type );
								}else {
									trace( "buy item failed you already bought this item " + item.type );
								}
							break;
							
							case ItemConfig.SHOP_HAMMER:
								if ( !_gdc.hasComboAttack() ) {
									_gdc.updateTotalGold(-item.price);
									_gdc.setComboAttack(true);
									_caveSmashEvent = new CaveSmashEvent(CaveSmashEvent.ON_BUY_ITEM);
									_es.dispatchESEvent(_caveSmashEvent);
									_gdc.saveData();
									GetShopAward();
									trace( "buy item successful" + item.type );
								}else {
									trace( "buy item failed you already bought this item " + item.type );
								}
							break;
							
							case ItemConfig.SHOP_THROW:
								if ( !_gdc.hasThrowWeapon() ) {
									_gdc.updateTotalGold(-item.price);
									_gdc.setThrowWeapon(true);
									_caveSmashEvent = new CaveSmashEvent(CaveSmashEvent.ON_BUY_ITEM);
									_es.dispatchESEvent(_caveSmashEvent);
									_gdc.saveData();
									GetShopAward();
									trace( "buy item successful" + item.type );
								}else {
									trace( "buy item failed you already bought this item " + item.type );
								}
							break;
							
							case ItemConfig.SHOP_HEART:
								if ( _gdc.getAdditionalLive() < 2 ) {
									_gdc.updateTotalGold(-item.price);
									_gdc.updateAdditionalLive(1);
									_caveSmashEvent = new CaveSmashEvent(CaveSmashEvent.ON_BUY_ITEM);
									_es.dispatchESEvent(_caveSmashEvent);
									_gdc.saveData();
									GetShopAward();
									trace( "buy item successful" + item.type );
								}else {
									trace( "buy item failed you already bought this item " + item.type );
								}
							break;
							
							case ItemConfig.SHOP_BOMB:
								if ( !_gdc.hasBomber() ) {
									_gdc.updateTotalGold(-item.price);
									_gdc.setBomber(true);
									_caveSmashEvent = new CaveSmashEvent(CaveSmashEvent.ON_BUY_ITEM);
									_es.dispatchESEvent(_caveSmashEvent);
									_gdc.saveData();
									GetShopAward();
									trace( "buy item successful" + item.type );
								}else {
									trace( "buy item failed you already bought this item " + item.type );
								}
							break;
							
							default:
						}
						removeGameCaption();
						addGameCaption();
					}else {
						trace( "buy item failed not enough gold!!!" );
					}
				}else{
					_gameEvent = new GameEvent(GameEvent.REMOVE_LEVEL_CLEAR_POP_UP);
					_es.dispatchESEvent(_gameEvent);
					
					_caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.ON_REMOVE_INFO );
					_es.dispatchESEvent( _caveSmashEvent );
					trace( "skip now fuck!!!" );
				}
			}
		}
		
		private function GetShopAward():void{
			_gameEvent= new GameEvent( GameEvent.GET_AWARD );
			_gameEvent.obj.id = 1;				
			_es.dispatchESEvent( _gameEvent );
		}
		
		private function onMouseLeaveWindow(e:WindowEvent):void
		{
			trace( "[ GameScreen]: mouseleave window..........." );
			if ( !_gdc.getPausedGame() ){
				isWindowLostFocus = true;
				_dm.loadSubScreen( DisplayManagerConfig.LOST_FOCUS_SCREEN );
				gamePaused();
			}
		}
		
		
		private function onClickWindow(e:WindowEvent):void
		{
			trace( "[ GameScreen]: mouse return window..........." );
			if ( isWindowLostFocus ) {
				isWindowLostFocus = false;
				_dm.removeSubScreen( DisplayManagerConfig.LOST_FOCUS_SCREEN );
				gameUnPaused();
			}
		}
		
		private function onGameUnPaused(e:GameEvent):void
		{
			gameUnPaused();
		}
		
		private function onGamePaused(e:GameEvent):void
		{
			gamePaused();
		}
		
		private function onShowGameSetting(e:GameEvent):void
		{
			_isKeyboardLock = true;
			_dm.loadSubScreen( DisplayManagerConfig.SETTING_SCREEN );
		}
		
		private function onShowPausedScreen(e:GameEvent):void
		{
			_isKeyboardLock = true;
			_dm.loadSubScreen( DisplayManagerConfig.PAUSED_SCREEN );
		}
		
		private function onLevelFailed(e:CaveSmashEvent):void{
			_isLevelDone = true;
			if(_bgmSfxGUI != null){
				_bgmSfxGUI.playBgMusic(4);
			}
			//load level fail screen here to unload whole gamescreen avoid memory bloat
		}
		
		private function onLevelComplete(e:CaveSmashEvent):void
		{
			_isLevelDone = true;
			//load level Complete here screen here to unload whole gamescreen avoid memory bloat
		}
		
		private function onReloadLevel(e:CaveSmashEvent):void
		{
			//load level fail screen here to unload whole gamescreen avoid memory bloat
			_isLevelDone = false;
			resetLevelTint();
			_keyIndicatorGUI.setKey( false );
			_isKeyboardLock = false;
			_isShortcutKeyLock = false;
			removeGameCaption();
			addGameCaption();
			checkWhatBgmToPlay();
		}
		
		private function onLoadLevel(e:CaveSmashEvent):void {
			_isLevelDone = false;
			resetLevelTint();
			_keyIndicatorGUI.setKey( false );
			_isKeyboardLock = false;
			_isShortcutKeyLock  = false;
			removeGameCaption();
			addGameCaption();
			checkWhatBgmToPlay();
		}
		
		private function onLockShortcutKeys(e:GameEvent):void
		{
			_isShortcutKeyLock  = true;
		}
		
		private function onLevelStarted(e:CaveSmashEvent):void {
			_isLevelDone = false;
			resetLevelTint();			
			/*_keyIndicatorGUI.setKey( false );
			_isKeyboardLock = false;
			_isShortcutKeyLock = false;
			*/
		}
		
		private function onShowInfo(e:CaveSmashEvent):void
		{
			_isShortcutKeyLock  = true;
		}
		
		private function onRemoveInfo(e:CaveSmashEvent):void
		{
			_isShortcutKeyLock  = false;
		}
		
		private function onCollectKey(e:CaveSmashEvent):void
		{
			_keyIndicatorGUI.setKey( true );
		}
		
		private function onClickSetting(e:MouseEvent):void
		{
			showSettings();
		}
		
		private function onClickMute(e:MouseEvent):void
		{
			goMute();
		}
		
		private function onClickPause(e:GameEvent):void{
			pauseGame();
		}
		
		private function onMiniDarkBossDied(e:CaveSmashEvent):void {
			//_gdc.setIsLockControlls( true );
			TweenLite.to( this, 3, { alpha:0.75,tint:0xCCCCCC , onComplete : onSummonDarkBoss } );
		}
		
		private function onSummonDarkBoss():void{
			trace("final dark boss! summon");
			_caveSmashEvent = new CaveSmashEvent(CaveSmashEvent.SUMMON_DARK_BOSS);
			_es = EventSatellite.getInstance();
			_es.dispatchESEvent(_caveSmashEvent);
		}
		
		private function onDarkBossSummonComplete(e:CaveSmashEvent):void{
			TweenLite.to( this, 1, { alpha:1,tint:null,onComplete:onContinueBattle} );
		}
		
		private function onContinueBattle():void{
			//_gdc.setIsLockControlls( false );
		}
	}

}