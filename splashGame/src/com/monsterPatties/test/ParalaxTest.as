package com.monsterPatties.test 
{
	import com.lextalkington.parallax.ParallaxEngine;
	import com.lextalkington.parallax.ParallaxInertia;
	import com.lextalkington.parallax.ParallaxReturn;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	/**
	 * ...
	 * @author jc
	 */
	public class ParalaxTest extends Sprite
	{
		private var _pEi:ParallaxInertia;
		private var _pE:ParallaxEngine;
		private var _pEr:ParallaxReturn;
		
		public function ParalaxTest() 
		{
			addEventListener( Event.ADDED_TO_STAGE, init );
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener( Event.REMOVED_FROM_STAGE, destroy );
			initParalax();
		}
		
		private function destroy(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
		}
		
		private function initParalax():void 
		{
			//stage.scaleMode = StageScaleMode.NO_SCALE;
			//stage.align = StageAlign.TOP;	
			//stage.showDefaultContextMenu = false;
			//stage.quality = StageQuality.BEST;
			
			const xpos:uint = 0;
			const w:uint = 640;
			const h:uint = 480;			
			
			_pE = new ParallaxEngine(w, h, 0.09, ParallaxEngine.X_AXIS);			
			_pEr = new ParallaxReturn(w, h, 0.15, ParallaxEngine.Y_AXIS);
			_pEi = new ParallaxInertia(w, h, 0.09, ParallaxEngine.BOTH_AXIS);
			
			_pEi.x = xpos;			
			_pEi.y = 0;			
			var cAi:ClipA = new ClipA();
			var cBi:ClipB = new ClipB();
			cAi.filters = [new BlurFilter(20,20,3)];
			// I'm cacheing the clips to possibly improve performance, cAi is already cached actually due to the applied filter.
			cBi.cacheAsBitmap = true;
			_pEi.addPlate(cAi);
			_pEi.addPlate(cBi);
			addChild(_pEi);
			addEventListener( Event.ENTER_FRAME, onEnterFrame );
			_pEi.update( stage.mouseX, stage.mouseY );			
			_pEi.start();			
		}
		
		private function onEnterFrame(e:Event):void 
		{			
			_pEi.update( stage.mouseX, stage.mouseY );
		}
		
	}

}