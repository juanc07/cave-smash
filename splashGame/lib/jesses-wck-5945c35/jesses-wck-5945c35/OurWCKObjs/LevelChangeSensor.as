package com.OurWCKObjs
{
	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.ContactEvent;
	
	import com.GeneralManagers.LevelManager;
	
	import flash.events.Event;
	
	import shapes.Box;

	public class LevelChangeSensor extends Box
	{
		//Well send this to the world manager.
		[Inspectable(defaultValue="L1")]
		public var levelToLoad:String;
		
		//Well apply this to our hero.
		[Inspectable(defaultValue="Left",enumeration='Left,Right,Top,Bottom,Middle,Secret')]
		public var entrance:String;
		
		public static var LevManageRef:LevelManager;
		
		public static var heroBodRef:HeroBody;
		
		public function LevelChangeSensor()
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
			if (e.contact.m_fixtureA.m_userData is MCHeroBody ||
				e.contact.m_fixtureB.m_userData is MCHeroBody)
			{
				if (e.contact.m_fixtureA.m_userData is MCHeroBody)
				{
					if((e.contact.m_fixtureA.m_userData.parent as HeroContainer).grappleArm &&
						(e.contact.m_fixtureA.m_userData.parent as HeroContainer).grappleArm.hook.type == 'Static')
					{
						return;
					}
				}
				
				if (e.contact.m_fixtureB.m_userData is MCHeroBody)
				{
					if((e.contact.m_fixtureB.m_userData.parent as HeroContainer).grappleArm &&
						(e.contact.m_fixtureB.m_userData.parent as HeroContainer).grappleArm.hook.type == 'Static')
					{
						return;
					}
				}
//				{
//					if (((e.contact.m_fixtureA.m_userData as MCHeroBody).parent as HeroContainer).grappleArm.hook.type == 'Static')
//					{
//						((e.contact.m_fixtureA.m_userData as MCHeroBody).parent as HeroContainer).grappleArm.ClearArm(false);
//					}
//				}
//				else
//				{
//					if (((e.contact.m_fixtureB.m_userData as MCHeroBody).parent as HeroContainer).grappleArm.hook.type == 'Static')
//					{
//						((e.contact.m_fixtureB.m_userData as MCHeroBody).parent as HeroContainer).grappleArm.ClearArm(false);
//					}
//				}
				addEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		}	
		
		public function onEnterFrame(e:Event):void
		{
			LevManageRef.LoadWorld(levelToLoad, entrance);
			
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
	}
}