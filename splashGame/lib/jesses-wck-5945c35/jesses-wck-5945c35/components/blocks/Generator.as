package components.blocks {	
	
	import com.monsterPatties.events.CaveSmashEvent;
	import com.monsterPatties.utils.eventSatellite.EventSatellite;
	import wck.*;
	
	public class Generator extends BodyShape{
	
		/*------------------------------------------------------------------Constant----------------------------------------------------------------------*/		
		/*------------------------------------------------------------------Properties--------------------------------------------------------------------*/		
		public var blockType:String = BlockConfig.GENERATOR;		
		public var _es:EventSatellite;
		public var hasRemoved:Boolean;
		public var _levelIsDone:Boolean = false;
		/*------------------------------------------------------------------Constructor----------------------------------------------------------------------*/		
		override public function shapes():void{
			super.shapes();
			box();
		}
		
		//public override function shapes():void {			
		//}
		
		override public function create():void{
			super.create();
			type = "Dynamic";
			//applyGravity = false;
			//fixedRotation = true;			
			addGameEvent();
		}
		/*------------------------------------------------------------------Methods----------------------------------------------------------------------*/		
		public function clearAll():void
		{				
			removeAllListeners();
			removeControllers();
			removeGameEvent();					
		}
		
		private function initControllers():void{			
		}			
		
		private function removeControllers():void{			
		}
		
		private function addGameEvent():void{
			_es = EventSatellite.getInstance();
			_es.addEventListener( CaveSmashEvent.LEVEL_STARTED, onLevelStarted );
			_es.addEventListener( CaveSmashEvent.LEVEL_QUIT, OnLevelQuit );
			_es.addEventListener( CaveSmashEvent.LEVEL_COMPLETE, onLevelComplete );			
			_es.addEventListener( CaveSmashEvent.LEVEL_FAILED, onLevelFailed );
			_es.addEventListener( CaveSmashEvent.RELOAD_LEVEL, onReloadLevel );			
		}		
		
		private function removeGameEvent():void{
			_es = EventSatellite.getInstance();
			_es.removeEventListener( CaveSmashEvent.LEVEL_STARTED, onLevelStarted );
			_es.removeEventListener( CaveSmashEvent.LEVEL_QUIT, OnLevelQuit );
			_es.removeEventListener( CaveSmashEvent.LEVEL_COMPLETE, onLevelComplete );			
			_es.removeEventListener( CaveSmashEvent.LEVEL_FAILED, onLevelFailed );
			_es.removeEventListener( CaveSmashEvent.RELOAD_LEVEL, onReloadLevel );			
		}
		
		public function removeME():void{
			if( !hasRemoved  ){
				hasRemoved = true;
				this.remove();
			}
		}
		/*------------------------------------------------------------------Setters----------------------------------------------------------------------*/
		
		/*------------------------------------------------------------------Getters----------------------------------------------------------------------*/
		
		/*------------------------------------------------------------------EventHandlers----------------------------------------------------------------*/		
		public function onLevelFailed(e:CaveSmashEvent):void{			
			_levelIsDone = true;
			clearAll();			
		}
		
		public function onLevelComplete(e:CaveSmashEvent):void {			
			_levelIsDone = true;
			clearAll();
		}
		
		public function onLevelStarted(e:CaveSmashEvent):void{
			_levelIsDone = false;
			initControllers();			
		}
		
		public function OnLevelQuit(e:CaveSmashEvent):void{			
			clearAll();
			removeME();
		}
		
		public function onReloadLevel(e:CaveSmashEvent):void{
			clearAll();
			removeME();
		}
	}
}