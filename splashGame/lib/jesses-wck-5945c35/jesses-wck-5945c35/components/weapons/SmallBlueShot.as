package components.weapons 
{
	import com.monsterPatties.config.CaveSmashConfig;
	import flash.geom.Point;
	import misc.Util;
	/**
	 * ...
	 * @author jc
	 */
	public class SmallBlueShot extends MultiDirectionShot
	{
		
		public function SmallBlueShot() 
		{
			super();
		}
		
		override protected function updateVector():void 
		{
			super.updateVector();			
		}
		
		override public function create():void{			
			DOWNWARD_FORCE = 3;
			FORWARD_FORCE =  CaveSmashConfig.SMALL_BLUE_SHOT_SPEED;
			UPWARD_FORCE = 8;
			
			LIFE_SPAN = CaveSmashConfig.SMALL_BLUE_SHOT_LIFE_SPAN;
			super.create();
		}
		
		override public function addProjectileEffect():void{
			super.addProjectileEffect();
			//addEffect();
		}
		
		/*private function addEffect():void{			
			if(this != null && world != null ){
				var explodeEffect:BlueShotEffectMC = new BlueShotEffectMC();				
				explodeEffect.scaleX = 0.2;
				explodeEffect.scaleY = 0.2;
				Util.addChildAtPosOf( world, explodeEffect, this, -1, new Point(0,30));
			}
		}*/
	}
}