package components.items 
{
	import components.base.DynamicItemBase;
	import components.base.StaticItemBase;
	import Box2DAS.Dynamics.ContactEvent;
	import com.monsterPatties.config.CaveSmashConfig;
	import com.monsterPatties.events.CaveSmashEvent;	
	import misc.Util;
	/**
	 * ...
	 * @author jc
	 */
	public class ItemHeart extends StaticItemBase
	{
		public static const LABEL_COLLECT:String = "collect";
		private var _isCollected:Boolean = false;
		
		public function ItemHeart() 
		{
			super();
		}
		
		override public function shapes():void 
		{
			super.shapes();
			box();
			goStatic();
			itemType = ItemConfig.HEART;
		}
		
		override public function create():void 
		{
			super.create();			
		}
		
		private function goStatic():void 
		{			
			type = "Static";
			applyGravity = false;
			isSensor = true;
		}
		
		public function collect():void 
		{			
			if ( !_isCollected && this.mc.currentFrameLabel != LABEL_COLLECT && this.mc != null  ){				
				Util.addChildAtPosOf(world, new FX1(), this );
				this.mc.addFrameScript( this.mc.totalFrames - 2, onEndAnimation );
				this.mc.gotoAndPlay( LABEL_COLLECT );
				_isCollected = true;
			}
		}
		
		private function onEndAnimation():void 
		{
			if ( this != null ) {
				this.mc.addFrameScript( this.mc.totalFrames - 2, null );
				_caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.PICK_UP_ITEM );
				_caveSmashEvent.obj.itemType = itemType;
				_caveSmashEvent.obj.score = CaveSmashConfig.ORE_SCORE;
				_es.dispatchESEvent( _caveSmashEvent );
				this.remove();
			}
		}
		
		override public function handleContact(e:ContactEvent):void 
		{
			super.handleContact(e);
			//trace( "[ ItemGold ]: contact with: === >" + e.other.GetBody().GetUserData() );			
			if ( this != null && world ){
				if( e.other.GetBody().m_userData is Player ){
					collect();
				}
			}
		}
		
		override public function endContact(e:ContactEvent):void 
		{
			super.endContact(e);
			//trace( "[ ItemGold ]: end contact with: === >" + e.other.GetBody().GetUserData() );
		}
		
	}

}