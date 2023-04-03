package components.weapons 
{
	import com.monsterPatties.config.CaveSmashConfig;
	/**
	 * ...
	 * @author jc
	 */
	public class WhiteShotOd extends BaseShot
	{
		
		public function WhiteShotOd() 
		{
			super();
		}
		
		override public function create():void 
		{
			MOVE_POWER = CaveSmashConfig.WHITE_SHOT_SPEED;
			super.create();			
		}
		
		override protected function updateVector():void 
		{
			super.updateVector();
			if ( currentDirection == DIRECTION_RIGHT ) {
				this.mc.scaleX = -1;
			}
		}		
	}
}