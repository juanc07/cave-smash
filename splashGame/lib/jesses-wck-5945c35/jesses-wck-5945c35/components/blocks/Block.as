package components.blocks {	
	
	import com.monsterPatties.config.GameConfig;
	import components.items.ItemGold;
	import misc.Util;
	import wck.*;
	
	public class Block extends BodyShape {		
	
		/*------------------------------------------------------------------Constant----------------------------------------------------------------------*/		
		/*------------------------------------------------------------------Properties--------------------------------------------------------------------*/
		public var blockType:String = "";		
		/*------------------------------------------------------------------Constructor----------------------------------------------------------------------*/		
		public override function shapes():void {
			type = "Static";			
			setRandomSkin();			
			if ( GameConfig.showCollider ){
				this.collider.alpha = 1;
			}
		}		
		/*------------------------------------------------------------------Methods----------------------------------------------------------------------*/
		public function animate():void 
		{
			this.mc.gotoAndPlay( "shake" );
			this.mc.addFrameScript( this.mc.totalFrames - 1, onEndAnimation );
		}
		
		private function onEndAnimation():void 
		{		
			if ( this.blockType == BlockConfig.GOLD ){
				Util.addChildAtPosOf(world, new ItemGold(), this );
			}else if( this.blockType == BlockConfig.NORMAL ){
				Util.addChildAtPosOf(world, new FX1(), this );
			}
			
			if ( this.blockType != BlockConfig.UN_BREAKABLE ){				
				this.remove();
			}
		}
		
		private function setRandomSkin():void 
		{
			var rnd:int = ( Math.random() * this.totalFrames ) + 1;
			this.gotoAndStop( rnd );
			blockType = this.currentFrameLabel;
		}
		/*------------------------------------------------------------------Setters----------------------------------------------------------------------*/
		
		/*------------------------------------------------------------------Getters----------------------------------------------------------------------*/
		
		/*------------------------------------------------------------------EventHandlers----------------------------------------------------------------*/
		
	}
}