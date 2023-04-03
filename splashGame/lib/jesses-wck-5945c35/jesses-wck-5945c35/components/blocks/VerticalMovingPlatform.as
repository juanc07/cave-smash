package components.blocks 
{
	import com.monsterPatties.config.GameConfig;
	/**
	 * ...
	 * @author jc
	 */
	public class VerticalMovingPlatform extends MPlatform
	{
		
		public function VerticalMovingPlatform() 
		{
			super();			
		}
		
		override public function shapes():void 
		{
			super.shapes();
			box();			
			friction = 100;
			//restitution = 0.3;
			PlatformType = VERTICAL;
			currentDirection = DIRECTION_UP;
			friction = 0.01;
			_friction = 0.01;
		}
		
		override public function create():void 
		{
			super.create();
			//PlatformType = VERTICAL;
			//currentDirection = DIRECTION_UP;
			//friction = 0.01;
			//_friction = 0.01;
		}
		
	}

}