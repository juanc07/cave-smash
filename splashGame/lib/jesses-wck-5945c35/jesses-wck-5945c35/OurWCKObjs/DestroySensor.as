package OurWCKObjs
{
	import Box2DAS.Dynamics.ContactEvent;
	
	import shapes.Box;
	
	public class DestroySensor extends Box
	{
		public function DestroySensor()
		{
			super();
		}
		
		public override function create():void	
		{
			isSensor = true;
			type = 'Static';
			super.create();
			
			listenWhileVisible(this, ContactEvent.BEGIN_CONTACT, handleContact);
		}
		
		public function handleContact(e:ContactEvent):void
		{
			if(e.contact.m_fixtureA.m_userData is L3RobotBox)
			{
				(e.contact.m_fixtureA.m_userData as L3RobotBox).needReset = true;
			}
			
			if(e.contact.m_fixtureB.m_userData is L3RobotBox)
			{
				(e.contact.m_fixtureB.m_userData as L3RobotBox).needReset = true;
			}
		}
	}
}