package components.colliders {
	
	import wck.*;
	
	public class TreasureBoxCollider extends BodyShape{		
		
		public override function shapes():void{			
			box();
			restitution = 0.3;			
			//isSensor = true;
		}	
	}
}