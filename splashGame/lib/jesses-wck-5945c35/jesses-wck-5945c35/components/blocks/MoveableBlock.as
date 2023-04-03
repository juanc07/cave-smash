package components.blocks 
{
	import com.monsterPatties.events.CaveSmashEvent;
	import components.base.MoveableBase;
	/**
	 * ...
	 * @author jc
	 */
	public class MoveableBlock extends MoveableBase
	{
		
		public function MoveableBlock() 
		{
			super();
		}
		
		override public function create():void 
		{
			super.create();
			fixedRotation = true;
		}		
	}
}