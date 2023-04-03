package components.weapons 
{
	import com.monsterPatties.config.CaveSmashConfig;
	import com.monsterPatties.config.SoundConfig;
	import com.monsterPatties.events.CaveSmashEvent;
	import flash.geom.Point;
	import misc.Util;
	/**
	 * ...
	 * @author jc
	 */
	public class WhiteShot extends ProjectileBase
	{
		
		public function WhiteShot() 
		{
			super();
		}
		
		override public function create():void 
		{
			MOVE_POWER = CaveSmashConfig.WHITE_SHOT_SPEED;
			DOWNWARD_FORCE = 0.5;
			FORWARD_FORCE =  0.5;
			super.create();		
			
			_caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.PLAY_SFX );
			_caveSmashEvent.obj.id = SoundConfig.WHITE_SHOT_SFX;
			_es.dispatchESEvent( _caveSmashEvent );
		}
		
		override protected function updateVector():void 
		{
			super.updateVector();
			if ( currentDirection == DIRECTION_RIGHT ) {
				this.scaleX = -1;
			}
		}
		
		override public function addProjectileEffect():void 
		{
			super.addProjectileEffect();
			if(this != null && world != null ){
				var explodeEffect:WhiteShotEffectMC = new WhiteShotEffectMC();
				if ( currentDirection == DIRECTION_LEFT ) {
					explodeEffect.scaleX = -1;
				}
				//var xpos:Number = ( explodeEffect.width * 0.5 ) * -1;
				//var ypos:Number = ( explodeEffect.height * -1 )+ 35;
				Util.addChildAtPosOf( world, explodeEffect, this, -1, new Point(0,-25));
			}
		}
		
	}
}