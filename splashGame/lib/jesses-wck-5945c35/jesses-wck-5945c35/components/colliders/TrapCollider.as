package components.colliders {
	
	import wck.*;
	
	public class TrapCollider extends BodyShape{		
		
		public override function shapes():void{			
			box();
			isSensor = true;
		}	
	}
}