package components.colliders {
	
	import wck.*;
	
	public class WeaponCollider extends BodyShape{		
		
		public override function shapes():void{			
			box();			
			isSensor = true;
			reportBeginContact = true;
			reportEndContact = true;			
		}		
	}
}