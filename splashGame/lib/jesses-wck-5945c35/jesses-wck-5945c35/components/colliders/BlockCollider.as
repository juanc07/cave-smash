package components.colliders {
	
	import wck.*;
	
	public class BlockCollider extends BodyShape{		
		
		public override function shapes():void{			
			box();			
			reportBeginContact = true;
			reportEndContact = true;
		}	
	}
}