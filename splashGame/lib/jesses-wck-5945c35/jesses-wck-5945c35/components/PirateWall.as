package components {	
	
	import shapes.ShapeBase;
	import wck.*;
	
	public class PirateWall extends ShapeBase {
	
		public override function shapes():void {
			box();
			
			//categoryBits = 0x0004;
			//_categoryBits =0x0004;
			//_maskBits = 0x0002;
			//maskBits = 0x0002;
			categoryBits = 4;
			
			type = "static";
			applyGravity = false;
		}	
	}
}