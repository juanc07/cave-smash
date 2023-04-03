package components.items 
{
	import Box2DAS.Dynamics.ContactEvent;
	import com.monsterPatties.config.CaveSmashConfig;
	import com.monsterPatties.config.GameConfig;
	import com.monsterPatties.events.CaveSmashEvent;
	import com.monsterPatties.utils.eventSatellite.EventSatellite;
	import components.players.Player2;
	import misc.Util;
	import wck.BodyShape;
	import wck.ContactList;
	/**
	 * ...
	 * @author jc
	 */
	public class ItemSilver extends BodyShape {	
		
		public static const LABEL_COLLECT:String = "collect";
		private var _isCollected:Boolean = false;
		public var itemType:String = ItemConfig.SILVER;		
		public var contacts:ContactList;
		
		//cavesmash events
		private var _es:EventSatellite;
		private var _caveSmashEvent:CaveSmashEvent;
		/*----------------------------------------------------------------------Constructor-------------------------------------------------------------*/
		
		public override function shapes():void {			
		}
		
		override public function create():void 
		{
			super.create();
			
			//type = "Dynamic";
			type = "Static";
			applyGravity = false;
			
			listenWhileVisible(this, ContactEvent.BEGIN_CONTACT, handleContact);
			listenWhileVisible(this, ContactEvent.END_CONTACT, endContact);
			contacts = new ContactList();
			contacts.listenTo(this);						
			
			if ( GameConfig.showCollider ){
				this.collider.alpha = 1;
			}
			
			addGameEvent();
		}
		
		public function collect():void 
		{			
			if ( !_isCollected && this.mc.currentFrameLabel != LABEL_COLLECT && this.mc != null && this.collider != null ) {			
				type = "Static";				
				this.collider.isSensor = true;
				Util.addChildAtPosOf(world, new FX1(), this );
				this.mc.addFrameScript( this.mc.totalFrames - 2, onEndAnimation );
				this.mc.gotoAndPlay( LABEL_COLLECT );
				_isCollected = true;
			}
		}
		
		private function onEndAnimation():void 
		{
			if ( this != null ) {
				this.mc.addFrameScript( this.mc.totalFrames - 2, null );
				_caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.PICK_UP_ITEM );
				_caveSmashEvent.obj.itemType = itemType;
				_caveSmashEvent.obj.score = CaveSmashConfig.ORE_SCORE;
				_es.dispatchESEvent( _caveSmashEvent );
				this.remove();
			}
		}
		
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
			_es.addEventListener( CaveSmashEvent.LEVEL_COMPLETE, onLevelComplete );			
			_es.addEventListener( CaveSmashEvent.LEVEL_FAILED, onLevelFailed );
			_es.addEventListener( CaveSmashEvent.RELOAD_LEVEL, onLevelFailed );
			trace( "[NormalBlock]:add GameEvent........................ " );
		}
		
		private function removeGameEvent():void 
		{
			_es = EventSatellite.getInstance();
			_es.removeEventListener( CaveSmashEvent.LEVEL_STARTED, onLevelStarted );
			_es.removeEventListener( CaveSmashEvent.LEVEL_COMPLETE, onLevelComplete );			
			_es.removeEventListener( CaveSmashEvent.LEVEL_FAILED, onLevelFailed );
			_es.removeEventListener( CaveSmashEvent.RELOAD_LEVEL, onLevelFailed );
			trace( "[NormalBlock]:remove GameEvent........................ " );
		}
		/*----------------------------------------------------------------------Events-------------------------------------------------------------*/
		
		public function endContact(e:ContactEvent):void {
			if( this != null ){
				trace( "[ Item ]: end contact with: === >" + e.other.GetBody().GetUserData() );			
				if ( e.other.GetBody().GetUserData() is Player2 ) {
					collect();
				}
			}
		}
		public function handleContact(e:ContactEvent):void {
			trace( "[ Item ]: begin contact with: === >" + e.other.GetBody().GetUserData() );
			if ( this != null ){
				if ( e.other.GetBody().GetUserData() is Player2 ) {
					collect();
				}
			}
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
	}

}