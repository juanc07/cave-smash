package components.interactive
{
	import Box2DAS.Dynamics.ContactEvent;
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import com.monsterPatties.controllers.GameDataController;
	import com.monsterPatties.events.CaveSmashEvent;
	import components.base.StaticItemBase;
	import components.config.LiveData;
	import flash.geom.Point;
	import misc.Util;
	/**
	 * ...
	 * @author jc
	 */
	public class Checkpoint extends StaticItemBase
	{
		private var isHitPlayer:Boolean = false;
		public static const LABEL_CHECK:String = "check";
		private var _gdc:GameDataController;
		
		public function Checkpoint()
		{
			super();
		}
		
		override public function create():void
		{
			super.create();
			_gdc = GameDataController.getInstance();
		}
		
		//private function showMessage():void
		//{
			//if( this != null && world != null ){
				//if ( !isHitPlayer ){
					//checkPoint();
				//}
			//}
		//}
		
		private function checkPoint():void
		{
			if( !isHitPlayer && this != null && world != null ){
				isHitPlayer = true;
				_gdc.setCheckpoint(LiveData.playerPosition);
				if(this.mc.currentLabel != LABEL_CHECK){
					this.mc.gotoAndPlay(LABEL_CHECK);
				}
				trace("hit checkpoint!!!!!!!!!!!!!!!!!");
			}
		}
		
		override public function handleContact(e:ContactEvent):void
		{
			super.handleContact(e);
			if( this != null ){
				if ( e.other.GetBody().GetUserData() is Player ) {
					checkPoint();
				}
			}
		}
		
		override public function endContact(e:ContactEvent):void
		{
			super.endContact(e);
			if( this != null ){
				if ( e.other.GetBody().GetUserData() is Player && isHitPlayer ) {
					trace( "[ Checkpoint ]: end contact with: === >" + e.other.GetBody().GetUserData() );
					//isHitPlayer = false;
				}
			}
		}
	}

}