package components.levels {	
	
	import Box2DAS.Dynamics.ContactEvent;
	import Box2DAS.Dynamics.StepEvent;
	import com.monsterPatties.config.GameConfig;
	import com.monsterPatties.events.CaveSmashEvent;
	import com.monsterPatties.utils.eventSatellite.EventSatellite;
	import flash.events.Event;
	import flash.geom.Point;
	import wck.*;
	
	public class Divider extends BodyShape {		
	
		/*------------------------------------------------------------------Constant----------------------------------------------------------------------*/
		
		/*------------------------------------------------------------------Properties--------------------------------------------------------------------*/
		public var contacts:ContactList;		
		private var _es:EventSatellite;
		private var hasRemoved:Boolean;
		/*------------------------------------------------------------------Constructor----------------------------------------------------------------------*/
		
		public override function shapes():void{			
		}
		
		override public function create():void 
		{
			super.create();
			
			reportBeginContact = true;
			reportEndContact = true;
			fixedRotation = true;			
			density = 1;
			friction = 0.3;
			restitution = 0;
            type = "Static";			
			
			
			listenWhileVisible(this, ContactEvent.BEGIN_CONTACT, handleContact);
			listenWhileVisible(this, ContactEvent.END_CONTACT, endContact);
			listenWhileVisible(world, StepEvent.STEP, parseInput, false, 10);
			
			contacts = new ContactList();
			contacts.listenTo(this);			
			
			if ( GameConfig.showCollider ){
				this.collider.alpha = 1;
			}
			
			addGameEvent();
			//trace( "[Divider]:Create........................ " );
		}
		
		
		//optimization i think if turning visible false it really decreased the consumption on process
		private function checkForVisible():void 
		{
			if( this.mc != null && world.focus != null && world != null ){
				var newPos:Point = this.mc.localToGlobal( new Point( stage.x, stage.y ) )
				var newPos2:Point = world.focus.localToGlobal( new Point( stage.x, stage.y ) )
				
				var focusLeft:Number = newPos2.x - ( stage.stageWidth );
				var focusRight:Number = newPos2.x + ( stage.stageWidth );
				
				var focusUp:Number = newPos2.y - ( stage.stageHeight );
				var focusDown:Number = newPos2.y + ( stage.stageHeight );
				
				//trace( "[normalBlock]: this pos " + newPos.x );
				//trace( "[normalBlock]: focusleft: " + focusLeft );
				//trace( "[normalBlock]: focusRight: " + focusRight );
				
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
			_es.addEventListener( CaveSmashEvent.RELOAD_LEVEL, onReloadLevel );
			_es.addEventListener( CaveSmashEvent.LEVEL_QUIT, OnLevelQuit );
			//trace( "[Divider]:add GameEvent........................ " );
		}
		
		private function removeGameEvent():void 
		{			
			_es.removeEventListener( CaveSmashEvent.LEVEL_STARTED, onLevelStarted );
			_es.removeEventListener( CaveSmashEvent.LEVEL_COMPLETE, onLevelComplete );
			_es.removeEventListener( CaveSmashEvent.LEVEL_FAILED, onLevelFailed );
			_es.removeEventListener( CaveSmashEvent.RELOAD_LEVEL, onReloadLevel );
			_es.removeEventListener( CaveSmashEvent.LEVEL_QUIT, OnLevelQuit );
			//trace( "[Divider]:remove GameEvent........................ " );
		}		
		
		private function clearAll():void
		{			
			removeControllers();
			removeGameEvent();
			//this.remove();
			//destroy();
			//trace( "[Divider]:ClearALl........................ " );
		}
		
		private function removeME():void 
		{
			if( !hasRemoved  ){
				hasRemoved = true;
				this.remove();				
				while (this.numChildren > 0){
					this.removeChildAt(0);
				}
				//trace( "divider clear via reloader level!!!!!!!!!!!!!!!!!!!!" );
			}
		}
		/*------------------------------------------------------------------Methods----------------------------------------------------------------------*/
		
		/*------------------------------------------------------------------Setters----------------------------------------------------------------------*/
		
		/*------------------------------------------------------------------Getters----------------------------------------------------------------------*/
		
		/*------------------------------------------------------------------EventHandlers----------------------------------------------------------------*/		
		public function endContact(e:ContactEvent):void {
			//trace( "[ Divider ]: end contact with: === >" + e.other.GetBody().GetUserData() );						
		}
		public function handleContact(e:ContactEvent):void {
			//trace( "[ Divider ]: begin contact with: === >" + e.other.GetBody().GetUserData() );			
		}
		
		public function parseInput(e:Event):void{			
			if (!world  || this == null ) return;
			checkForVisible();
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
		
		private function onReloadLevel(e:CaveSmashEvent):void 
		{
			clearAll();
			removeME();
		}
		
		private function OnLevelQuit(e:CaveSmashEvent):void 
		{
			clearAll();
			removeME();
		}
	}
}