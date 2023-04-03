package components.levels.doors 
{
	import Box2DAS.Dynamics.ContactEvent;
	import com.monsterPatties.config.GameConfig;
	import com.monsterPatties.controllers.GameDataController;
	import com.monsterPatties.events.CaveSmashEvent;
	import components.levels.Door;
	import flash.events.Event;
	import flash.geom.Point;
	/**
	 * ...
	 * @author jc
	 */
	public class NormalDoor extends Door
	{
		private var _caveSmashEvent:CaveSmashEvent;
		private var _gdc:GameDataController;
		
		public function NormalDoor() 
		{
			super();
			
			if ( GameConfig.showCollider ){
				this.collider.alpha = 1;
			}
		}
		
		
		//optimization i think if turning visible false it really decreased the consumption on process
		private function checkForVisible():void
		{
			if( this != null || !isGameCompleted ){
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
		
		override public function initControllers():void 
		{
			super.initControllers();
			
			_gdc = GameDataController.getInstance();
		}
		
		
		override public function handleContact(e:ContactEvent):void 
		{
			super.handleContact(e);
			
			trace( "[Normal Door]: " + e.other.GetBody().GetUserData() );
			
			if ( e.other.GetBody().GetUserData() is Player && !isGameCompleted  ) {
				isGameCompleted = true;
				removeAllListeners();
				
				var level:int = _gdc.getCurrLevel();
				var map:int = _gdc.getCurrentMap( ) + 1;
				
				_gdc.updateCurrentSubLevel( 1 );
				var subCurrentLevel:int = _gdc.getCurrentSubLevel( );
				
				
				if ( map == 1 ) {
					if ( level == 1 ){
						if ( subCurrentLevel == 1 ){
							_gdc.setCurrLevel( 2 );
						}else if ( subCurrentLevel == 2 ){
							_gdc.setCurrLevel( 3 );
						}else if ( subCurrentLevel == 3 ) {
							_gdc.setCurrLevel( 4 );
						}
					}else if ( level == 2 ){
						if ( subCurrentLevel == 1 ){
							_gdc.setCurrLevel( 2 );
						}else if ( subCurrentLevel == 2 ){
							_gdc.setCurrLevel( 3 );
						}else if ( subCurrentLevel == 3 ) {
							_gdc.setCurrLevel( 4 );
						}
					}else if ( level == 3 ) {
						if ( subCurrentLevel == 1 ){
							_gdc.setCurrLevel( 2 );
						}else if ( subCurrentLevel == 2 ){
							_gdc.setCurrLevel( 3 );
						}else if ( subCurrentLevel == 3 ) {
							_gdc.setCurrLevel( 4 );
						}
					}	
				}else if ( map == 2 ) {
					if ( level == 11 ){
						if ( subCurrentLevel == 1 ){
							_gdc.setCurrLevel( 1 );
						}else if ( subCurrentLevel == 2 ){
							_gdc.setCurrLevel( 2 );
						}else if ( subCurrentLevel == 3 ) {
							_gdc.setCurrLevel( 3 );
						}
					}else if ( level == 12 ) {
						if ( subCurrentLevel == 1 ){
							_gdc.setCurrLevel( 1 );
						}else if ( subCurrentLevel == 2 ){
							_gdc.setCurrLevel( 2 );
						}else if ( subCurrentLevel == 3 ) {
							_gdc.setCurrLevel( 3 );
						}
					}
				}
				
				
				_caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.LEVEL_COMPLETE );
				es.dispatchESEvent( _caveSmashEvent );
			}			
		}
		
		override public function parseInput(e:Event):void 
		{
			super.parseInput(e);
			checkForVisible();
		}		
	}
}