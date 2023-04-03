package components.weapons 
{
	import com.greensock.TweenLite;
	import com.monsterPatties.config.CaveSmashConfig;
	import com.monsterPatties.config.SoundConfig;
	import com.monsterPatties.events.CaveSmashEvent;
	import flash.geom.Point;
	import misc.Util;
	/**
	 * ...
	 * @author jc
	 */
	public class BlueShot extends DoubleActionProjectileShot
	{
		
		public function BlueShot() 
		{
			super();
		}
		
		override protected function updateVector():void 
		{
			super.updateVector();			
		}
		
		override public function create():void{
			//MOVE_POWER = CaveSmashConfig.BLUE_SHOT_SPEED;
			UPWARD_FORCE = 4;
			DOWNWARD_FORCE = 0.5;
			FORWARD_FORCE =  CaveSmashConfig.BLUE_SHOT_SPEED;;
			LIFE_SPAN = ( Math.random() * CaveSmashConfig.BLUE_SHOT_LIFE_SPAN) + 0.3;
			super.create();
			
			_caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.PLAY_SFX );
			_caveSmashEvent.obj.id = SoundConfig.BLUE_SHOT_SFX;
			_es.dispatchESEvent( _caveSmashEvent );
		}
		
		override public function fireAdditionalShot():void{
			super.fireAdditionalShot();
			fireSmallBlueShot(0);
			fireSmallBlueShot(2);
			fireSmallBlueShot(3);
			fireSmallBlueShot(1);			
		}
		
		override public function addProjectileEffect():void{
			super.addProjectileEffect();
			addEffect();
		}
		
		private function addEffect():void{			
			if (this != null && world != null ){				
				var explodeEffect:BlueShotEffectMC = new BlueShotEffectMC();				
				Util.addChildAtPosOf( world, explodeEffect, this, -1, new Point(0, 30));				
			}
		}
		
		private function fireSmallBlueShot(pattern:int):void {
			if (this != null && world != null ) {
				trace("pattern small blue shot " + pattern);
				var shot:SmallBlueShotMC = new SmallBlueShotMC();
				shot.setDirection( currentDirection );
				shot.isEnemyBullet = true;
				shot.pattern = pattern;
				
				var offsetX:Number = 0;
				var offsetY:Number = 0;
				
				if (pattern == 0){
					offsetX = -50;
				}else if (pattern == 2){
					offsetX = 50;
				}else if (pattern == 3) {
					offsetX = -50;
					offsetY = -50;
				}else if (pattern == 1) {
					offsetX = 50;
					offsetY = -50;
				}
				
				if( currentDirection == DIRECTION_RIGHT ){
					Util.addChildAtPosOf( world, shot, this, -1, new Point( 65 + offsetX , 0 + offsetY ) );
				}else{					
					Util.addChildAtPosOf( world, shot, this, -1, new Point( -65 + offsetX , 0 + offsetY ) );
				}
				
				_caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.PLAY_SFX );
				_caveSmashEvent.obj.id = SoundConfig.BLUE_SHOT_SFX;
				_es.dispatchESEvent( _caveSmashEvent );				
			}
		}
	}
}