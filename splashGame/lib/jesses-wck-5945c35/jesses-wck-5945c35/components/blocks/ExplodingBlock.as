package components.blocks 
{
	import Box2DAS.Dynamics.ContactEvent;
	import com.greensock.TweenLite;
	import com.monsterPatties.config.SoundConfig;
	import com.monsterPatties.events.CaveSmashEvent;
	import components.players.Player2;
	import flash.events.Event;
	import flash.geom.Point;
	/**
	 * ...
	 * @author ...
	 */
	public class ExplodingBlock extends BlockBase
	{
		private var _caveSmashEvent:CaveSmashEvent;
		
		public function ExplodingBlock(){
			super();
		}
		
		override public function create():void{
			super.create();
			blockType = BlockConfig.EXPLODING;
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
			if ( !_isDestroyed && this != null ){
				_isDestroyed  = true;
				this.mc.gotoAndPlay( "animate" );				
				this.mc.addFrameScript( this.mc.totalFrames - 1, onEndAnimation );				
				this.mc.addFrameScript( this.mc.totalFrames * 0.5, onCheckIfHitPlayer );
			}
		}
		
		private function playSFX():void{
			_caveSmashEvent = new CaveSmashEvent( CaveSmashEvent.PLAY_SFX );
			_caveSmashEvent.obj.id = SoundConfig.EXPLOSION_SFX;
			_es.dispatchESEvent( _caveSmashEvent );
		}
		
		private function onCheckIfHitPlayer():void{
			playSFX()
			this.mc.addFrameScript( this.mc.totalFrames * 0.5, null );
			checkIfHitPlayer();
		}		
		
		private function onEndAnimation():void{			
			if ( this != null ){
				this.mc.addFrameScript( this.mc.totalFrames - 1, null );
				cleanMe();
			}
		}
		
		
		private function cleanMe():void{			
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
			if ( e.other.GetBody().m_userData is Player2 ){
				_target = null;
			}
		}
		
		override public function handleContact(e:ContactEvent):void{
			super.handleContact(e);
			if ( e.other.GetBody().m_userData is Player2 ) {
				_target = e.other.GetBody().m_userData;
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