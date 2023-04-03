package OurWCKObjs
{
	import Box2DAS.Dynamics.ContactEvent;
	
	import com.OverlayStuff.DialoguePopUp;
	
	import shapes.Box;
	
	public class GrapplePickUp extends Box
	{
		public static var hasBeenPickedUp:Boolean = false;
		
		public function GrapplePickUp()
		{
			super();
		}
		
		public override function create():void
		{
			if (hasBeenPickedUp) 
			{
				this.visible = false;
				return;
			}
			
			
			isSensor = true;
			type = 'Static';
			super.create();
			listenWhileVisible(this, ContactEvent.BEGIN_CONTACT, handleContact);
		}
		
		public function handleContact(e:ContactEvent):void
		{
			if (hasBeenPickedUp) return;
			
			if (e.contact.m_fixtureA.m_userData is MCHeroBody ||
				e.contact.m_fixtureB.m_userData is MCHeroBody)
			{
				DialoguePopUp(this.parent.parent.parent["diag"]).TweenIn("GrappleMessage");
				hasBeenPickedUp = true;
				HeroContainer.enableArm = true;
				this.visible = false;
			}
			

		}	
	}
}