package com.monsterPatties.ui 
{
	import com.monsterPatties.controllers.GameDataController;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author jc
	 */
	public class ItemBox extends Sprite
	{
		/*------------------------------------------Constant------------------------------------------------------------------------*/
		
		/*------------------------------------------Properties------------------------------------------------------------------------*/
		private var _mc:ShopItemInfoMC;
		private var _itemId:int;
		private var _itemName:String;
		private var _itemInfo:String;
		private var _itemPrice:int;
		private var _gdc:GameDataController;
		/*------------------------------------------Constructor------------------------------------------------------------------------*/
		public function ItemBox( itemId:int, itemName:String, itemInfo:String, itemPrice:int ) 
		{
			_itemId = itemId;
			_itemName = itemName;
			_itemInfo = itemInfo;
			_itemPrice = itemPrice;
			_gdc = GameDataController.getInstance();
			
			addEventListener( Event.ADDED_TO_STAGE, init );
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener( Event.REMOVED_FROM_STAGE, destroy );
			setDisplay();
		}
		
		private function destroy(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			removeDisplay();
		}
		
		/*------------------------------------------methods------------------------------------------------------------------------*/
		private function setDisplay():void 
		{
			if ( _mc == null ){
				_mc =  new ShopItemInfoMC();
				addChild( _mc );				
				
				_mc.icon.gotoAndStop( _itemId + 1 );
				_mc.txtName.text = _itemName;				
				_mc.buyBtn.buttonMode = true;
				_mc.buyBtn.txtPrice.text = String(_itemPrice);
				_mc.buyBtn.addEventListener( MouseEvent.CLICK, onBuyItem );				
			}
		}		
		
		private function removeDisplay():void 
		{
			if ( _mc != null ){
				if ( this.contains( _mc ) ) {
					_mc.buyBtn.buttonMode = false;
					_mc.buyBtn.removeEventListener( MouseEvent.CLICK, onBuyItem );
					this.removeChild( _mc );
					_mc = null;
				}
			}
		}
		/*------------------------------------------Setters------------------------------------------------------------------------*/
		/*------------------------------------------Getters------------------------------------------------------------------------*/
		/*------------------------------------------EventHandlers-------------------------------------------------------------------*/
		private function onBuyItem(e:MouseEvent):void 
		{
			trace( "buy item itemId " + _itemId + " itemName " + _itemName + " _itemPrice " + _itemPrice );
			var gold:int = _gdc.getTotalGold();
			//if ( gold  >= _itemPrice ){
				if ( _itemId == 0 && !_gdc.hasDoubleJump() ) {
					_gdc.setDoubleJump( true );
				}else if ( _itemId == 1 && !_gdc.hasComboAttack() ) {
					_gdc.setComboAttack( true );
				}else if ( _itemId == 2 && !_gdc.hasThrowWeapon() ) {
					_gdc.setThrowWeapon( true );
				}else if ( _itemId == 3 && !_gdc.hasBomber() ) {
					_gdc.setBomber( true );
				}
			//}
		}
	}

}