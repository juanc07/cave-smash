package components.monsters 
{
	import com.greensock.TweenLite;
	import com.monsterPatties.config.CaveSmashConfig;
	import com.monsterPatties.config.GameConfig;
	import com.monsterPatties.config.SoundConfig;
	import com.monsterPatties.events.CaveSmashEvent;
	import components.items.ItemKey;
	import flash.events.Event;
	import flash.geom.Point;
	import misc.Util;
	/**
	 * ...
	 * @author jc
	 */
	public class MiniDarkBoss extends MiniBossFly
	{		
		public function MiniDarkBoss()
		{
			super();
		}		
		
		override public function create():void {
			HIT_DELAY = 0.5;
			ATTACK_DELAY = CaveSmashConfig.MINI_DARK_BOSS_ATTACK_DELAY;		
			
			if(GameConfig.isCheat){
				hp = 1;
			}else {
				hp = CaveSmashConfig.MINI_DARK_BOSS_HP;
			}
			
			super.create();			
		}
		
		override public function playHit():void 
		{
			super.playHit();
			if ( this.mc.currentLabel != LABEL_HIT && this.mc.currentLabel != LABEL_TRANSFORM ){				
				this.mc.gotoAndPlay( LABEL_HIT );				
			}
		}		
		
		override public function teleport():void 
		{
			super.teleport();
			_caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.PLAY_SFX );
			_caveSmashEvent.obj.id = SoundConfig.MINI_DARK_BOSS_TELEPORT_SFX;
			_es.dispatchESEvent( _caveSmashEvent );
		}
		
		override public function kill():void 
		{
			super.kill();
			if ( this.mc.currentLabel != LABEL_DIE){
				this.mc.gotoAndPlay( LABEL_DIE );
				trace("play mini dark boss label die animation");
			}			
		}
		
		private function checkIfTransform():void{
			if (isDead && this.mc.currentLabel == LABEL_TRANSFORM  && !hasStartTransformation) {
				hasStartTransformation = true;
				startTranformation();
			}
		}
		
		override public function goRight():void 
		{
			super.goRight();			
			if( this != null ){
				if( /*this.mc.currentLabel != LABEL_WALK &&*/ !isHit && !isDetectPlayer && !isDead ){
					//this.mc.gotoAndPlay( LABEL_WALK );
				}
			}
		}
		
		override public function goLeft():void
		{
			super.goLeft();			
			if( this != null ){
				if( /*this.mc.currentLabel != LABEL_WALK &&*/ !isHit && !isDetectPlayer && !isDead ){
					//this.mc.gotoAndPlay( LABEL_WALK );
				}
			}
		}
		
		override public function summonShot():void 
		{
			super.summonShot();
			if(this != null && world != null && this.mc != null){
				if( this.mc.currentLabel != LABEL_ATTACK && !isHit && !isDead ){
					this.mc.gotoAndPlay( LABEL_ATTACK );
				}
				
				var rnd:int = Math.random() * 2;
				if ( rnd == 0 ) {
					fireGreenSphereShot();					
				}else {
					fireBlueShot();				
				}				
			}
		}		
		
		
		override public function rapidShot():void 
		{
			super.rapidShot();
			if(this != null && world != null && this.mc != null){
				if( this.mc.currentLabel != LABEL_ATTACK && !isHit && !isDead ){
					this.mc.gotoAndPlay( LABEL_ATTACK );
				}		
				
				//var rnd:int = Math.random() * 2;				
				//if ( rnd == 0 ) {
					TweenLite.delayedCall( 0.1, fireGreenSphereShot );
					TweenLite.delayedCall( 1.9, fireGreenSphereShot );
					//TweenLite.delayedCall( 2.8, fireGreenSphereShot );
				//}else{
					//TweenLite.delayedCall( 0.1, fireBlueShot );
					//TweenLite.delayedCall( 1.8, fireBlueShot );
					//TweenLite.delayedCall( 2.7, fireBlueShot );
				//}
			}
		}		
		
		private function fireGreenSphereShot():void {			
			var shot:GreenSphereMC = new GreenSphereMC();
			shot.setDirection( currentDirection );
			if( currentDirection == DIRECTION_RIGHT ){					
				Util.addChildAtPosOf( world, shot, this, -1, new Point( 60 , 25 ) );
			}else{					
				Util.addChildAtPosOf( world, shot, this, -1, new Point( -60 , 25 ) );
			}
		}
		
		private function fireBlueShot():void{			
			var shot:BlueShotMC = new BlueShotMC();
			shot.setDirection( currentDirection );
			shot.isEnemyBullet = true;
			shot.pattern = 3;
			
			
			if( currentDirection == DIRECTION_RIGHT ){					
				Util.addChildAtPosOf( world, shot, this, -1, new Point( 65 , 0 ) );
			}else{					
				Util.addChildAtPosOf( world, shot, this, -1, new Point( -65 , 0 ) );
			}
		}
		
		override public function summonMonster():void 
		{
			super.summonMonster();
			if(this != null && world != null && this.mc != null && summonMonsterCount == 0){
				if( this.mc.currentLabel != LABEL_ATTACK && !isHit && !isDetectPlayer && !isDead){
					this.mc.gotoAndPlay( LABEL_ATTACK );
				}
				
				var greenDasher:GreenDasherMC = new GreenDasherMC();			
				var index:int = world.getChildIndex( this );
				
				if( currentDirection == DIRECTION_RIGHT ){					
					Util.addChildAtPosOf( world, greenDasher, this,(index-1), new Point( 250 , -250 ) );
				}else{					
					Util.addChildAtPosOf( world, greenDasher, this,(index-1), new Point( -250 , -250 ) );
				}				
				greenDasher.setDirection( currentDirection );
				greenDasher.addEventListener(CaveSmashEvent.MONSTER_DIED, onMonsterDied);
				summonMonsterCount++;
			}
		}
		
		override public function summonBoss():void 
		{
			super.summonBoss();
			trace("show up dark boss now!!!!!!! 1 this "+ this + " world " + world + " this.mc " + this.mc + " hasSummonDarkBoss " + hasSummonDarkBoss);
			if (this != null && this.mc != null && !hasSummonDarkBoss) {
				hasSummonDarkBoss = true;				
				var darkBoss:DarkBossMC = new DarkBossMC();							
				var index:int = world.getChildIndex( this );				
				//Util.addChildAtPosOf( world, darkBoss, this, (index - 1), new Point(1127.9 , -25 ) );
				//Util.addChildAtPos(world,darkBoss,new Point(1367.9 , -315 ),(index - 1));
				Util.addChildAtPos(world,darkBoss,new Point(1367.9 , -315 ),0);
				darkBoss.manualSetup();
				//Util.addChildAtPosOf( world, darkBoss, this, (index - 1), new Point(0, 0 ) );
				
				_caveSmashEvent = new CaveSmashEvent(CaveSmashEvent.DARK_BOSS_SUMMON_COMPLETE);
				_es.dispatchESEvent(_caveSmashEvent);
				trace("show up dark boss now!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!  2 ");
			}
		}		
		
		private function onMonsterDied(e:CaveSmashEvent):void{			
			summonMonsterCount--;
		}
		
		override public function dropItem():void{
			super.dropItem();
			/*
			if ( this != null && !hasDropItem ){
				hasDropItem = true;
				var itemKey:ItemKeyMC = new ItemKeyMC();
				var index:int = world.getChildIndex( this );
				Util.addChildAtPosOf( world, itemKey, this, ( index -1 ), new Point( 0 , 0 ) );
			}*/
		}
		
		private function killTweens():void{
			TweenLite.killDelayedCallsTo(fireGreenSphereShot);
			TweenLite.killDelayedCallsTo(fireBlueShot);
		}
		
		
		override public function onReloadLevel(e:CaveSmashEvent):void{
			super.onReloadLevel(e);
			killTweens();
		}
		
		override public function OnLevelQuit(e:CaveSmashEvent):void{
			super.OnLevelQuit(e);
			killTweens();
		}
		
		override public function onLevelComplete(e:CaveSmashEvent):void{
			super.onLevelComplete(e);
			killTweens();
		}
		
		override public function onLevelFailed(e:CaveSmashEvent):void{
			super.onLevelFailed(e);
			killTweens();
		}
		
		override public function onLevelStarted(e:CaveSmashEvent):void{ 
			super.onLevelStarted(e);
			killTweens();
		}
		
		override public function parseInput(e:Event):void{
			checkIfTransform();
			super.parseInput(e);
			
		}
	}
}