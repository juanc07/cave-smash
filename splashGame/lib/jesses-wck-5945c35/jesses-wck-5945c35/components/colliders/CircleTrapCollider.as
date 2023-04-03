package components.colliders {
	
	import wck.*;
	
	public class CircleTrapCollider extends BodyShape{		
		
		public override function shapes():void{			
			circle();
			reportBeginContact = true;
			reportEndContact = true;
			isSensor = true;
		}	
	}
}