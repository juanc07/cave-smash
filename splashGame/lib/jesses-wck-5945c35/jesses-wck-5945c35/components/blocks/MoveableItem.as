package components.blocks 
{
	import components.base.MoveableBase;
	
	/**d
	 * ...
	 * @author jc
	 */
	public class MoveableItem extends MoveableBase
	{
		
		public function MoveableItem() 
		{
			super();
		}
		
		override public function create():void 
		{
			super.create();
			fixedRotation = false;
		}		
	}

}