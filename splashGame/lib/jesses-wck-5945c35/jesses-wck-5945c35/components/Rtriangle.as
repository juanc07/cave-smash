package components {
	
	import flash.events.MouseEvent;
	import OurWCKObjs.ExplosionSensor;
	import shapes.ShapeBase;
	import wck.*;
	
	public class Rtriangle extends ShapeBase{	
		
		public override function shapes():void {			
			triangle();
			addEventListener( MouseEvent.CLICK, onClickMe );
		}
		
		private function onClickMe(e:MouseEvent):void 
		{			
			removeEventListener( MouseEvent.CLICK, onClickMe );
			trace( "click me.." );
			playFade();				
		}	
		
		private function playFade():void 
		{
			this.gotoAndPlay( "remove" );
			this.addFrameScript( this.totalFrames - 2, onRemoveMe )
			//this.visible = false;
			destroy();	
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