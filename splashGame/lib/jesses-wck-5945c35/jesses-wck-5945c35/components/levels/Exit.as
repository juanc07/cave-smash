package components.levels 
{
	import Box2DAS.Dynamics.ContactEvent;
	import com.greensock.TweenLite;
	import com.monsterPatties.config.GameConfig;
	import com.monsterPatties.data.GameData;
	import com.monsterPatties.events.CaveSmashEvent;
	import com.monsterPatties.events.GameEvent;	
	import components.base.DoorBase;
	import flash.events.Event;
	/**
	 * ...
	 * @author jc
	 */
	public class Exit extends DoorBase
	{		
		public function Exit() 
		{
			super();
		}
		
		override public function initControllers():void 
		{
			super.initControllers();			
			if( this != null ){
				var level:int = _gdc.getCurrLevel();
				if ( level == 15 || level == 30 || level == 45 ) {
					bossExit();
				}else {
					normalExit();
				}
			}		
		}
		
		
		override public function parseInput(e:Event):void 
		{
			super.parseInput(e);			
		}
		
		override public function handleContact(e:ContactEvent):void 
		{
			super.handleContact(e);
			if( this != null ){				
				//trace( "[ Exit ]: begin contact with: === >" + e.other.GetBody().GetUserData() );
				//check if have key			
				if ( e.other.GetBody().GetUserData() is Player && _gdc.getIsKeyCollected() ) {
					var gameEvent:GameEvent = new GameEvent( GameEvent.LOCK_SHORCUT_KEYS );
					_es.dispatchESEvent( gameEvent );					
					TweenLite.delayedCall( 0.1,onClearLevel );				
				}
			}
		}		
		
		private function onClearLevel():void 
		{
			TweenLite.killDelayedCallsTo(onClearLevel);
			
			_isGameCompleted = true;
			removeAllListeners();
			var currentLevel:int  = _gdc.getCurrLevel();
			var currentMap:int  = _gdc.getCurrentMap();
			var currentCrystals:int  = _gdc.getCrystal();
			var currentGold:int  = _gdc.getGold() * currentCrystals;			
			_gdc.updateCollectedCrystal( currentMap, currentLevel, currentCrystals );
			
			var totalCollectedCrystals:int = _gdc.getTotalCollectedCrystal();
			trace(" totalCollectedCrystals: "+ totalCollectedCrystals );
			
			if (GameConfig.isCheat ){
				totalCollectedCrystals = GameData.MAX_CRYSTALS;
			}
			
			if (totalCollectedCrystals>= GameData.MAX_CRYSTALS){				
				var _gameEvent:GameEvent = new GameEvent( GameEvent.GET_AWARD );
				_gameEvent.obj.id = 5;				
				_es.dispatchESEvent( _gameEvent );				
			}
			
			_gdc.updateCurrLevel( 1 );
			
			if ( _gdc.getCurrLevel() > 15 && _gdc.getCurrLevel() <= 30){
				_gdc.setCurrentMap(2);
				_gdc.setMap(2);
			}else if ( _gdc.getCurrLevel() > 30 && _gdc.getCurrLevel() <= 45){
				_gdc.setCurrentMap(3);
				_gdc.setMap(3);
			}
			
			if( _gdc.getCurrLevel() > _gdc.getLevel() ){
				_gdc.setLevel( _gdc.getCurrLevel() );
				//_gdc.updateTotalCrystal( currentCrystals );
				//trace( "update level===============================>>>>> " + _gdc.getLevel() );
			}			
			_gdc.updateTotalGold( currentGold );
			trace( "update level===============================>>>>> gold: " +_gdc.getTotalGold() );
			
			_gdc.setIsDoneLevel( true );
			_gdc.setCurrentSubLevel( 0 );			
			
			//update stats and score
			var currentScore:int = _gdc.getCurrentScore();
			trace( "check current currentMap : " +currentMap + " currentLevel " + currentLevel + " currentScore " + currentScore );
			_gdc.updateLevelScore( currentMap, currentLevel, currentScore );
			
			trace( "map 1 score " + _gdc.getTotalLevelScoreByMap(1) );
			trace( "map 2 score " + _gdc.getTotalLevelScoreByMap(2) );
			trace( "map 3 score " + _gdc.getTotalLevelScoreByMap(3) );
			
			//_gdc.updateScore( currentScore );
			//var score:int = _gdc.getScore();
			var hiScore:int = _gdc.getHiScore();
			
			if ( currentScore > hiScore ){
				_gdc.setHiScore( currentScore );
				trace( "new highscore has been set " + _gdc.getHiScore() );
			}
			
			var totalScore:int = _gdc.totalAllScore();
			_gdc.setTotalScore(totalScore);
			
			_gdc.saveData();
			_caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.LEVEL_COMPLETE );
			_es.dispatchESEvent( _caveSmashEvent );
		}
		
		override public function endContact(e:ContactEvent):void 
		{
			super.endContact(e);
			if( this != null ){
				//trace( "[ Exit ]: end contact with: === >" + e.other.GetBody().GetUserData() );
			}
		}		
	}

}