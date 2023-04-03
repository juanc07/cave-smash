package components.blocks {
	
	import Box2DAS.Dynamics.ContactEvent;
	import Box2DAS.Dynamics.StepEvent;
	import com.greensock.TweenLite;
	import com.monsterPatties.events.CaveSmashEvent;
	import com.monsterPatties.utils.eventSatellite.EventSatellite;
	import components.players.Player2;
	import flash.events.Event;
	import flash.geom.Point;
	import wck.*;
	
	public class ExplodingBlockold extends BodyShape{
	
		/*------------------------------------------------------------------Constant----------------------------------------------------------------------*/
		/*------------------------------------------------------------------Properties--------------------------------------------------------------------*/
		public var contacts:ContactList;
		public var blockType:String = BlockConfig.EXPLODING;
		private var _isDestroyed:Boolean = false;
		private var _es:EventSatellite;
		private var hasRemoved:Boolean;
		
		public var _target:Player2;
		public var _levelIsDone:Boolean = false;
		/*------------------------------------------------------------------Constructor----------------------------------------------------------------------*/
		public override function shapes():void{
		}
		
		override public function create():void{
			super.create();
			type = "Static";
			applyGravity = false;
			fixedRotation = true;
			
			listenWhileVisible(this, ContactEvent.BEGIN_CONTACT, handleContact);
			listenWhileVisible(this, ContactEvent.END_CONTACT, endContact);
			listenWhileVisible(world, StepEvent.STEP, parseInput, false, 10);
			
			contacts = new ContactList();
			contacts.listenTo(this);
			addGameEvent();
		}
		/*------------------------------------------------------------------Methods----------------------------------------------------------------------*/
		public function animate():void
		{
			if ( !_isDestroyed && this != null ){
				_isDestroyed  = true;
				this.mc.gotoAndPlay( "animate" );
				this.mc.addFrameScript( this.mc.totalFrames - 1, onEndAnimation );
				this.mc.addFrameScript( this.mc.totalFrames * 0.5, checkIfHitPlayer );
			}
		}
		
		private function cleanMe():void {
			if ( _levelIsDone ){
				return;
			}
			
			if ( this != null && _isDestroyed){
				_target = null;
				_isDestroyed = false;
				this.mc.gotoAndPlay( "idle" );
				this.mc.alpha = 0;
				TweenLite.to( this.mc, 0.5,{alpha:1});
			}
		}
		
		private function onEndAnimation():void
		{
			if ( this != null ){
				this.mc.addFrameScript( this.mc.totalFrames - 1, null );
				cleanMe();
				//clearAll();
				//this.remove();
			}
		}
		
		private function checkIfHitPlayer():void
		{
			if ( _levelIsDone ) {
				return;
			}
			
			if ( this != null ) {
				this.mc.addFrameScript( this.mc.totalFrames * 0.5, null );
				if ( _target != null ){
					attackPlayer( _target );
				}
			}
		}
		
		public function attackPlayer( target:Player2 ):void
		{
			var player:Player2 = target as Player2;
			if( !player.isDead){
				player.die();
				//player.hit(0,0,0);
			}
		}
		
		//optimization i think if turning visible false it really decreased the consumption on process
		private function checkForVisible():void
		{
			if ( this != null ){
				var newPos:Point = this.mc.localToGlobal( new Point( stage.x, stage.y ) )
				var newPos2:Point = world.focus.localToGlobal( new Point( stage.x, stage.y ) )
				
				var focusLeft:Number = newPos2.x - ( stage.stageWidth );
				var focusRight:Number = newPos2.x + ( stage.stageWidth );
				
				var focusUp:Number = newPos2.y - ( stage.stageHeight );
				var focusDown:Number = newPos2.y + ( stage.stageHeight );
				
				if ( ( newPos.x + this.mc.width ) < focusLeft  ){
					this.mc.visible = false;
				}else if ( ( newPos.x - this.mc.width ) > focusRight ){
					this.mc.visible = false;
				}else if ( ( newPos.y + this.mc.height ) < focusUp ) {
					this.mc.visible = false;
				}else if ( ( newPos.y - this.mc.height ) > focusDown ) {
					this.mc.visible = false;
				}else{
					this.mc.visible = true;
				}
			}
		}
		
		private function clearAll():void
		{
			removeTweens();
			removeAllListeners();
			removeControllers();
			removeGameEvent();
			//this.remove();
			//destroy();
		}
		
		private function removeTweens():void{
			TweenLite.killTweensOf(this.mc);
		}
		
		private function initControllers():void
		{
			
		}
		
		private function removeControllers():void
		{
			
		}
		
		private function addGameEvent():void
		{
			_es = EventSatellite.getInstance();
			_es.addEventListener( CaveSmashEvent.LEVEL_STARTED, onLevelStarted );
			_es.addEventListener( CaveSmashEvent.LEVEL_QUIT, OnLevelQuit );
			_es.addEventListener( CaveSmashEvent.LEVEL_COMPLETE, onLevelComplete );
			_es.addEventListener( CaveSmashEvent.LEVEL_FAILED, onLevelFailed );
			_es.addEventListener( CaveSmashEvent.RELOAD_LEVEL, onReloadLevel );
		}
		
		private function removeGameEvent():void
		{
			_es = EventSatellite.getInstance();
			_es.removeEventListener( CaveSmashEvent.LEVEL_STARTED, onLevelStarted );
			_es.removeEventListener( CaveSmashEvent.LEVEL_QUIT, OnLevelQuit );
			_es.removeEventListener( CaveSmashEvent.LEVEL_COMPLETE, onLevelComplete );
			_es.removeEventListener( CaveSmashEvent.LEVEL_FAILED, onLevelFailed );
			_es.removeEventListener( CaveSmashEvent.RELOAD_LEVEL, onReloadLevel );
		}
		
		private function removeME():void
		{
			if( !hasRemoved  ){
				hasRemoved = true;
				this.remove();
			}
		}
		/*------------------------------------------------------------------Setters----------------------------------------------------------------------*/
		
		/*------------------------------------------------------------------Getters----------------------------------------------------------------------*/
		
		/*------------------------------------------------------------------EventHandlers----------------------------------------------------------------*/
		public function endContact(e:ContactEvent):void {
			if (!world  || this == null ) return;
			trace( "[ Exploding Block ]: end contact with: === >" + e.other.GetBody().GetUserData() );
			if ( e.other.GetBody().m_userData is Player2 ) {
				_target = null;
			}
		}
		public function handleContact(e:ContactEvent):void {
			if (!world  || this == null ) return;
			trace( "[ Exploding Block ]: begin contact with: === >" + e.other.GetBody().GetUserData() );
			if ( e.other.GetBody().m_userData is Player2 ) {
				_target = e.other.GetBody().m_userData;
				animate();
			}
		}
		
		public function parseInput(e:Event):void{
			if (!world  || this == null ) return;
			checkForVisible();
		}
		
		private function onLevelFailed(e:CaveSmashEvent):void{
			_levelIsDone = true;
			clearAll();
		}
		
		private function onLevelComplete(e:CaveSmashEvent):void {
			_levelIsDone = true;
			clearAll();
		}
		
		private function onLevelStarted(e:CaveSmashEvent):void{
			_levelIsDone = false;
			initControllers();
		}
		
		private function OnLevelQuit(e:CaveSmashEvent):void{
			clearAll();
			removeME();
		}
		
		private function onReloadLevel(e:CaveSmashEvent):void{
			clearAll();
			removeME();
		}
	}
}