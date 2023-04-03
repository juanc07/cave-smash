package OurWCKObjs
{
	import Box2DAS.Dynamics.ContactEvent;
	
	import shapes.Box;
	
	public class L5BarrelSplatSensor extends Box
	{
		public function L5BarrelSplatSensor()
		{
			super();
		}
		
		public override function create():void
		{
			super.create();
			
			listenWhileVisible(this, ContactEvent.BEGIN_CONTACT, handleContact);
		}
			
		public function handleContact(e:ContactEvent):void 
		{
			if(e.contact.m_fixtureA.m_userData is Level5Barrel)
			{
				(e.contact.m_fixtureA.m_userData as Level5Barrel).needReset = true;
			}
			
			if(e.contact.m_fixtureB.m_userData is Level5Barrel)
			{
				(e.contact.m_fixtureB.m_userData as Level5Barrel).needReset = true;
			}
		}
	}
}