package com.monsterPatties.ui 
{
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Elastic;
	import com.greensock.TweenLite;
	import com.monsterPatties.config.ContentConfig;
	import com.monsterPatties.controllers.GameDataController;
	import com.monsterPatties.events.CaveSmashEvent;
	import com.monsterPatties.events.GameEvent;
	import com.monsterPatties.utils.displayManager.config.DisplayManagerConfig;
	import com.monsterPatties.utils.displayManager.DisplayManager;
	import com.monsterPatties.utils.eventSatellite.EventSatellite;
	import com.monsterPatties.utils.Helper;
	import com.monsterPatties.views.LevelClearPopUp;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.TextField;
	import misc.Util;
	/**
	 * ...
	 * @author jc
	 */
	public class MessageGUI extends Sprite
	{
		/*----------------------------------------------------------------------Constant--------------------------------------------------------------*/
		private static const LEVEL_FAIL_POSITION:Point = new Point(-17.75,187.3  );
		private static const LEVEL_COMPLETE_POSITION:Point = new Point( -9.5, 129.65 );
		/*----------------------------------------------------------------------Properties------------------------------------------------------------*/
		private var _levelFail:LevelFailMC;
		private var _levelComplete:LevelCompleteMC;
		private var _levelClear:LevelClearPopUp;
		
		private var _es:EventSatellite;
		private var _gdc:GameDataController;
		private var _caveSmashEvent:CaveSmashEvent;
		private var _curtain:Sprite;
		private var _dm:DisplayManager;
		private var messageInfoBox:MessageInfoBox;
		private var _cover:Sprite;
		private var _gameEvent:GameEvent;
		private var txtPressSpace:TextField;
		/*----------------------------------------------------------------------Constructor-----------------------------------------------------------*/
		
		
		public function MessageGUI(  ) 
		{			
			addEventListener( Event.ADDED_TO_STAGE, init );
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener( Event.REMOVED_FROM_STAGE, destroy );
			initControllers();
			initEventListeners();
			setDisplay();
		}
		
		private function destroy(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			removeEventListeners();
			removeDisplay();
		}
		
		/*----------------------------------------------------------------------Methods--------------------------------------------------------------*/
		private function setDisplay():void 
		{
			
		}
		
		private function removeDisplay():void 
		{
			
		}
		
		private function initEventListeners():void 
		{
			_es =  EventSatellite.getInstance();
			_es.addEventListener( CaveSmashEvent.LEVEL_FAILED, onLevelFail );
			_es.addEventListener( CaveSmashEvent.LEVEL_COMPLETE, onLevelComplete );
			_es.addEventListener( CaveSmashEvent.RELOAD_LEVEL, onReloadLevel );
			_es.addEventListener( CaveSmashEvent.LEVEL_QUIT, onQuitLevel );
			_es.addEventListener( CaveSmashEvent.ON_SHOW_CRYSTAL_INFO, onShowCrystalInfo );			
			_es.addEventListener( CaveSmashEvent.ON_SHOW_COIN_INFO, onShowCoinInfo );
			_es.addEventListener( CaveSmashEvent.ON_REMOVE_INFO, onRemoveCrystalInfo );
		}
		
		private function removeEventListeners():void
		{			
			_es.removeEventListener( CaveSmashEvent.LEVEL_COMPLETE, onLevelComplete );
			_es.removeEventListener( CaveSmashEvent.LEVEL_FAILED, onLevelFail );
			_es.removeEventListener( CaveSmashEvent.RELOAD_LEVEL, onReloadLevel );
			_es.removeEventListener( CaveSmashEvent.LEVEL_QUIT, onQuitLevel );
			_es.removeEventListener( CaveSmashEvent.ON_SHOW_CRYSTAL_INFO, onShowCrystalInfo );			
			_es.removeEventListener( CaveSmashEvent.ON_SHOW_COIN_INFO, onShowCoinInfo );
			_es.removeEventListener( CaveSmashEvent.ON_REMOVE_INFO, onRemoveCrystalInfo );
		}	
		
		private function initControllers():void 
		{
			_gdc = GameDataController.getInstance();			
		}
		
		private function removeControllers():void 
		{
			//reset date here ????
		}
		
		private function showLevelFail():void 
		{
			if( _levelFail == null ){
				_levelFail = new LevelFailMC();
				addChild( _levelFail );
				_levelFail.x = LEVEL_FAIL_POSITION.x;
				_levelFail.y = LEVEL_FAIL_POSITION.y;
				_levelFail.addFrameScript( _levelFail.totalFrames - 2,  exitFailAnimation );
			}
		}
		
		private function exitFailAnimation(  ):void 
		{
			_levelFail.stop();
			TweenLite.to( _levelFail, 2, { alpha:0, onComplete:removeLevelFail } );
		}
		
		private function removeLevelFail():void 
		{
			if ( _levelFail != null ) {
				TweenLite.killTweensOf( _levelFail )
				if ( this.contains( _levelFail ) ) {
					this.removeChild( _levelFail )
					_levelFail = null;
					_caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.RELOAD_LEVEL );
					_es.dispatchESEvent( _caveSmashEvent );
				}
			}
		}
		
		private function showLevelComplete():void
		{
			if ( _levelComplete == null ){				
				_levelComplete = new LevelCompleteMC();
				addChild( _levelComplete );
				_levelComplete.x = LEVEL_COMPLETE_POSITION.x;
				_levelComplete.y = LEVEL_COMPLETE_POSITION.y;
				_levelComplete.addFrameScript( _levelComplete.totalFrames - 2,  exitCompleteAnimation );				
			}
		}
		
		private function fadeToBlackTransition():void 
		{
			_curtain =  new Sprite();
			_curtain.graphics.lineStyle( 1, 0x000000);
			_curtain.graphics.beginFill( 0x000000, 1  );
			_curtain.graphics.drawRect( 0, 0, 640, 480 );
			addChild( _curtain );
			_curtain.alpha = 0;
			
			TweenLite.to( _curtain, 0.5, { alpha:1, onComplete:removeFadeToBlackTimer } );			
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
		
		private function removeFadeToBlackTimer():void 
		{
			TweenLite.delayedCall( 0.5, removeFadeToBlackTransition );	
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
		
		private function removeLevelComplete():void 
		{
			if ( _levelComplete != null ) {
				TweenLite.killTweensOf( _levelComplete )
				if ( this.contains( _levelComplete ) ) {
					this.removeChild( _levelComplete )
					_levelComplete = null;
					checkWhatLevelToLoad();					
				}
			}
		}
		
		private function exitCompleteAnimation(  ):void 
		{			
			_levelComplete.stop();
			TweenLite.to( _levelComplete, 2, { alpha:0, onComplete:removeLevelComplete } );			
		}
		
		private function checkWhatLevelToLoad():void
		{
			_dm = DisplayManager.getInstance();
			_dm.loadSubScreen( DisplayManagerConfig.LEVEL_CLEAR_WINDOW );
		}
		
		private function addMessageInfoBox( id:int, msg:String ):void 
		{
			if ( messageInfoBox == null ){
				addCover();
				_gdc.setIsLockControlls( true );
				addTxtPressSpace();
				
				_gameEvent = new GameEvent( GameEvent.GAME_PAUSED );
				_es.dispatchESEvent( _gameEvent );
				
				if ( id == 0 ){
					_gdc.setCrystalTutorial( true );
				}else if ( id == 1 ){
					_gdc.setCoinTutorial( true );
				}
				messageInfoBox = new MessageInfoBox(id,msg);
				messageInfoBox.msg = msg;
				messageInfoBox.id = id;
				addChild( messageInfoBox );
				messageInfoBox.x = ( stage.stageWidth * 0.5 );
				//messageInfoBox.y = ( stage.stageHeight * 0.25 );
				messageInfoBox.y = ( stage.stageHeight * 0.5 );
				//messageInfoBox.scaleX = 0;
				//messageInfoBox.scaleY = 0;
				//TweenLite.to( messageInfoBox, 0.5, { scaleX:1, scaleY:1, ease:Cubic.easeOut } );
			}
		}
		
		private function removeMessageInfoBox():void 
		{
			if ( messageInfoBox != null ) {
				removeTxtPressSpace();
				_gameEvent = new GameEvent( GameEvent.GAME_UNPAUSED );
				_es.dispatchESEvent( _gameEvent );
				
				removeCover();
				_gdc.setIsLockControlls( false );
				TweenLite.killTweensOf( messageInfoBox );
				if ( this.contains( messageInfoBox ) ) {
					this.removeChild( messageInfoBox );
					messageInfoBox = null;
				}
			}
		}
		
		private function addTxtPressSpace():void 
		{
			if( txtPressSpace ==null ){
				txtPressSpace = Helper.createTextField("press \"space\" to continue!", 30, 400, 130,0xFFCC00, "JasmineUPC" );
				addChild( txtPressSpace );			
				txtPressSpace.x = ( ( stage.stageWidth * 0.5 ) - ( txtPressSpace.width * 0.5 ) ) + 20;
				txtPressSpace.y = ( stage.stageHeight * 0.75 );			
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
		/*----------------------------------------------------------------------Setters--------------------------------------------------------------*/
		
		/*----------------------------------------------------------------------Getters--------------------------------------------------------------*/
		
		/*----------------------------------------------------------------------EventHandlers--------------------------------------------------------*/
		private function onLevelFail(e:CaveSmashEvent):void 
		{
			removeMessageInfoBox();
			showLevelFail();
		}
		
		private function onLevelComplete(e:CaveSmashEvent):void 
		{
			removeMessageInfoBox();
			if( _gdc.getIsDoneLevel() ){
				//showLevelComplete();
				checkWhatLevelToLoad();
			}else {
				fadeToBlackTransition();
			}
		}
		
		private function onReloadLevel(e:CaveSmashEvent):void 
		{
			removeMessageInfoBox();
		}
		
		private function onQuitLevel(e:CaveSmashEvent):void 
		{
			removeMessageInfoBox();
		}
		
		private function onShowCrystalInfo(e:CaveSmashEvent):void{		
			//addMessageInfoBox( 0, "you need to collect crystal to unlock next levels and maps" );			
			addMessageInfoBox( 0, ContentConfig.TUT_CRYSTAL );			
		}
		
		private function onRemoveCrystalInfo(e:CaveSmashEvent):void 
		{
			removeMessageInfoBox();
			stage.focus = this;
		}
		
		private function onRemoveCoinInfo(e:CaveSmashEvent):void 
		{
			removeMessageInfoBox();
			stage.focus = this;
		}
		
		private function onShowCoinInfo(e:CaveSmashEvent):void 
		{
			//addMessageInfoBox( 1,"you need to collect coin to buy items and upgrades" );
			addMessageInfoBox( 1,ContentConfig.TUT_COIN );
		}
	}

}