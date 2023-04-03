package components {
	
	import Box2DAS.*;
	import Box2DAS.Collision.*;
	import Box2DAS.Collision.Shapes.*;
	import Box2DAS.Common.*;
	import Box2DAS.Dynamics.*;
	import Box2DAS.Dynamics.Contacts.*;
	import Box2DAS.Dynamics.Joints.*;
	import cmodule.Box2D.*;
	import wck.*;
	import shapes.*;
	import misc.*;
	import extras.*;
	import flash.utils.*;
	import flash.events.*;
	import flash.display.*;
	import flash.text.*;
	import flash.geom.*;
	
	public class LoaderTruck extends ScrollerChild {
		
		/*-----------------------------------------------------------------------Constant-------------------------------------------------------------*/
		
		/*-----------------------------------------------------------------------Properties-------------------------------------------------------------*/
		//Contacts of our main body.
		public var contacts:ContactList;
		
		private var dx:Number;
		private var dy:Number;
		private var mouseAngle:Number;
		private var mouseDistance:Number;
		private var ndx:Number;
		private var ndy:Number;
		private var limit:Number = 400;
		private var bulletSpeed:Number = 1;
		private var allow:int = 40;
		 
		public var body:BodyShape;
		public var frontWheel:BodyShape;
		public var backWheel:BodyShape;		
		
		public var rollTorque:Number = 13.0;
		//public var maxWheelSpeed:Number = 200.0;
		//public var wheelSpeedInc:Number = 10.0;
		public var maxWheelSpeed:Number = 50.0;
		public var wheelSpeedInc:Number = 5.0;
		
		private var _graplingHook:GraplingHook;
		private var _isHookAdded:Boolean;
		/*-----------------------------------------------------------------------Construction-------------------------------------------------------------*/
		
		public override function create():void {
			super.create();
			listenWhileVisible(this, Event.ENTER_FRAME, parseInput, false, 10);
			listenWhileVisible(stage, MouseEvent.MOUSE_MOVE, this.mouseAimHandler);
			 
			body = getChildByName('b') as BodyShape;
			frontWheel = getChildByName('fw') as BodyShape;
			backWheel = getChildByName('bw') as BodyShape;			
		}		
		
		/*-----------------------------------------------------------------------Methods-------------------------------------------------------------*/		
		
		/*-----------------------------------------------------------------------Setters-------------------------------------------------------------*/
		
		/*-----------------------------------------------------------------------Getters-------------------------------------------------------------*/
		
		/*-----------------------------------------------------------------------EventHandlers--------------------------------------------------------*/
		public function parseInput(e:Event):void {			
			var left:Boolean = Input.kd('A', 'LEFT');
			var right:Boolean = Input.kd('D', 'RIGHT');
			var up:Boolean = Input.kd('W', 'UP');
			var down:Boolean = Input.kd('S', 'DOWN');
			var jump:Boolean = Input.kp('W', 'UP');			
			
			if(left) {
				body.b2body.ApplyTorque(-rollTorque);
			}
			if(right) {
				body.b2body.ApplyTorque(rollTorque);
			}
			var av:Number = frontWheel.b2body.m_angularVelocity;
			if(up) {
				if(av < 0) {
					av = 0;
				}
				if(!(av > maxWheelSpeed)) {
					av = Math.min(maxWheelSpeed, av + wheelSpeedInc);
				}
			}
			if(down) {
				if(av > 0) {
					av = 0;
				}
				if(!(av < -maxWheelSpeed)) {
					av = Math.max(-maxWheelSpeed, av - wheelSpeedInc);
				}
			}
			frontWheel.b2body.m_angularVelocity = av;
			backWheel.b2body.m_angularVelocity = av;			
		}
		
		private function mouseAimHandler(event:MouseEvent) : void
        {
			
		}
	}
}
