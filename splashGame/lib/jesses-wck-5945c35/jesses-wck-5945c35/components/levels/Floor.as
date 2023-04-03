package components.levels {	
	
	import Box2DAS.Dynamics.StepEvent;
	import com.monsterPatties.config.GameConfig;
	import com.monsterPatties.events.CaveSmashEvent;
	import com.monsterPatties.utils.eventSatellite.EventSatellite;
	import flash.events.Event;
	import flash.geom.Point;
	import wck.*;
	
	public class Floor extends BodyShape {		
	
		/*------------------------------------------------------------------Constant----------------------------------------------------------------------*/
		
		/*------------------------------------------------------------------Properties--------------------------------------------------------------------*/		
		public var contacts:ContactList;
		private var _caveSmashEvent:CaveSmashEvent;
		private var _es:EventSatellite;
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
			
			listenWhileVisible(world, StepEvent.STEP, parseInput, false, 10);
			
			contacts = new ContactList();
			contacts.listenTo(this);
			
			if ( GameConfig.showCollider ){
				this.collider.alpha = 1;
			}
			
			addGameEvent();
		}
		
		/*------------------------------------------------------------------Methods----------------------------------------------------------------------*/
		//optimization i think if turning visible false it really decreased the consumption on process
		private function checkForVisible():void 
		{
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
		
		
		private function clearAll():void
		{			
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
		/*------------------------------------------------------------------Setters----------------------------------------------------------------------*/
		
		/*------------------------------------------------------------------Getters----------------------------------------------------------------------*/
		
		/*------------------------------------------------------------------EventHandlers----------------------------------------------------------------*/				
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
	}
}