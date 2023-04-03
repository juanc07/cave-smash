package components.monsters 
{
	import com.greensock.TweenLite;
	import com.monsterPatties.config.CaveSmashConfig;
	import com.monsterPatties.config.GameConfig;
	import com.monsterPatties.config.SoundConfig;
	import com.monsterPatties.events.CaveSmashEvent;
	import com.monsterPatties.ui.WarningAlert;
	import flash.events.Event;
	import flash.geom.Point;
	import misc.Util;
	/**
	 * ...
	 * @author jc
	 */
	public class DarkBoss extends FinalDarkBoss
	{			
		private var currentXpos:Array;
		private var rndX:int;
		private var xPos:int;
		private var _warnings:Vector.<WarningAlert>;
		private var warning:WarningAlert;
		private var hasPlaySmashSFX:Boolean = false;
		
		public function DarkBoss()
		{
			super();
		}		
		
		override public function create():void {
			if ( _warnings == null ) {
				_warnings = new Vector.<WarningAlert>();
			}
			
			HIT_DELAY = 0.5;
			ATTACK_DELAY = CaveSmashConfig.DARK_BOSS_ATTACK_DELAY;

			if(GameConfig.isCheat){
				hp = 1;
			}else{
				hp = CaveSmashConfig.DARK_BOSS_HP;
			}
			
			trace("Dark boss created!!!!!!!!!!!!!");
			currentXpos = new Array();
			super.create();			
		}
		
		override public function playHit():void 
		{
			super.playHit();
			if ( this.mc.currentLabel != LABEL_HIT && this.mc.currentLabel != LABEL_GO_ATTACK && this.mc.currentLabel != LABEL_GO_ATTACK2){				
				this.mc.gotoAndPlay( LABEL_HIT );
				fireDarkBossBlast();
			}
		}		
		
		override public function kill():void 
		{
			super.kill();
			_es.removeEventListener( CaveSmashEvent.DARK_BOSS_ROCK_EXPLODED, onDarkBossRockExploded );
			TweenLite.to(this.mc, 7, {y:450,onComplete:killAnimationDone});
			this.mc.gotoAndStop( LABEL_DIE );
			_gdc.setIsLockControlls( true );			
		}
		
		private function killAnimationDone():void {			
			_gdc.setIsLockControlls( false);
			cleanMe();
		}
		
		
		private function summonDarkBossRock():void {
			if(darkBossRockCount<3){
				var darkBossRock:DarkBossRockMC = new DarkBossRockMC();
				darkBossRock.setDirection( currentDirection );
				darkBossRock.isEnemyBullet = true;
				darkBossRock.pattern = 5;
				
				var arrY:Array = [ -1100, -1300, -1500, -1800, -2100 ];
				var rndY:int = Math.random() * arrY.length;
				
				var arrX:Array = [ 250,360,450,560,650,760,850];
				rndX = Math.random() * arrX.length;
				
				var yPos:int = arrY[rndY];
				xPos = arrX[rndX];				
				var found:Boolean;
				if ( currentDirection == DIRECTION_RIGHT ) {
					found = searchX(xPos);
				}else{
					found = searchX(-xPos);
				}
				
				while(found){
					rndX = Math.random() * arrX.length;
					xPos = arrX[rndX];
					if ( currentDirection == DIRECTION_RIGHT ) {
						found = searchX(xPos);
					}else{
						found = searchX(-xPos);
					}
				}			
				
				if ( currentDirection == DIRECTION_RIGHT ){
					trace("push x " + xPos );
					currentXpos.push(xPos);
					darkBossRock.tempX = xPos;
					darkBossRock.id = _warnings.length;
					addWarning(xPos, -185,_warnings.length);
					Util.addChildAtPosOf( world, darkBossRock, this, -1, new Point( xPos, yPos ) );
				}else {
					trace("push x negative " + -xPos );
					currentXpos.push( -xPos);
					darkBossRock.tempX = -xPos;
					darkBossRock.id = _warnings.length;
					addWarning(-xPos, -185,_warnings.length);
					Util.addChildAtPosOf( world, darkBossRock, this, -1, new Point( -xPos, yPos ) );
				}
				_es.addEventListener( CaveSmashEvent.DARK_BOSS_ROCK_EXPLODED, onDarkBossRockExploded );				
				darkBossRockCount++;
			}
		}	
		
		private function searchX(xpos:Number, removeX:Boolean =false):Boolean {
			var found:Boolean = false;
			var len:int = currentXpos.length;
			for (var i:int = 0; i < len; i++){				
				trace("current search head: " + currentXpos[i] );
				if (removeX) {
					if ( currentXpos[i] == xpos ){
						found = true;												
						trace("remove x " + xpos );
						currentXpos.splice(i,1);						
						break;
					}
				}else {
					if (xpos < 0) {
						if ( currentXpos[i] == xpos || xpos == ( xpos + (110 * -1) ) ||  xpos == ( xpos - (110 * -1) ) ){
							found = true;
							break;
						}	
					}else{
						if ( currentXpos[i] == xpos || xpos == ( xpos + 110 ) || xpos == ( xpos - 110 ) ){
							found = true;
							break;
						}
					}
				}
			}
			return found;
		}
		
		
		private function addWarning(xpos:Number, ypos:Number, id:int):void{			
			warning = new WarningAlert();
			addChild(warning);
			warning.x = xpos;
			warning.y = ypos;			
			_warnings.push(warning);
			warning.id = id;
		}
		
		private function removeWarning(id:int):void{
			var len:int = _warnings.length;
			for (var i:int = 0; i < len; i++){
				if ( _warnings[i].id == id ) {
					if (_warnings[i]!= null) {
						if (this.contains(_warnings[i])) {
							this.removeChild(_warnings[i]);
							_warnings[i] = null;
							_warnings.splice(i,1);
							break;
						}
					}					
				}
			}
		}
		
		private function onDarkBossRockExploded(e:CaveSmashEvent):void {
			trace("preparing to remove rock check x " + e.obj.x );
			removeWarning(e.obj.id);
			searchX(e.obj.x, true);
			darkBossRockCount--;
			hasPlaySmashSFX = false;
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
		
		override public function playAttack2():void{
			super.playAttack2();
			if( this.mc.currentLabel != LABEL_ATTACK2 && !isHit && !isDead ){
				this.mc.gotoAndPlay( LABEL_ATTACK2 );
			}
		}
		
		private function checkAttack2():void{
			if ( this.mc.currentLabel == LABEL_GO_ATTACK2 ){
				fireDarkBossBlast();
			}
		}
		
		private function checkAttack():void{
			if ( this.mc.currentLabel == LABEL_GO_ATTACK ) {
				
				if (!hasPlaySmashSFX) {
					hasPlaySmashSFX = true;
					_caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.PLAY_SFX );
					_caveSmashEvent.obj.id = SoundConfig.DARK_ROCK_EXPLOSION_SFX;
					_es.dispatchESEvent( _caveSmashEvent );
				}
				
				summonFinalBossAttackRange();
				TweenLite.delayedCall(0.35, summonDarkBossRock);
				//summonDarkBossRock();
			}
		}
		
		override public function smash():void 
		{
			super.smash();
			if(this != null && world != null && this.mc != null){
				if( this.mc.currentLabel != LABEL_ATTACK && !isHit && !isDead ){
					this.mc.gotoAndPlay( LABEL_ATTACK );
				}				
			}
		}
		
		private function summonFinalBossAttackRange():void{
			if (!hasAttackRange) {
				hasAttackRange = true;
				var finalBossAttackRangeMC:FinalBossAttackRangeMC = new FinalBossAttackRangeMC();
				finalBossAttackRangeMC.setDirection( currentDirection );
				
				if(currentDirection == DIRECTION_LEFT){
					Util.addChildAtPosOf( world, finalBossAttackRangeMC, this, -1, new Point( -150 , 50 ) );
				}else {
					Util.addChildAtPosOf( world, finalBossAttackRangeMC, this, -1, new Point( 150 , 50 ) );
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
		
		private function fireDarkBossBlast():void {
			if(!hasFireShot){
				var shot:DarkBossBlastMC = new DarkBossBlastMC();
				shot.setDirection( currentDirection );		
				
				if( currentDirection == DIRECTION_RIGHT ){					
					Util.addChildAtPosOf( world, shot, this, -1, new Point( 100 , 80 ) );
				}else{					
					Util.addChildAtPosOf( world, shot, this, -1, new Point( -100 , 80 ) );
				}
				
				hasFireShot = true;
			}
		}		
		
		override public function dropItem():void{
			super.dropItem();
			if ( this != null && !hasDropItem ){
				hasDropItem = true;
				var itemKey:ItemKeyMC = new ItemKeyMC();
				var index:int = world.getChildIndex( this );
				Util.addChildAtPosOf( world, itemKey, this, ( index -1 ), new Point( 0 , 0 ) );
			}
		}
		
		//private function killTweens():void {
			//TweenLite.killTweensOf(this);
			//TweenLite.killDelayedCallsTo(summonDarkBossRock);
		//}
		
		
		override public function onReloadLevel(e:CaveSmashEvent):void{
			super.onReloadLevel(e);
			//killTweens();
		}
		
		override public function OnLevelQuit(e:CaveSmashEvent):void{
			super.OnLevelQuit(e);
			//killTweens();
		}
		
		override public function onLevelComplete(e:CaveSmashEvent):void{
			super.onLevelComplete(e);
			//killTweens();
		}
		
		override public function onLevelFailed(e:CaveSmashEvent):void{
			super.onLevelFailed(e);
			//killTweens();
		}
		
		override public function onLevelStarted(e:CaveSmashEvent):void{ 
			super.onLevelStarted(e);
			//killTweens();
		}
		
		override public function parseInput(e:Event):void 
		{
			super.parseInput(e);
			checkAttack2();
			checkAttack();
		}
	}
}