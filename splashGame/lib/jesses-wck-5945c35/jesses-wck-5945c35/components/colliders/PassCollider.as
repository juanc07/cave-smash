package components.colliders {
	
	import wck.*;
	
	public class PassCollider extends BodyShape{		
		
		public override function shapes():void{			
			box();			
			isSensor = true;
		}	
	}
}