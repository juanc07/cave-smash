package components.weapons 
{
	import com.monsterPatties.config.SoundConfig;
	import com.monsterPatties.events.CaveSmashEvent;
	/**
	 * ...
	 * @author jc
	 */
	public class PulseShot extends BaseShot
	{
		
		public function PulseShot() 
		{
			super();
		}
		
		override protected function updateVector():void 
		{
			super.updateVector();
			if ( currentDirection == DIRECTION_RIGHT ){				
				this.scaleX = -1;
			}
		}
		
		override public function create():void 
		{
			super.create();
			_caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.PLAY_SFX );
			_caveSmashEvent.obj.id = SoundConfig.PULSE_SHOT_SFX;
			_es.dispatchESEvent( _caveSmashEvent );
		}
	}
}