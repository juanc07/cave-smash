package com.monsterPatties.ui
{
	import com.monsterPatties.config.SoundConfig;
	import com.monsterPatties.controllers.GameDataController;
	import com.monsterPatties.events.CaveSmashEvent;
	import com.monsterPatties.events.GameEvent;
	import com.monsterPatties.utils.buttonManager.ButtonManager;
	import com.monsterPatties.utils.buttonManager.events.ButtonEvent;
	import com.monsterPatties.utils.eventSatellite.EventSatellite;
	import com.monsterPatties.utils.soundManager.SoundManager;
	import flash.display.Sprite;
	import flash.events.Event;	
	/**
	 * ...
	 * @author ...
	 */
	public class SoundGUI extends Sprite
	{
		/*------------------------------------------------------------------Constant--------------------------------------------------------------------*/
		private static var _instance:SoundGUI;
		
		public static const COLLECT_RING_SFX:String = "collectRing";
		public static const COLLECT_SPECIAL_SFX:String = "collectSpecial";
		public static const COLLECT_BAD_SFX:String = "collectBad";
		public static const DIVING_SFX:String = "diving";
		public static const SPLASH_SFX:String = "splash";
		public static const GOAL_COMPLETE_SFX:String = "goalComplete";
		public static const RETRY_SFX:String = "retry";
		
		
		public static const COLLECT_COIN_SFX:String = "COLLECT_COIN_SFX";
		public static const COLLECT_CRYSTAL_SFX:String = "COLLECT_CRYSTAL_SFX";
		public static const COLLECT_HEART_SFX:String = "COLLECT_HEART_SFX";
		public static const COLLECT_KEY_SFX:String = "COLLECT_KEY_SFX";
		public static const CRACK_SFX:String = "CRACK_SFX";
		public static const ATTACK_SFX:String = "ATTACK_SFX";
		public static const PORTAL_SFX:String = "PORTAL_SFX";
		public static const PORTAL2_SFX:String = "PORTAL2_SFX";
		public static const BOUNCE_SFX:String = "BOUNCE_SFX";
		
		//new
		//
		public static const BUY_SFX:String = "BUY_SFX";
		public static const THROW_SFX:String = "THROW_SFX";
		
		//bgm
		public static const MAIN_GAME_BGM:String = "MAIN_GAME_BGM";
		public static const DESSERT_GAME_BGM:String = "DESSERT_GAME_BGM";
		public static const DARK_GAME_BGM:String = "DARK_GAME_BGM";
		
		public static const MAP_BGM:String = "MAP_BGM";
		public static const END_SCENE_BGM:String = "END_SCENE_BGM";
		public static const BOSS3_SCENE_BGM:String = "BOSS3_SCENE_BGM";
		public static const INTRO_BGM:String = "INTRO_BGM";
		public static const BOSS1_SCENE_BGM:String = "BOSS1_SCENE_BGM";
		public static const BOSS2_SCENE_BGM:String = "BOSS2_SCENE_BGM";
		public static const LEVEL_CLEAR_BGM:String = "LEVEL_CLEAR_BGM";
		public static const LEVEL_FAILED_BGM:String = "LEVEL_FAILED_BGM";
		
		public static const BOSS1_BGM:String = "BOSS1_BGM";
		public static const BOSS2_BGM:String = "BOSS2_BGM";
		public static const BOSS3_BGM:String = "BOSS3_BGM";
		public static const SHOP_BGM:String = "SHOP_BGM";
		
		/*------------------------------------------------------------------Properties------------------------------------------------------------------*/
		private var _mc:BgmSfxUIMC;
		private var _xPos:Number;
		private var _yPos:Number;
		private var _bm:ButtonManager;
		private var _soundManager:SoundManager;
        private var _isBgmSfxToggle:Boolean;
		private var _es:EventSatellite;
		private var _gameEvent:GameEvent;
		private var _gdc:GameDataController;
		/*------------------------------------------------------------------Constructor-----------------------------------------------------------------*/
		
		
		public function SoundGUI( enforcer:SingletonEnforcer )
		{
			
		}
		
		public static function getIntance():SoundGUI
		{
			if ( SoundGUI._instance == null ) {
				SoundGUI._instance = new SoundGUI( new SingletonEnforcer() );
			}
			
			return SoundGUI._instance;
		}
		
		public function init():void
		{
			_soundManager = SoundManager.getInstance();
			setDisplay();
		}
		
		public function setXYPos( xpos:Number, ypos:Number ):void
		{
			_xPos = xpos
			_yPos = ypos;
		}
		
		public function destroy():void
		{
			//muteBgm();
			//muteSfx();
			removeDisplay();
		}
		
		/*------------------------------------------------------------------Methods--------------------------------------------------------------------*/
		private function setDisplay():void
		{
			_gdc = GameDataController.getInstance();
			addSoundManager();
			
			_mc = new BgmSfxUIMC();
			addChild( _mc );
			_mc.x = _xPos;
			_mc.y = _yPos;
			
			_bm = new ButtonManager();
			_bm.addBtnListener( _mc.bgmBtn );
			_bm.addBtnListener( _mc.sfxBtn );
			_bm.addBtnListener( _mc.pauseBtn );
			_bm.addBtnListener( _mc.settingsBtn );
			_bm.addEventListener( ButtonEvent.CLICK_BUTTON, onClickBtn );
			_bm.addEventListener( ButtonEvent.ROLL_OVER_BUTTON, onRollOverBtn );
			_bm.addEventListener( ButtonEvent.ROLL_OUT_BUTTON, onRollOutBtn );

            //_mc.bgmBtn.visible = false;
            //_mc.sfxBtn.visible = false;
			
			_es = EventSatellite.getInstance();
			_es.addEventListener( GameEvent.GAME_UNPAUSED, onUnPaused );
			_es.addEventListener( GameEvent.TOGGLE_MUSIC, onToggleMusic );
			_es.addEventListener( CaveSmashEvent.ON_CRACK_NORMAL_BLOCK, onCrackNormalBlock );
			_es.addEventListener( CaveSmashEvent.MONSTER_DIED, onMonsterDied );
			_es.addEventListener( CaveSmashEvent.LEVEL_STARTED, onLevelStarted );
			_es.addEventListener( CaveSmashEvent.MONSTER_HIT, onHitMonster );
			_es.addEventListener( CaveSmashEvent.BOUNCE_MUSHROOM, onBounceMushroom );			
			_es.addEventListener( CaveSmashEvent.ON_BUY_ITEM, onBuyItem );
			_es.addEventListener( CaveSmashEvent.THROW_WEAPON, onThrowWeapon );
			_es.addEventListener( CaveSmashEvent.PLAY_SFX, onPlaySfx );
		}
		
		private function removeDisplay():void
		{
			if ( _mc != null ) {
				_es.removeEventListener( GameEvent.GAME_UNPAUSED, onUnPaused );
				_es.removeEventListener( GameEvent.TOGGLE_MUSIC, onToggleMusic );
				_es.removeEventListener( CaveSmashEvent.ON_CRACK_NORMAL_BLOCK, onCrackNormalBlock );
				_es.removeEventListener( CaveSmashEvent.MONSTER_DIED, onMonsterDied );
				_es.removeEventListener( CaveSmashEvent.LEVEL_STARTED, onLevelStarted );
				_es.removeEventListener( CaveSmashEvent.MONSTER_HIT, onHitMonster );
				_es.removeEventListener( CaveSmashEvent.BOUNCE_MUSHROOM, onBounceMushroom );				
				_es.removeEventListener( CaveSmashEvent.ON_BUY_ITEM, onBuyItem );
				_es.removeEventListener( CaveSmashEvent.THROW_WEAPON, onThrowWeapon );
				_es.removeEventListener( CaveSmashEvent.PLAY_SFX, onPlaySfx );
				
				removeSoundManager();
				_bm.removeBtnListener( _mc.bgmBtn );
				_bm.removeBtnListener( _mc.sfxBtn );
				_bm.removeBtnListener( _mc.pauseBtn );
				_bm.removeBtnListener( _mc.settingsBtn );
				_bm.removeEventListener( ButtonEvent.CLICK_BUTTON, onClickBtn );
				_bm.removeEventListener( ButtonEvent.ROLL_OVER_BUTTON, onRollOverBtn );
				_bm.removeEventListener( ButtonEvent.ROLL_OUT_BUTTON, onRollOutBtn );
				_bm.clearButtons();
				_bm = null;
				if ( this.contains( _mc ) ) {
					this.removeChild( _mc );
					_mc = null;
				}
			}
		}
		
		private function addSoundManager():void
		{
			_soundManager =  SoundManager.getInstance();

			_soundManager.loadBgm( MAIN_GAME_BGM, new CBgm1() );
			_soundManager.loadBgm( DESSERT_GAME_BGM, new DessertBGM() );
			_soundManager.loadBgm( DARK_GAME_BGM, new DarkBGM() );
			
			_soundManager.loadBgm( MAP_BGM, new MapBGM() );
			_soundManager.loadBgm( INTRO_BGM, new IntroBGM() );
			_soundManager.loadBgm( BOSS1_SCENE_BGM, new Boss1SceneBGM() );
			_soundManager.loadBgm( BOSS2_SCENE_BGM, new Boss2SceneBGM() );
			_soundManager.loadBgm( BOSS3_SCENE_BGM, new Boss3SceneBGM() );
			_soundManager.loadBgm( END_SCENE_BGM, new EndSceneBGM() );
			_soundManager.loadBgm( LEVEL_CLEAR_BGM, new LevelClearBGM() );
			_soundManager.loadBgm( LEVEL_FAILED_BGM, new LevelFailedBGM() );
			_soundManager.loadBgm( BOSS1_BGM, new Boss1BGM() );
			_soundManager.loadBgm( BOSS2_BGM, new Boss2BGM() );
			_soundManager.loadBgm( BOSS3_BGM, new Boss3BGM() );
			_soundManager.loadBgm( SHOP_BGM, new ShopBGM() );
			
			_soundManager.loadSfx( COLLECT_COIN_SFX, new coinSFX() , 0.5 );
			_soundManager.loadSfx( COLLECT_KEY_SFX, new KeySFX() , 1 );
			_soundManager.loadSfx( COLLECT_CRYSTAL_SFX, new CrystalSFX() , 1 );
			_soundManager.loadSfx( COLLECT_HEART_SFX, new HeartSFX() , 1 );
			_soundManager.loadSfx( CRACK_SFX, new CrackSFX() , 0.6 );
			
			_soundManager.loadSfx( ATTACK_SFX, new AttackSFX() , 0.7 );
			_soundManager.loadSfx( PORTAL_SFX, new PortalSFX() , 1 );
			_soundManager.loadSfx( PORTAL2_SFX, new Portal2SFX() , 0.8 );
			_soundManager.loadSfx( BOUNCE_SFX, new bounceSFX() , 0.7 );
			
			_soundManager.loadSfx( SoundConfig.EXPLOSION_SFX, new ExplosionSFX() , 0.5 );
			_soundManager.loadSfx( BUY_SFX, new BuySFX() , 0.8 );
			_soundManager.loadSfx( THROW_SFX, new ThrowSFX() , 0.8 );
			
			_soundManager.loadSfx( SoundConfig.ATTACK1_SFX, new Attack1SFX() , 0.8 );
			_soundManager.loadSfx( SoundConfig.ATTACK2_SFX, new Attack2SFX() , 0.8 );
			_soundManager.loadSfx( SoundConfig.PLAYER_HIT_SFX, new PlayerHitSFX(), 1);
			
			_soundManager.loadSfx( SoundConfig.BLUE_SHOT_SFX, new BlueShotSFX(), 1);
			_soundManager.loadSfx( SoundConfig.FALL_SFX, new FallSFX(), 0.3);
			_soundManager.loadSfx( SoundConfig.POO_SHOT_SFX, new PooShotSFX(), 1);
			_soundManager.loadSfx( SoundConfig.PULSE_SHOT_SFX, new PulseShotSFX(), 0.05);
			_soundManager.loadSfx( SoundConfig.WARNING_SFX, new WarningSFX(), 1);
			_soundManager.loadSfx( SoundConfig.BOSS2_DASH_SFX, new Boss2DashSFX(), 1);
			_soundManager.loadSfx( SoundConfig.BOSS2_FLAP_SFX, new Boss2FlapSFX(), 1);
			
			_soundManager.loadSfx( SoundConfig.DARK_BOSS_BLAST_SFX, new DarkBossBlastSFX(), 1);
			_soundManager.loadSfx( SoundConfig.GREEN_BOMB_SFX, new GreenBombSFX(), 1);
			_soundManager.loadSfx( SoundConfig.GREEN_BOMB_EXPLODE_SFX, new GreenBombExplodeSFX(), 1);
			_soundManager.loadSfx( SoundConfig.MINI_DARK_BOSS_TELEPORT_SFX, new MiniDarkBossTeleportSFX(), 1);
			_soundManager.loadSfx( SoundConfig.JUMP_SFX, new JumpSFX(), 1);
			_soundManager.loadSfx( SoundConfig.STAR_SFX, new StarSFX(), 1);
			
			_soundManager.loadSfx( SoundConfig.BIG_ROCK_SFX, new BigRockSFX(), 1);
			_soundManager.loadSfx( SoundConfig.TRANSFORM_SFX, new TransformSFX(), 1);
			_soundManager.loadSfx( SoundConfig.ROCK_FALL_SFX, new RockFallSFX(), 1);
			_soundManager.loadSfx( SoundConfig.WHITE_SHOT_SFX, new WhiteShotSFX(), 0.9);
			_soundManager.loadSfx( SoundConfig.ROLL_ATTACK_SFX, new RollAttackSFX(), 1);
			_soundManager.loadSfx( SoundConfig.BLADE_FALL_SFX, new BladeFallSFX(), 1);
			_soundManager.loadSfx( SoundConfig.DARK_ROCK_EXPLOSION_SFX, new DarkRockExplosionSFX(), 1);
			_soundManager.loadSfx( SoundConfig.CLICK_SFX, new ClickSFX(), 0.1);
			
			trace( "[SoundGUI]: init..." );
		}
		
		private function removeSoundManager():void
		{
			_soundManager.stopBgMusic();
			_soundManager.stopSoundEffect();
			_soundManager.unloadBgm();
			_soundManager.unloadSfx();
		}
		
		public function muteSfx():void
		{
			if ( !_soundManager.sfxOff ) {
				_soundManager.muteSfx();
				_mc.sfxBtn.gotoAndStop( 2 );
			}
			
			_soundManager.stopSoundEffect();
			_soundManager.setSfxVolume( 0 );
		}
		
		public function muteBgm():void
		{
			if ( !_soundManager.bgmOff ) {
				_soundManager.muteBgm();
				_mc.bgmBtn.gotoAndStop( 2 );
			}
			
			_soundManager.stopBgMusic();
			_soundManager.SetBgmVolume( 0 );
		}
		
		public function unMuteSFX():void
		{
			_soundManager.setSfxVolume( .3 );
			if ( _soundManager.sfxOff ) {
				_soundManager.unMuteSfx();
				_mc.sfxBtn.gotoAndStop( 1 );
			}
		}
		
		public function unMuteBgm():void
		{
			//_soundManager.SetBgmVolume( .8 );
			if ( _soundManager.bgmOff ) {
				_soundManager.unMuteBgm();
				_mc.bgmBtn.gotoAndStop( 1 );
				
				if ( !_soundManager.bgmIsPlaying ) {
					_soundManager.stopBgMusic();
					_soundManager.selectBgMusic( MAIN_GAME_BGM );
					//_soundManager.SetBgmVolume( .4 );
					_soundManager.SetBgmVolume( .3 );
					_soundManager.playBgMusic();
				}
			}
		}
		
		public function playBgMusic( type:int ):void
		{
			if( type == 0 ){
				_soundManager.selectBgMusic( MAIN_GAME_BGM );
			}else if( type == 1 ){
				muteBgm();
				unMuteBgm();
			}else if ( type == 2 ){
				_soundManager.selectBgMusic( MAP_BGM );
			}else if ( type == 3 ){
				_soundManager.selectBgMusic( LEVEL_CLEAR_BGM );
			}else if ( type == 4 ){
				_soundManager.selectBgMusic( LEVEL_FAILED_BGM );
			}else if ( type == 5 ){
				_soundManager.selectBgMusic( BOSS1_BGM );
			}else if ( type == 6 ){
				_soundManager.selectBgMusic( BOSS2_BGM );
			}else if ( type == 7 ){
				_soundManager.selectBgMusic( BOSS3_BGM );
			}else if ( type == 8 ){
				_soundManager.selectBgMusic( SHOP_BGM );
			}else if ( type == 9 ){
				_soundManager.selectBgMusic( DESSERT_GAME_BGM );
			}else if ( type == 10 ){
				_soundManager.selectBgMusic( DARK_GAME_BGM );
			}
			
			if (type == 4){
				_soundManager.SetBgmVolume( .8 );
			}else if (type == 8) {
				_soundManager.SetBgmVolume( .1 );
			}else {
				//_soundManager.SetBgmVolume( .4 );
				_soundManager.SetBgmVolume( .3 );
			}
			//_soundManager.stopBgMusic();
			
			if(type == 3 || type == 4){
				_soundManager.playBgMusic( false );
			}else {
				_soundManager.playBgMusic(  );
			}
			trace( "play bg ko1" );
		}
		
		public function stopAndSelectBGM(type:int):void{
			_soundManager.stopBgMusic();
			selectBGM(type);
		}
		
		public function playSceneBGM(scene:int):void{
			if( scene == 0 ){
				_soundManager.selectBgMusic( INTRO_BGM );
			}else if( scene == 1 ){
				_soundManager.selectBgMusic( BOSS1_SCENE_BGM );
			}else if( scene == 2 ){
				_soundManager.selectBgMusic( BOSS2_SCENE_BGM );
			}else if( scene == 3 ){
				_soundManager.selectBgMusic( BOSS3_SCENE_BGM );
			}else if( scene == 4 ){
				_soundManager.selectBgMusic( END_SCENE_BGM );
			}else if( scene == 5 ){
				_soundManager.selectBgMusic( LEVEL_CLEAR_BGM );
			}else {
				_soundManager.selectBgMusic( MAP_BGM );
			}
			
			_soundManager.stopBgMusic();
			//_soundManager.SetBgmVolume( .4 );
			_soundManager.SetBgmVolume( .3 );
			_soundManager.playBgMusic();
		}
		
		public function selectBGM(type:int):void 
		{
			if( type == 0 ){
				_soundManager.selectBgMusic( MAIN_GAME_BGM );
			}else if ( type == 1 ){
				_soundManager.selectBgMusic( MAP_BGM );
			}else if ( type == 2 ){
				_soundManager.selectBgMusic( LEVEL_CLEAR_BGM );
			}else if ( type == 3 ){
				_soundManager.selectBgMusic( LEVEL_FAILED_BGM );
			}
		}
		
		public function playSFX( sfx:String ):void
		{
			_soundManager.selectSfx( sfx );
			_soundManager.playSoundSfx( false );
		}
		
        public function toggleBgmSfx():void
        {
            if ( !_isBgmSfxToggle ) {
                _isBgmSfxToggle = true;
                muteBgm();
                muteSfx();
            }else {
                _isBgmSfxToggle = false;
                unMuteBgm();
                unMuteSFX();
            }
        }

		/*------------------------------------------------------------------Setters--------------------------------------------------------------------*/
		public function set isBgmSfxToggle(value:Boolean):void
        {
            _isBgmSfxToggle = value;
        }
		/*------------------------------------------------------------------Getters--------------------------------------------------------------------*/
		 public function get isBgmSfxToggle():Boolean
        {
            return _isBgmSfxToggle;
        }

		/*------------------------------------------------------------------EventHandlers--------------------------------------------------------------*/
		private function onRollOutBtn(e:ButtonEvent):void
		{
			var btnName:String = e.obj.name;
			
			switch ( btnName )
			{
				case "sfxBtn":
					if ( !_soundManager.sfxOff ){
						_mc.sfxBtn.gotoAndStop( 1 );
					}else {
						_mc.sfxBtn.gotoAndStop( 2 );
					}
				break;
				
				case "bgmBtn":
					if ( !_soundManager.bgmOff ){
						_mc.bgmBtn.gotoAndStop( 1 );
					}else {
						_mc.bgmBtn.gotoAndStop( 2 );
					}
				break;
				
				default:
				break;
			}
		}
		
		private function onRollOverBtn(e:ButtonEvent):void
		{
			var btnName:String = e.obj.name;
			
			switch ( btnName )
			{
				case "sfxBtn":
					if ( !_soundManager.sfxOff ){
						_mc.sfxBtn.gotoAndStop( 1 );
					}else {
						_mc.sfxBtn.gotoAndStop( 2 );
					}
				break;
				
				case "bgmBtn":
					if ( !_soundManager.bgmOff ){
						_mc.bgmBtn.gotoAndStop( 1 );
					}else {
						_mc.bgmBtn.gotoAndStop( 2 );
					}
				break;
				
				default:
				break;
			}
		}
		
		private function onClickBtn(e:ButtonEvent):void
		{
			var btnName:String = e.obj.name;
			
			switch ( btnName )
			{
				case "sfxBtn":
					if ( !_soundManager.sfxOff ) {
						muteSfx();
					}else{
						unMuteSFX();
					}
				break;
				
				case "bgmBtn":
					if ( !_soundManager.bgmOff ) {
						muteBgm();
					}else {
						unMuteBgm();
					}
				break;
				
				case "pauseBtn":
					_mc.pauseBtn.gotoAndStop( 2 );
					_gameEvent = new GameEvent( GameEvent.SHOW_PAUSED_SCREEN );
					_es.dispatchESEvent( _gameEvent );
				break;
				
				case "settingsBtn":
					_mc.settingsBtn.gotoAndStop( 2 );
					_gameEvent = new GameEvent( GameEvent.SHOW_GAME_SETTING );
					_es.dispatchESEvent( _gameEvent );
					trace( "[SoundGui]:click settings......." );
				break;
				
				default:
				break;
			}
		}
		
		
		private function onUnPaused(e:GameEvent):void
		{
			_mc.pauseBtn.gotoAndStop( 1 );
			_mc.settingsBtn.gotoAndStop( 1 );
		}
		
		private function onToggleMusic(e:GameEvent):void
		{
			if ( !_soundManager.sfxOff ) {
				muteSfx();
			}else{
				unMuteSFX();
			}
			
			if ( !_soundManager.bgmOff ){
				muteBgm();
			}else{
				unMuteBgm();
			}
		}
		
		private function onCrackNormalBlock(e:CaveSmashEvent):void
		{
			playSFX(CRACK_SFX);
		}
		
		private function onMonsterDied(e:CaveSmashEvent):void
		{
			playSFX(PORTAL2_SFX);
		}
		
		private function onLevelStarted(e:CaveSmashEvent):void
		{
			playSFX(PORTAL_SFX);
		}
		
		private function onHitMonster(e:CaveSmashEvent):void
		{
			playSFX(ATTACK_SFX);
			trace("hit monster soundGUI!!!");
		}
		
		private function onBounceMushroom(e:CaveSmashEvent):void
		{
			playSFX(BOUNCE_SFX);
		}
		
		private function onThrowWeapon(e:CaveSmashEvent):void{
			playSFX(THROW_SFX);
		}		
		
		private function onBuyItem(e:CaveSmashEvent):void{
			playSFX(BUY_SFX);
		}
		
		private function onPlaySfx(e:CaveSmashEvent):void {
			playSFX(e.obj.id);
		}
	}

}

class SingletonEnforcer{}