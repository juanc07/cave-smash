package com.monsterPatties.controllers 
{
	import com.monsterPatties.events.GameEvent;
	import com.monsterPatties.utils.eventSatellite.EventSatellite;
	import com.monsterPatties.utils.spil.SpilManager;
	/**
	 * ...
	 * @author ...
	 */
	public class AwardController 
	{
		/*----------------------------------------------------------Properties------------------------------------------------------------------------*/
		private static var _instance:AwardController;
		private var _es:EventSatellite;
		private var _spilManager:SpilManager;
		private var _isStarted:Boolean = false;
		/*----------------------------------------------------------Constants------------------------------------------------------------------------*/
		
		/*----------------------------------------------------------Constructor------------------------------------------------------------------------*/
		
		
		public function AwardController( enforcer:SingletonEnforcer  )
		{
		}
		
		public static function getInstance(  ):AwardController
		{
			if ( AwardController._instance == null ) {
				AwardController._instance = new AwardController( new SingletonEnforcer() );
			}
			
			return AwardController._instance;
		}
		
		/*----------------------------------------------------------Methods------------------------------------------------------------------------*/
		public function init():void {
			if (!_isStarted) {
				_isStarted = true;
				_spilManager = SpilManager.getInstance();
				_es = EventSatellite.getInstance();
				_es.addEventListener( GameEvent.GET_AWARD, onGetAward );
			}
		}
		
		public function destroy():void{
			_es.removeEventListener( GameEvent.GET_AWARD, onGetAward );
		}
		
		private function onGetAward(e:GameEvent):void{
			switch (e.obj.id) 
			{
				case 1:
					_spilManager.submitAward(SpilManager.AWARD1);
				break;
				
				case 2:
					_spilManager.submitAward(SpilManager.AWARD2);
				break;
				
				case 3:
					_spilManager.submitAward(SpilManager.AWARD3);
				break;
				
				case 4:
					_spilManager.submitAward(SpilManager.AWARD4);
				break;
				
				case 5:
					_spilManager.submitAward(SpilManager.AWARD5);
				break;
				default:
			}
		}
		/*----------------------------------------------------------Setters------------------------------------------------------------------------*/
		
		/*----------------------------------------------------------Getters------------------------------------------------------------------------*/
		
		/*----------------------------------------------------------EventHandlers------------------------------------------------------------------------*/
		
	}
}

class SingletonEnforcer {}