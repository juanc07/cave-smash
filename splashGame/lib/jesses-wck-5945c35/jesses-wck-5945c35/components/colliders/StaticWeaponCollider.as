package components.colliders {
	
	import wck.*;
	
	public class StaticWeaponCollider extends BodyShape{		
		
		public override function shapes():void{			
			box();
			isSensor = true;			
		}	
	}
}