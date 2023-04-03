package components.levels {	
	
	import Box2DAS.Dynamics.ContactEvent;
	import Box2DAS.Dynamics.StepEvent;
	import com.monsterPatties.config.GameConfig;
	import components.players.Player2;
	import flash.events.Event;
	import wck.*;
	
	public class Spike extends BodyShape {		
		private var target:Player2;
	
		/*------------------------------------------------------------------Constant----------------------------------------------------------------------*/
		
		/*------------------------------------------------------------------Properties--------------------------------------------------------------------*/
		public var contacts:ContactList;		
		/*------------------------------------------------------------------Constructor----------------------------------------------------------------------*/
		
		public override function shapes():void {
			
		}
		
		override public function create():void 
		{
			super.create();
			
			type = "Static";
			applyGravity = false;
			
			listenWhileVisible(world, StepEvent.STEP, parseInput, false, 10);
			listenWhileVisible(this, ContactEvent.BEGIN_CONTACT, handleContact);
			listenWhileVisible(this, ContactEvent.END_CONTACT, endContact);
			contacts = new ContactList();
			contacts.listenTo(this);
			
			if ( GameConfig.showCollider ){
				this.collider.alpha = 1;
			}
		}
		
		/*------------------------------------------------------------------Methods----------------------------------------------------------------------*/
		private function checkIfHitTarget():void 
		{
			if ( this != null ){
				if( target != null ){
					if( !target.isDead ){
						target.hit(0,0  );
					}
				}
			}else {
				return;
			}
		}
		/*------------------------------------------------------------------Setters----------------------------------------------------------------------*/
		
		/*------------------------------------------------------------------Getters----------------------------------------------------------------------*/
		
		/*------------------------------------------------------------------EventHandlers----------------------------------------------------------------*/		
		public function parseInput(e:Event):void {
			checkIfHitTarget();
		}
		
		public function endContact(e:ContactEvent):void {
			//trace( "[ Spike ]: end contact with: === >" + e.other.GetBody().GetUserData() );			
			target = null;
		}
		public function handleContact(e:ContactEvent):void {
			//trace( "[ Spike ]: begin contact with: === >" + e.other.GetBody().GetUserData() );
			if ( this != null ){
				if( e.other.GetBody().m_userData is Player ){
					target = e.other.GetBody().m_userData;
				}
			}
		}
	}
}