package components.monsters 
{
	import com.monsterPatties.config.CaveSmashConfig;
	import misc.Util;
	/**
	 * ...
	 * @author jc
	 */
	public class HeliFly extends Fly
	{		
		public function HeliFly()
		{
			super();
		}		
		
		override public function create():void 
		{
			super.create();
			HIT_DELAY = 0.5;
			ATTACK_DELAY = CaveSmashConfig.HELI_FLYER_ATTACK_DELAY;
			hp = CaveSmashConfig.HELI_FLYER_HP;
			MOVE_POWER = CaveSmashConfig.HELO_FLY_SPEED;
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