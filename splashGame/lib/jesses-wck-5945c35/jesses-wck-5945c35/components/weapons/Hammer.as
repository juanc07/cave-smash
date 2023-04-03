package components.weapons
{
	import com.monsterPatties.events.CaveSmashEvent;
	import components.effects.HammerEffect;
	import flash.geom.Point;
	import misc.Util;
	/**
	 * ...
	 * @author jc
	 */
	public class Hammer extends HammerBase{
		public function Hammer()
		{
			super();
		}
		
		override public function create():void
		{
			super.create();
			playSFX();
		}
		
		private function playSFX():void{
			_caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.THROW_WEAPON );
			_es.dispatchESEvent( _caveSmashEvent );
		}
		
		override public function addProjectileEffect():void 
		{
			super.addProjectileEffect();
			if(this != null && world != null ){
				var hammerEffect:HammerEffectMC = new HammerEffectMC();			
				Util.addChildAtPosOf( world, hammerEffect, this, -1, new Point(0, 30));				
				trace("add hammer effect");
			}
		}
		
		override protected function updateVector():void
		{
			super.updateVector();
		}
	}
}