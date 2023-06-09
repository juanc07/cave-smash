﻿package shapes {
	
	import Box2DAS.*;
	import Box2DAS.Collision.*;
	import Box2DAS.Collision.Shapes.*;
	import Box2DAS.Common.*;
	import Box2DAS.Dynamics.*;
	import Box2DAS.Dynamics.Contacts.*;
	import Box2DAS.Dynamics.Joints.*;
	import cmodule.Box2D.*;	
	import misc.Input;
	import misc.Util;
	import shapes.*;	
	import extras.*;
	import flash.utils.*;
	import flash.events.*;
	import flash.display.*;
	import flash.text.*;
	import flash.geom.*;
	import wck.BodyShape;
	import wck.ContactList;
	
	public class Cow extends Circle {
		
		public var contacts:ContactList;
		
		public override function create():void {
			reportBeginContact = true;
			reportEndContact = true;
			fixedRotation = true;
			super.create();
			listenWhileVisible(world, StepEvent.STEP, parseInput, false, 10);
			listenWhileVisible(this, ContactEvent.BEGIN_CONTACT, handleContact);
			contacts = new ContactList();
			contacts.listenTo(this);
		}
		
		public function handleContact(e:ContactEvent):void {
			//var body:BodyShape = fixture.m_userData.body 			
			//if ( fixture.m_userData is Grass ) {
				//body.remove();
			//}
			var p:Grass = e.other.m_userData as Grass;
			if(p) {
				Util.addChildAtPosOf(world, new FX1(), p);  				
				//Util.addChildAtPosOf(world, new BoxMC2(), p);
				p.remove();
				
			}
		}
		
		public function parseInput(e:Event):void {
			var manifold:b2WorldManifold = null;
			var dot:Number = -1;
			
			// Search for the most ground/floor-like contact.
			if(!contacts.isEmpty()) {
				contacts.forEach(function(keys:Array, c:ContactEvent) {
					var wm:b2WorldManifold = c.getWorldManifold();
					if(wm.normal) { 
						
						// Dot producting the contact normal with gravity indicates how floor-like the
						// contact is. If the dot product = 1, it is a flat foor. If it is -1, it is
						// a ceiling. If it's 0.5, it's a sloped floor. Save the contact manifold
						// that is the most floor like.
						var d:Number = wm.normal.dot(gravity);
						if(!manifold || d > dot) {
							manifold = wm;
							dot = d;
						}
					}
				});
				contacts.clean();
			}
			var left:Boolean = Input.kd('A', 'LEFT');
			var right:Boolean = Input.kd('D', 'RIGHT');
			var jump:Boolean = Input.kp(' ', 'UP');
			var v:V2;
			
			// Here we could add a dot product threshold for disallowing the player from jumping
			// off of walls, ceilings, etc. For example:
			// if(jump && manifold && dot > 0) {
			if(jump && manifold) {
				v = manifold.normal.clone().multiplyN(-2);
				b2body.ApplyImpulse(v, b2body.GetWorldCenter());
			}
			else if(left) {
				b2body.ApplyImpulse(new V2(-0.1, 0), b2body.GetWorldCenter());
			}
			else if(right) {
				b2body.ApplyImpulse(new V2(0.1, 0), b2body.GetWorldCenter());				
			}
		}
	}
}
