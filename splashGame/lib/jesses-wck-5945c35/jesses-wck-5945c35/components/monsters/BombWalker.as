package components.monsters
{
	import Box2DAS.Dynamics.ContactEvent;
	import com.monsterPatties.config.CaveSmashConfig;
	import components.players.Player2;
	import flash.geom.Point;
	import misc.Util;
	/**
	 * ...
	 * @author jc
	 */
	public class BombWalker extends Walker
	{
		public function BombWalker()
		{
			super();
		}
		
		override public function create():void
		{
			super.create();
			HIT_DELAY = 0.5;
			hp = CaveSmashConfig.BOMB_WALKER_HP;
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
		
		private function addExplosionEffect():void
		{
			var explodeEffect:ExplodeMC = new ExplodeMC();
			var xpos:Number = ( explodeEffect.width * 0.5 ) * -1;
			var ypos:Number = ( explodeEffect.height * -1 )+ 20;
			Util.addChildAtPosOf( world, explodeEffect, this, -1, new Point( xpos , ypos ) );
		}
		
		override public function kill():void
		{
			super.kill();
			this.mc.gotoAndStop( LABEL_DIE );
		}
		
		override public function handleContact(e:ContactEvent):void
		{
			super.handleContact(e);
			if ( e.other.GetBody().GetUserData() is Player ){
				_target = e.other.GetBody().m_userData;
			}
		}
		
		override public function attackPlayer(target:Player2):void
		{
			super.attackPlayer(target);
			addExplosionEffect();
			hp = 0;
			kill();
			target.die();
			//target.hit( 0,0,0 );
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