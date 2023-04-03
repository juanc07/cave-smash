package components.levels.trap 
{
	import components.blocks.TrapConfig;
	/**
	 * ...
	 * @author jc
	 */
	public class BladeTrap extends DynamicTrap
	{
		
		public function BladeTrap() 
		{
			super();			
		}
		
		override public function create():void 
		{
			super.create();
			fixedRotation = true;
			trapType = TrapConfig.BLADE_TRAP;
		}		
	}

}