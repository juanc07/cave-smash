package components.interactive 
{
	import Box2DAS.Dynamics.ContactEvent;	
	import components.base.StaticItemBase;
	import flash.geom.Point;
	import misc.Util;
	/**
	 * ...
	 * @author jc
	 */
	public class InGameHelpBase extends StaticItemBase
	{
		
		public var isHitPlayer:Boolean = false;
		public var inGameHelp:InGameMessageMC;
		
		public function InGameHelpBase() 
		{
			super();
		}
		
		override public function create():void 
		{
			super.create();
		}
		
		override public function handleContact(e:ContactEvent):void 
		{
			super.handleContact(e);
		}
		
		override public function endContact(e:ContactEvent):void 
		{
			super.endContact(e);			
		}
		
	}

}