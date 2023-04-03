package com.monsterPatties.ui 
{
	import com.monsterPatties.config.CaveSmashConfig;
	import com.monsterPatties.controllers.GameDataController;
	import com.monsterPatties.utils.displayManager.config.DisplayManagerConfig;
	import com.monsterPatties.utils.displayManager.DisplayManager;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author jc
	 */
	public class LevelBtn extends Sprite
	{
		private var _mc:LevelBtnMC;
		public var id:int;
		public var map:int;
		public var btnLabel:String;
		public var crystalStatus:String;
		
		private var _dm:DisplayManager;
		private var _gdc:GameDataController;
		
		
		public function LevelBtn() 
		{
			addEventListener( Event.ADDED_TO_STAGE, init );
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener( Event.REMOVED_FROM_STAGE, destroy );
			initControllers();
			setDisplay();
		}
		
		private function destroy(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			removeDisplay();
		}
		
		
		/*-----------------------------------------------------------------------Methods---------------------------------------------------------------*/
		
		private function initControllers():void 
		{
			_gdc = GameDataController.getInstance();
			_dm = DisplayManager.getInstance();
		}
		
		private function removeControllers():void 
		{
			
		}
		
		private function setDisplay():void 
		{
			_mc = new LevelBtnMC();
			addChild( _mc );
			_mc.buttonMode = true;			
			
			//trace( " _gdc.getMap()  " + _gdc.getMap() + " id " + id + " map " + map );
			var level:int = int( btnLabel );
			
			if ( _gdc.getLevel() >= level && _gdc.getMap() >= map ) {			
				_mc.xMark.visible = false;
			}
			
			/*
			if ( _gdc.getMap() >= map ){
				_mc.xMark.visible = false;
			}else if ( _gdc.getLevel() >= level ) {
				_mc.xMark.visible = false;
			}*/
			
			_mc.txtCrystal.text = _gdc.getCollectedCrystalByMapAndLevel( map ,level ) + "/" + CaveSmashConfig.MAX_CRYSTALS_PER_LEVEL;
			_mc.txtLabel.text = btnLabel;
			
			_mc.addEventListener( MouseEvent.CLICK, onClick );
			_mc.addEventListener( MouseEvent.ROLL_OVER, onRollOverClick );
			_mc.addEventListener( MouseEvent.ROLL_OUT, onRollOutClick );
		}			
		
		private function removeDisplay():void 
		{
			if ( _mc != null ) {
				_mc.removeEventListener( MouseEvent.CLICK, onClick );
				_mc.removeEventListener( MouseEvent.ROLL_OVER, onRollOverClick );
				_mc.removeEventListener( MouseEvent.ROLL_OUT, onRollOutClick );				
				if ( this.contains( _mc ) ) {
					this.removeChild( _mc );
					_mc = null;
				}
			}
		}
		
		private function loadLevel():void 
		{
			//for now don't activate other map because there's still no levels availble for other map
			//if( ( _gdc.getCurrentMap() + 1 ) == 1 ){
				//_dm.loadScreen( DisplayManagerConfig.GAME_SCREEN );
			//}
			
			_dm.loadScreen( DisplayManagerConfig.GAME_SCREEN );
		}
		
		/*----------------------------------------------------------------------EventHandlers----------------------------------------------------------*/
		
		private function onRollOutClick(e:MouseEvent):void 
		{			
			_mc.gotoAndStop( 1 );			
			//trace( "rollout check id " + id );
		}
		
		private function onRollOverClick(e:MouseEvent):void 
		{
			_mc.gotoAndStop( 2 );
			//trace( "rollover check id " + id );
		}
		
		private function onClick(e:MouseEvent):void 
		{
			_mc.gotoAndStop( 3 );
			
			var level:int = int( btnLabel );
			if ( _gdc.getLevel() >= level && ( _gdc.getMap() + 1 ) > _gdc.getCurrentMap() ) {
				trace( "load level now!!!" );
				_gdc.setCurrLevel( id );
				loadLevel();			
			}
			trace( "check id " + id + "current map" + _gdc.getCurrentMap() + " current level " + _gdc.getCurrLevel() + " level " + _gdc.getLevel() + "btnLevel" + level );
			trace( "map: " + ( _gdc.getMap() + 1 ) );
		}
	}

}