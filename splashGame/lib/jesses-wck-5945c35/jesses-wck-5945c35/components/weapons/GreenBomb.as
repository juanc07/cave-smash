package components.weapons 
{
	import com.monsterPatties.config.SoundConfig;
	import com.monsterPatties.events.CaveSmashEvent;
	import flash.geom.Point;
	import misc.Util;
	/**
	 * ...
	 * @author jc
	 */
	public class GreenBomb extends ProjectileBase
	{
		
		public function GreenBomb() 
		{
			super();
		}
		
		override public function create():void 
		{
			super.create();			
		}
		
		override protected function updateVector():void 
		{
			super.updateVector();			
		}
		
		override public function addProjectileEffect():void 
		{
			super.addProjectileEffect();
			if(this != null && world != null ){
				var explodeEffect:GreenBombEffectMC = new GreenBombEffectMC();
				//var xpos:Number = ( explodeEffect.width * 0.5 ) * -1;
				//var ypos:Number = ( explodeEffect.height * -1 )+ 35;
				Util.addChildAtPosOf( world, explodeEffect, this, -1, new Point(0, 30));
				
				_caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.PLAY_SFX );
				_caveSmashEvent.obj.id = SoundConfig.GREEN_BOMB_EXPLODE_SFX;
				_es.dispatchESEvent( _caveSmashEvent );
			}
		}
		
	}
}