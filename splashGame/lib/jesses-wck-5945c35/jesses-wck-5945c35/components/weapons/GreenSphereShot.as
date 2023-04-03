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
	public class GreenSphereShot extends HomingShot
	{
		
		public function GreenSphereShot() 
		{
			super();
		}
		
		
		override public function create():void {
			MOVE_POWER = CaveSmashConfig.GREEN_SPHERE_SHOT_SPEED;
			LIFE_SPAN = CaveSmashConfig.GREEN_SPHERE_SHOT_LIFE_SPAN;
			super.create();
			
			_caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.PLAY_SFX );
			_caveSmashEvent.obj.id = SoundConfig.GREEN_BOMB_SFX;
			_es.dispatchESEvent( _caveSmashEvent );
		}
		
		override protected function updateVector():void 
		{
			super.updateVector();			
		}
		
		
		override public function addBaseShotEffect():void{
			super.addBaseShotEffect();
			addEffect();
		}
		
		private function addEffect():void{			
			if(this != null && world != null ){
				var explodeEffect:GreenSphereEffectMC = new GreenSphereEffectMC();				
				Util.addChildAtPosOf( world, explodeEffect, this, -1, new Point(0, 30));
				
				_caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.PLAY_SFX );
				_caveSmashEvent.obj.id = SoundConfig.GREEN_BOMB_EXPLODE_SFX;
				_es.dispatchESEvent( _caveSmashEvent );
			}
		}
	}
}