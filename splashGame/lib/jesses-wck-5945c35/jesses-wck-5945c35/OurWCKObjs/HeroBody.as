package OurWCKObjs
{
	import Box2DAS.Collision.Shapes.b2MassData;
	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.ContactEvent;
	import Box2DAS.Dynamics.StepEvent;
	
	import com.GeneralManagers.LevelManager;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import shapes.Box;
	
	import wck.ContactList;
	
	public class HeroBody extends Box
	{

		public static var setPositionWhenPossible:Boolean = false;
		
		public var jakClip:MovieClip;
		
		public function HeroBody()
		{
			super();
		}
		
		public override function create():void
		{
			if ((this.parent)['grappy'] != null)
			{
				trace("started with grappy");
			}
			linearDamping = 0;
			friction = 0.8;
			reportBeginContact = true;
			reportEndContact = true;
			fixedRotation = true;
			
			

				//focusOn = true;

			super.create();
			listenWhileVisible(this, ContactEvent.BEGIN_CONTACT, handleContact);
			
			listenWhileVisible(world, StepEvent.STEP, HeroContainer(this.parent).AllBodyInput, false, 10);
			
			HeroContainer(this.parent).contacts = new ContactList();
			
			HeroContainer(this.parent).contacts.listenTo(this);
			
			b2body.SetTransform(new V2(-999, -999), 0);
			setPositionWhenPossible = true;
			
			if (GrapplePickUp.hasBeenPickedUp == true)
			{
				jakClip.gotoAndPlay("grapplewalk");
				(this.parent as HeroContainer).addEventListener(Event.ENTER_FRAME, (this.parent as HeroContainer).WaitFrameToCreate); 
			}
			
			var tempMD:b2MassData = new b2MassData();
			b2body.GetMassData(tempMD);
			
			tempMD.mass = .82;
			
			b2body.SetMassData(tempMD);
			
		}
		
		public function handleContact(e:ContactEvent):void 
		{
			
		}
		
		
	}
}