package components.colliders {
	
	import wck.*;
	
	public class CircleCollider extends BodyShape{	
		
		public override function shapes():void{			
			circle();			
			reportBeginContact = true;
			reportEndContact = true;
		}		
	}
}