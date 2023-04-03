package components.interactive 
{
	import Box2DAS.Dynamics.ContactEvent;
	import com.monsterPatties.controllers.GameDataController;
	import com.monsterPatties.utils.Helper;
	import components.base.StaticItemBase;
	import components.items.ItemConfig;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;
	/**
	 * ...
	 * @author jc
	 */
	public class InGameMessage extends StaticItemBase
	{
		
		private var _gdc:GameDataController;
		private var txtMessage:TextField;
		public var msg:String = "";
		private var gameHelpMC:GameHelpMC;
		public var id:int;
		
		public function InGameMessage() 
		{
			super();	
		}
		
		override public function shapes():void 
		{
			super.shapes();
			box();
			isSensor = true;
			itemType = ItemConfig.IN_GAME_MESSAGE;
		}
		
		override public function create():void 
		{
			super.create();			
			addTxtMessage();
		}
		
		private function addTxtMessage():void 
		{
			_gdc = GameDataController.getInstance();
			var level:int = _gdc.getCurrLevel();			
			
			if (gameHelpMC ==null) {
				gameHelpMC = new GameHelpMC();
				addChild(gameHelpMC);
				gameHelpMC.x -= 100;
				gameHelpMC.y -= 50;
			}
			
			if( msg == "" ){
				switch ( level ) 
				{
					case 1:
						//msg = "Left Arrow key to move left \n Right Arrow key to move right \n Up Arrow key - to jump";
						//msg = "Press the Left and Right Arrow Keys \nto move. \nUp Arrow Key to jump.";
						gameHelpMC.gotoAndStop(1);
					break;
					
					case 2:
						//msg = "monster will always block your way \n you can strike them by pressing \"Z\"";
						//msg = "Look Out! Monsters are \nblocking the way! \nPress \"Z\" to attack them.";
						gameHelpMC.gotoAndStop(2);
					break;
					
					case 3:
						//msg = "mud blocks are breakable \n Press \"Z\" to break them.";
						//msg = "Attack mudblocks to break them.";
						gameHelpMC.gotoAndStop(3);
					break;				
					
					case 4:
						//msg = "Hi there adventurer if you need\n something just drop by to my shop.\n press \"P\" then select shop";
						//msg = "Hello adventurer. Drop by the shop if \nyou need anything. Press \"P\" to go to \nthe shop.";
						gameHelpMC.gotoAndStop(4);
					break;
					
					case 5:
						//msg = " \"Blue Block\" is moveable \n try push  or smash it left or right.";
						//msg = "Attack the \"Blue Block\" \nto move it left or right.";
						gameHelpMC.gotoAndStop(5);
					break;					
					
					case 7:
						//msg = " \"Bouncy Mushroom\" can help you \n jump over high places. go try it.";					
						//msg = "Jump on the \"Bouncy Mushroom\" \nto reach high places. \nGo on, try it!";
						gameHelpMC.gotoAndStop(6);
					break;
					
					case 8:
						//msg = "wait for the moving platform!";					
					break;					
					
					default:
				}			
			}
			
			
			switch (id) 
			{				
				case 7:
					gameHelpMC.gotoAndStop(4);
				break;
				
				case 8:
					gameHelpMC.gotoAndStop(8);
				break;
				
				case 9:
					gameHelpMC.gotoAndStop(9);
				break;
				
				case 10:
					gameHelpMC.gotoAndStop(10);
				break;
				
				case 11:
					gameHelpMC.gotoAndStop(11);
				break;
				
				case 12:
					gameHelpMC.gotoAndStop(12);
				break;
				
				default:
			}
			
			/*if( txtMessage == null ){
				txtMessage = Helper.createTextField(msg, 25, 300, 110,0xFF0000, "JasmineUPC", TextFormatAlign.CENTER, false, true );
				addChild( txtMessage );
				txtMessage.x = -( txtMessage.width  / 2 );			
				txtMessage.y = -( txtMessage.height  / 2 );
			}*/
		}
		
		override public function clearAll():void 
		{
			super.clearAll();
			removeTxtMessage();
		}
		
		
		private function removeTxtMessage():void 
		{
			if ( txtMessage !=null ) {
				if ( this.contains( txtMessage ) ) {
					this.removeChild( txtMessage );
					txtMessage = null;
				}
			}
		}
		
		override public function handleContact(e:ContactEvent):void 
		{
			super.handleContact(e);
			//trace( "[ InGameMessage ]: contact with: === >" + e.other.GetBody().GetUserData() );
		}
		
		override public function endContact(e:ContactEvent):void 
		{
			super.endContact(e);
			//removeTxtMessage();
			//trace( "[ InGameMessage ]: end contact with: === >" + e.other.GetBody().GetUserData() );
		}
		
	}

}