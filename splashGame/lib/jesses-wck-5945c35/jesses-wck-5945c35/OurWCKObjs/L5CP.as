package com.OurWCKObjs
{
	import Box2DAS.Dynamics.ContactEvent;
	
	import shapes.Box;
	
	import wck.ContactList;
	
	public class L5CP extends Box
	{
		public static const totalCount:int = 12;
		public static var deathCount:int = 0;
		
		public function L5CP()
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
			if (!this._active) return; 
			
			if(e.contact.m_fixtureA.m_userData is Level5Barrel)
			{
				(e.contact.m_fixtureA.m_userData as Level5Barrel).needReset = true;
				this._active = false;
				this.b2body.m_userData["clip"].gotoAndStop("2");
				deathCount += 1;
			}
			
			if(e.contact.m_fixtureB.m_userData is Level5Barrel)
			{
				(e.contact.m_fixtureB.m_userData as Level5Barrel).needReset = true;
				this._active = false;
				this.b2body.m_userData["clip"].gotoAndStop("2");
				deathCount += 1;
			}
			
			if (deathCount == 12)
			{
				trace("we did it!");
			}
		}
	}
}