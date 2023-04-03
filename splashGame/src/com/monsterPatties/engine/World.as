package com.monsterPatties.engine 
{
	import com.greensock.TweenLite;
	import com.lextalkington.parallax.ParallaxEngine;
	import com.lextalkington.parallax.ParallaxInertia;
	import com.lextalkington.parallax.ParallaxReturn;
	import com.monsterPatties.controllers.FGLTracker;
	import com.monsterPatties.controllers.GameDataController;
	import com.monsterPatties.controllers.PlaytomicController;
	import com.monsterPatties.data.GameData;
	import com.monsterPatties.events.CaveSmashEvent;
	import com.monsterPatties.ui.SoundGUI;
	import com.monsterPatties.ui.TimerUI;
	import com.monsterPatties.utils.displayManager.DisplayManager;
	import com.monsterPatties.utils.eventSatellite.EventSatellite;
	import components.items.ItemConfig;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import wck.WCK;
	/**
	 * ...
	 * @author ...
	 */
	public class World extends WCK
	{
		/*--------------------------------------------------------------------Constant----------------------------------------------------------------*/
		private static const	DELAY_LOAD_LEVEL:int = 0.5;
		/*--------------------------------------------------------------------Properties---------------------------------------------------------------*/
		private var _gdc:GameDataController;
		private var _es:EventSatellite;
		private var _caveSmashEvent:CaveSmashEvent;
		
		private var _displayManager:DisplayManager;	
		
		//persistent data
		private var _level:*;		
		private var _timerUI:TimerUI;
		
		//trackers analytics ( optional )
		private var _fglTracker:FGLTracker;
		private var _playtomic:PlaytomicController;
		private var _cover:Sprite;
		
		
		//paralax
		private var _pEi:ParallaxInertia;
		private var _pE:ParallaxEngine;
		private var _pEr:ParallaxReturn;
		
		private var _paralaxHolder:Sprite;
		private var _worldHolder:Sprite;
		private var _bgHolder:Sprite;
		
		private var _baseBG:GrassBaseBGMC;
		private var _bg:BG1MC;
		private var _bg2:BG1_2MC;
		private var _shopBg:ShopBGMC;
		private var _mainBg:*;
		
		/*--------------------------------------------------------------------Constructor---------------------------------------------------------------*/
		public function World() 
		{
			initControllers();
			addGameEventListeners();
			addEventListener( Event.ADDED_TO_STAGE, init );			
		}
		
		private function init(e:Event):void 
		{
			addPlaytomicTracker();			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener( Event.REMOVED_FROM_STAGE, clearWorld );
			
			addGameEventListeners();
			addFGLTracker();			
			addLevel();			
		}
		
		private function clearWorld(e:Event):void 
		{			
			removeEventListener(Event.REMOVED_FROM_STAGE, clearWorld);			
			removeGameEventListeners();
			removeCover();
			removeBG();			
			removeLevel();
			removeHolders();
		}
		
		private function reloadLevel():void 
		{
			TweenLite.killDelayedCallsTo( reloadLevel );
			var level:int = _gdc.getLevel();
			
			loadLevel();						
			//_gdc.setLive( GameData.MAX_ADDITIONAL_LIVE + _gdc.getAdditionalLive());
			
			_caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.RESET_LIFE  );
			_es.dispatchESEvent( _caveSmashEvent );
		}
		/*--------------------------------------------------------------------Methods---------------------------------------------------------------*/		
		private function addGameEventListeners():void 
		{
			_es = EventSatellite.getInstance();
			_es.addEventListener( CaveSmashEvent.PICK_UP_ITEM, onPickUpItem );			
			_es.addEventListener( CaveSmashEvent.LOAD_LEVEL, onLoadLevel );			
			_es.addEventListener( CaveSmashEvent.LEVEL_FAILED, onLevelFailed );
			_es.addEventListener( CaveSmashEvent.RELOAD_LEVEL, onReloadLevel );
		}							
		
		private function removeGameEventListeners():void 
		{			
			_es.removeEventListener( CaveSmashEvent.PICK_UP_ITEM, onPickUpItem );			
			_es.removeEventListener( CaveSmashEvent.LOAD_LEVEL, onLoadLevel );			
			_es.removeEventListener( CaveSmashEvent.LEVEL_FAILED, onLevelFailed );
			_es.removeEventListener( CaveSmashEvent.RELOAD_LEVEL, onReloadLevel );
		}
		
		private function initControllers():void 
		{			
			_gdc = GameDataController.getInstance();			
			_displayManager = DisplayManager.getInstance();
		}
		
		private function addLevel():void 
		{			
			if( _bgHolder == null ){
				_bgHolder= new Sprite();
				addChild( _bgHolder );
			}
			
			if( _paralaxHolder == null ){
				_paralaxHolder = new Sprite();
				addChild( _paralaxHolder );
			}
			
			if( _worldHolder == null ){
				_worldHolder = new Sprite();
				addChild( _worldHolder );
			}
			
			//reset persistent data			
			_gdc.retry();
			_gdc.setIsDoneLevel( false );
			
			trace( "[World]: _gdc.getCurrentMap( ) b4 " + _gdc.getCurrentMap( ) );
			
			var level:int = _gdc.getCurrLevel();
			//var map:int = _gdc.getCurrentMap( ) + 1;
			//var map:int = _gdc.getCurrentMap( );
			var map:int = _gdc.getMap();
			//var map:int = _gdc.getCurrentMap( );
			
			
			trace( "[World]: current level " + level );
			trace( "[World]: current map " + map );
			trace( "[World]: getIsGoingToShop " + _gdc.getIsGoingToShop() );
			
			if ( _gdc.getIsGoingToShop() ) {
				_level = new ShopLevelMC();
			}else{			
				if( map == 1 ){
					if( level == 1 ){					
						_level = new level1();						
					}else if ( level == 2 ){
						_level = new level2();					
					}else if ( level == 3 ){
						_level = new level3();								
					}else if ( level == 4 ){
						_level = new level4();					
					}else if ( level == 5 ){
						_level = new level5();					
					}else if ( level == 6 ){
						_level = new level6();					
					}else if ( level == 7 ){
						_level = new level7();					
					}else if ( level == 8 ){
						_level = new level8();					
					}else if ( level == 9 ){
						_level = new level9();					
					}else if ( level == 10 ){
						_level = new level10(); 					
					}else if ( level == 11 ){
						_level = new level11(); 					
					}else if ( level == 12 ){
						_level = new level12(); 					
					}else if ( level == 13 ){
						_level = new level13(); 
					}else if ( level == 14 ){
						_level = new level14(); 
					}else if ( level == 15 ){
						_level = new level15();					
					}
				}else if ( map == 2 ) {
					//if ( _gdc.getLevel() >= 20 ) {
						//_gdc.setLevel( 1 );
					//}				
					if( level == 16 ){
						_level = new dessert1();
					}else if ( level == 17 ){
						_level = new dessert2();
					}else if ( level == 18 ){
						_level = new dessert3();
					}else if ( level == 19 ){
						_level = new dessert4();
					}else if ( level == 20 ){
						_level = new dessert5();
					}else if ( level == 21 ){
						_level = new dessert6();
					}else if ( level == 22 ){					
						_level = new dessert7();
					}else if ( level == 23 ){					
						_level = new dessert8();
					}else if ( level == 24 ){					
						_level = new dessert9();
					}else if ( level == 25 ){					
						_level = new dessert10();
					}else if ( level == 26 ){					
						_level = new dessert11();
					}else if ( level == 27 ){
						_level = new dessert12();
					}else if ( level == 28 ){
						_level = new dessert13();
					}else if ( level == 29 ){
						_level = new dessert14();
					}else if ( level == 30 ){
						_level = new dessert15();
					}		
				}else if ( map == 3 ) {
					trace( "load map3!!!!!!!!!!!!!!!!!!!!!!!!!!!!" );
					if ( level == 31 ){
						_level = new dark1();
					}else if ( level == 32 ){
						_level = new dark2();
					}else if ( level == 33 ){
						_level = new dark3();
					}else if ( level == 34 ){
						_level = new dark4();
					}else if ( level == 35 ){
						_level = new dark5();
					}else if ( level == 36 ){
						_level = new dark6();
					}else if ( level == 37 ){
						_level = new dark7();
					}else if ( level == 38 ){
						_level = new dark8();
					}else if ( level == 39 ){
						_level = new dark9();
					}else if ( level == 40 ){
						_level = new dark10();
					}else if ( level == 41 ){
						_level = new dark11();
					}else if ( level == 42 ){
						_level = new dark12();
					}else if ( level == 43 ){
						_level = new dark13();
					}else if ( level == 44 ){
						_level = new dark14();
					}else if ( level == 45 ){
						_level = new dark15();
					}else {
						_level = new dark1();	
					}					
				}
			}
			
			if( _level != null ){
				addBG();
				_worldHolder.addChild( _level );
				if ( this != null ) {
					var caveSmashEvent:CaveSmashEvent = new CaveSmashEvent( CaveSmashEvent.HIDE_BOSS_HP );
					_es.dispatchESEvent( caveSmashEvent );
					
					
					_caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.LEVEL_STARTED );
					_es.dispatchESEvent( _caveSmashEvent );
				}
				addCover();
			}
			stage.focus = this;
			trace( " level childer count  " + _level.numChildren + " this children count  " + this.numChildren );
		}
		
		private function removeHolders():void 
		{
			if ( _bgHolder != null ){			
				if ( this.contains( _bgHolder ) ) {
					this.removeChild( _bgHolder );
					_bgHolder = null;
				}
			}
			
			if ( _paralaxHolder != null ){			
				if ( this.contains( _paralaxHolder ) ) {
					this.removeChild( _paralaxHolder );
					_paralaxHolder = null;
				}
			}
			
			if ( _worldHolder != null ){			
				if ( this.contains( _worldHolder ) ) {
					this.removeChild( _worldHolder );
					_worldHolder = null;
				}
			}
		}
		
		private function removeLevel():void 
		{		
			removeBG();		
			if ( _level != null ) {
				_level.clearWorld();
				if ( _worldHolder.contains( _level ) ) {
					_worldHolder.removeChild( _level );
					_level = null;
				}
			}
		}
		
		private function addCover():void 
		{
			if( _cover ==null ){
				_cover = new Sprite();
				_cover.graphics.lineStyle( 1, 0x000000 );
				_cover.graphics.beginFill( 0x000000 );
				_cover.graphics.drawRect( 0, 0, 640, 480 );
				addChild( _cover );
				TweenLite.to( _cover, 1, { alpha:0, onComplete:removeCover } );
			}
		}
		
		private function removeCover():void 
		{
			if ( _cover != null ) {
				TweenLite.killTweensOf( _cover );
				if ( this.contains( _cover ) ) {
					this.removeChild( _cover );
					_cover = null;
				}
			}
		}
		
		public function stopWorld():void 
		{
			_level.stopSimulation();
		}
		
		public function startWorld():void 
		{
			_level.startSimulation();
		}		
		
		private function addFGLTracker():void
		{
			_fglTracker = FGLTracker.getInstance();			
		}
		
		private function addPlaytomicTracker():void 
		{
			_playtomic = PlaytomicController.getInstance();
			_playtomic.started( _gdc.getLevel() );
		}	
		
		private function loadLevel():void 
		{		
			//TweenLite.killDelayedCallsTo( loadLevel  );
			addLevel();
		}	
		
		private function addBG():void 
		{
			/*
			_baseBG = new GrassBaseBGMC();
			_bgHolder.addChild( _baseBG );
			//_baseBG.cacheAsBitmap = true;
			
			_bg = new BG1MC();
			_bgHolder.addChild( _bg );
			_bg.x = -725;
			//_bg.cacheAsBitmap = true;
			
			
			_bg2 = new BG1_2MC();
			_bgHolder.addChild( _bg2 );
			//_bg2.cacheAsBitmap = true;
			_bg2.x = _bg.width - 10;
			*/
			//addEventListener( Event.ENTER_FRAME, onEnterFrame );
			var map:int = _gdc.getCurrentMap();
			var level:int = _gdc.getCurrLevel();
			
			if ( map == 1 ) {
				_mainBg = new GrassBG();
			}else if ( map == 2 ){
				_mainBg = new DessertBG();
			}else if ( map == 3 ){
				_mainBg = new DarkBGMC();
			}
			
			if ( _gdc.getIsGoingToShop() ) {
				_mainBg = new ShopBGMC();
			}		
			
			_bgHolder.addChild( _mainBg );
		}
		
		private function removeBG():void 
		{
			/*
			if ( _bg != null ){
				//removeEventListener( Event.ENTER_FRAME, onEnterFrame );
				if ( _bgHolder.contains( _bg ) ) {
					_bgHolder.removeChild( _bg );
					_bg = null;
				}
			}
			
			if ( _bg2 != null ){				
				if ( _bgHolder.contains( _bg2 ) ) {
					_bgHolder.removeChild( _bg2 );
					_bg2 = null;
				}
			}
			
			
			if ( _baseBG != null ){				
				if ( _bgHolder.contains( _baseBG ) ) {
					_bgHolder.removeChild( _baseBG );
					_baseBG = null;
				}
			}*/
			
			if ( _mainBg != null ){
				//removeEventListener( Event.ENTER_FRAME, onEnterFrame );
				if ( _bgHolder.contains( _mainBg ) ) {
					_bgHolder.removeChild( _mainBg );
					_mainBg = null;
				}
			}
		}
		
		/*
		private function onEnterFrame(e:Event):void{
			var playerPos:DisplayObject = _level.getPlayer();			
			var min:Number = 55;
			var max:Number = 1347;
			var xDelay:Number = 0.05;
			var yDelay:Number = 0.05;			
			
			_bg.x = -playerPos.x * xDelay;
			_bg2.x = _bg.x  +  ( _bg.width - 30 );			
			
            _bg.y = ( playerPos.y + (  stage.stageHeight * 0.75 ) ) * yDelay;
			_bg2.y = ( playerPos.y + (  stage.stageHeight * 0.75 ) ) * yDelay;
		}
		*/
		/*--------------------------------------------------------------------EventHandler----------------------------------------------------------------*/	
		private function onPickUpItem(e:CaveSmashEvent):void 
		{
			trace( "[ World ]:onPickUpItem what item: " + e.obj.itemType );
			
			var itemType:String = e.obj.itemType;
			var soundGUI:SoundGUI = SoundGUI.getIntance();
			
			switch ( itemType ) 
			{
				case ItemConfig.KEY:
					_gdc.setIsKeyCollected( true );
					soundGUI.playSFX( SoundGUI.COLLECT_KEY_SFX );
				break;
				
				case ItemConfig.GOLD:
					_gdc.updateGold( 1 );
					soundGUI.playSFX( SoundGUI.COLLECT_COIN_SFX );
				break;				
				
				case ItemConfig.CRYSTAL:
					_gdc.updateCrystal( 1 );
					soundGUI.playSFX( SoundGUI.COLLECT_CRYSTAL_SFX );
				break;				
				
				case ItemConfig.HEART:
					_gdc.updateLive( 1 );
					soundGUI.playSFX( SoundGUI.COLLECT_HEART_SFX );
				break;
				
				default:
			}
			
			trace( "[ World ]: check all collected items "
					+ " lives/heart: " + _gdc.getLive()
					+ " gold: " + _gdc.getGold()
					+ " Total Gold: " + _gdc.getTotalGold()
					+ " crstal: " + _gdc.getCrystal()					
					+ " isKeyCollected: " + _gdc.getIsKeyCollected()
				);
		}		
		
		private function onLevelFailed(e:CaveSmashEvent):void 
		{				
			trace( "[ World ]:onLevelFailed!!!! " );
		}
		
		private function onLoadLevel(e:CaveSmashEvent):void 
		{			
			trace( "[ World ]:onLoadLevel! current level " + _gdc.getCurrLevel() );
			trace( "[ World ]:level " + _gdc.getLevel() );
			
			removeLevel();
			loadLevel();
			//TweenLite.delayedCall( DELAY_LOAD_LEVEL, loadLevel );
		}	
		
		private function onReloadLevel(e:CaveSmashEvent):void 
		{		
			removeLevel();
			TweenLite.delayedCall( DELAY_LOAD_LEVEL, reloadLevel );			
		}
	}
}