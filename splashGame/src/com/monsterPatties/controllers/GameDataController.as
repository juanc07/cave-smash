package com.monsterPatties.controllers
{
	import com.monsterPatties.config.GameConfig;
	import com.monsterPatties.data.GameData;
	import com.monsterPatties.data.ShopItem;
	import com.monsterPatties.utils.kongregateApi.Kong;
	import com.monsterPatties.utils.sharedObjects.SharedData;
	import components.items.ItemConfig;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GameDataController
	{
		
		/*-------------------------------------------------------------------Constant----------------------------------------------*/
		
		/*-------------------------------------------------------------------Properties--------------------------------------------*/
		private static var _instance:GameDataController;
		private var _gameData:GameData;
		private var _kong:Kong;
		private var _sd:SharedData;
		/*-------------------------------------------------------------------Constructor-------------------------------------------*/
		
		public function GameDataController( enforcer:SingletonEnforcer  )
		{
		}
		
		public static function getInstance(  ):GameDataController
		{
			if ( GameDataController._instance == null ) {
				GameDataController._instance = new GameDataController( new SingletonEnforcer() );
			}
			
			return GameDataController._instance;
		}
		
		
		public function init():void
		{
			if ( GameConfig.isLive ) {
				if ( GameConfig.isKongregate ) {
					_kong = Kong.getInstance();
				}
			}		
			
			_gameData = new GameData();
			clearCollectedCrystal();
			clearLevelScores();
			setCurrentScore( 0 );
			setScore( 0 );
			setMoney( 0 );
			setLive( GameData.MAX_LIVE + getAdditionalLive() );
			setHiScore( 0 );
			setTotalMoney( 0 );
			setIsKeyCollected( false );
			setGold( 0 );
			setCrystal( 0 );
			
			setTotalGold( 0 );
			//setTotalCrystal( 0 );
			
			//setLevel( 20 );
			setLevel( 1 );
			setCurrLevel( 1 );
			//setCurrLevel( 20 );
			setCurrentMap( 1 );
			setMap(1);
			setWallClimb(true);
			//setCurrentMap( 2 );
			trace( "[GameDataController]: init....");
			clearCompletedScene();
			loadData();
			
			if (GameConfig.isCheat){
				setGold( 99999 );
				setTotalGold(99999);				
				setMoney( 99999 );
				setCrystal(9999)
				
				setLevel( 45 );
				setCurrLevel( 45 );			
				setCurrentMap( 2 );
				setMap(2);
				
				updateCompletedScene(1);
				updateCompletedScene(2);
				updateCompletedScene(3);
				updateCompletedScene(4);
				//ItemConfig.SHOP_SHOES_PRICE = 1;
				//ItemConfig.SHOP_HAMMER_PRICE = 1;
				//ItemConfig.SHOP_THROW_PRICE = 1;
				//ItemConfig.SHOP_HEART_PRICE = 1;
				//ItemConfig.SHOP_BOMB_PRICE = 1;
			}else {
				ItemConfig.SHOP_SHOES_PRICE = 300;
				ItemConfig.SHOP_HAMMER_PRICE = 450;
				ItemConfig.SHOP_THROW_PRICE = 550;
				ItemConfig.SHOP_HEART_PRICE = 250;
				ItemConfig.SHOP_BOMB_PRICE = 800;
			}
		}
		
		public function retry():void
		{
			
			setCurrentScore( 0 );
			setMoney( 0 );
			setLive( GameData.MAX_LIVE + getAdditionalLive() );
			setPausedGame( false );
			setIsKeyCollected( false );
			
			setGold( 0 );
			setCrystal( 0 );
		}
		
		/*-------------------------------------------------------------------Methods----------------------------------------------*/
		public function loadData():void
		{
			_sd = SharedData.getInstance();
			
			//tutorials
			setCoinTutorial(_sd.getSharedData( "coin"));
			setCrystalTutorial(_sd.getSharedData( "crystals"));
			setCompletedScene(_sd.getSharedData( "scenes"));		
			
			loadAllScore();
			var loadedScore:int = totalAllScore();
			setTotalScore(loadedScore);
			_sd.addSharedData( "totalScore", _gameData.totalScore );
			
			
			trace( "loadData map 1 score " + getTotalLevelScoreByMap(1) );
			trace( "loadData map 2 score " + getTotalLevelScoreByMap(2) );
			trace( "loadData map 3 score " + getTotalLevelScoreByMap(3) );
			
			//game status
			_gameData.currLevel = _sd.getSharedData( "currentLevel" );
			_gameData.totalScore = _sd.getSharedData( "totalScore" );
			_gameData.hiScore = _sd.getSharedData( "hiscore" );
			_gameData.level = _sd.getSharedData( "level" );
			_gameData.totalGold = _sd.getSharedData( "totalGold" );
			var crystals:Array = _sd.getSharedData( "allCrystal" );
			
			
			//updgrades
			setDoubleJump( _sd.getSharedData( "jump"));
			setComboAttack(_sd.getSharedData( "combo"));
			setThrowWeapon(_sd.getSharedData( "throw"));
			setBomber(_sd.getSharedData( "bomb"));
			setAdditionalLive(_sd.getSharedData( "extraLives"));
			
			if ( crystals != null){
				setAllCrystallArray(crystals);
			}else {
				clearCollectedCrystal();
			}
			
			
			if ( _gameData.totalGold == 0) {
				_gameData.totalGold = 0;
			}
			
			if ( _gameData.score == 0) {
				_gameData.score = 0;
			}
			
			if ( _gameData.hiScore == 0) {
				_gameData.hiScore = 0;
			}

			if ( _gameData.currLevel > 15 && _gameData.currLevel <= 30){
				setCurrentMap(2);
				setMap(2);
			}else if ( _gameData.currLevel > 30 && _gameData.currLevel <= 45){
				setCurrentMap(3);
				setMap(3);
			}else {
				setCurrentMap(1);
				setMap(1);
			}
			
			trace( "[Game data Controller ]: data has been loaded...." );
		}
		
		public function saveData():void
		{
			//tutorial
			_sd.addSharedData( "coin", getCoinTutorial() );
			_sd.addSharedData( "crystals", getCrystalTutorial() );
			_sd.addSharedData( "scenes", getCompletedScene() );
			
			
			//game status
			_sd.addSharedData( "currentLevel", _gameData.currLevel );
			_sd.addSharedData( "totalScore", _gameData.totalScore );
			_sd.addSharedData( "hiscore", _gameData.hiScore );
			_sd.addSharedData( "level", _gameData.level );
			_sd.addSharedData( "totalGold", _gameData.totalGold );
			_sd.addSharedData( "allCrystal", getAllCollectedCrsytalArray() );
			
			
			//updagrades
			_sd.addSharedData( "jump", hasDoubleJump());
			_sd.addSharedData( "throw", hasThrowWeapon());
			_sd.addSharedData( "combo", hasComboAttack());
			_sd.addSharedData( "bomb", hasBomber());
			_sd.addSharedData( "extraLives", getAdditionalLive());
			
			trace( "[Game data Controller ]: data has been saved...." );
		}
		
		public function deleteData():void
		{
			deleteAllScore();
			_sd.removeSharedData( "coin" );
			_sd.removeSharedData( "crystals" );
			_sd.removeSharedData( "scenes" );
			
			_sd.removeSharedData( "currentLevel" );
			_sd.removeSharedData( "totalScore" );
			_sd.removeSharedData( "hiscore" );
			_sd.removeSharedData( "level" );
			_sd.removeSharedData( "totalGold");
			_sd.removeSharedData( "allCrystal");
			
			_sd.removeSharedData( "jump");
			_sd.removeSharedData( "throw");
			_sd.removeSharedData( "combo");
			_sd.removeSharedData( "bomb");
			_sd.removeSharedData( "extraLives");
			
			clearCompletedScene();
			clearCollectedCrystal();
			clearLevelScores();
			setMap(1);
			setCurrentMap(1);
			setScore(0);
			setCurrentScore(0);
			setHiScore(0);
			setAdditionalLive(0);
			setBomber(false);
			setCoinTutorial(false);
			setComboAttack(false);
			setCrystal(0);
			setCrystalTutorial(false);
			setCurrentSelectedItem(null);
			setCurrentSubLevel(1);
			
			loadData();
			trace( "[Game data Controller ]: data has been deleted...." );
		}
		/*-------------------------------------------------------------------Setters----------------------------------------------*/
		public function setCurrentScore( val:int ):void {
			_gameData.currentScore = val;
		}
		
		public function updateCurrentScore( val:int ):void {
			_gameData.currentScore += val;
		}
		
		
		public function setScore( val:int ):void {
			_gameData.score = val;
		}
		
		public function updateScore( val:int ):void {
			_gameData.score += val;
		}

        public function setHiScore( val:int ):void {
			_gameData.hiScore = val;
		}

        public function updateHiScore( val:int ):void {
			_gameData.hiScore += val;
		}
		
		public function setKongTime( time:String ):void
		{
			_kong.submitTime( time );
		}
		
		public function setLive( val:int ):void
		{
			_gameData.live = val;
		}
		
		public function setPrevTime( val:String ):void
		{
			_gameData.prevTime = val;
		}
		
		public function setCurTime( val:String ):void
		{
			_gameData.curTime = val;
			//trace( "[GDC]  Curtime", _gameData.curTime );
		}
		
		public function setPausedGame( val:Boolean ):void
		{
			_gameData.isPaused = val;
		}
		
		public function setSecond( val:int ):void
		{
			_gameData.second = val;
		}
		
		public function updateSecond( val:int ):void
		{
			_gameData.second += val;
		}
		
		public function setMinute( val:int ):void
		{
			_gameData.minute = val;
		}
		
		public function updateMinute( val:int ):void
		{
			_gameData.minute += val;
		}
		
		public function setHour( val:int ):void
		{
			_gameData.hour = val;
		}
		
		public function updateHour( val:int ):void
		{
			_gameData.hour += val;
		}
		
		
		public function setSpeed( val:int ):void
		{
			_gameData.speed = val;
		}
		
		public function updateSpeed( val:int ):void
		{
			_gameData.speed += val;
		}
		
		public function updateTotalSec( val:int ):void
		{
			_gameData.totalSec += 1;
		}
		
		public function setTotalSec( val:int ):void
		{
			_gameData.totalSec = val;
		}
		
		public function setLevel( val:int ):void
		{
			_gameData.level = val;
		}
		
		public function updateLevel( val:int ):void
		{
			_gameData.level += val;
		}
		
		public function setCurrLevel( val:int ):void
		{
            _gameData.currLevel = val;
		}
		
		public function setCurrentSubLevel( val:int ):void
		{
			_gameData.currentSubLevel = val;
		}
		
		public function updateCurrentSubLevel( val:int ):void
		{
			_gameData.currentSubLevel += val;
		}
		
		public function updateCurrLevel( val:int ):void
		{
			_gameData.currLevel += val;
		}
		
		public function updateMoney(val:int ):void
		{
			_gameData.money += val;
		}
		
		public function setMoney(val:int ):void
		{
			_gameData.money = val;
		}
		
		public function setTotalMoney( val:int ):void
		{
			_gameData.totalMoney = val;
		}
		
		public function updateTotalMoney( val:int ):void
		{
			_gameData.totalMoney += val;
		}
		
		//new cave smash data
		public function setIsKeyCollected( val:Boolean ):void {
			_gameData.isKeyCollected = val;
		}
		
		public function setGold(val:int ):void
		{
			_gameData.gold = val;
		}
		
		public function updateGold(val:int ):void
		{
			_gameData.gold += val;
		}
		
		public function setTotalGold(val:int ):void
		{
			_gameData.totalGold = val;
		}
		
		public function updateTotalGold(val:int ):void
		{
			_gameData.totalGold += val;
		}
		
		public function setCrystal(val:int ):void
		{
			_gameData.crystal = val;
		}
		
		public function updateCrystal(val:int ):void
		{
			_gameData.crystal += val;
		}
		
		//public function setTotalCrystal(val:int ):void
		//{
			//_gameData.totalCrystal = val;
		//}
		
		//public function updateTotalCrystal(val:int ):void
		//{
			//_gameData.totalCrystal += val;
		//}
		
		
		public function setMap(val:int ):void
		{
			_gameData.map = val;
		}
		
		public function updateMap(val:int ):void
		{
			_gameData.map += val;
		}
		
		public function setCurrentMap(val:int ):void
		{
			_gameData.currentMap = val;
		}
		
		public function updateCurrentMap(val:int ):void
		{
			_gameData.currentMap += val;
		}
		
		public function setDir( val:int ):void
		{
			_gameData.direction = val;
		}
		
		public function setIsDoneLevel( val:Boolean ):void
		{
			_gameData.isDoneLevel = val;
		}
		
		public function setDoubleJump(val:Boolean):void
		{
			_gameData.hasDoubleJump = val;
		}
		
		public function setComboAttack(val:Boolean):void
		{
			_gameData.hasComboAttack = val;
		}
		
		public function setThrowWeapon(val:Boolean):void
		{
			_gameData.hasThrowWeapon = val;
		}
		
		public function setThrowAirWeapon(val:Boolean):void
		{
			_gameData.hasThrowAirWeapon = val;
		}
		
		public function setWallClimb(val:Boolean):void
		{
			_gameData.hasWallClimb = val;
		}
		
		public function setBomber(val:Boolean):void
		{
			_gameData.hasBomber = val;
		}
		
		public function setIsLockControlls(val:Boolean):void
		{
			_gameData.isLockControlls = val;
		}
		
		public function updateCollectedCrystal( map:int , level:int ,crystal:int ):void
		{
			if( _gameData.collectedCrystals == null  ){
				clearCollectedCrystal();
			}
			_gameData.collectedCrystals[ map -1 ][  level - 1] = crystal;
		}
		
		public function clearCollectedCrystal():void
		{
			_gameData.collectedCrystals = [ [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
											[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
											[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
										  ];
		}
		
		public function setAllCrystallArray(crystals:Array):void {
			clearCollectedCrystal();
			_gameData.collectedCrystals = crystals;
		}
		
		public function updateLevelScore( map:int , level:int ,score:int ):void
		{
			if( _gameData.levelScores == null  ){
				_gameData.levelScores = [ [],[],[] ];
			}
			
			var currMap:int = map - 1;			
			_gameData.levelScores[ currMap ][  level ] = score;
			_sd.addSharedData( currMap.toString() + level.toString(), score );
		}
		
		
		public function loadAllScore():void {
			var row:int = 3;
			var col:int = 15;
			var scores:int = 0;
			var currentLevel:int;
			//trace("--------------------------------loadAllScore----------------------------------");
			for (var i:int = 0; i < row; i++){
				for (var j:int = 0; j < col; j++) {
					currentLevel =  ( j + 1 ) + (i * 15);
					_gameData.levelScores[ i ][  currentLevel ] = _sd.getSharedData( i.toString()+currentLevel.toString() );
					//trace( " i " + i + " j " + currentLevel + " score " + _gameData.levelScores[ i ][  currentLevel ] );
				}
			}
			//trace("--------------------------------loadAllScore----------------------------------");			
		}
		
		public function deleteAllScore():void {
			var row:int = 3;
			var col:int = 15;
			var scores:int = 0;
			var currentLevel:int;
			//trace("--------------------------------deleteAllScore----------------------------------");
			for (var i:int = 0; i < row; i++){
				for (var j:int = 0; j < col; j++) {
					currentLevel =  ( j + 1 ) + (i * 15);
					_sd.removeSharedData( i.toString() + currentLevel.toString() );
					_gameData.levelScores[ i ][  currentLevel ] = _sd.getSharedData( i.toString()+currentLevel.toString() );
					//trace( " i " + i + " j " + currentLevel + " score " + _gameData.levelScores[ i ][  currentLevel ] );
				}
			}
			//trace("--------------------------------deleteAllScore----------------------------------");			
		}
		
		public function totalAllScore():int {
			var row:int = 3;
			var col:int = 15;
			var scores:int = 0;
			var currentLevel:int;
			//trace("--------------------------------gettotalscore----------------------------------");
			for (var i:int = 0; i < row; i++){
				for (var j:int = 0; j < col; j++) {
					currentLevel =  ( j + 1 ) + (i * 15);
					//trace( " i " + i + " j " + currentLevel );
					if (_gameData.levelScores[i ][ currentLevel ] != undefined ) {
						scores += _gameData.levelScores[i ][ currentLevel ];
					}					
				}
			}
			//trace(" scores " +  scores );
			//trace(" _gameData.levelScores[i ][ currentLevel ] test check" +  _gameData.levelScores[ 0 ][ 3 ] );
			//trace("--------------------------------gettotalscore----------------------------------");
			return scores;			
		}
		
		public function clearLevelScores():void
		{
			_gameData.levelScores = [ [],[],[] ];
		}
		
		
		public function setCrystalTutorial(val:Boolean):void
		{
			_gameData.isCrystalTutorialDone = val;
		}
		
		public function setCoinTutorial(val:Boolean):void
		{
			_gameData.isCoinTutorialDone = val;
		}
		
		
		public function setCurrentSelectedItem(item:ShopItem):void
		{
			_gameData.currentSelectedItem = item;
		}
		
		public function setIsGoingToShop(val:Boolean):void
		{
			_gameData.isGoingToShop = val;
		}
		
		public function setAdditionalLive(val:int):void
		{
			_gameData.additionalLive = val;
			if (_gameData.additionalLive > GameData.MAX_ADDITIONAL_LIVE) {
				_gameData.additionalLive = GameData.MAX_ADDITIONAL_LIVE;
			}
		}
		
		public function clearCompletedScene():void{
			_gameData.completeScene = new Vector.<int>();
		}
		
		public function setCompletedScene(arr:Vector.<int>):void {
			if(arr != null){
				_gameData.completeScene = arr;
			}else {
				trace("no scene loaded!!!");
			}
		}
		
		public function getCompletedScene():Vector.<int>{
			return _gameData.completeScene;
		}
		
		public function updateCompletedScene(scene:int):void{
			_gameData.completeScene.push(scene);
		}
		
		public function setCurrentSelectedLevel(val:int):void{
			_gameData.currentSelectedLevel = val;
		}
		
		public function getCurrentSelectedLevel():int{
			return _gameData.currentSelectedLevel;
		}
		
		public function setIsScenePlaying(val:Boolean):void{
			_gameData.isScenePlaying = val;
		}
		
		public function getIsScenePlaying():Boolean{
			return _gameData.isScenePlaying;
		}
		
		public function getCheckpoint():Point {
			//if (_gameData.checkpoint == null){
				//_gameData.checkpoint = new Point(0,0);
			//}
			return _gameData.checkpoint;
		}
		
		public function setCheckpoint(pt:*):void{
			_gameData.checkpoint = pt;
		}
		
		public function setTotalScore(val:int):void {
			_gameData.totalScore = val;
		}
		/*-------------------------------------------------------------------Getters----------------------------------------------*/
		
		public function getCurrentScore( ):int {
			return _gameData.currentScore;
		}
		
		public function getScore():int
		{
			return _gameData.score;
		}

        public function getHiScore():int
		{
			return _gameData.hiScore;
		}
		
		public function getHour(  ):int
		{
			return _gameData.hour;
		}
		
		public function getMinute(  ):int
		{
			return _gameData.minute;
		}
		
		public function getSecond(  ):int
		{
			return _gameData.second;
		}
		
		public function getLive( ):int
		{
			return _gameData.live;
		}
		
		public function updateLive( val:int ):void
		{
			_gameData.live += val;
			if ( _gameData.live >= (GameData.MAX_LIVE + _gameData.additionalLive) ) {
				_gameData.live = (GameData.MAX_LIVE + _gameData.additionalLive);
			}
		}
		
		public function getAdditionalLive():int
		{
			return _gameData.additionalLive;
		}
		
		public function updateAdditionalLive(val:int):void
		{
			_gameData.additionalLive += val;
			if (_gameData.additionalLive > GameData.MAX_ADDITIONAL_LIVE){
				_gameData.additionalLive = GameData.MAX_ADDITIONAL_LIVE;
			}
			trace("update additional live updated add live is " + _gameData.additionalLive );
		}
		
		public function getPausedGame(  ):Boolean
		{
			return _gameData.isPaused;
		}
		
		public function getSpeed( ):int
		{
			return _gameData.speed;
		}
		
		public function getTotalSec():int
		{
			return _gameData.totalSec;
		}
		
		public function getLevel(  ):int
		{
			return _gameData.level;
		}
		
		public function getCurrLevel(  ):int
		{
			return _gameData.currLevel;
		}
		
		public function getCurrentSubLevel(  ):int
		{
			return _gameData.currentSubLevel;
		}
		
		public function getMoney():int
		{
			return _gameData.money;
		}
		
		public function getTotalMoney( ):int
		{
			return _gameData.totalMoney;
		}
		
		public function getIsKeyCollected(  ):Boolean{
			return _gameData.isKeyCollected;
		}
		
		
		public function getGold(  ):int
		{
			return _gameData.gold;
		}
		
		public function getCrystal(  ):int
		{
			return _gameData.crystal;
		}
		
		public function getTotalGold():int
		{
			return _gameData.totalGold;
		}
		
		//public function getTotalCrystal():int
		//{
			//return _gameData.totalCrystal;
		//}
		
		public function getDir(  ):int
		{
			return _gameData.direction;
		}
		
		public function getMap(  ):int
		{
			return _gameData.map;
		}
		
		public function getCurrentMap(  ):int
		{
			return _gameData.currentMap;
		}
		
		public function getIsDoneLevel( ):Boolean
		{
			return _gameData.isDoneLevel;
		}
		
		public function getRequiredScoreByLevel( level:int ):int
		{
			var score:int = 0;
			
			switch ( level )
			{
				case 1:
					score = 1500;
				break;
				
				case 2:
					score = 2500;
				break;
				
				case 3:
					score = 3750;
				break;
				
				case 4:
					score = 4500;
				break;
				
				case 5:
					score = 6500;
				break;
				
				case 6:
					score = 7500;
				break;
				
				case 7:
					score = 8500;
				break;
				
				case 8:
					score = 8500;
				break;
				
				case 9:
					score = 8500;
				break;
				
				case 10:
					score = 9500;
				break;
				
				case 11:
					score = 9500;
				break;
				
				case 12:
					score = 10500;
				break;
				
				
				case 13:
					score = 10500;
				break;
				
				case 14:
					score = 12500;
				break;
				
				case 15:
					score = 12500;
				break;
				
				case 16:
					score = 12500;
				break;
				
				case 17:
					score = 13500;
				break;
				
				case 18:
					score = 13500;
				break;
				
				case 19:
					score = 14500;
				break;
				
				case 20:
					score = 14500;
				break;
			}
			
			return score;
		}
		
		public function hasDoubleJump():Boolean
		{
			return _gameData.hasDoubleJump;
		}
		
		public function hasComboAttack():Boolean
		{
			return _gameData.hasComboAttack;
		}
		
		public function hasThrowWeapon():Boolean
		{
			return _gameData.hasThrowWeapon;
		}
		
		public function hasThrowAirWeapon():Boolean
		{
			return _gameData.hasThrowAirWeapon;
		}
		
		public function hasWallClimb():Boolean
		{
			return _gameData.hasWallClimb;
		}
		
		public function hasBomber():Boolean
		{
			return _gameData.hasBomber;
		}
		
		public function getIsLockControlls():Boolean
		{
			return _gameData.isLockControlls;
		}
		
		public function getAllCollectedCrsytalArray():Array{
			return _gameData.collectedCrystals;
		}
		
		public function getCollectedCrystalByMapAndLevel(map:int, level:int):int {
			if (GameConfig.isCheat) {
				return 3;
			}else {
				return _gameData.collectedCrystals[ map - 1 ][  level - 1 ];
			}			
		}
		
		public function getTotalCollectedCrystalByMap(map:int):int{
			var len:int = _gameData.collectedCrystals[map - 1].length;
			
			var total:int = 0;
			for (var j:int = 0; j < len; j++)
			{
				total += _gameData.collectedCrystals[ map - 1 ][ j ];
			}
			return total;
		}
		
		public function getTotalCollectedCrystal():int{
			//trace( "len " + _gameData.collectedCrystals.length + " len2 " + _gameData.collectedCrystals[0].length + "  len3 " + _gameData.collectedCrystals[1].length + "  len4 " + _gameData.collectedCrystals[2].length );
			
			var total:int = 0;
			var len:int = 3;
			var currLevel:int = 0;
			var currCrystal:int = 0;
			
			for (var i:int = 0; i < len; i++){
				var len2:int = _gameData.collectedCrystals[i].length;				
				for (var j:int = 0; j < 15; j++) {
					currLevel = ( 15 * i ) + j;
					currCrystal = _gameData.collectedCrystals[i][currLevel];
					trace(" map " + i + " currLevel " + currLevel + " crystal " + currCrystal );
					if(_gameData.collectedCrystals[i][currLevel]!=undefined){
						total += currCrystal;
					}
				}
			}
			
			trace( " total crystals " + total);
			//hack
			if (GameConfig.isCheat) {
				return 9999;
			}else {
				return total;
			}			
		}
		
		public function getLevelScoreByMapAndLevel(map:int, level:int):int
		{
			return _gameData.levelScores[ map - 1 ][  level ];
		}
		
		public function getTotalLevelScoreByMap(map:int):int {
			var currentMap:int = map - 1;
			var len:int = _gameData.levelScores[currentMap].length;
			//trace(" getTotalLevelScoreByMap len " + len + " map " + currentMap );	
			
			var total:int = 0;
			var start:int;
			
			if (currentMap == 0) {
				start = 1;
			}else if (currentMap == 1) {
				start = 16;
			}else if (currentMap == 2) {
				start = 31;
			}			
			
			for (var j:int = start; j < len; j++) {
				//trace(" getTotalLevelScoreByMap loop " + j + " score " + _gameData.levelScores[ map - 1 ][ j ] );
				if (_gameData.levelScores[ map - 1 ][ j ] != undefined) {
					total += _gameData.levelScores[ map - 1 ][ j ];
				}				
			}
			//trace("  check total b4 sending " + total);
			return total;
		}
		
		public function getCrystalTutorial():Boolean
		{
			return _gameData.isCrystalTutorialDone;
		}
		
		public function getCoinTutorial():Boolean
		{
			return _gameData.isCoinTutorialDone;
		}
		
		public function getCurrentSelectedItem():ShopItem
		{
			return _gameData.currentSelectedItem;
		}
		
		public function getIsGoingToShop():Boolean
		{
			return _gameData.isGoingToShop;
		}
		
		public function getTotalScore():int {
			return _gameData.totalScore;
		}
		
		/*-------------------------------------------------------------------EventHandlers----------------------------------------*/
	}
}

class SingletonEnforcer {}

