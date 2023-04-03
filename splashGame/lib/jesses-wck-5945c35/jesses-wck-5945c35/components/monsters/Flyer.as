package components.monsters 
{
	import com.monsterPatties.config.CaveSmashConfig;
	import flash.geom.Point;
	import misc.Util;
	/**
	 * ...
	 * @author jc
	 */
	public class Flyer extends Fly
	{		
		public function Flyer()
		{
			super();
		}		
		
		override public function create():void{
			HIT_DELAY = 0.5;
			ATTACK_DELAY = ( Math.random() * CaveSmashConfig.FLYER_ATTACK_DELAY )  + CaveSmashConfig.EXTRA_ATTACK_DELAY;
			hp = CaveSmashConfig.FLYER_HP;
			MOVE_POWER = CaveSmashConfig.FLYER_MOVE_SPEED;
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
				var pulseShot:PulseShotMC = new PulseShotMC();
				pulseShot.setDirection( currentDirection );
				if( currentDirection == DIRECTION_RIGHT ){
					Util.addChildAtPosOf( world, pulseShot, this, -1, new Point( 20 , -10 ) );
				}else {
					Util.addChildAtPosOf( world, pulseShot, this, -1, new Point(  -20 , -10 ) );
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