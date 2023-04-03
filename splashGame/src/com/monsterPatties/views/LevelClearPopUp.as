package com.monsterPatties.views
{
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Elastic;
	import com.greensock.plugins.EndArrayPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.monsterPatties.config.SoundConfig;
	import com.monsterPatties.controllers.GameDataController;
	import com.monsterPatties.events.CaveSmashEvent;
	import com.monsterPatties.events.GameEvent;
	import com.monsterPatties.ui.SoundGUI;
	import com.monsterPatties.utils.buttonManager.ButtonManager;
	import com.monsterPatties.utils.buttonManager.events.ButtonEvent;
	import com.monsterPatties.utils.displayManager.config.DisplayManagerConfig;
	import com.monsterPatties.utils.displayManager.DisplayManager;
	import com.monsterPatties.utils.displayManager.Window;
	import com.monsterPatties.utils.eventSatellite.EventSatellite;
	import com.monsterPatties.utils.Helper;
	import com.monsterPatties.utils.spil.SpilManager;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author jc
	 */
	public class LevelClearPopUp extends Window
	{
		/*----------------------------------------------------------Constant---------------------------------------------------------------*/
		
		/*----------------------------------------------------------Properties---------------------------------------------------------------*/
		private var _mc:LevelClearMC;
		private var _bm:ButtonManager;
		private var _dm:DisplayManager;
		private var _gameEvent:GameEvent;
		private var _es:EventSatellite;
		private var _caveSmashevent:CaveSmashEvent;
		public var _gdc:GameDataController;
		private var _curtain:Sprite;
		private var _id:int;		
		private var hasSelected:Boolean;
		private var _cover:Sprite;
		private var _isLock:Boolean;
		private var txtPressSpace:TextField;
		private var timeline:TimelineLite;
		private var timeline2:TimelineLite;
		private var hasSkip:Boolean;
		private var _bgmSfxGUI:SoundGUI;
		private var _caveSmashEvent:CaveSmashEvent;
		private var _spilManager:SpilManager;
		/*----------------------------------------------------------Constructor---------------------------------------------------------------*/
		public function LevelClearPopUp(windowName:String, winWidth:Number = 0, winHeight:Number = 0, hideWindowName:Boolean = false)
		{
			super(windowName, winWidth, winHeight);
		}
		
		/*----------------------------------------------------------Methods---------------------------------------------------------------*/
		private function setDisplay():void {			
			hasSkip = false;
			_isLock = true;
			removeTxtPressSpace();
			addCover();
			
			stage.focus = this;
			hasSelected = false;
			_gdc = GameDataController.getInstance();
			_es = EventSatellite.getInstance();
			_es.addEventListener( GameEvent.REMOVE_LEVEL_CLEAR_POP_UP, onRemoveLevelClearPopUp );
			_mc = new LevelClearMC();
			addChild(_mc);
			
			_mc.star.gotoAndStop( 4 );
			
			_mc.x = stage.stageWidth * 0.5;
			_mc.y = stage.stageHeight * 0.5;
			
			_mc.scaleX = 0;
			_mc.scaleY = 0;
			
			_mc.reloadBtn.alpha = 0;
			_mc.levelSelectBtn.alpha = 0;
			_mc.nextBtn.alpha = 0;
			
			_bm = new ButtonManager();
			_bm.addBtnListener(_mc.reloadBtn);
			_bm.addBtnListener(_mc.levelSelectBtn);
			_bm.addBtnListener(_mc.nextBtn);
			_bm.addEventListener(ButtonEvent.CLICK_BUTTON, onClickBtn);
			
			//TweenLite.delayedCall( 0.1, callPaused );
			///showStat();
			initStat();
			TweenLite.to( _mc, 1.5, { scaleX:1, scaleY:1, ease:Elastic.easeOut, onComplete:showStat } );
			addTxtPressSpace("press \"space\" to skip!");
			addBgmSfxUI();
			
			_spilManager = SpilManager.getInstance();
			var totalScore:int = _gdc.totalAllScore();
			//_spilManager.saveGame();
			_spilManager.submitScore(totalScore);
		}
		
		private function addCover():void
		{
			_cover = Helper.getCover();
			addChild( _cover );
			_cover.alpha = 0.65;
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
		
		private function initStat():void
		{
			_mc.txtScore.text = "0";
			_mc.txtGem.text = "0";
			_mc.txtGold.text = "0";
		}
		
		private function showStar( score:int, reqScore:int, reqScore2:int, crystal:int  ):void
		{
			timeline = new TimelineLite();
			
			//if ( score > reqScore && crystal >= 3 ){
			if ( crystal == 3 ){
				_mc.star.gotoAndStop( 3 );
				
				_mc.star.star1.scaleX = 0;
				_mc.star.star1.scaleY = 0;
				
				_mc.star.star2.scaleX = 0;
				_mc.star.star2.scaleY = 0;
				
				_mc.star.star3.scaleX = 0;
				_mc.star.star3.scaleY = 0;
				
				timeline.append( new TweenLite(_mc.star.star1, 0.5, {scaleX:1,scaleY:1, ease:Elastic.easeOut,onStart:playStarSFX}) );
				timeline.append( new TweenLite(_mc.star.star2, 0.5, {scaleX:1,scaleY:1, ease:Elastic.easeOut,onStart:playStarSFX}) );
				timeline.append( new TweenLite(_mc.star.star3, 0.5, {scaleX:1,scaleY:1, ease:Elastic.easeOut,onStart:playStarSFX}) );
				timeline.insertMultiple( TweenMax.allTo([_mc.star.star1, _mc.star.star2, _mc.star.star3], 1, { alpha:1,onComplete:unlock } ), timeline.duration );
			//}else if ( score >= reqScore2 && score <= reqScore && crystal >= 2  ){
			}else if ( crystal == 2  ){
				_mc.star.gotoAndStop( 2 );
				
				_mc.star.star1.scaleX = 0;
				_mc.star.star1.scaleY = 0;
				
				_mc.star.star2.scaleX = 0;
				_mc.star.star2.scaleY = 0;
				
				timeline.append( new TweenLite(_mc.star.star1, 0.5, {scaleX:1,scaleY:1, ease:Elastic.easeOut,onStart:playStarSFX}) );
				timeline.append( new TweenLite(_mc.star.star2, 0.5, {scaleX:1,scaleY:1, ease:Elastic.easeOut,onStart:playStarSFX}) );
				timeline.insertMultiple( TweenMax.allTo([_mc.star.star1, _mc.star.star2], 1, { alpha:1 , onComplete:unlock} ), timeline.duration );
			}else{
				_mc.star.gotoAndStop( 1 );
				_mc.star.star1.scaleX = 0;
				_mc.star.star1.scaleY = 0;
				timeline.append( new TweenLite(_mc.star.star1, 0.5, {scaleX:1,scaleY:1, ease:Elastic.easeOut,onStart:playStarSFX}) );
				timeline.insertMultiple( TweenMax.allTo([_mc.star.star1], 1, { alpha:1,onComplete:unlock } ), timeline.duration );
			}
		}
		
		private function playStarSFX():void{
			_caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.PLAY_SFX );
			_caveSmashEvent.obj.id = SoundConfig.STAR_SFX;
			_es.dispatchESEvent( _caveSmashEvent );
		}
		
		private function unlock():void
		{
			//if ( _isLock ){
				timeline2 = new TimelineLite();
				timeline2.append( new TweenLite(_mc.reloadBtn, 0.25, { alpha:1}) );
				timeline2.append( new TweenLite(_mc.levelSelectBtn, 0.25, { alpha:1}) );
				timeline2.append( new TweenLite(_mc.nextBtn, 0.25, { alpha:1}) );
				timeline2.insertMultiple( TweenMax.allTo([_mc.reloadBtn, _mc.levelSelectBtn,_mc.nextBtn], 0.25, { ease:Cubic.easeOut,onComplete:killTween} ), timeline2.duration );				
			//}
		}
		
		private function killTween():void{
			TweenMax.killAll(  );
			TweenLite.killTweensOf( onUpdateStat );
			TweenLite.killTweensOf( this );
			TweenLite.killDelayedCallsTo(showStar);
			_isLock = false;
			addTxtPressSpace("press \"space\" to continue...");			
			trace(" check score  " + _gdc.getScore() );
		}
		
		private function addTxtPressSpace(msg:String):void
		{
			if (txtPressSpace != null){
				removeTxtPressSpace();
			}
			
			if( txtPressSpace ==null ){
				txtPressSpace = Helper.createTextField(msg, 30, 400, 130,0xFFCC00, "JasmineUPC" );
				addChild( txtPressSpace );
				txtPressSpace.x = ( stage.stageWidth * 0.5 ) - ( txtPressSpace.width * 0.5 );
				txtPressSpace.y = ( stage.stageHeight * 0.91 );
			}else {
				txtPressSpace.visible = true;
			}
		}
		
		private function removeTxtPressSpace():void
		{
			if ( txtPressSpace != null ){
				if ( this.contains( txtPressSpace ) ) {
					this.removeChild( txtPressSpace );
					txtPressSpace = null;
					trace(  "remove txtPressSpace ");
				}
			}else {
				trace(  "remove txtPressSpace != null error!!!!");
			}
		}
		
		
		private function showStat():void
		{
			if ( _mc != null ) {
				var score:int = _gdc.getCurrentScore();
				var level:int = _gdc.getCurrLevel() - 1;
				var reqScore:int = _gdc.getRequiredScoreByLevel( level );
				var reqScore2:int = reqScore * 0.5;
				var crystal:int = _gdc.getCrystal();
				var gold:int = _gdc.getGold() * crystal;
				
				TweenPlugin.activate([EndArrayPlugin]);
				var myArray:Array = [ 0, 0, 0 ];
				TweenLite.to(myArray, 2, {endArray:[score, crystal, gold], onUpdate :onUpdateStat,  onUpdateParams:[myArray]});
				TweenLite.delayedCall( 2.3,showStar, [score,reqScore,reqScore2, crystal  ]  );
			}
		}
		
		private function onUpdateStat( myArray:Array ):void
		{
			//trace( "on update stat!!!" + myArray );
			_mc.txtScore.text = Math.round( myArray[0] ) + "";
			_mc.txtGem.text = Math.round( myArray[1] ) + "";
			_mc.txtGold.text = Math.round( myArray[2 ] ) + "";
		}
		
		private function quickStat():void
		{
			killTween();
			TweenMax.killAll(  );
			TweenLite.killTweensOf( onUpdateStat );
			TweenLite.killTweensOf( this );
			TweenLite.killDelayedCallsTo(showStar);
			
			_mc.scaleX = 1;
			_mc.scaleY = 1;
			
			_mc.reloadBtn.alpha = 1;
			_mc.levelSelectBtn.alpha = 1;
			_mc.nextBtn.alpha = 1;
			
			var score:int = _gdc.getCurrentScore();
			var level:int = _gdc.getCurrLevel() - 1;
			var reqScore:int = _gdc.getRequiredScoreByLevel( level );
			var reqScore2:int = reqScore * 0.5;
			var crystal:int = _gdc.getCrystal();
			var gold:int = _gdc.getGold() * crystal;
			
			if ( crystal == 3 ){
				_mc.star.gotoAndStop( 3 );
			}else if ( crystal == 2  ){
				_mc.star.gotoAndStop( 2 );
			}else{
				_mc.star.gotoAndStop( 1 );
			}
			
			_mc.txtScore.text = score + "";
			_mc.txtGem.text = crystal + "";
			_mc.txtGold.text = gold  + "";
			//txtPressSpace.visible = false;
			addTxtPressSpace("press \"space\" to continue...");
			removeBgmSfxUI();
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
				removeBgmSfxUI();
				_es.removeEventListener( GameEvent.REMOVE_LEVEL_CLEAR_POP_UP, onRemoveLevelClearPopUp );
				TweenLite.killTweensOf( _mc );
				TweenLite.killDelayedCallsTo( callPaused );
				TweenLite.killDelayedCallsTo( showStar );
				removeTxtPressSpace();
				removeCover();
				_bm.removeBtnListener(_mc.reloadBtn);
				_bm.removeBtnListener(_mc.levelSelectBtn);
				_bm.removeBtnListener(_mc.nextBtn);
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
		
		private function fadeToBlackTransition():void
		{
			if( _curtain == null ){
				_curtain =  new Sprite();
				_curtain.graphics.lineStyle( 1, 0x000000);
				_curtain.graphics.beginFill( 0x000000, 1  );
				_curtain.graphics.drawRect( 0, 0, 640, 480 );
				addChild( _curtain );
				_curtain.alpha = 0;
				
				TweenLite.to( _curtain, 0.5, { alpha:1, onComplete:removeFadeToBlackTimer } );
				trace( "fadeToBlackTransition!!!!................");
			}
		}
		
		private function removeFadeToBlackTimer():void
		{
			TweenLite.delayedCall( 0.5, removeFadeToBlackTransition );
		}
		
		private function removeFadeToBlackTransition():void
		{
			if ( _curtain != null ) {
				TweenLite.killTweensOf( _curtain );
				if ( this.contains( _curtain ) ) {
					this.removeChild( _curtain );
					_curtain = null;
				}
			}
			checkWhatLevelToLoad();
		}
		
		private function checkWhatLevelToLoad():void
		{
			_dm.removeSubScreen(DisplayManagerConfig.LEVEL_CLEAR_WINDOW);
			
			switch ( _id )
			{
				case 0:
					var scenes:Vector.<int> =  _gdc.getCompletedScene();
					var len:int = scenes.length;
					var level:int = _gdc.getCurrLevel();
			
					trace("LevelClearPopUp: len " + len + " level " + level );
			
					if (len == 1 && level == 15){
						loadScene();
					}else if (len == 2 && level == 30) {
						loadScene();
					}else if (len == 3 && level == 45) {
						loadScene();
					}else if (len == 4 && level == 46) {
						loadScene();
					}else if (len > 4) {
						if (_gdc.getCurrLevel()<= 44){
							loadMap();
						}else {
							_gdc.setLevel(45);
							_gdc.setCurrLevel(45);							
							loadTitleScreen();		
						}					
					}else if (level == 16 || level == 31 ){
						loadMap();
					}else{
						_caveSmashevent = new CaveSmashEvent( CaveSmashEvent.LOAD_LEVEL );
						_es.dispatchESEvent( _caveSmashevent );
					}
				break;
				
				case 1:
					_caveSmashevent = new CaveSmashEvent( CaveSmashEvent.RELOAD_LEVEL );
					_es.dispatchESEvent( _caveSmashevent );
				break;
				
				
				case 2:
					_caveSmashevent = new CaveSmashEvent( CaveSmashEvent.LEVEL_QUIT );
					_es.dispatchESEvent( _caveSmashevent );
					
					//_dm.loadScreen( DisplayManagerConfig.LEVEL_SELECTION_SCREEN );
					_dm.loadScreen( DisplayManagerConfig.MAP_SCREEN );
				break;
				
				default:
			}
		}
		
		private function loadScene():void{
			loadMap();
			_dm.loadSubScreen( DisplayManagerConfig.SCENE_SCREEN );
		}
		
		private function loadMap():void{
			_caveSmashevent = new CaveSmashEvent( CaveSmashEvent.LEVEL_QUIT );
			_es.dispatchESEvent( _caveSmashevent );
			_dm.loadScreen( DisplayManagerConfig.MAP_SCREEN );
			removeClearPopUp();
		}
		
		private function loadTitleScreen():void{
			_caveSmashevent = new CaveSmashEvent( CaveSmashEvent.LEVEL_QUIT );
			_es.dispatchESEvent( _caveSmashevent );
			_dm.loadScreen( DisplayManagerConfig.TITLE_SCREEN );
			removeClearPopUp();
		}
		
		
		private function addBgmSfxUI():void
		{
			_bgmSfxGUI = SoundGUI.getIntance();
			//_bgmSfxGUI.setXYPos( 496, 8 );
			//_bgmSfxGUI.init();
			//addChild( _bgmSfxGUI );
			//_bgmSfxGUI.visible = false;
			_bgmSfxGUI.playBgMusic( 3 );
		}
		
		private function removeBgmSfxUI():void
		{
			if ( _bgmSfxGUI != null ) {
				_bgmSfxGUI.stopAndSelectBGM( 0 );				
			}
		}
		/*----------------------------------------------------------Setters---------------------------------------------------------------*/
		
		/*----------------------------------------------------------Getters---------------------------------------------------------------*/
		
		/*----------------------------------------------------------EventHandlers---------------------------------------------------------------*/
			
		private function onClickBtn(e:ButtonEvent):void
		{
			if( !_isLock ){
				var btnName:String = e.obj.name;
				hasSelected = true;
				removeTxtPressSpace();
				removeCover();
				
				switch (btnName)
				{
					case "nextBtn":
						_id = 0;
						_gameEvent = new GameEvent(GameEvent.GAME_UNPAUSED);
						_es.dispatchESEvent(_gameEvent);
						
						fadeToBlackTransition();
						break;
					
					case "reloadBtn":
						_id = 1;
						_gdc.updateCurrLevel( -1 );
						_gameEvent = new GameEvent(GameEvent.GAME_UNPAUSED);
						_es.dispatchESEvent(_gameEvent);
						
						fadeToBlackTransition();
						break;
					
					case "levelSelectBtn":
						_id = 2;
						_gameEvent = new GameEvent(GameEvent.GAME_UNPAUSED);
						_es.dispatchESEvent(_gameEvent);
						fadeToBlackTransition();
						break;
						
					default:
						break;
				}
			}
		}
		
		private function removeClearPopUp():void
		{
			if ( !hasSelected && hasSkip ){
				_es.removeEventListener( GameEvent.REMOVE_LEVEL_CLEAR_POP_UP, onRemoveLevelClearPopUp );
				hasSelected = true;
				removeTxtPressSpace();
				removeCover();
				
				_id = 0;
				_gameEvent = new GameEvent(GameEvent.GAME_UNPAUSED);
				_es.dispatchESEvent(_gameEvent);
				fadeToBlackTransition();
				//trace( "level clear popup press what " + e.obj.key);
			}
			
			if ( !hasSkip ) {
				hasSkip = true;
				quickStat();
			}
		}
		
		private function onRemoveLevelClearPopUp(e:GameEvent):void{
			removeClearPopUp();
		}
	}
}