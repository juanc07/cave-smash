package components {
	
	import Box2DAS.Collision.AABB;
	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.b2Body;
	import Box2DAS.Dynamics.b2Fixture;
	import flash.events.MouseEvent;
	import misc.Util;
	import shapes.ShapeBase;
	import wck.*;
	
	public class Obstacle extends ShapeBase {	
		
		//kaybol
		 var ndx:Number = 0;
        var ndy:Number = 0;
        var bulletSpeed:int = 1;
        var mouseAngle:Number = 0;
        public var contacts:ContactList;
        var dx:Number = 0;
        var dy:Number = 0;
        var quake:Number = 0;
        var quakevalue:int = 10;
		//
		
		public override function shapes():void {
			box();
			addEventListener( MouseEvent.CLICK, onClickMe );
			
		}
		
		private function onClickMe(e:MouseEvent):void 
		{	
			
			var tempPos:V2 = b2body.GetPosition();
			explosion(tempPos.x, tempPos.y, 120, 20 );
					
			removeEventListener( MouseEvent.CLICK, onClickMe );
			playFade();
			trace( "click me.. box realme" );
		}	
		
		private function playFade():void 
		{			
			Util.addChildAtPosOf(world, new explosionMC(), this );  
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
		
		public function explosion(locx:Number, locy:Number, radius:Number,force:Number):void{			
			var body:b2Body;						
			var METER:Number = 30;
			var lowV2:V2 = new V2( (locx - radius) / METER, (locy - radius ) / METER  );
			var upperV2:V2 = new V2( ( locx + radius ) / METER, (locy + radius ) / METER  );
			
			var newAABB:AABB = new AABB( lowV2,upperV2 );		
			
			world.b2world.QueryAABB(
				function(fixture:b2Fixture):Boolean
				{
					if (!fixture.m_body.IsStatic() && (fixture.m_body != body))
					{					
						body = fixture.m_body;						
						
						//if (body.m_userData is Rblock )
						//{
							//trace( "[Turret ]: hitting myself turret!!" );
						//}
						//else
						//{
							var pBodyPos:V2 = body.GetWorldCenter();
							var pHitVector:V2 = new V2( pBodyPos.x - locx/METER, pBodyPos.y - locy/METER  );							
							
							var radDist:Number = V2.normalize(pHitVector).x;
							radDist = (radDist * METER);
							
							if ( radDist <= radius ){								
								var nHitForce:Number = ((radius-radDist) / radius) * force;
								var appForce:V2 = new V2(V2.normalize(pHitVector).x*nHitForce,V2.normalize(pHitVector).y*nHitForce);
								body.ApplyImpulse(appForce, body.GetWorldCenter());
								
								//var angle:Number = Math.atan2(-1 * pHitVector.y,pHitVector.x);
								//var torque:Number = Math.sin(angle + Math.PI) * Math.cos(angle + Math.PI);
								//torque=(Math.sin(angle + Math.PI) < 0) ? torque :torque*-1;
								//body.ApplyTorque(torque*force*2);
							}
						//}						
					}
					
					return true;
				}, newAABB);
		}
	}
}