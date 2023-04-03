package components.base{
	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.ContactEvent;
	import Box2DAS.Dynamics.StepEvent;
	import components.players.Player2;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import wck.*;
	
	public class RevolvingTrapBase extends BodyShape{
		
		public var contacts:ContactList;
		private var _target:Player2;
		
		public override function shapes():void{
		}
		
		override public function create():void
		{
			super.create();
			
			type = "Dynamic"
			reportBeginContact = true;
			reportEndContact = true;
			fixedRotation = false;
			applyGravity = true;
			
			listenWhileVisible(world, StepEvent.STEP, parseInput, false, 10);
			listenWhileVisible(this, ContactEvent.BEGIN_CONTACT, handleContact);
			listenWhileVisible(this, ContactEvent.END_CONTACT, endContact);
			contacts = new ContactList();
			contacts.listenTo(this);
		}
		
		/*method*/
		
		private function attackPlayer(  ):void
		{
			if( _target != null && this != null ){
				var player:Player2 = _target as Player2;
				if( !player.isDead  ){
					player.die();
					//player.hit(0,0,0);
				}
			}
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
				
				if ( this != null ){
					if ( e.other.GetBody().GetUserData() is Player ){
						_target = e.other.GetBody().m_userData;
					}
				}
			}
		}
		
		public function parseInput(e:Event):void {
			//trace( "[ MovingPlatform ]: parse!!");
			if (!world  || this == null ) return;
			attackPlayer();
		}
	}
}