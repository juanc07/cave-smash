package components {
	
	import shapes.Circle;
	import wck.*;
	
	public class CanonBallGuide extends Circle{		
		
		override public function create() : void
        {            
			super.create();			
			maskBits = 4;
			density = 1;
			friction = 3;
			restitution = 0.1;
			//isSensor = true;
			//isGuideShape = true;
			
			//categoryBits = 0x0002;
			//_categoryBits =0x0002;
			//_maskBits = 0x0004;
			//maskBits = 0x0004;
			
			
			//_isSensor = true;
			//isSensor = true;
			//isGuideShape = true;
			
			//categoryBits = 0x0002;
			//_categoryBits =0x0002;
			//_maskBits = 0x0004;
			//maskBits = 0x0004;
		}	
	}
}