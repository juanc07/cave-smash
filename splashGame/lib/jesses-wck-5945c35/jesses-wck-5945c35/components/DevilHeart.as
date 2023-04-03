package components {
	
	import Box2DAS.Dynamics.StepEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import misc.Util;
	import shapes.Box;
	import shapes.ShapeBase;
	import wck.*;
	
	public class DevilHeart extends HeartBox {
	
		override public function create() : void
        {            
			htype = HeartBox.DEVIL_HEART;
			super.create();		
		}		
	}
}