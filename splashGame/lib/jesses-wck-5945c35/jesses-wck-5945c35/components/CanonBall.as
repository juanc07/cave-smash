package components {
		
	import shapes.ShapeBase;
	import wck.*;
	
	public class CanonBall extends ShapeBase{			
		
		public override function shapes():void {			
			circle();		
			//categoryBits = 0x0002;
			//_categoryBits =0x0002;
			//_maskBits = 0x0004;
			//maskBits = 0x0004;
			
			
			//for walls
			//categoryBits = 0x0004;
			//_categoryBits =0x0004;
			//_maskBits = 0x0002;
			//maskBits = 0x0002;
			
			density = 1;
			friction = 3;
			restitution = 0.1;
			focusOn = true;
		}			
	}
}