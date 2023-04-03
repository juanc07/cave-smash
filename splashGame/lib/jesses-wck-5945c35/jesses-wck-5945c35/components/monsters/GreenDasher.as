package components.monsters 
{
	import com.monsterPatties.config.CaveSmashConfig;
	import com.monsterPatties.config.SoundConfig;
	import com.monsterPatties.events.CaveSmashEvent;
	import flash.events.Event;
	import misc.Util;
	/**
	 * ...
	 * @author jc
	 */
	public class GreenDasher extends Walker
	{		
		public static const LABEL_ATTACK:String = "attack";
		public static const LABEL_ATTACK_ROLL:String = "attackRoll";
		public static const LABEL_START_ATTACK_ROLL:String = "startAttackRoll";
		
		public function GreenDasher()
		{
			super();
		}		
		
		override public function create():void 
		{			
			isDasher = true;
			isAgressive = true;
			KNOCK_BACK_POWER = 15;
			DASH_POWER = CaveSmashConfig.GREEN_DASHER_DASH_POWER;
			magnitudeOffsetY = CaveSmashConfig.GREEN_DASHER_MAGNITUDE_Y;
			magnitude = CaveSmashConfig.GREEN_DASHER_MAGNITUDE_X;
			hasIdle = true;
			MOVE_POWER = CaveSmashConfig.GREEN_DASHER_SPEED;
			HIT_DELAY = 0.5;
			hp = CaveSmashConfig.GREEN_DASHER_HP;
			idleTime = CaveSmashConfig.GREEN_DASHER_IDLE_TIME;
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
		
		private function checkAttackRoll():void 
		{
			if ( this != null ){
				if(isPreparingToAttack){				
					if ( this.mc.currentLabel == LABEL_START_ATTACK_ROLL ) {
						if ( this.mc.currentLabel != LABEL_ATTACK_ROLL ) {
							_caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.PLAY_SFX );
							_caveSmashEvent.obj.id = SoundConfig.ROLL_ATTACK_SFX;
							_es.dispatchESEvent( _caveSmashEvent );
							this.mc.gotoAndPlay( LABEL_ATTACK_ROLL );
						}
						
						isPreparingToAttack = false;
						attack();
						checkDirection();
					}
				}
			}
		}		
		
		override public function prepareAttack():void 
		{
			super.prepareAttack();
			trace("prepareAttack GreenDasher fuck 1 !!!!!!");
			if( this != null ){
				if ( this.mc.currentLabel != LABEL_ATTACK && !isHit && !isDead ) {
					trace("prepareAttack GreenDasher fuck  2!!!!!!");					
					this.mc.gotoAndPlay( LABEL_ATTACK );
				}
			}
		}
		
		override public function parseInput(e:Event):void 
		{
			super.parseInput(e);
			checkAttackRoll();			
		}
	}
}