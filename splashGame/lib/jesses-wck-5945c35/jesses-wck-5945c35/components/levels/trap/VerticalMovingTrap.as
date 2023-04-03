package components.levels.trap 
{
	import components.blocks.TrapConfig;
	/**
	 * ...
	 * @author jc
	 */
	public class VerticalMovingTrap extends MovingTrap
	{
		
		public function VerticalMovingTrap() 
		{
			super();			
		}
		
		override public function create():void 
		{
			super.create();			
			trapType = TrapConfig.HORIZONTAL_MOVING_SAW_TRAP;
			MovingTrapType = VERTICAL;
			currentDirection = DIRECTION_UP;			
		}		
	}

}