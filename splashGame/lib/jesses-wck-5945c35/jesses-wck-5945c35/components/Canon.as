package components 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	/**
	 * ...
	 * @author ...
	 */
	public class Canon extends MovieClip
	{
		/*---------------------------------------------------------------------Constant----------------------------------------------------------------*/
		
		/*---------------------------------------------------------------------Properties---------------------------------------------------------------*/
		private var _mc:CanonMC;
		private var _xpos:Number =0;
		private var _ypos:Number =0;
		/*---------------------------------------------------------------------Constructor--------------------------------------------------------------*/
		
		public function Canon( xpos:Number, ypos:Number ) 
		{
			_xpos = xpos;
			_ypos = ypos;
			addEventListener( Event.ADDED_TO_STAGE, init );			
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			_mc = new CanonMC();
			addChild( _mc );
			this.x = _xpos;
			this.y = _ypos;			
			
			stage.addEventListener( MouseEvent.MOUSE_MOVE, onAim );			
		}
		
		private function onAim(e:MouseEvent):void 
		{
			//var newPoint:Point = localToGlobal( new Point( this.mouseX, this.mouseY ) );
			//var newPoint2:Point = localToGlobal( new Point( this.x, this.y ) );	
			
			this.x= mouseX;
			this.y = mouseY;
			
			//var distanceX:Number = this.x;// - _xpos;
			//var distanceY:Number =  this.y;// - _ypos;
			var distanceX:Number = this.x - _xpos;
			var distanceY:Number =  this.y - _ypos;
			if (distanceX*distanceX+distanceY*distanceY>10000) {
				var birdAngle:Number=Math.atan2(distanceY,distanceX);
				this.x=100+_xpos*Math.cos(birdAngle);
				this.y=100+_ypos*Math.sin(birdAngle);
				//this.x=100*Math.cos(birdAngle);
				//this.y=100*Math.sin(birdAngle);
			}
		}
		
		
		/*---------------------------------------------------------------------Methods--------------------------------------------------------------*/
		
		/*---------------------------------------------------------------------setters--------------------------------------------------------------*/
		
		/*---------------------------------------------------------------------Getters--------------------------------------------------------------*/		
		
		/*---------------------------------------------------------------------EventHandlers---------------------------------------------------------*/
		
	}

}