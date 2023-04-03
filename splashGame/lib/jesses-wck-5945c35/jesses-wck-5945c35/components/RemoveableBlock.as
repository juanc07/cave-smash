package components {
	
	import Box2DAS.Collision.AABB;
	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.b2Body;
	import Box2DAS.Dynamics.b2Fixture;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import misc.Util;
	import shapes.ShapeBase;
	import wck.*;
	
	public class RemoveableBlock extends ShapeBase{		
		
		public override function shapes():void {
			box();
			addEventListener( MouseEvent.CLICK, onClickMe );			
		}		
		
		
		private function onClickMe(e:MouseEvent):void 
		{				
			removeEventListener( MouseEvent.CLICK, onClickMe );
			playFade();
			trace( "click me.. box realme" );
		}	
		
		private function playFade():void 
		{			
			Util.addChildAtPosOf(world, new FX1(), this );  			
			this.remove();
				
			//this.gotoAndPlay( "remove" );
			this.addFrameScript( this.totalFrames - 2, onRemoveMe )
			//this.visible = false;
			//destroy();	
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