package components.levels.trap 
{
	import components.blocks.TrapConfig;
	/**
	 * ...
	 * @author jc
	 */
	public class PendulumTrap extends DynamicTrap
	{
		
		public function PendulumTrap() 
		{
			super();			
		}
		
		override public function create():void 
		{
			super.create();
			fixedRotation = true;
			_linearDamping = 0;
			_angularDamping = 0;			
			_friction = 0;
			movementForce = 5;
			currentDirection = DIRECTION_RIGHT;
			trapType = TrapConfig.PENDULUM_TRAP;
			startForceMovement();
		}		
	}

}