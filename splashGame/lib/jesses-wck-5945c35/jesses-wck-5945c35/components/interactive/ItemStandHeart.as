package components.interactive 
{
	import Box2DAS.Dynamics.ContactEvent;
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import com.monsterPatties.data.GameData;
	import com.monsterPatties.data.ShopItem;
	import com.monsterPatties.events.CaveSmashEvent;
	import components.base.StaticItemBase;
	import components.items.ItemConfig;
	import flash.geom.Point;
	import misc.Util;
	/**
	 * ...
	 * @author jc
	 */
	public class ItemStandHeart extends StaticItemBase
	{
		
		private var isHitPlayer:Boolean = false;
		private var inGameHelp:InGameMessageMC;
		
		public function ItemStandHeart() 
		{
			super();
		}
		
		override public function create():void 
		{
			super.create();
		}
		
		private function showMessage():void 
		{
			if( this != null && world != null ){
				if ( !isHitPlayer ){										
					addMessage();
				}
			}
		}
		
		private function addMessage():void 
		{
			if( !isHitPlayer && !checkIfMaxLive() ){				
				isHitPlayer = true;
				inGameHelp = new InGameMessageMC();
				inGameHelp.id = 11;
				inGameHelp.msg = ItemConfig.SHOP_HEART_DESC + "\n" + ItemConfig.SHOP_HEART_PRICE + " gold." + "\n press \"SPACE\" to buy";
				Util.addChildAtPosOf( world, inGameHelp, this, -1, new Point( 1.5 , -100 ) );
				inGameHelp.scaleX = 0;
				inGameHelp.scaleY = 0;					
				TweenLite.to( inGameHelp, 0.5, { scaleX:1, scaleY:1, ease:Cubic.easeOut } );
				
				var item:ShopItem = new ShopItem();
				item.type =  ItemConfig.SHOP_HEART;
				item.desc =  ItemConfig.SHOP_HEART_DESC;
				item.price =  ItemConfig.SHOP_HEART_PRICE;
				
				gdc.setCurrentSelectedItem( item );
			}
		}
		
		private function showItemStandInfo( itemType:String, isSold:Boolean ):void 
		{
			this.mc.gotoAndStop(itemType);
			if(isSold){
				this.mc.soldMC.visible = true;
				removeMessage();
			}else {
				this.mc.soldMC.visible = false;
			}
		}
		
		private function removeMessage():void 
		{
			Util.remove( inGameHelp );
			isHitPlayer = false;
			gdc.setCurrentSelectedItem( null );
		}
		
		override public function addGameEvent():void 
		{
			super.addGameEvent();
			_es.addEventListener(CaveSmashEvent.ON_BUY_ITEM, onBuyItem);
		}
		
		override public function removeGameEvent():void 
		{
			super.removeGameEvent();
			_es.removeEventListener(CaveSmashEvent.ON_BUY_ITEM, onBuyItem);
		}
		
		override public function handleContact(e:ContactEvent):void 
		{
			super.handleContact(e);			
			if( this != null ){
				if ( e.other.GetBody().GetUserData() is Player ) {
					addMessage();
				}
			}
		}
		
		override public function endContact(e:ContactEvent):void 
		{
			super.endContact(e);
			if( this != null ){
				if ( e.other.GetBody().GetUserData() is Player && isHitPlayer ) {
					trace( "[ InGameHelp ]: end contact with: === >" + e.other.GetBody().GetUserData() );
					Util.remove( inGameHelp );
					isHitPlayer = false;
					gdc.setCurrentSelectedItem( null );
				}
			}
		}
		
		
		override public function onLevelStarted(e:CaveSmashEvent):void 
		{
			super.onLevelStarted(e);
			if ( this != null ) {
				if(gdc.getAdditionalLive() >= 2 ){
					showItemStandInfo( ItemConfig.SHOP_HEART, true );
				}else {
					showItemStandInfo( ItemConfig.SHOP_HEART, false );
				}
			}
			//addMessage();
		}
		
		private function checkIfMaxLive():Boolean 
		{
			var live:int = gdc.getAdditionalLive();
			var maxLive:int = gdc.getAdditionalLive() + GameData.MAX_LIVE;
			
			var sold:Boolean = false;
			if ( live >= 2 ) {
				sold = true;
			}else {
				sold = false;
			}
			
			if ( live >= 1 ) {
				//gdc.setLive(maxLive);
				_caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.RESET_LIFE );
				_es.dispatchESEvent( _caveSmashEvent );
			}
			
			return sold;
		}
		
		private function onBuyItem(e:CaveSmashEvent):void 
		{			
			showItemStandInfo( ItemConfig.SHOP_HEART, checkIfMaxLive() );			
		}
	}

}