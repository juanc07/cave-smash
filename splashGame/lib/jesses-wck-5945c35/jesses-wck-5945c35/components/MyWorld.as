package components {
	
	import Box2DAS.*;
	import Box2DAS.Collision.*;
	import Box2DAS.Collision.Shapes.*;
	import Box2DAS.Common.*;
	import Box2DAS.Dynamics.*;
	import Box2DAS.Dynamics.Contacts.*;
	import Box2DAS.Dynamics.Joints.*;
	import cmodule.Box2D.*;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.ui.*;
	import flash.utils.*;
	import gravity.*;
	import misc.*;
	import wck.*;
	
	/**
	 * Wraps b2World and provides inspectable properties that can be edited in Flash.
	 */
	public class MyWorld extends World {
		
		/// See the Box2d documentation for explanations of the variables below.
		//joints
		public var s1:*;
		public var s2:*;
		public var s3:*;
		public var anc:*;
		public var anc2:*;
		public var anc3:*;
		
		//connector / or the actuall spring
		public var connectorString:ConnectorSpring;
		public var connectorDot:ConnectorDots;
		public var connectorRed:ConnectorRed;
		public var connectorWhite:ConnectorWhite;
		
		
		
		public override function create():void {
			super.create();			
            //focusOn = "player";
            scrolling = true;
			debugDraw = true;
		}
		
		public function stopSimulation():void 
		{
			paused = true;
			scrolling = false;
		}
		
		public function startSimulation():void 
		{
			paused = false;
			scrolling = true;
		}
		
		public function getPlayer():DisplayObject 
		{
			return this.focus;
		}
		
		public function getWorld():DisplayObject 
		{
			return this;
		}
		
		public function clearWorld():void 
		{
			trace( "b4 clearing world!!!!! numChildren " + this.numChildren );
			while (this.numChildren > 0){				
				this.removeChildAt(0);
			}
			trace( "clearing world!!!!! last numChildren " + this.numChildren );
		}
		
		//public function createHero():void 
		//{
			//var hero:Player2 = new Player2();					
			//Util.addChildAtPosOf( this, hero, this );
		//}
	}
}