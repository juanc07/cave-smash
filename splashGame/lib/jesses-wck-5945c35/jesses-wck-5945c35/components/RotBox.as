package components 
{
	import Box2DAS.Dynamics.StepEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import shapes.Box;
	/**
	 * ...
	 * @author ...
	 */
	public class RotBox extends Box
	{
		
		
		override public function create():void 
		{
			super.create();
			listenWhileVisible(stage, MouseEvent.MOUSE_MOVE, this.mouseAimHandler);
			listenWhileVisible(world, StepEvent.STEP, parseInput, false, 10);
		}		
		
		private function mouseAimHandler( e:Event ):void 
		{
			var mousePos:Number = Math.atan2( this.y - this.parent.mouseY, this.x - this.parent.mouseX ) * 180 / Math.PI;
			this.rotation = mousePos + 180;
			syncTransform();			
		}
		
		private function parseInput( e:Event ):void 
		{		
			//var dx:Number = this.x - this.parent.mouseX;
            //var dy:Number = this.y - this.parent.mouseY;
            //var mouseAngle:Number = Math.atan2( -dy, -dx) * 180 / Math.PI;			
			//this.rotation = mouseAngle;
			//syncTransform();
			//trace( "[RotBox]: mouseMoving............." );
		}
		
	}

}