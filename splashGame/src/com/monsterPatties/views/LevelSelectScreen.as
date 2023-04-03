package com.monsterPatties.views 
{	
	import com.greensock.TweenLite;
	import com.monsterPatties.controllers.GameDataController;
	import com.monsterPatties.ui.LevelBtn;
	import com.monsterPatties.ui.LevelSet;
	import com.monsterPatties.utils.buttonManager.ButtonManager;
	import com.monsterPatties.utils.buttonManager.events.ButtonEvent;
	import com.monsterPatties.utils.displayManager.config.DisplayManagerConfig;
	import com.monsterPatties.utils.displayManager.DisplayManager;
	import com.monsterPatties.utils.displayManager.Window;	
	import flash.display.Sprite;
	/**
	 * ...
	 * @author jc
	 */
	public class LevelSelectScreen extends Window
	{
		/*----------------------------------------------------------Constant---------------------------------------------------------------*/
		private static var MIN_MAP:int = 0;
		private static var MAX_MAP:int = 3;
		private static var NAVIGATION_IN:Number = 1;
		private static var NAVIGATION_OUT:Number = 0.5;		
		
		/*----------------------------------------------------------Properties---------------------------------------------------------------*/				
		private var _mc:LevelSelectMC;
		private var _bm:ButtonManager;
		private var _gdc:GameDataController;
		private var _dm:DisplayManager;
		private var _levelSetCollection:Vector.<LevelSet>;
		
		private var _levelBtnHolder:Sprite;
		private var _levelBtnCollection:Vector.<LevelBtn>;
		private var _currentMap:int;	
		private var _levelSelectLower:LevelSelectLowerMC;		
		/*----------------------------------------------------------Constructor---------------------------------------------------------------*/
		public function LevelSelectScreen( windowName:String, winWidth:Number = 0, winHeight:Number = 0 , hideWindowName:Boolean = false ) 
		{			
			super( windowName , winWidth, winHeight );
		}		
		
		/*----------------------------------------------------------Methods---------------------------------------------------------------*/
		private function setDisplay():void 
		{	
			_mc = new LevelSelectMC();			
			addChild( _mc );		
			
			createLevelSets();			
			updateMapLevels();			
			
			updateMapInfo();
			
			_levelSelectLower = new LevelSelectLowerMC();
			addChild( _levelSelectLower );
			_levelSelectLower.y = 410;
			
			_bm = new ButtonManager();
			
			if( _levelSelectLower != null ){
				_bm.addBtnListener( _levelSelectLower.nextBtn );
				_bm.addBtnListener( _levelSelectLower.prevBtn );
				_bm.addBtnListener( _levelSelectLower.upgradeBtn );
				
				_bm.addEventListener( ButtonEvent.CLICK_BUTTON, onClickBtn );
				_bm.addEventListener( ButtonEvent.ROLL_OVER_BUTTON, onRollOverBtn );
				_bm.addEventListener( ButtonEvent.ROLL_OUT_BUTTON, onRollOutBtn );
			}
		}		
		
		private function removeDisplay():void 
		{				
			if ( _mc != null ){				
				if( _levelSelectLower != null ){
					_bm.removeBtnListener( _levelSelectLower.nextBtn );
					_bm.removeBtnListener( _levelSelectLower.prevBtn );
					_bm.removeBtnListener( _levelSelectLower.upgradeBtn );		
					
					_bm.removeEventListener( ButtonEvent.CLICK_BUTTON, onClickBtn );
					_bm.removeEventListener( ButtonEvent.ROLL_OVER_BUTTON, onRollOverBtn );
					_bm.removeEventListener( ButtonEvent.ROLL_OUT_BUTTON, onRollOutBtn );
					_bm.clearButtons();
					_bm = null;	
					
					if ( _levelSelectLower != null ) {
						if ( this.contains( _levelSelectLower ) ) {
							this.removeChild( _levelSelectLower );
							_levelSelectLower = null;
						}
					}
				}				
				
				if ( this.contains( _mc ) ) {
					this.removeChild( _mc );
					_mc = null;
				}
			}
		}
		
		private function createLevelSets():void 
		{		
			_levelSetCollection = new Vector.<LevelSet>();			
			var xOffset:int = 640;
			var levelSet:LevelSet;
			
			for (var i:int = 0; i < MAX_MAP; i++)
			{
				levelSet = new LevelSet();
				levelSet.id = i;
				addChild( levelSet );
				levelSet.x = ( levelSet.width + xOffset ) * i;				
				_levelSetCollection.push( levelSet );
			}			
		}
		
		
		private function removeLevelSets():void 
		{
			var len:int = _levelSetCollection.length;
			
			for (var i:int = len - 1; i >= 0; i--) 
			{
				if ( _levelSetCollection[ i ] != null  ) {
					if ( this.contains( _levelSetCollection[ i ] ) ) {
						this.removeChild( _levelSetCollection[ i ] );
						_levelSetCollection[ i ] = null;
						_levelSetCollection.splice( i , 0 );
						//trace( "remove splice " + i );
					}
				}
			}			
			_levelSetCollection = new Vector.<LevelSet>();
		}
		
		override public function initWindow():void{
			super.initWindow();
			
			initControllers();
			setDisplay(  );				
			trace( windowName + " init!!" );
		}
		
		override public function clearWindow():void 
		{			
			super.clearWindow();
			removeLevelSets();
			removeDisplay();
			trace( windowName + " destroyed!!" );
		}
		
		private function initControllers():void 
		{
			_dm = DisplayManager.getInstance();		
			_gdc = GameDataController.getInstance();
		}        
        
		private function updateMapInfo():void 
		{
			//trace( "maps" + maps );
			_gdc.setCurrentMap( _currentMap );			
			_gdc.setIsDoneLevel( true );
			_gdc.setCurrentSubLevel( 0 );			
		}
		
		
		private function nextMap():void 
		{
			if ( _currentMap < ( MAX_MAP - 1 ) ){
				TweenLite.to( _levelSetCollection[ _currentMap ], NAVIGATION_OUT, { x:-640 }  );
				_currentMap++;
				if( _currentMap < MAX_MAP ){
					TweenLite.to( _levelSetCollection[ _currentMap ], NAVIGATION_IN, { x:0 }  );
					updateMapInfo();
				}
				trace( "currentMap " + _currentMap );
			}			
		}
		
		
		
		
		private function prevMap():void 
		{
			if ( _currentMap > MIN_MAP ){
				TweenLite.to( _levelSetCollection[ _currentMap ], NAVIGATION_OUT, { x:(640 * 2 ) }  );
				_currentMap--;
				TweenLite.to( _levelSetCollection[ _currentMap ], NAVIGATION_IN, { x:0 }  );
				updateMapInfo();
				trace( "currentMap " + _currentMap );
			}
		}
		
		
		private function updateMapLevels():void 
		{			
			var curr:int = _currentMap;			
			
			for (var i:int = 0; i <= curr; i++)
			{			
				if ( i == _currentMap ) {
					_levelSetCollection[ i ].x = 0;
				}else {
					_levelSetCollection[ i ].x = -640;
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
				case "nextBtn":
					_levelSelectLower.nextBtn.gotoAndStop( 1 );
				break;
                
				case "prevBtn":
					_levelSelectLower.prevBtn.gotoAndStop( 1 );
				break;
				case "upgradeBtn":
					_levelSelectLower.upgradeBtn.gotoAndStop( 1 );
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
				case "nextBtn":
					_levelSelectLower.nextBtn.gotoAndStop( 2 );
				break;
                
				case "prevBtn":
					_levelSelectLower.prevBtn.gotoAndStop( 2 );
				break;
				case "upgradeBtn":
					_levelSelectLower.upgradeBtn.gotoAndStop( 2 );
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
				case "nextBtn":
					_levelSelectLower.nextBtn.gotoAndStop( 3 );
					nextMap();
				break;
                
				case "prevBtn":
					_levelSelectLower.prevBtn.gotoAndStop( 3 );
					prevMap();
				break;
				case "upgradeBtn":
					_levelSelectLower.upgradeBtn.gotoAndStop( 3 );
					_dm.loadScreen( DisplayManagerConfig.SHOP_WINDOW );
				break;		
				
				default:
					
				break;
			}
		}
		
	}

}