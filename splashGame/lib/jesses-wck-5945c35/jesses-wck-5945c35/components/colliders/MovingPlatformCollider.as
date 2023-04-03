package components.colliders {
	
	import wck.*;
	
	public class MovingPlatformCollider extends BodyShape{		
		
		public override function shapes():void{			
			box();
			friction = 100;
		}	
	}
}