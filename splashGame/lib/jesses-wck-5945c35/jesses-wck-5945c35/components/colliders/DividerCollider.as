package components.colliders {
	
	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.ContactEvent;
	import Box2DAS.Dynamics.StepEvent;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import wck.*;
	
	public class DividerCollider extends BodyShape{		
		
		public var contacts:ContactList;
		
		public override function shapes():void{			
			box();			
		}
		
		override public function create():void 
		{
			super.create();			
			reportBeginContact = true;
			reportEndContact = true;
			fixedRotation = true;			
			applyGravity = false;
			
			listenWhileVisible(world, StepEvent.STEP, parseInput, false, 10);
			listenWhileVisible(this, ContactEvent.BEGIN_CONTACT, handleContact);
			listenWhileVisible(this, ContactEvent.END_CONTACT, endContact);
			contacts = new ContactList();
			contacts.listenTo(this);			
		}
		
		public function endContact(e:ContactEvent):void {
			if( this != null ){				
				e.contact.SetEnabled(true);
			}
		}
		public function handleContact(e:ContactEvent):void {	
			if( this != null ){
				//for player to enter from below this moving platform prevent sticky power
				if ( e.other.GetBody().GetUserData() is BossBisonMC ){
					if(e.normal) {
						var m:Matrix = matrix.clone();
						m.tx = 0;
						m.ty = 0;
						m.invert();
						var n:V2 = b2body.GetLocalVector(e.normal);
						var p:Point = m.transformPoint(n.toP());
						e.contact.SetEnabled(p.y < -0.8);
					}
				}
			}
		}
		
		public function parseInput(e:Event):void {
			//trace( "[ MovingPlatform ]: parse!!");
			if (!world  || this == null ) return;		
		}
	}
}