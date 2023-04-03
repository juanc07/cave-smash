package com.monsterPatties.views 
{	
	import com.monsterPatties.controllers.GameDataController;
	import com.monsterPatties.ui.ItemBox;
	import com.monsterPatties.utils.buttonManager.ButtonManager;
	import com.monsterPatties.utils.buttonManager.events.ButtonEvent;
	import com.monsterPatties.utils.displayManager.config.DisplayManagerConfig;
	import com.monsterPatties.utils.displayManager.DisplayManager;
	import com.monsterPatties.utils.displayManager.Window;
	/**
	 * ...
	 * @author jc
	 */
	public class ShopScreen extends Window
	{
		/*----------------------------------------------------------Constant---------------------------------------------------------------*/
		
		/*----------------------------------------------------------Properties---------------------------------------------------------------*/				
		private var _mc:ShopWindowMC;
		private var _bm:ButtonManager;
		private var _dm:DisplayManager;
		private var _gdc:GameDataController;
		private var _itemList:Vector.<ItemBox>
		
		/*----------------------------------------------------------Constructor---------------------------------------------------------------*/
		public function ShopScreen( windowName:String, winWidth:Number = 0, winHeight:Number = 0 , hideWindowName:Boolean = false ) 
		{			
			super( windowName , winWidth, winHeight );
		}		
		
		/*----------------------------------------------------------Methods---------------------------------------------------------------*/
		private function setDisplay():void 
		{	
			_mc = new ShopWindowMC();
			addChild( _mc );
			_mc.x = 0;
			_mc.y = 0;
			initData();
			
			
			_bm = new ButtonManager();			
			_bm.addBtnListener( _mc.homeBtn );
			_bm.addBtnListener( _mc.resumeBtn );
			_bm.addBtnListener( _mc.armoryBtn );
			_bm.addBtnListener( _mc.accBtn );
			_bm.addBtnListener( _mc.powerUpBtn );
			_bm.addEventListener( ButtonEvent.CLICK_BUTTON, onClickBtn );
			_bm.addEventListener( ButtonEvent.ROLL_OVER_BUTTON, onRollOverBtn );
			_bm.addEventListener( ButtonEvent.ROLL_OUT_BUTTON, onRollOutBtn );
		}		
		
		private function initData():void 
		{
			_gdc = GameDataController.getInstance();
			var gold:int = _gdc.getTotalGold();
			_mc.txtGold.text = String( gold );
			
			_itemList = new Vector.<ItemBox>();
			var itemCount:int = 4;
			var itemBox:ItemBox;
			for (var i:int = 0; i < itemCount; i++) 
			{
				itemBox = new ItemBox( i, "test item", "some info", ( 50 * i ) + 50 );
				addChild( itemBox );
				_itemList.push( itemBox );
				itemBox.x = 20;
				itemBox.y = 140 + ( itemBox.height * i );
			}
		}
		
		private function removeItemBoxs():void 
		{
			var len:int = _itemList.length;
			
			for (var i:int = len - 1; i >= 0; i--) 
			{
				if( _itemList[ i ] != null  ){
					if ( this.contains( _itemList[ i ] ) ) {
						this.removeChild( _itemList[i] );
						_itemList[i] = null;
						_itemList.splice( i, 1 );						
					}
				}
			}
		}
		
		private function removeDisplay():void 
		{				
			if ( _mc != null ) {
				removeItemBoxs();
				_bm.removeBtnListener( _mc.homeBtn );
				_bm.removeBtnListener( _mc.resumeBtn );
				_bm.removeBtnListener( _mc.armoryBtn );
				_bm.removeBtnListener( _mc.accBtn );
				_bm.removeBtnListener( _mc.powerUpBtn );
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
			_dm = DisplayManager.getInstance();			
		}        
        
		/*----------------------------------------------------------Setters---------------------------------------------------------------*/
		
		/*----------------------------------------------------------Getters---------------------------------------------------------------*/		
		
		
		/*----------------------------------------------------------EventHandlers---------------------------------------------------------------*/		
		private function onRollOutBtn(e:ButtonEvent):void 
		{
			var btnName:String = e.obj.name;
			
			switch ( btnName ) 
			{				
				case "homeBtn":
					_mc.homeBtn.gotoAndStop( 1 );
				break;
                
				case "resumeBtn":
					_mc.resumeBtn.gotoAndStop( 1 );
				break;			
				
				case "armoryBtn":
					_mc.armoryBtn.gotoAndStop( 3 );
				break;
                
				case "accBtn":
					_mc.accBtn.gotoAndStop( 3 );
				break;
				
				case "powerUpBtn":
					_mc.powerUpBtn.gotoAndStop( 3 );
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
				case "homeBtn":
					_mc.homeBtn.gotoAndStop( 2 );
				break;
                
				case "resumeBtn":
					_mc.resumeBtn.gotoAndStop( 2 );
				break;
				
				case "armoryBtn":
					_mc.armoryBtn.gotoAndStop( 2 );
				break;
                
				case "accBtn":
					_mc.accBtn.gotoAndStop( 2 );
				break;
				
				case "powerUpBtn":
					_mc.powerUpBtn.gotoAndStop( 2 );
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
				case "homeBtn":					
					_mc.homeBtn.gotoAndStop( 3 );
					_dm.loadScreen( DisplayManagerConfig.TITLE_SCREEN );
				break;
                
				case "resumeBtn":					
					_mc.resumeBtn.gotoAndStop( 3 );
					//_dm.loadScreen( DisplayManagerConfig.LEVEL_SELECTION_SCREEN );
					_dm.loadScreen( DisplayManagerConfig.MAP_SCREEN );
				break;			
				
				case "armoryBtn":
					_mc.armoryBtn.gotoAndStop( 3 );
				break;
                
				case "accBtn":
					_mc.accBtn.gotoAndStop( 3 );
				break;
				
				case "powerUpBtn":
					_mc.powerUpBtn.gotoAndStop( 3 );
				break;
				
				default:
				break;
			}
		}		
	}
}