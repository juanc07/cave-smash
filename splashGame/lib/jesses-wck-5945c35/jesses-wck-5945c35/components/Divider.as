package components {	
	
	import wck.*;
	
	public class Divider extends BodyShape {		
	
		/*------------------------------------------------------------------Constant----------------------------------------------------------------------*/
		
		/*------------------------------------------------------------------Properties--------------------------------------------------------------------*/
		
		/*------------------------------------------------------------------Constructor----------------------------------------------------------------------*/
		
		public override function shapes():void {
			box();
		}		
		
		public var contacts:ContactList;
		
		public override function create():void {
			trace( "[Divider] created" );			
			super.create();
			reportBeginContact = true;
			reportEndContact = true;
			fixedRotation = true;			
			density = 1;
			friction = 0.3;
			restitution = 0;
            type = "Static";			
			contacts = new ContactList();
			contacts.listenTo(this);
		}	
		
		/*------------------------------------------------------------------Methods----------------------------------------------------------------------*/
		
		/*------------------------------------------------------------------Setters----------------------------------------------------------------------*/
		
		/*------------------------------------------------------------------Getters----------------------------------------------------------------------*/
		
		/*------------------------------------------------------------------EventHandlers----------------------------------------------------------------*/		
	}
}