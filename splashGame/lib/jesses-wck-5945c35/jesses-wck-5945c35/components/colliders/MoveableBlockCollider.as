package components.colliders {
	
	import wck.*;
	
	public class MoveableBlockCollider extends BodyShape{		
		
		public override function shapes():void{			
			box();
			//density = 1;
			friction = 0.04;
			//restitution = 0.2;
		}	
	}
}