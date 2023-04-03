package components.monsters 
{
	import com.monsterPatties.config.CaveSmashConfig;
	import misc.Util;
	/**
	 * ...
	 * @author jc
	 */
	public class SlideBone extends Walker
	{		
		public function SlideBone()
		{
			super();
		}		
		
		override public function create():void 
		{
			isAgressive = true;
			hasIdle = true;
			KNOCK_BACK_POWER = 4;
			MOVE_POWER = CaveSmashConfig.SLIDE_BONE_SPEED;
			HIT_DELAY = 0.5;
			hp = CaveSmashConfig.SLIDE_BONE_HP;			
			idleTime = ( Math.random() * CaveSmashConfig.WALKER_IDLE_TIME ) + 0.3;
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
		
		override public function goStill():void 
		{
			super.goStill();
			if( this != null ){
				if( this.mc.currentLabel != LABEL_IDLE && !isHit && !isDead ){
					this.mc.gotoAndPlay( LABEL_IDLE );
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