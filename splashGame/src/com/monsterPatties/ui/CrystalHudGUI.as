package com.monsterPatties.ui 
{
	import com.monsterPatties.controllers.GameDataController;
	import com.monsterPatties.events.CaveSmashEvent;
	import com.monsterPatties.events.GameEvent;
	import com.monsterPatties.utils.eventSatellite.EventSatellite;
	import components.items.ItemConfig;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author jc
	 */
	public class CrystalHudGUI extends Sprite
	{
		/*----------------------------------------------------------------------Constant--------------------------------------------------------------*/
		
		/*----------------------------------------------------------------------Properties------------------------------------------------------------*/
		private var _crystalHudGUI:crystalHudMC;
		private var _xpos:Number = 0;
		private var _ypos:Number = 0;
		private var _es:EventSatellite;
		private var _gdc:GameDataController;
		/*----------------------------------------------------------------------Constructor-----------------------------------------------------------*/
		
		
		public function CrystalHudGUI( xpos:Number = 0, ypos:Number = 0 ) 
		{
			_xpos = xpos;
			_ypos = ypos;
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
			_crystalHudGUI = new crystalHudMC();
			addChild( _crystalHudGUI );
			_crystalHudGUI.x = _xpos;
			_crystalHudGUI.y = _ypos;
		}
		
		private function removeDisplay():void 
		{
			if ( _crystalHudGUI != null ) {
				if ( this.contains( _crystalHudGUI ) ) {
					this.removeChild( _crystalHudGUI )
					_crystalHudGUI = null;
				}
			}
		}
		
		private function initEventListeners():void 
		{
			_es =  EventSatellite.getInstance();			
			_es.addEventListener( CaveSmashEvent.PICK_UP_ITEM, onPickUpItem );
			_es.addEventListener( CaveSmashEvent.LOAD_LEVEL, onResetCrystal );
			_es.addEventListener( CaveSmashEvent.RELOAD_LEVEL, onResetCrystal );			
		}	
		
		private function removeEventListeners():void 
		{			
			_es.removeEventListener( CaveSmashEvent.PICK_UP_ITEM, onPickUpItem );
			_es.removeEventListener( CaveSmashEvent.LOAD_LEVEL, onResetCrystal );
			_es.removeEventListener( CaveSmashEvent.RELOAD_LEVEL, onResetCrystal );
		}
		
		private function initControllers():void 
		{
			_gdc = GameDataController.getInstance();			
		}
		
		private function removeControllers():void 
		{
			//reset date here ????
		}
		
		private function updateCrystalHud( crystal:int = 0 ):void 
		{
			if ( _crystalHudGUI != null ){				
				switch ( crystal ) 
				{
					case 1:
						_crystalHudGUI.gotoAndStop( 2 );
					break;
					
					case 2:
						_crystalHudGUI.gotoAndStop( 3 );
					break;
					
					case 3:
						_crystalHudGUI.gotoAndStop( 4 );
					break;
					
					case 0:
						_crystalHudGUI.gotoAndStop( 1 );
					break;
					
					default:
				}
			}
		}
		/*----------------------------------------------------------------------Setters--------------------------------------------------------------*/
		
		/*----------------------------------------------------------------------Getters--------------------------------------------------------------*/
		
		/*----------------------------------------------------------------------EventHandlers--------------------------------------------------------*/
			
		private function onPickUpItem(e:CaveSmashEvent):void 
		{
			var itemType:String = e.obj.itemType;
			if ( itemType == ItemConfig.CRYSTAL ) {
				var crystal:int = _gdc.getCrystal();
				updateCrystalHud(crystal);
			}
		}		
		
		private function onResetCrystal(e:CaveSmashEvent):void 
		{
			updateCrystalHud(0);
		}
	}

}