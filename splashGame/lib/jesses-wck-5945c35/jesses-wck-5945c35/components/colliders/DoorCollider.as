package components.colliders {
	
	import wck.*;
	
	public class DoorCollider extends BodyShape{		
		
		public override function shapes():void{			
			box();			
			isSensor = true;
		}	
	}
}