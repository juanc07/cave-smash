package components.joints 
{
	import com.monsterPatties.events.CaveSmashEvent;
	import com.monsterPatties.utils.eventSatellite.EventSatellite;
	import wck.Joint;
	/**
	 * ...
	 * @author ...
	 */
	public class JointBase extends Joint
	{		
		public var _es:EventSatellite;
		public var hasRemoved:Boolean;
		public var _levelIsDone:Boolean = false;
		
		public function JointBase(){
			super();
		}
		
		override public function create():void{
			super.create();
			addGameEvent();
		}
		
		/*------------------------------------------------------------------Methods----------------------------------------------------------------------*/		
		public function clearAll():void{				
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
			if( !hasRemoved && this != null && world != null && this.b2body1 != null && this.b2body2 != null && b2joint != null && connector != null ){
				hasRemoved = true;				
				//this.destroyConnector();
				//this.destroyJoint();
				//this.remove();
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