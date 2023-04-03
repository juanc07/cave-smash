package components.weapons 
{
	import Box2DAS.Dynamics.ContactEvent;
	import com.monsterPatties.config.CaveSmashConfig;
	import com.monsterPatties.config.SoundConfig;
	import com.monsterPatties.events.CaveSmashEvent;
	import flash.geom.Point;
	import misc.Util;
	/**
	 * ...
	 * @author jc
	 */
	public class DarkBossRock extends ProjectileBase
	{
		
		public function DarkBossRock() 
		{
			super();
		}
		
		override public function create():void{			
			isBossDarkRock = true;
			FORWARD_FORCE = CaveSmashConfig.DARK_BOSS_ROCK_FORWARD_FORCE;
			LIFE_SPAN = CaveSmashConfig.DARK_BOSS_ROCK_LIFE_SPAN;
			fixedRotation = false;
			super.create();			
		}
		
		override protected function updateVector():void 
		{
			super.updateVector();			
		}
		
		override public function addProjectileEffect():void 
		{
			super.addProjectileEffect();
			if (this != null && world != null ) {
				_caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.PLAY_SFX );
				_caveSmashEvent.obj.id = SoundConfig.EXPLOSION_SFX;
				_es.dispatchESEvent( _caveSmashEvent );
				
				
				var darkBossRockEffect:DarkBossRockEffectMC = new DarkBossRockEffectMC();				
				Util.addChildAtPosOf( world, darkBossRockEffect, this, -1, new Point(0, 0));
				_caveSmashEvent = new CaveSmashEvent(CaveSmashEvent.DARK_BOSS_ROCK_EXPLODED);
				_caveSmashEvent.obj.x = this.tempX;
				_caveSmashEvent.obj.id = this.id;
				_es.dispatchESEvent(_caveSmashEvent);
			}
		}
		
		override public function handleContact(e:ContactEvent):void 
		{
			super.handleContact(e);
			_caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.PLAY_SFX );
			_caveSmashEvent.obj.id = SoundConfig.ROCK_FALL_SFX;
			_es.dispatchESEvent( _caveSmashEvent );
		}
		
	}
}