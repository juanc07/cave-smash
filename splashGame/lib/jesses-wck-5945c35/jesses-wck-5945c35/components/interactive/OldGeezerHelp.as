package components.interactive 
{
	import Box2DAS.Dynamics.ContactEvent;
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import com.monsterPatties.config.ContentConfig;
	import com.monsterPatties.controllers.GameDataController;
	import com.monsterPatties.events.CaveSmashEvent;
	import com.monsterPatties.utils.eventSatellite.EventSatellite;
	import flash.events.Event;
	import flash.geom.Point;
	import misc.Util;
	/**
	 * ...
	 * @author jc
	 */
	public class OldGeezerHelp extends InGameHelpBase
	{		
		public function OldGeezerHelp() 
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
			if( this != null && world != null && gdc != null ){
				var gdc:GameDataController = GameDataController.getInstance();
				var level:int = gdc.getCurrLevel();
				var msg:String = "";
				
				if (gdc.getIsGoingToShop()) {
					//msg = "welcome to my shop please \n check my items \n press \"R\" when you are done buying.";
					msg = ContentConfig.SHOP_OLD_GEEZER;
				}else{
					//msg = "Hi there adventurer if you need\n something just drop by to my shop.\n press \"P\" then select shop";
					msg = "Hello adventurer. Drop by the shop if \nyou need anything. Press \"P\" to go to \nthe shop.";					
					
					isHitPlayer = true;
					inGameHelp = new InGameMessageMC();
					inGameHelp.msg = msg;
					inGameHelp.id = 7;
					Util.addChildAtPosOf( world, inGameHelp, this, -1, new Point( 0 , -85 ) );
					inGameHelp.scaleX = 0;
					inGameHelp.scaleY = 0;
					TweenLite.to( inGameHelp, 0.5, { scaleX:1, scaleY:1, ease:Cubic.easeOut } );
				}			
			}
		}
		
		private function removeMessage():void 
		{
			Util.remove( inGameHelp );
			isHitPlayer = false;
		}
		
		override public function handleContact(e:ContactEvent):void 
		{
			super.handleContact(e);
			
			if( this != null ){
				if ( e.other.GetBody().GetUserData() is Player && !isHitPlayer ) {
					addMessage();
					//trace( "[ InGameHelp ]: contact with: === >" + e.other.GetBody().GetUserData() );
					//isHitPlayer = true;
					//inGameHelp = new InGameMessageMC();
					//Util.addChildAtPosOf( world,inGameHelp, this, -1, new Point( 0 , -100 ) );
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
				}
			}
		}
		
		override public function onLevelStarted(e:CaveSmashEvent):void 
		{			
			super.onLevelStarted(e);
			showMessage();
		}
		
		override public function onLevelQuit(e:CaveSmashEvent):void 
		{
			super.onLevelQuit(e);
			removeMessage();
		}
		
		override public function onLevelFailed(e:CaveSmashEvent):void 
		{
			super.onLevelFailed(e);
			removeMessage();
		}
		
		override public function onReloadLevel(e:CaveSmashEvent):void 
		{
			super.onReloadLevel(e);
			removeMessage();
		}
	}

}