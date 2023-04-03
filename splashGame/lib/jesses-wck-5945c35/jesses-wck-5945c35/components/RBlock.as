package components {
	
	import Box2DAS.Collision.AABB;
	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.b2Body;
	import Box2DAS.Dynamics.b2Fixture;
	import com.monsterPatties.controllers.GameDataController;
	import com.monsterPatties.events.GameEvent;
	import com.monsterPatties.utils.eventSatellite.EventSatellite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import misc.Util;
	import shapes.ShapeBase;
	import wck.*;
	
	public class RBlock extends ShapeBase {		
		
		private var _gameEvent:GameEvent;
		//private var _gdc:GameDataController;
		private var _es:EventSatellite;
		
		public override function shapes():void {
			box();
			addEventListener( MouseEvent.CLICK, onClickMe );			
			//_gdc =  GameDataController.getInstance();
			_es = EventSatellite.getInstance();			
			allowDragging = false;
		}		
		
		
		private function onClickMe(e:MouseEvent):void 
		{				
			removeEventListener( MouseEvent.CLICK, onClickMe );
			
			
			//if ( ( _gdc.getClickCnt() - 1  ) < 0 ) {
				//_gameEvent = new GameEvent( GameEvent.LEVEL_FAILED );
				//_es.dispatchESEvent( _gameEvent );
			//}else {
				//_gdc.updateClick( -1 );
				//_gdc.updateTotalClickCnt( 1 );
				//_gameEvent =  new GameEvent( GameEvent.UPDATE_CLICK );
				//_es.dispatchESEvent( _gameEvent );
			//}
			
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