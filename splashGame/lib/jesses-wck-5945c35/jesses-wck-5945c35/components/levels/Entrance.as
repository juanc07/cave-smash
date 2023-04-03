package components.levels 
{
	import Box2DAS.Dynamics.ContactEvent;
	import components.base.DoorBase;
	import flash.events.Event;
	/**
	 * ...
	 * @author jc
	 */
	public class Entrance extends DoorBase
	{
		
		public function Entrance() 
		{
			super();
		}
		
		override public function parseInput(e:Event):void 
		{
			super.parseInput(e);			
		}
		
		override public function handleContact(e:ContactEvent):void 
		{
			super.handleContact(e);
			if( this != null ){
				//trace( "[ Entrance ]: begin contact with: === >" + e.other.GetBody().GetUserData() );
			}
		}
		
		override public function endContact(e:ContactEvent):void 
		{
			super.endContact(e);
			if( this != null ){
				//trace( "[ Entrance ]: end contact with: === >" + e.other.GetBody().GetUserData() );
			}
		}	
	}

}