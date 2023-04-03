package components.interactive {	
	
	import Box2DAS.Dynamics.ContactEvent;
	import com.monsterPatties.events.CaveSmashEvent;
	import com.monsterPatties.utils.eventSatellite.EventSatellite;
	import components.blocks.BlockConfig;
	import wck.*;
	
	public class BouncyMushroom extends BodyShape {		
	
		/*------------------------------------------------------------------Constant----------------------------------------------------------------------*/		
		/*------------------------------------------------------------------Properties--------------------------------------------------------------------*/
		public var contacts:ContactList;
		public var blockType:String = BlockConfig.BOUNCY;		
		private var _caveSmashEvent:CaveSmashEvent;
		private var _es:EventSatellite;
		private var hasRemoved:Boolean;
		/*------------------------------------------------------------------Constructor----------------------------------------------------------------------*/		
		public override function shapes():void{
		}
		
		override public function create():void 
		{
			super.create();
			
			type = "Static";
			applyGravity = false;
			fixedRotation = true;
			
			listenWhileVisible(this, ContactEvent.BEGIN_CONTACT, handleContact);
			listenWhileVisible(this, ContactEvent.END_CONTACT, endContact);
			contacts = new ContactList();
			contacts.listenTo(this);
			
			//if ( GameConfig.showCollider ){
				//this.collider.alpha = 1;
			//}
			
			addGameEvent();
		}
		/*------------------------------------------------------------------Methods----------------------------------------------------------------------*/
		private function clearAll():void
		{			
			removeAllListeners();
			removeControllers();
			removeGameEvent();
			//this.remove();
			//destroy();
			//trace( "[NormalBlock]:ClearALl........................ " );
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
			trace( "[NormalBlock]:add GameEvent........................ " );
		}	
		
		private function removeGameEvent():void 
		{
			_es = EventSatellite.getInstance();
			_es.removeEventListener( CaveSmashEvent.LEVEL_STARTED, onLevelStarted );
			_es.removeEventListener( CaveSmashEvent.LEVEL_QUIT, OnLevelQuit );
			_es.removeEventListener( CaveSmashEvent.LEVEL_COMPLETE, onLevelComplete );			
			_es.removeEventListener( CaveSmashEvent.LEVEL_FAILED, onLevelFailed );
			_es.removeEventListener( CaveSmashEvent.RELOAD_LEVEL, onReloadLevel );
			trace( "[NormalBlock]:remove GameEvent........................ " );
		}
		
		private function animate():void 
		{
			this.mc.gotoAndPlay( "animate" );
			this.mc.addFrameScript( this.mc.totalFrames  * 0.5, onPlaySFX );			
		}
		
		private function onPlaySFX():void 
		{
			_caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.BOUNCE_MUSHROOM );
			_es.dispatchESEvent( _caveSmashEvent );
		}
		
		private function removeME():void 
		{
			if( !hasRemoved  ){
				hasRemoved = true;
				this.remove();
				while (this.numChildren > 0){
					this.removeChildAt(0);
				}
				//trace( "ItemCrystal clear via reloader level!!!!!!!!!!!!!!!!!!!!" );
			}
		}
		/*------------------------------------------------------------------Setters----------------------------------------------------------------------*/
		
		/*------------------------------------------------------------------Getters----------------------------------------------------------------------*/
		
		/*------------------------------------------------------------------EventHandlers----------------------------------------------------------------*/
		public function endContact(e:ContactEvent):void {
			trace( "[ MoveableBlock ]: end contact with: === >" + e.other.GetBody().GetUserData() );
		}
		public function handleContact(e:ContactEvent):void {
			if ( this != null ){
				if( e.other.GetBody().m_userData is Player ){
					animate();
				}			
			}
			//trace( "[ MoveableBlock ]: begin contact with: === >" + e.other.GetBody().GetUserData() );			
		}
		
		private function onLevelFailed(e:CaveSmashEvent):void 
		{			
			clearAll();
			//trace( "[NormalBlock]: on level failed" );
		}
		
		private function onLevelComplete(e:CaveSmashEvent):void 
		{			
			clearAll();			
			//trace( "[NormalBlock]: onLevelComplete............................" );
		}
		
		private function onLevelStarted(e:CaveSmashEvent):void 
		{
			initControllers();
			//trace( "[NormalBlock]: onLevelStarted............................" );
		}
		
		private function OnLevelQuit(e:CaveSmashEvent):void 
		{
			clearAll();
			removeME();
		}
		
		private function onReloadLevel(e:CaveSmashEvent):void 
		{
			clearAll();
			removeME();
		}
	}
}