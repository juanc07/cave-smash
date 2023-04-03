package components.items 
{
	import Box2DAS.Dynamics.ContactEvent;
	import com.monsterPatties.config.GameConfig;
	import com.monsterPatties.events.WCKEvent;
	import components.players.Player2;
	import misc.Util;
	import wck.BodyShape;
	import wck.ContactList;
	/**
	 * ...
	 * @author jc
	 */
	public class Item extends BodyShape {	
		
		public static const LABEL_COLLECT:String = "collect";
		private var _isCollected:Boolean = false;
		public var itemType:String;	
		
		public var contacts:ContactList;
		
		
		public override function shapes():void {
			//type = "Dynamic";
			type = "Static";
			applyGravity = false;
			
			listenWhileVisible(this, ContactEvent.BEGIN_CONTACT, handleContact);
			listenWhileVisible(this, ContactEvent.END_CONTACT, endContact);
			contacts = new ContactList();
			contacts.listenTo(this);
			
			if ( GameConfig.showCollider ){
				this.collider.alpha = 1;
			}
		}
		
		public function collect():void 
		{
			if ( !_isCollected && this.mc.currentFrameLabel != LABEL_COLLECT && this.mc != null && this.collider != null ) {
				type = "Static";
				this.collider.isSensor = true;
				//this.mc1.isSensor = true;
				//this.mc2.isSensor = true;
				//this.mc3.isSensor = true;
				this.mc.addFrameScript( this.mc.totalFrames - 1, onEndAnimation );
				this.mc.gotoAndPlay( LABEL_COLLECT );
				_isCollected = true;
			}
		}
		
		private function onEndAnimation():void 
		{
			if( this != null ){
				//Util.addChildAtPosOf(world, new FX1(), this );  
				//this.remove();
			}
		}
		
		private function setRandomSkin():void 
		{
			var rnd:int = ( Math.random() * this.totalFrames ) + 1;
			this.gotoAndStop( rnd );
			itemType = this.currentFrameLabel;
			//this.mc.stop();
		}
		
		private function setItemSkin():void 
		{			
			this.gotoAndStop( this.setItemType );			
		}
		
		public function setItemType( itemType:String ):void 
		{
			this.itemType = itemType;
		}
		
		//public function animate():void 
		//{
			//this.mc.gotoAndPlay( "animate" );
			//this.mc.addFrameScript( this.mc.totalFrames - 1, onEndAnimation );
		//}
		
		/*----------------------------------------------------------------------Events-------------------------------------------------------------*/
		
		public function endContact(e:ContactEvent):void {
			if( this != null ){
				trace( "[ Item ]: end contact with: === >" + e.other.GetBody().GetUserData() );			
				if ( e.other.GetBody().GetUserData() is Player2 ) {
					collect();
				}
			}
		}
		public function handleContact(e:ContactEvent):void {
			trace( "[ Item ]: begin contact with: === >" + e.other.GetBody().GetUserData() );
			if ( this != null ){
				if ( e.other.GetBody().GetUserData() is Player2 ) {
					collect();
				}
			}
		}
	}

}