package shapes {
	
	import Box2DAS.Dynamics.ContactEvent;
	import Box2DAS.Dynamics.StepEvent;
	import flash.events.Event;
	import wck.*;
	
	public class Grass extends ShapeBase {	
		
		public override function shapes():void {			
			box()			
		}	
		
		private function playFade():void 
		{
			destroy();
			this.gotoAndPlay( "remove" );
			this.addFrameScript( this.totalFrames - 2, onRemoveMe )
			//this.visible = false;			
		}
		
		private function onRemoveMe():void 
		{
			if ( this != null ) {
				if ( this.parent.contains( this ) ) {
					this.parent.removeChild( this );					
				}
			}
		}
	}
}