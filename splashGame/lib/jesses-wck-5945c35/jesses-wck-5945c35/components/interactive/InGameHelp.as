package components.interactive 
{
	import Box2DAS.Dynamics.ContactEvent;
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import com.monsterPatties.events.CaveSmashEvent;
	import components.base.StaticItemBase;
	import flash.geom.Point;
	import misc.Util;
	/**
	 * ...
	 * @author jc
	 */
	public class InGameHelp extends StaticItemBase
	{
		
		private var isHitPlayer:Boolean = false;
		private var inGameHelp:InGameMessageMC;
		
		public function InGameHelp() 
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
			if( !isHitPlayer && this != null && world != null ){				
				isHitPlayer = true;
				inGameHelp = new InGameMessageMC();	
				if( inGameHelp != null ){
					Util.addChildAtPosOf( world, inGameHelp, this, -1, new Point( 1.5 , -100 ) );
					inGameHelp.scaleX = 0;
					inGameHelp.scaleY = 0;					
					TweenLite.to( inGameHelp, 0.5, { scaleX:1, scaleY:1, ease:Cubic.easeOut } );
				}
			}
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
				}
			}
		}
		
		
		override public function onLevelStarted(e:CaveSmashEvent):void 
		{
			super.onLevelStarted(e);
			addMessage();
		}
	}

}