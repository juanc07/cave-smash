package components.monsters 
{
	import com.greensock.TweenLite;
	import com.monsterPatties.config.CaveSmashConfig;
	import flash.geom.Point;
	import misc.Util;
	/**
	 * ...
	 * @author jc
	 */
	public class TallShooter extends Walker
	{	
		/*Constant*/
		private static const LABEL_ATTACK:String = "attack";
		private static var ATTACK_DELAY:Number = CaveSmashConfig.TALL_SHOOTER_ATTACK_DELAY;		
		/*Properties*/
		
		
		/*Constructor*/
		
		
		public function TallShooter()
		{
			super();
		}		
		
		override public function create():void 
		{
			ATTACK_DELAY = ( Math.random() * CaveSmashConfig.TALL_SHOOTER_ATTACK_DELAY ) + CaveSmashConfig.EXTRA_ATTACK_DELAY;
			HIT_DELAY = 0.5;
			hp = CaveSmashConfig.TALL_SHOOTER_HP;			
			super.create();
			TweenLite.delayedCall( ATTACK_DELAY, attackNow );			
		}
		
		private function attackNow():void{
			TweenLite.killDelayedCallsTo( attackNow );
			summonShot();
		}
		
		override public function summonShot():void 
		{
			super.summonShot();
			
			if ( _levelIsDone || this == null || this.mc == null || this.b2body == null ) {
				return;
			}			
			
			if(this != null && world != null && this.mc != null){
				if ( this.mc.currentLabel != LABEL_ATTACK && !isHit  && !isAttacking && !isDead ) {
					this.mc.gotoAndPlay( LABEL_ATTACK );
					firePooShot();
				}
			}
		}
		
		
		private function firePooShot():void{
			var pooMC:PooMC = new PooMC();
			pooMC.setDirection( currentDirection );
			if( currentDirection == DIRECTION_RIGHT ){
				Util.addChildAtPosOf( world, pooMC, this, -1, new Point( 20 , -10 ) );
			}else {
				Util.addChildAtPosOf( world, pooMC, this, -1, new Point(  -20 , -10 ) );
			}			
			
			isAttacking = true;				
			TweenLite.delayedCall( ATTACK_DELAY, deActivateAttack );
		}	
		/*methods*/
		
		
		private function deActivateAttack():void 
		{
			TweenLite.killDelayedCallsTo( deActivateAttack );
			isAttacking = false;
			TweenLite.delayedCall( ATTACK_DELAY, attackNow );
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
		
		override public function goRight():void 
		{
			super.goRight();			
			if( this != null ){
				if( this.mc.currentLabel != LABEL_WALK && !isHit && !isDead ){
					this.mc.gotoAndPlay( LABEL_WALK );
				}
			}
		}
		
		override public function goLeft():void
		{
			super.goLeft();			
			if( this != null ){
				if( this.mc.currentLabel != LABEL_WALK && !isHit && !isDead ){
					this.mc.gotoAndPlay( LABEL_WALK );
				}
			}
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
		
		/*Setters*/
		/*Getters*/
		/*EventHandlers*/
	}
}