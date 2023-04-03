package components.monsters 
{
	import com.monsterPatties.config.CaveSmashConfig;
	import flash.geom.Point;
	import misc.Util;
	/**
	 * ...
	 * @author jc
	 */
	public class RedFly extends Fly
	{		
		public function RedFly()
		{
			super();
		}		
		
		override public function create():void{
			HIT_DELAY = 0.5;			
			ATTACK_DELAY = ( Math.random() * CaveSmashConfig.RED_FLY_ATTACK_DELAY ) + CaveSmashConfig.EXTRA_ATTACK_DELAY;
			hp = CaveSmashConfig.RED_FLY_HP;
			super.create();			
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
				if( this.mc.currentLabel != LABEL_ATTACK && !isHit && !isDetectPlayer && !isDead ){
					this.mc.gotoAndPlay( LABEL_ATTACK );
				}
				
				var whiteShot:WhiteShotMC = new WhiteShotMC();
				whiteShot.setDirection( currentDirection );
				whiteShot.isEnemyBullet = true;
				whiteShot.pattern = 4;
				
				if( currentDirection == DIRECTION_RIGHT ){
					//Util.addChildAtPosOf( world, whiteShot, this, -1, new Point( 20 , -10 ) );
					Util.addChildAtPosOf( world, whiteShot, this, -1, new Point( 40 , 0 ) );
				}else {
					//Util.addChildAtPosOf( world, whiteShot, this, -1, new Point(  -20 , -10 ) );
					Util.addChildAtPosOf( world, whiteShot, this, -1, new Point( -40 , 0 ) );
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
	}
}