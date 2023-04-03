package components.colliders {
	
	import wck.*;
	
	public class ItemCollider extends BodyShape{
		
		public override function shapes():void{			
			box();			
			isSensor = true;
			//reportBeginContact = true;
			//reportEndContact = true;
			//fixedRotation = true;
			//active = true;
		}		
	}
}