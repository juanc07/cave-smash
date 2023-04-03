package components.colliders {
	
	import wck.*;
	
	public class AttackRangeCollider extends BodyShape{	
		
		public override function shapes():void{
			circle();			
			isSensor = true;
			reportBeginContact = true;
			reportEndContact = true;			
		}		
	}
}