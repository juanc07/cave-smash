package components.levels.trap 
{
	import components.base.RevolvingTrapBase;
	/**
	 * ...
	 * @author ...
	 */
	public class RevolvingTrap extends RevolvingTrapBase
	{
		
		public function RevolvingTrap(){
			super();
		}
		
		override public function shapes():void 
		{
			super.shapes();
			box();
		}
		
		
		override public function create():void 
		{
			super.create();
		}		
	}
}