package components 
{
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	import misc.*;	
	
	/**
	 * ...
	 * @author ...
	 */
	public class Explosion extends ExplosionArea
	{		
		private var _mc:ExplosionMC2;
		
		public function Explosion() {
			_mc = new ExplosionMC2();
			addChild( _mc );			
			
			_mc.addFrameScript( _mc.totalFrames - 2, onRemoveMe );
			
			
			mouseEnabled = false;
			mouseChildren = false;			
		}		
		
		private function onRemoveMe():void 
		{
			_mc.addFrameScript( _mc.totalFrames - 2, null );
			Util.remove(this);
			destroy();
		}		
		
	}

}