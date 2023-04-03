package components.blocks {	
	
	import com.monsterPatties.config.GameConfig;
	import misc.Util;
	import wck.*;
	
	public class SilverBlock extends BodyShape {		
	
		/*------------------------------------------------------------------Constant----------------------------------------------------------------------*/		
		/*------------------------------------------------------------------Properties--------------------------------------------------------------------*/
		public var blockType:String = BlockConfig.SILVER;		
		/*------------------------------------------------------------------Constructor----------------------------------------------------------------------*/		
		public override function shapes():void {
			type = "Static";
			//type = "Dynamic";
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
			Util.addChildAtPosOf(world, new ItemSilverMC(), this );			
			this.remove();			
		}		
		/*------------------------------------------------------------------Setters----------------------------------------------------------------------*/
		
		/*------------------------------------------------------------------Getters----------------------------------------------------------------------*/
		
		/*------------------------------------------------------------------EventHandlers----------------------------------------------------------------*/
		
	}
}