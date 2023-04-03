package components.items 
{
	import Box2DAS.Dynamics.ContactEvent;
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
	public class TreasureBox extends BodyShape {	
		
		/*----------------------------------------------------------------------Constants-------------------------------------------------------------*/
		public static const LABEL_COLLECT:String = "collect";
		/*----------------------------------------------------------------------Properties-------------------------------------------------------------*/
		private var _isCollected:Boolean = false;
		public var itemType:String = ItemConfig.TREASURE_BOX;		
		public var contacts:ContactList;
		
		//cavesmash events
		private var _es:EventSatellite;
		private var _caveSmashEvent:CaveSmashEvent;
		private var hasRemoved:Boolean;
		/*----------------------------------------------------------------------Constructor-------------------------------------------------------------*/
		public override function shapes():void {					
		}
		
		override public function create():void 
		{
			super.create();
			initControllers();
			type = "Dynamic";			
			listenWhileVisible(this, ContactEvent.BEGIN_CONTACT, handleContact);
			listenWhileVisible(this, ContactEvent.END_CONTACT, endContact);
			contacts = new ContactList();
			contacts.listenTo(this);
			addGameEvent();			
		}
		
		private function goStatic():void 
		{			
			type = "Static";
			applyGravity = false;
			this.collider.isSensor = true;			
		}
		
		/*----------------------------------------------------------------------Methods-------------------------------------------------------------*/
		public function collect():void 
		{			
			if ( !_isCollected && this.mc.currentFrameLabel != LABEL_COLLECT && this.mc != null && this.collider != null ) {
				goStatic();
				this.mc.addFrameScript( this.mc.totalFrames - 2, onEndAnimation );
				this.mc.gotoAndPlay( LABEL_COLLECT );
				_isCollected = true;
			}
		}
		
		private function onEndAnimation():void 
		{
			if ( this != null ) {
				this.mc.addFrameScript( this.mc.totalFrames - 2, null );
				trace( "[TreasureBox]: Opened!!!!" );				
				this.collider.isSensor = true;
				Util.addChildAtPosOf(world, new ItemGold(), this );				
			}
		}
		
		private function clearAll():void
		{			
			removeAllListeners();
			removeControllers();
			removeGameEvent();
			//this.remove();
			//destroy();			
		}
		
		private function initControllers():void 
		{
			_es = EventSatellite.getInstance();
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
		
		/*----------------------------------------------------------------------Setters-------------------------------------------------------------*/
		public function set isCollected(value:Boolean):void 
		{
			_isCollected = value;
		}
		/*----------------------------------------------------------------------Getters-------------------------------------------------------------*/
		public function get isCollected():Boolean 
		{
			return _isCollected;
		}
		/*----------------------------------------------------------------------Events-------------------------------------------------------------*/
		
		public function endContact(e:ContactEvent):void {
			if( this != null ){
				trace( "[ TreasureBox ]: end contact with: === >" + e.other.GetBody().GetUserData() );				
			}
		}
		public function handleContact(e:ContactEvent):void {			
			if ( this != null ) {
				trace( "[ TreasureBox ]: begin contact with: === >" + e.other.GetBody().GetUserData() );
				if ( e.other.GetBody().GetUserData() is Player2 ) {										
					collect();
				}
			}
		}
		
		private function onLevelFailed(e:CaveSmashEvent):void 
		{			
			clearAll();			
		}
		
		private function onLevelComplete(e:CaveSmashEvent):void 
		{			
			clearAll();
		}
		
		private function onLevelStarted(e:CaveSmashEvent):void 
		{
			initControllers();			
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