package components.monsters 
{
	import com.monsterPatties.config.CaveSmashConfig;
	import com.monsterPatties.config.SoundConfig;
	import com.monsterPatties.events.CaveSmashEvent;
	import flash.events.Event;
	import flash.geom.Point;
	import misc.Util;
	/**
	 * ...
	 * @author jc
	 */
	public class BossBison extends BossFly
	{				
		public static const ATTACK1:String = "attack";
		public static const LABEL_ATTACK2:String = "ready_attack2";		
		public static const ATTACK_UP:String = "attackup";
		public static const END_ATTACK_UP:String = "endAttackUp";
		public static const MID_ATTACK2:String = "midAttack2";
		private var isAttacking2:Boolean = false;
		
		public function BossBison()
		{
			super();
		}		
		
		override public function create():void 
		{
			super.create();
			//type = "Dynamic";			
			HIT_DELAY = CaveSmashConfig.BOSS_BISON_HIT_DELAY;
			hp = CaveSmashConfig.BOSS_BISON_HP;
			magnitude = CaveSmashConfig.BOSS_BISON_RANGE;			
		}
		
		override public function hit(dir:int, isKnockBack:Boolean = false, damage:int = 1):Boolean
		{
			if ( !isHit && !isDead ){
				if (this.mc.currentLabel != LABEL_HIT && this.mc.currentLabel != LABEL_ATTACK2 ){
					this.mc.gotoAndPlay( LABEL_HIT );
				}
				
				if( !isAttacking2 ){				
					var rnd:int = Math.random() * 10;
					if( rnd >= 5 ){
						goAttack2();
					}
				}			
			}			
			return super.hit(dir, isKnockBack,damage);
		}
		
		override public function kill():void 
		{
			super.kill();
			if (this.mc.currentLabel != LABEL_DIE){
				this.mc.gotoAndPlay( LABEL_DIE );
			}			
		}
		
		override public function goRight():void{
			super.goRight();			
		}
		
		override public function goLeft():void{
			super.goLeft();			
		}		
		
		private function checkAttack2Ready():void{
			if ( this.mc.currentLabel == MID_ATTACK2){
				//trace("call attack bison go!!!");				
				isAttacking2 = false;
				summonTornado();
			}
		}		
		
		override public function goAttack2():void 
		{
			super.goAttack2();
			if ( !isAttacking2 ){
				isAttacking2 = true;
				playSFX(1);				
				if (this.mc.currentLabel != LABEL_ATTACK2){
					this.mc.gotoAndPlay( LABEL_ATTACK2 );
				}				
			}
		}
		
		override public function goUp():void 
		{
			super.goUp();			
		}
		
		override public function goDown():void 
		{
			super.goDown();
			if( this.mc.currentFrameLabel != ATTACK1 ){
				this.mc.gotoAndPlay( ATTACK1 );				
			}
		}
		
		
		override public function offVerticalMovement():void 
		{
			super.offVerticalMovement();
			if ( this.mc.currentFrameLabel != LABEL_IDLE ){				
				this.mc.gotoAndPlay( LABEL_IDLE );
			}			
		}		
		
		private function playSFX(id:int):void{
			var sfxId:String;
			if (id == 1) {				
				sfxId = SoundConfig.BOSS2_FLAP_SFX;
			}else if (id == 2) {
				sfxId = SoundConfig.BOSS2_DASH_SFX;
			}
			
			_caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.PLAY_SFX );
			_caveSmashEvent.obj.id = sfxId;
			_es.dispatchESEvent( _caveSmashEvent );
		}
		
		override public function driveUp():void{
			super.driveUp();
			if( this.mc.currentFrameLabel != ATTACK_UP ){
				this.mc.gotoAndPlay( ATTACK_UP );	
				playSFX(2);
			}
			isAttacking2 = false;
		}
		
		override public function driveDown():void 
		{
			super.driveDown();
			if( this.mc.currentFrameLabel != ATTACK1 ){
				this.mc.gotoAndPlay( ATTACK1 );	
				playSFX(2);
			}
			isAttacking2 = false;
		}
		
		override public function dropItem():void 
		{
			super.dropItem();
			if ( !_hasDropItem ) {
				_hasDropItem = true;
				var itemKey:ItemKeyMC = new ItemKeyMC();
				//itemKey.gotoAndStop(2);
				var index:int = world.getChildIndex( this );
				Util.addChildAtPosOf( world, itemKey, this, ( index -1 ), new Point( 0 , 0 ) );
			}
		}
		
		override public function parseInput(e:Event):void 
		{
			super.parseInput(e);	
			checkAttack2Ready();
		}
	}
}