package components {	
	
	import Box2DAS.Collision.AABB;
	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.b2Body;
	import Box2DAS.Dynamics.b2Fixture;
	import Box2DAS.Dynamics.StepEvent;
	import com.greensock.TweenLite;
	import com.monsterPatties.controllers.GameDataController;
	import com.monsterPatties.events.GameEvent;
	import com.monsterPatties.utils.eventSatellite.EventSatellite;
	import com.monsterPatties.utils.soundManager.SoundManager;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import misc.Util;
	import shapes.Box;
	import wck.*;
	
	public class HeartBox extends Box {
	
		/*----------------------------------------------------------------------Constant--------------------------------------------------------------*/
		
		public static var RED_HEART:String = "RED";
		public static var BLACK_HEART:String = "BLACK";
		public static var DEVIL_HEART:String = "DEVIL";
		
		
		/*----------------------------------------------------------------------Properties-------------------------------------------------------------*/
		/**
		 * type of heart
		 */
		
		public var htype:String;
		//private var _gdc:GameDataController;
		private var _es:EventSatellite;
		private var _gameEvent:GameEvent;
		private var _soundManager:SoundManager;		
		/*----------------------------------------------------------------------Constructor--------------------------------------------------------------*/
		
		override public function create() : void
        {            
			super.create();
			
			_es = EventSatellite.getInstance();
			//_gdc = GameDataController.getInstance();
			
            fixedRotation = true;
			allowDragging = false;
			listenWhileVisible(world, StepEvent.STEP, worldStep, false, 10);
			//addEventListener( Event.ENTER_FRAME, worldStep );
			addEventListener( Event.REMOVED_FROM_STAGE, clearMe );
			addEventListener( MouseEvent.MOUSE_DOWN, onClickMe );
			
			addSoundManager();
			//world.b2world.GetBodyCount();			
		}						
		
		
		/*----------------------------------------------------------------------Methods-----------------------------------------------------------------*/
		private function removeMe():void 
		{				
			if ( this != null ) {
				levelCounter();
				if (  htype == HeartBox.RED_HEART ) {
					trace( "[before awake modify]: awake", awake, "_awake", _awake );
					awake = false;
					_awake = false;
					trace( "[AFTER awake modify]: awake", awake, "_awake", _awake );
					//_gdc.setRedheartActive( false );
					//if ( !_gdc.getIsLevelDone() ){
						//_gameEvent = new GameEvent( GameEvent.LEVEL_FAILED );
						//_es.dispatchESEvent( _gameEvent );
					//}
				}else{
					//TweenLite.delayedCall( 0.5, levelChecker );					
				}
				
				this.remove();
				destroy();				
			}
		}
		
		private function addSoundManager():void 
		{
			_soundManager =  SoundManager.getInstance();
			//_soundManager.loadBgm( "bgm1", new Bgm1 );
			//_soundManager.selectBgMusic( "bgm1" );
			//_soundManager.SetBgmVolume( .5 );
			//_soundManager.playBgMusic();			
			
			//_soundManager.loadSfx( "getItem", new Explosion() );
			//_soundManager.selectSfx( "getItem" );
			//_soundManager.playSoundSfx( false );
			_soundManager.loadSfx( "explosion", new ExplosionSFX() , .1 );
			trace( "[GE] add soundmanager Play again" );
		}
		
		private function playFade():void 
		{				
			if ( htype == HeartBox.BLACK_HEART ){				
				this.gotoAndPlay( "remove" );							
				this.addFrameScript( this.totalFrames - 2, onRemoveMe )			
			}
		}
		
		private function onRemoveMe():void 
		{			
			var explosion:Explosion = new Explosion();
			explosion.visible = false;
			Util.addChildAtPosOf(world, explosion, this );
			Util.addChildAtPosOf(world, new ExplosionFx(), this );		
			
			if ( this != null ){				
				this.remove();
				destroy();
			}			
			
			trace( "[Bheart removing...]" );
			levelCounter();
			//TweenLite.delayedCall( 0.5, levelChecker );			
		}
		
		
		private function levelCounter():void 
		{
			switch ( htype ) 
			{
				case HeartBox.RED_HEART:
					//_gdc.updateRcount( 1 );
					trace( HeartBox.RED_HEART + " has been added, remove and destroy!!" );
				break;
				
				case HeartBox.BLACK_HEART:
					//_gdc.updateBcount( 1 );
					trace( HeartBox.BLACK_HEART + " has been added, remove and destroy!!" );
				break;
				
				case HeartBox.DEVIL_HEART:
					//_gdc.updateDcount( 1 );
					trace( HeartBox.DEVIL_HEART + " has been added, remove and destroy!!" );
				break;
				
				default:
					trace( "unknown object just remove and destroy!!" );
				break;
			}			
		}
		
		/*
		private function levelGoalChecker():void 
		{		
			var valid:Boolean = _gdc.getIsLevelDone();
			var valid2:Boolean = _gdc.getRedheartActive();
			
			if ( !valid && !valid2 ){
			
				//trace( "[ HeartBox] level checker", _gdc.getBcount(), _gdc.getRcount(), _gdc.getDcount() );
				_gameEvent = new GameEvent( GameEvent.LEVEL_COMPLETE );
				
				if ( _gdc.getLevel() == 1 && _gdc.getBcount() == 1  ){
					_es.dispatchESEvent( _gameEvent );
				}else if ( _gdc.getLevel() == 2 && _gdc.getBcount() == 4  ){
					_es.dispatchESEvent( _gameEvent );
				}else if ( _gdc.getLevel() == 3 && _gdc.getBcount() == 4  ) {
					_es.dispatchESEvent( _gameEvent );
				}else if ( _gdc.getLevel() == 4 && _gdc.getBcount() == 3 ) {
					_es.dispatchESEvent( _gameEvent );
				}else if ( _gdc.getLevel() == 5 && _gdc.getBcount() == 2 &&  _gdc.getDcount() == 1 ) {
					_es.dispatchESEvent( _gameEvent );
				}else if ( _gdc.getLevel() == 6 && _gdc.getBcount() == 3 &&  _gdc.getDcount() == 1 ) {
					_es.dispatchESEvent( _gameEvent );
				}else if ( _gdc.getLevel() == 7 && _gdc.getBcount() == 2 &&  _gdc.getDcount() == 1 ) {
					_es.dispatchESEvent( _gameEvent );
				}else if ( _gdc.getLevel() == 8 && _gdc.getBcount() == 4 &&  _gdc.getDcount() == 2  ) {
					_es.dispatchESEvent( _gameEvent );
				}else if ( _gdc.getLevel() == 9 && _gdc.getBcount() == 2 &&  _gdc.getDcount() == 1  ) {
					_es.dispatchESEvent( _gameEvent );
				}else if ( _gdc.getLevel() == 10 && _gdc.getBcount() == 3 &&  _gdc.getDcount() == 1  ) {
					_es.dispatchESEvent( _gameEvent );
				}else if ( _gdc.getLevel() == 11 && _gdc.getBcount() == 2 &&  _gdc.getDcount() == 2  ) {
					_es.dispatchESEvent( _gameEvent );
				}else if ( _gdc.getLevel() == 12 && _gdc.getBcount() == 1 &&  _gdc.getDcount() == 2  ) {
					_es.dispatchESEvent( _gameEvent );
				}else if ( _gdc.getLevel() == 13 && _gdc.getBcount() == 4 &&  _gdc.getDcount() == 3  ) {
					_es.dispatchESEvent( _gameEvent );
				}else if ( _gdc.getLevel() == 14 && _gdc.getBcount() == 4 &&  _gdc.getDcount() == 2  ) {
					_es.dispatchESEvent( _gameEvent );
				}else if ( _gdc.getLevel() == 15 && _gdc.getBcount() == 2 &&  _gdc.getDcount() == 2  ) {
					_es.dispatchESEvent( _gameEvent );
				}else if ( _gdc.getLevel() == 16 && _gdc.getBcount() == 2 &&  _gdc.getDcount() == 2  ) {
					_es.dispatchESEvent( _gameEvent );
				}else if ( _gdc.getLevel() == 17 && _gdc.getBcount() == 2  ) {
					_es.dispatchESEvent( _gameEvent );
				}else if ( _gdc.getLevel() == 18 && _gdc.getBcount() == 3 &&  _gdc.getDcount() == 1  ) {
					_es.dispatchESEvent( _gameEvent );
				}else if ( _gdc.getLevel() == 19 && _gdc.getBcount() == 3   ) {
					_es.dispatchESEvent( _gameEvent );				
				}else if ( _gdc.getLevel() == 20 && _gdc.getBcount() == 2 &&  _gdc.getDcount() == 2  ) {
					_es.dispatchESEvent( _gameEvent );
				}else if ( _gdc.getLevel() == 21 && _gdc.getBcount() == 3 &&  _gdc.getDcount() == 2  ) {
					_es.dispatchESEvent( _gameEvent );
				}			
				
			}
		}
		*/
		
		/*
		private function levelFailChecker():void 
		{	
			var valid:Boolean = _gdc.getIsLevelDone();
			var valid2:Boolean = _gdc.getRedheartActive();
			
			if ( !valid && !valid2 ){
				_gameEvent = new GameEvent( GameEvent.LEVEL_FAILED );
					
				if ( _gdc.getLevel() == 4 && _gdc.getRcount() > 0  ) {				
					_es.dispatchESEvent( _gameEvent );				
				}else if ( _gdc.getLevel() == 5 && _gdc.getRcount() > 0  ){
					_es.dispatchESEvent( _gameEvent );
				}else if ( _gdc.getLevel() == 6 && _gdc.getRcount() > 0  ){
					_es.dispatchESEvent( _gameEvent );
				}else if ( _gdc.getLevel() == 7 && _gdc.getRcount() > 0  ){
					_es.dispatchESEvent( _gameEvent );
				}else if ( _gdc.getLevel() == 10 && _gdc.getRcount() > 0  ){
					_es.dispatchESEvent( _gameEvent );
				}else if ( _gdc.getLevel() == 11 && _gdc.getRcount() > 0  ){
					_es.dispatchESEvent( _gameEvent );
				}else if ( _gdc.getLevel() == 12 && _gdc.getRcount() > 0  ){
					_es.dispatchESEvent( _gameEvent );
				}else if ( _gdc.getLevel() == 14 && _gdc.getRcount() > 0  ){
					_es.dispatchESEvent( _gameEvent );
				}else if ( _gdc.getLevel() == 16 && _gdc.getRcount() > 0  ){
					_es.dispatchESEvent( _gameEvent );
				}else if ( _gdc.getLevel() == 17 && _gdc.getRcount() > 0  ){
					_es.dispatchESEvent( _gameEvent );
				}else if ( _gdc.getLevel() == 18 && _gdc.getRcount() > 0  ){
					_es.dispatchESEvent( _gameEvent );
				}else if ( _gdc.getLevel() == 19 && _gdc.getRcount() > 0  ){
					_es.dispatchESEvent( _gameEvent );
				}else if ( _gdc.getLevel() == 21 && _gdc.getRcount() > 0  ){
					_es.dispatchESEvent( _gameEvent );
				}
			}
		}
		
		*/
		
		/*
		private function levelChecker():void 
		{			
			levelFailChecker();
			levelGoalChecker();	
		}
		*/
		
		
		private function searchObject( object:* ):Boolean 
		{
			var found:Boolean = false;			
			
			for(var b:* = world.b2world.GetBodyList(); b; b = b.GetNext() ) {				
				var bb:b2Body = b;
				if( bb.m_userData != undefined ){
					if ( bb.m_userData is object ){
						found = true;
						break;
					}					
				}
			}
			
			return found;
		}		
		
		private function getObjectB2Body( object:* ):b2Body 
		{			
			var myBody:b2Body = null;
			
			for(var b:* = world.b2world.GetBodyList(); b; b = b.GetNext() ) {				
				var bb:b2Body = b;
				if( bb.m_userData != undefined ){
					if ( bb.m_userData is object ){
						myBody = bb;						
						break;
					}
					//trace( "fuck", bb.m_userData, bb.GetFixtureList().m_userData.width );					
				}
			}
			
			return myBody;
		}	
		
		
		public function explode(x:Number, y:Number, radius:Number,
								  force:Number):void
		{
			var explosionPos:V2 = new V2(x, y);
			var body:b2Body;
			var bodyPos:V2;
			var distance:Number;
			
			var newAABB:AABB = new AABB(new V2(x - radius, y - radius), new V2(x + radius, y + radius));			
			
			this.world.b2world.QueryAABB(
				function(fixture:b2Fixture):Boolean
				{
					if (!fixture.m_body.IsStatic() && (fixture.m_body != body))
					{
						body = fixture.m_body;
						bodyPos = body.GetWorldCenter();
						distance = explosionPos.distance(bodyPos);
						if (distance < radius)
							body.ApplyImpulse(bodyPos.subtract(explosionPos).multiplyN((radius - distance) * force), body.GetWorldCenter());
					}
					
					return true;
				}, newAABB);
		}
		/*----------------------------------------------------------------------Setters--------------------------------------------------------------*/
		
		/*----------------------------------------------------------------------Getters--------------------------------------------------------------*/
		
		/*------------------------------------------------------------------EventHandlers--------------------------------------------------------------*/
		
		private function onClickMe(e:MouseEvent):void 
		{
			/*
			var myPoint:V2 = this.b2body.GetPosition();
			explode( myPoint.x,myPoint.y, 3, 20 );
			*/
			
			
			if (  htype == HeartBox.BLACK_HEART  ){
				_soundManager.selectSfx( "explosion" );
				_soundManager.playSoundSfx( false );
			}
			
			removeEventListener( MouseEvent.MOUSE_DOWN, onClickMe );			
			trace( "click me.." );			
			
			//if ( ( _gdc.getClickCnt() - 1  ) < 0 ) {
				//if ( !_gdc.getIsLevelDone() ){
					//_gameEvent = new GameEvent( GameEvent.LEVEL_FAILED );
					//_es.dispatchESEvent( _gameEvent );
				//}
			//}else {
				//_gdc.updateClick( -1 );
			//}
			//
			//_gdc.updateTotalClickCnt( 1 );
			//_gameEvent =  new GameEvent( GameEvent.UPDATE_CLICK );
			//_es.dispatchESEvent( _gameEvent );
			
			playFade();			
		}
		
		private function clearMe(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, clearMe);
			removeAllListeners();
		}		
		
		private function worldStep( e:Event ):void 
		{		
			/*
			if (  htype == HeartBox.RED_HEART  && !_gdc.getIsLevelDone() ){
				if ( !awake ){
					//TweenLite.delayedCall( 1, extraChecker );				
					//levelChecker();
					_gdc.setRedheartActive( false );
					TweenLite.delayedCall( .5, levelChecker );
					//trace( "[ heart is not awake... ]" );					
				}else {
					//trace( "[ heart is awake... ]" );
					_gdc.setRedheartActive( true );
					//dont check wait till not awake
				}
			}
			*/
			/*if (  htype == HeartBox.RED_HEART ){				
				if ( linearVelocityX != 0  ) {
					_gdc.setRedheartActive( true );
				}else if ( linearVelocityY != 0  ) {
					_gdc.setRedheartActive( true );
				}else if ( linearVelocityX == 0 && linearVelocityY == 0 && this.angularVelocity == 0 && this._angularDamping == 0 ) {
					_gdc.setRedheartActive( false );					
				}				
			}*/
			
			if( this != null ){
				if( this.y >= 480 ){
					trace( htype + ": heart out of screen!!" );
					removeMe();
				}else if ( this.x <= -50 ) {
					trace( htype + ": heart out of screen!!" );
					removeMe();
				}else if ( this.x >= 680 ) {
					trace( htype + ": heart out of screen!!" );
					removeMe();
				}
			}else {
				trace( htype + ": hear already remove!!" );
			}
		}
	}
}