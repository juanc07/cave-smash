package components.blocks {	
	
	import Box2DAS.Dynamics.ContactEvent;
	import Box2DAS.Dynamics.StepEvent;
	import com.monsterPatties.config.CaveSmashConfig;
	import com.monsterPatties.events.CaveSmashEvent;
	import com.monsterPatties.utils.eventSatellite.EventSatellite;
	import components.items.ItemGold;
	import flash.events.Event;
	import flash.geom.Point;
	import misc.Util;
	import wck.*;
	
	public class NormalBlockOld extends BodyShape {		
	
		/*------------------------------------------------------------------Constant----------------------------------------------------------------------*/		
		/*------------------------------------------------------------------Properties--------------------------------------------------------------------*/
		public var contacts:ContactList;
		public var blockType:String = BlockConfig.NORMAL;
		private var _isCollected:Boolean = false;
		private var _caveSmashEvent:CaveSmashEvent;
		private var _es:EventSatellite;
		private var isFinishDrop:Boolean = false;
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
			listenWhileVisible(world, StepEvent.STEP, parseInput, false, 10);
			
			contacts = new ContactList();
			contacts.listenTo(this);		
			addGameEvent();			
		}
		/*------------------------------------------------------------------Methods----------------------------------------------------------------------*/
		public function animate():void 
		{	
			if ( !_isCollected && this != null ) {
				_caveSmashEvent = new CaveSmashEvent(CaveSmashEvent.ON_CRACK_NORMAL_BLOCK);
				_es.dispatchESEvent( _caveSmashEvent );
				
				Util.addChildAtPosOf(world, new BlockExplodeMC(), this );
				_isCollected  = true;
				this.mc.gotoAndPlay( "shake" );
				//_isSensor = true;
				this.mc.addFrameScript( this.mc.totalFrames - 3, dropItem );
				this.mc.addFrameScript( this.mc.totalFrames - 1, onEndAnimation );				
			}
		}
		
		private function  dropItem():void{
			if ( !isFinishDrop ) {
				isFinishDrop = true;
				var rnd:int = Math.random() * 100;
				if ( rnd >= 80 && rnd <= 90  ){					
					Util.addChildAtPosOf(world, new ItemGold(), this );
				}else if ( rnd >= 90 && rnd <= 100  ){					
					Util.addChildAtPosOf(world, new ItemHeartMC(), this );
				}else{
					Util.addChildAtPosOf(world, new FX1(), this );
				}
			}
		}
		
		private function onEndAnimation():void 
		{		
			if ( this != null ) {
				this.mc.addFrameScript( this.mc.totalFrames - 1, null );			
				_es = EventSatellite.getInstance();
				_caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.DESTROY_BLOCK );
				_caveSmashEvent.obj.blockType = blockType;
				_caveSmashEvent.obj.score = CaveSmashConfig.BLOCK_SCORE;
				_es.dispatchESEvent( _caveSmashEvent );				
				this.remove();			
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
			removeAllListeners();
			removeControllers();
			removeGameEvent();
			//this.remove();
			//destroy();			
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
			if( e.other.GetBody().m_userData is BombMC ){
				var bomb:BombMC = e.other.GetBody().m_userData;
				if ( bomb.hasExplode) {
					animate();
				}
			}
			trace( "[ Normal Block ]: end contact with: === >" + e.other.GetBody().GetUserData() );			
		}
		public function handleContact(e:ContactEvent):void {
			trace( "[ Normal Block ]: begin contact with: === >" + e.other.GetBody().GetUserData() );
			if ( e.other.GetBody().m_userData is Boss1MC ) {
				animate();
			}else if ( e.other.GetBody().m_userData is RunnerMC ) {
				animate();
			}else if ( e.other.GetBody().m_userData is BossBisonMC ) {
				animate();
			}else if ( e.other.GetBody().m_userData is TornadoMC ) {
				animate();
			}else if ( e.other.GetBody().m_userData is GroundSpikeMC ){
				animate();
			}
		}
		
		public function parseInput(e:Event):void{			
			if (!world  || this == null ) return;
			checkForVisible();
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