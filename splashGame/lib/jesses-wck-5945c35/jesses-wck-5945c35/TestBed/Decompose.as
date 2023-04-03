﻿package {		import Box2DAS.*;	import Box2DAS.Collision.*;	import Box2DAS.Collision.Shapes.*;	import Box2DAS.Common.*;	import Box2DAS.Dynamics.*;	import Box2DAS.Dynamics.Contacts.*;	import Box2DAS.Dynamics.Joints.*;	import misc.*;	import flash.events.*;		public class Decompose extends Test {				public function Decompose() {			super();						Main.txt.text = "Decomposition:";						b2Def.body.type = b2Body.b2_dynamicBody;			var f:b2Fixture;			var hx:Number = 20 / scale;			var hy:Number = 20 / scale;			for(var x:Number = 100; x <= 500; x += 50) {				for(var y:Number = 100; y <= 200; y += 50) {					b2Def.body.position.x = x / scale;					b2Def.body.position.y = y / scale;					var b:b2Body = b2Def.body.create(this);					var s:Vector.<b2PolygonShape> = b2PolygonShape.Decompose(Vector.<Number>([						-hx, -hy,						0, -hy + (Math.random() * 20 - 10) / scale,						hx,  -hy,						hx + (Math.random() * 20 - 10) / scale, 0,						hx, hy,						0, hy + (Math.random() * 20 - 10) / scale,						-hx, hy,						-hx + (Math.random() * 20 - 10) / scale, 0					]));					for(var i:int = 0; i < s.length; ++i) {						with(b2Def.fixture) {							shape = s[i];							density = 1.0;							f = create(b);						}						s[i].destroy();					}				}			}		}	}}