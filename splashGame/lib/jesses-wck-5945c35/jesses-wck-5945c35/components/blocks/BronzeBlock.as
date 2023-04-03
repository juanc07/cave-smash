package components.blocks {	
	
	import com.monsterPatties.config.GameConfig;
	import misc.Util;
	import wck.*;
	
	public class BronzeBlock extends BodyShape {		
	
		/*------------------------------------------------------------------Constant----------------------------------------------------------------------*/		
		/*------------------------------------------------------------------Properties--------------------------------------------------------------------*/
		public var blockType:String = BlockConfig.BRONZE;		
		/*------------------------------------------------------------------Constructor----------------------------------------------------------------------*/		
		public override function shapes():void {
			type = "Static";
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
			Util.addChildAtPosOf(world, new ItemBronzeMC(), this );			
			this.remove();			
		}		
		/*------------------------------------------------------------------Setters----------------------------------------------------------------------*/
		
		/*------------------------------------------------------------------Getters----------------------------------------------------------------------*/
		
		/*------------------------------------------------------------------EventHandlers----------------------------------------------------------------*/
		
	}
}