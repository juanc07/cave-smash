package components.blocks 
{
	import com.monsterPatties.config.GameConfig;
	/**
	 * ...
	 * @author jc
	 */
	public class HorizontalMovingPlatform extends MPlatform
	{
		
		public function HorizontalMovingPlatform() 
		{
			super();			
		}
		
		
		override public function shapes():void 
		{
			super.shapes();
			box();			
			friction = 100;
			//restitution = 0.3;
			PlatformType = HORIZONTAL;
			currentDirection = DIRECTION_RIGHT;
		}
		
		override public function create():void 
		{
			super.create();		
			//PlatformType = HORIZONTAL;
			//currentDirection = DIRECTION_RIGHT;
		}
		
	}

}