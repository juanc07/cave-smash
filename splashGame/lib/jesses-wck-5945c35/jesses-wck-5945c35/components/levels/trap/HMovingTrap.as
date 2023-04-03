package components.levels.trap 
{
	import components.blocks.TrapConfig;
	/**
	 * ...
	 * @author jc
	 */
	public class HMovingTrap extends MovingTrap
	{
		
		public function HMovingTrap() 
		{
			super();			
		}
		
		override public function create():void 
		{
			super.create();			
			trapType = TrapConfig.HORIZONTAL_MOVING_SAW_TRAP;
			MovingTrapType = HORIZONTAL;
			currentDirection = DIRECTION_RIGHT;			
		}		
	}

}