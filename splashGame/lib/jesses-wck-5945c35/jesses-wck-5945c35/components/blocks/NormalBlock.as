package components.blocks
{
	import Box2DAS.Dynamics.ContactEvent;
	import com.greensock.TweenLite;
	import com.monsterPatties.config.CaveSmashConfig;
	import com.monsterPatties.events.CaveSmashEvent;
	import com.monsterPatties.utils.eventSatellite.EventSatellite;
	import components.players.Player2;
	import components.weapons.Hammer;
	import flash.events.Event;
	import flash.geom.Point;
	import misc.Util;
	/**
	 * ...
	 * @author ...
	 */
	public class NormalBlock extends BlockBase
	{
		
		private var _isCollected:Boolean = false;
		private var _caveSmashEvent:CaveSmashEvent;
		private var isFinishDrop:Boolean = false;
		
		public function NormalBlock(){
			super();
		}
		
		override public function create():void{
			super.create();
			blockType = BlockConfig.NORMAL;
		}
		
		//optimization i think if turning visible false it really decreased the consumption on process
		private function checkForVisible():void
		{
			if ( this != null && this.b2body != null && world != null && this.mc != null ){
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
		
		override public function animate():void{
			super.animate();
			if ( !_isCollected && this != null ) {
				_caveSmashEvent = new CaveSmashEvent(CaveSmashEvent.ON_CRACK_NORMAL_BLOCK);
				_es.dispatchESEvent( _caveSmashEvent );
				
				Util.addChildAtPosOf(world, new BlockExplodeMC(), this );
				_isCollected  = true;
				this.mc.gotoAndPlay( "shake" );
				this.mc.addFrameScript( this.mc.totalFrames - 3, dropItem );
				this.mc.addFrameScript( this.mc.totalFrames - 1, onEndAnimation );
			}
		}
		
		private function onCheckIfHitPlayer():void {
			this.mc.addFrameScript( this.mc.totalFrames * 0.5, null );
			checkIfHitPlayer();
		}
		
		private function onEndAnimation():void{
			if ( this != null ) {
				this.mc.addFrameScript( this.mc.totalFrames - 1, null );
				_es = EventSatellite.getInstance();
				_caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.DESTROY_BLOCK );
				_caveSmashEvent.obj.blockType = blockType;
				_caveSmashEvent.obj.score = CaveSmashConfig.BLOCK_SCORE;
				_es.dispatchESEvent( _caveSmashEvent );
				clearAll();
				removeME();
			}
		}
		
		private function  dropItem():void{
			if(this != null && !isFinishDrop ){
				this.mc.addFrameScript( this.mc.totalFrames - 3, null );
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
		
		
		private function cleanMe():void{
			if ( _levelIsDone ){
				return;
			}
			
			if ( this != null && _isCollected){
				_target = null;
				_isCollected = false;
				this.mc.gotoAndPlay( "idle" );
				this.mc.alpha = 0;
				TweenLite.to( this.mc, 0.5,{alpha:1});
			}
		}
		
		private function removeTweens():void{
			TweenLite.killTweensOf(this.mc);
		}
		
		override public function onLevelFailed(e:CaveSmashEvent):void{
			super.onLevelFailed(e);
			removeTweens();
		}
		
		override public function onLevelComplete(e:CaveSmashEvent):void{
			super.onLevelComplete(e);
			removeTweens();
		}
		
		override public function OnLevelQuit(e:CaveSmashEvent):void{
			super.OnLevelQuit(e);
			removeTweens();
		}
		
		override public function onLevelStarted(e:CaveSmashEvent):void{
			super.onLevelStarted(e);
			removeTweens();
		}
		
		override public function onReloadLevel(e:CaveSmashEvent):void{
			super.onReloadLevel(e);
			removeTweens();
		}
		
		override public function endContact(e:ContactEvent):void
		{
			super.endContact(e);
			if( e.other.GetBody().m_userData is BombMC ){
				var bomb:BombMC = e.other.GetBody().m_userData;
				if ( bomb.hasExplode) {
					animate();
				}
			}
		}
		
		override public function handleContact(e:ContactEvent):void
		{
			super.handleContact(e);
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
			}else if ( e.other.GetBody().m_userData is HammerMC ){
				animate();
			}
		}
		
		override public function parseInput(e:Event):void
		{
			super.parseInput(e);
			checkForVisible();
		}
	}

}