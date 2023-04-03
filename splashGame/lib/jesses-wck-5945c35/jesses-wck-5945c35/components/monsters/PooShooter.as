package components.monsters 
{
	import com.greensock.TweenLite;
	import com.monsterPatties.config.CaveSmashConfig;
	import com.monsterPatties.events.CaveSmashEvent;
	import flash.geom.Point;
	import misc.Util;
	/**
	 * ...
	 * @author jc
	 */
	public class PooShooter extends Still
	{	
		/*Constant*/
		private static const LABEL_HIDE:String = "hide";
		private static const LABEL_SHOW:String = "show";
		private static const LABEL_ATTACK:String = "attack";
		public var ATTACK_DELAY:Number = CaveSmashConfig.POO_SHOOTER_ATTACK_DELAY;
		public var SHOW_DELAY:Number = CaveSmashConfig.POO_SHOOTER_SHOW_DELAY;
		/*Properties*/
		
		
		/*Constructor*/
		
		
		public function PooShooter()
		{
			super();
		}		
		
		override public function create():void{
			HIT_DELAY = 0.5;
			ATTACK_DELAY = ( Math.random() * CaveSmashConfig.POO_SHOOTER_ATTACK_DELAY ) + CaveSmashConfig.EXTRA_ATTACK_DELAY;
			SHOW_DELAY = ( Math.random() * CaveSmashConfig.POO_SHOOTER_SHOW_DELAY ) + 0.5;
			hp = CaveSmashConfig.TALL_SHOOTER_HP;
			super.create();			
			TweenLite.delayedCall( SHOW_DELAY, show );
			lookLeft();
		}
		
		private function show():void {
			TweenLite.killDelayedCallsTo(show);
			if ( this.mc.currentLabel != LABEL_SHOW ) {
				this.mc.gotoAndPlay( LABEL_SHOW );
			}
			isHiding = false;
			TweenLite.delayedCall( ATTACK_DELAY, attack );
		}
		
		private function hide():void{
			if ( this.mc.currentLabel != LABEL_HIDE ) {
				this.mc.gotoAndPlay( LABEL_HIDE );
			}
			isHiding = true;
		}
		
		
		/*methods*/
		
		private function attack():void 
		{			
			if ( _levelIsDone || this == null || this.mc == null || this.b2body == null ) {
				return;
			}
			
			TweenLite.killDelayedCallsTo( attack );
			if ( this.mc.currentLabel != LABEL_ATTACK && !isHit  && !isAttacking && !isDead ) {
				shootPoo();
				this.mc.gotoAndPlay( LABEL_ATTACK );
				isAttacking = true;				
				TweenLite.delayedCall( ATTACK_DELAY, deActivateAttack );
			}			
		}
		
		private function rapidAttack():void 
		{
			TweenLite.delayedCall( 0.1 , shootGreenBomb);
			TweenLite.delayedCall( 0.3 , shootGreenBomb);
			TweenLite.delayedCall( 0.5 , shootGreenBomb);			
		}
		
		private function scatherShot():void 
		{
			if(this != null && world != null && this.mc != null){
				var len:int = 3;
				var greenBomb:GreenBombMC;
				var baseX:Number = 10;
				var baseY:Number = 40;			
				
				for (var i:int = 0; i < len; i++){
					greenBomb =  new GreenBombMC();
					greenBomb.setDirection(currentDirection);
					greenBomb.isEnemyBullet = true;
					greenBomb.pattern = 3;
					Util.addChildAtPosOf( world, greenBomb, this, -1, new Point( baseX + ( i * 35 )  , -baseY ) );
				}
			}
		}
		
		
		private function shootGreenBomb():void {			
			if(this != null && world != null && this.mc != null){
				var greenBomb:GreenBombMC =  new GreenBombMC();
				greenBomb.setDirection(currentDirection);
				greenBomb.isEnemyBullet = true;
				greenBomb.pattern = 3;
				var baseX:Number = 10;
				var baseY:Number = 40;			
				Util.addChildAtPosOf( world, greenBomb, this, -1, new Point( baseX  , -baseY ) );
			}
		}
		
		private function shootPoo():void {			
			if(this != null && world != null && this.mc != null){
				var pooMC:PooMC =  new PooMC();
				pooMC.setDirection(currentDirection);
				
				if( currentDirection == DIRECTION_RIGHT ){
					Util.addChildAtPosOf( world, pooMC, this, -1, new Point( 20 , -10 ) );
				}else {
					Util.addChildAtPosOf( world, pooMC, this, -1, new Point(  -20 , -10 ) );
				}				
			}
		}
		
		private function deActivateAttack():void 
		{			
			hide();			
			TweenLite.killDelayedCallsTo( deActivateAttack );
			isAttacking = false;
			TweenLite.delayedCall( SHOW_DELAY, show );
		}
		
		private function removeTweens():void{			
			TweenLite.killDelayedCallsTo(show);
			TweenLite.killDelayedCallsTo(attack);
			TweenLite.killDelayedCallsTo( deActivateAttack );
		}
		
		override public function resetHit():void{
			super.resetHit();			
			show();			
		}
		
		override protected function dropItem():void 
		{
			super.dropItem();
			if ( this != null ){
				var rnd:int = Math.random() * 100;
				if ( rnd >= 0 && rnd <= 80 ){					
					Util.addChildAtPosOf(world, new ItemGold(), this );				
				}else{
					Util.addChildAtPosOf(world, new ItemHeartMC(), this );					
				}
			}
		}
		
		
		override public function hit(dir:int, isKnockBack:Boolean = false):Boolean
		{
			if ( this.mc.currentLabel != LABEL_HIT && !isHit && !isDead ){
				if( hp > 0 ){
					this.mc.gotoAndPlay( LABEL_HIT );
				}
			}
			return super.hit(dir, isKnockBack);
		}
		
		override public function kill():void 
		{
			super.kill();			
			this.mc.gotoAndStop( LABEL_DIE );
		}
		
		override public function lookLeft():void 
		{
			super.lookLeft();
			if( this.currentLabel != LABEL_LEFT ){				
				this.gotoAndStop( LABEL_LEFT );
			}
		}
		
		
		override public function lookRight():void 
		{
			super.lookRight();
			if( this.currentLabel != LABEL_RIGHT ){
				this.gotoAndStop( LABEL_RIGHT );
			}
		}
		
		override public function onLevelFailed(e:CaveSmashEvent):void{
			super.onLevelFailed(e);
			removeTweens();
		}
		
		
		override public function onLevelComplete(e:CaveSmashEvent):void{
			super.onLevelComplete(e);
			removeTweens();
		}
		
		
		override public function OnLevelQuit(e:CaveSmashEvent):void{
			super.OnLevelQuit(e);
			removeTweens();
		}
		
		override public function onLevelStarted(e:CaveSmashEvent):void 
		{
			super.onLevelStarted(e);
			//removeTweens();
		}
		
		
		override public function onReloadLevel(e:CaveSmashEvent):void 
		{
			super.onReloadLevel(e);
			removeTweens();
		}
		/*Setters*/
		/*Getters*/
		/*EventHandlers*/
	}
}