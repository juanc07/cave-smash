package components.colliders {
	
	import wck.*;
	
	public class BoxCollider extends BodyShape{	
		
		public override function shapes():void{
			box();
			reportBeginContact = true;
			reportEndContact = true;
		}		
	}
}