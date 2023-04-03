package components.colliders {
	
	import wck.*;
	
	public class BouncyCollider extends BodyShape{		
		
		public override function shapes():void{			
			box();			
			restitution = 1.3;
		}	
	}
}