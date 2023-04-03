package com.lextalkington {
	
	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Lex Talkington
	 *	@since  26.07.2009
	 */
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.text.*;
	import flash.filters.BlurFilter;
	
	import com.lextalkington.parallax.ParallaxEngine;
	import com.lextalkington.parallax.ParallaxReturn;
	import com.lextalkington.parallax.ParallaxInertia;
	
	[SWF(frameRate="32", width="500", height="570", backgroundColor="#000000")]
	
	public class Doc extends Sprite {

		private var _pE:ParallaxEngine;
		private var _pEr:ParallaxReturn;
		private var _pEi:ParallaxInertia;

		public function Doc() {
			super();
			addEventListener(Event.ADDED_TO_STAGE, init);	
		}
		
		//-----------------------------------
		//	init
		//-----------------------------------
		private function init(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);	
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP;	
			stage.showDefaultContextMenu = false;
			stage.quality = StageQuality.BEST;
			
			const xpos:uint = 20;
			const w:uint = 460;
			const h:uint = 150;
			
			//------------------------------------------ ORIGINAL
			_pE = new ParallaxEngine(w,h,0.09,ParallaxEngine.X_AXIS);
			var cA:ClipA = new ClipA();
			var cB:ClipB = new ClipB();
			cA.filters = [new BlurFilter(20,20,3)];
			// I'm cacheing the clips to possibly improve performance, cA is already cached actually due to the applied filter.
			cB.cacheAsBitmap = true;
			_pE.addPlate(cA);
			_pE.addPlate(cB);
			_pE.x = xpos;
			_pE.y = 30;
			addChild(_pE);
			_pE.start();
			
			drawTextBox(xpos, _pE.y, "A: Motion stops upon mouse-out. Restricted to X-axis.");
			drawRectangle(xpos, _pE.y);

			//------------------------------------------ RETURN VARIATION
			_pEr = new ParallaxReturn(w,h,0.15,ParallaxEngine.Y_AXIS);
			var cAr:ClipA = new ClipA();
			var cBr:ClipB = new ClipB();
			cAr.filters = [new BlurFilter(20,20,3)];
			//center the plates at the starting point within this version
			cAr.x = (w-cAr.width)/2;
			cAr.y = (h-cAr.height)/2;
			cBr.x = (w-cBr.width)/2; 
			cBr.y = (h-cBr.height)/2;
			cAr.filters = [new BlurFilter(20,20,3)];
			// I'm cacheing the clips to possibly improve performance, cAr is already cached actually due to the applied filter.
			cBr.cacheAsBitmap = true;
			_pEr.addPlate(cAr);
			_pEr.addPlate(cBr);
			_pEr.x = xpos;
			_pEr.y = _pE.y + 180;
			addChild(_pEr);
			_pEr.start();
			
			drawTextBox(xpos, _pEr.y, "B: Clips return to initial position upon mouse-out. Restricted to Y-axis.");
			drawRectangle(xpos, _pEr.y);

			//------------------------------------------ INERTIA VARIATION
			_pEi = new ParallaxInertia(w,h,0.09,ParallaxEngine.BOTH_AXIS);
			_pEi.x = xpos;
			_pEi.y = _pEr.y + 180;
			var cAi:ClipA = new ClipA();
			var cBi:ClipB = new ClipB();
			cAi.filters = [new BlurFilter(20,20,3)];
			// I'm cacheing the clips to possibly improve performance, cAi is already cached actually due to the applied filter.
			cBi.cacheAsBitmap = true;
			_pEi.addPlate(cAi);
			_pEi.addPlate(cBi);
			addChild(_pEi);
			_pEi.start();
			
			drawTextBox(xpos, _pEi.y, "C: Inertia continues upon mouse-out, clips ease to a stop.");
			drawRectangle(xpos, _pEi.y);

		}
		
		//-----------------------------------
		//	drawRectangle
		//-----------------------------------
		private function drawRectangle(xp:uint,yp:uint):void {
			var box:Shape = new Shape();
			with(box.graphics) {
				lineStyle(0,0x757575);
				drawRect(xp,yp,460,150);
			}
			addChild(box);
		}
		
		//-----------------------------------
		//	drawTextBox
		//-----------------------------------
		private function drawTextBox(xp:uint, yp:uint, s:String):void {
			var t:TextField = new TextField();
			t.width = 460;
			t.height = 19;
			t.x = xp;
			t.y = yp-19;
			t.embedFonts = false;
			t.selectable = false;
			
			var tf:TextFormat = new TextFormat();
			tf.color = 0xCCCCCC;
			tf.font = "Verdana";
			tf.size = 10;
			
			t.defaultTextFormat = tf;
			t.text = s;
			addChild(t);
		}
		
		//--------------------------------------
		//  UTILITY METHODS
		//--------------------------------------
		private function tracer(str:*):void {
			trace("[Doc]", str);
		}
		
	}
	
}

