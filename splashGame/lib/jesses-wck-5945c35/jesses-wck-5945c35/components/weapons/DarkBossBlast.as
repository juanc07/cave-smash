package components.weapons 
{
	import com.monsterPatties.config.CaveSmashConfig;
	import com.monsterPatties.config.SoundConfig;
	import com.monsterPatties.events.CaveSmashEvent;
	/**
	 * ...
	 * @author jc
	 */
	public class DarkBossBlast extends BaseShot
	{
		
		public function DarkBossBlast() 
		{
			super();
		}
		
		override protected function updateVector():void 
		{
			super.updateVector();
			if ( currentDirection == DIRECTION_RIGHT ) {
				//this.mc.scaleX = -1;				
				this.scaleX = -1;
			}
		}
		
		override public function create():void 
		{
			KNOCK_BACK_POWER = CaveSmashConfig.BOSS_DARK_BLAST_KNOCK_BACK_POWER;
			KNOCK_BACK_RANGE = CaveSmashConfig.BOSS_DARK_BLAST_KNOCK_BACK_RANGE;
			MOVE_POWER = CaveSmashConfig.DARK_BOSS_BLAST_SHOT_SPEED;
			LIFE_SPAN =  CaveSmashConfig.DARK_BOSS_BLAST_SHOT_LIFE_SPAN;
			super.create();
			
			_caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.PLAY_SFX );
			_caveSmashEvent.obj.id = SoundConfig.DARK_BOSS_BLAST_SFX;
			_es.dispatchESEvent( _caveSmashEvent );
		}
	}
}