package com.monsterPatties.data
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author ...
	 */
	public class GameData
	{
		//data that will never change
		public static const maxLevel:int = 7;
		public static const MAX_LIVE:int = 3;
		public static const MAX_ADDITIONAL_LIVE:int = 2;
		public var additionalLive:int = 0;
		public static const MAX_CRYSTALS:int = 135;
		
		//data that is always reset every new level
		public var isKeyCollected:Boolean;
		public var previousLevel:int = 0;
		public var currLevel:int = 0;
		public var currentSubLevel:int = 0;
		public var prevTime:String;
		public var curTime:String;
		public var currentScore:int = 0;
		
		//data that is changing during gameplay
		public var totalSec:int;
		public var second:int;
		public var minute:int;
		public var hour:int;
		public var speed:int;
		public var live:int = 0;
		public var score:int = 0;
		public var totalScore:int = 0;
		public var money:int = 0;
		public var isPaused:Boolean;
		
		//data that changed rarely or every load of new game
		public var level:int = 0;
		public var map:int = 0;
		public var currentMap:int = 0;
		
        public var hiScore:int = 0;
		public var totalMoney:int = 0;
		
		//new cave Smash specific data
		public var gold:int;
		public var crystal:int;
		
		public var totalGold:int;
		//public var totalCrystal:int;
		
		public var direction:int;
		
		public var isDoneLevel:Boolean;
		
		public var hasDoubleJump:Boolean = false;
		public var hasComboAttack:Boolean = false;
		public var hasThrowWeapon:Boolean = false;
		public var hasThrowAirWeapon:Boolean = false;
		public var hasWallClimb:Boolean = false;
		public var hasBomber:Boolean = false;
		
		public var isLockControlls:Boolean = false;
		public var collectedCrystals:Array;
		public var levelScores:Array;
		public var isCrystalTutorialDone:Boolean = false;
		public var isCoinTutorialDone:Boolean = false;
		
		public var currentSelectedItem:ShopItem;
		public var isGoingToShop:Boolean;
		
		public var currentSelectedLevel:int;
		public var currentScene:int;
		public var completeScene:Vector.<int>;
		public var isScenePlaying:Boolean;
		public var checkpoint:Point;
		
		public function GameData()
		{
			
		}
		
	}

}