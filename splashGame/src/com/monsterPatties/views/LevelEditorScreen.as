package com.monsterPatties.views 
{	
	import Box2DAS.Common.b2Base;
	import com.monsterPatties.controllers.GameKeyInput;
	import com.monsterPatties.events.GameEvent;
	import com.monsterPatties.utils.buttonManager.ButtonManager;
	import com.monsterPatties.utils.buttonManager.events.ButtonEvent;
	import com.monsterPatties.utils.displayManager.config.DisplayManagerConfig;
	import com.monsterPatties.utils.displayManager.DisplayManager;
	import com.monsterPatties.utils.displayManager.Window;
	import com.monsterPatties.utils.eventSatellite.EventSatellite;
	import components.MyWorld;
	import components.players.Player2;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import misc.Input;
	import misc.Util;
	/**
	 * ...
	 * @author jc
	 */
	public class LevelEditorScreen extends Window
	{
		/*----------------------------------------------------------Constant---------------------------------------------------------------*/
		
		/*----------------------------------------------------------Properties---------------------------------------------------------------*/				
		private var _mc:TitleScreenMC;
		private var _bm:ButtonManager;
		private var _dm:DisplayManager;
		private var _levelEditor:LevelEditorMenuUIMC;
		private var _world:MyWorld;
		private var hero:MonsterMC;
		private var _worldHolder:Sprite;
		private var _isMoveWorldOn:Boolean;
		private var _keyInput:GameKeyInput;		
		
		
		private var _es:EventSatellite;
		
		private var _grassPlatformSmallplatformSet:Vector.<grassPlatformSmallMC>;
		/*----------------------------------------------------------Constructor---------------------------------------------------------------*/
		public function LevelEditorScreen( windowName:String, winWidth:Number = 0, winHeight:Number = 0 , hideWindowName:Boolean = false ) 
		{			
			super( windowName , winWidth, winHeight );
		}		
		
		/*----------------------------------------------------------Methods---------------------------------------------------------------*/
		private function setDisplay():void 
		{	
			addWorld();
			
			stage.stageHeight = 3000;
			stage.stageWidth = 3000;
			
			_levelEditor = new LevelEditorMenuUIMC();
			addChild( _levelEditor );
			
			_bm = new ButtonManager();			
			_bm.addBtnListener( _levelEditor.floorBtn );
			_bm.addBtnListener( _levelEditor.vPlatformBtn );
			_bm.addBtnListener( _levelEditor.hPlatformBtn );
			_bm.addBtnListener( _levelEditor.heroBtn );
			_bm.addBtnListener( _levelEditor.generateXMLBtn );
			
			_bm.addBtnListener( _levelEditor.item1Btn );
			_bm.addBtnListener( _levelEditor.item2Btn );
			_bm.addBtnListener( _levelEditor.item3Btn );
			_bm.addBtnListener( _levelEditor.item4Btn );
			_bm.addBtnListener( _levelEditor.item5Btn );
			_bm.addBtnListener( _levelEditor.item6Btn );
			_bm.addBtnListener( _levelEditor.item7Btn );
			_bm.addBtnListener( _levelEditor.item8Btn );
			_bm.addBtnListener( _levelEditor.item9Btn );
			_bm.addBtnListener( _levelEditor.item10Btn );
			
			_bm.addEventListener( ButtonEvent.CLICK_BUTTON, onClickBtn );
			_bm.addEventListener( ButtonEvent.ROLL_OVER_BUTTON, onRollOverBtn );
			_bm.addEventListener( ButtonEvent.ROLL_OUT_BUTTON, onRollOutBtn );
			
			/*
			_mc = new TitleScreenMC();
			addChild( _mc );
			_mc.x = -182;
			_mc.y = -56;		
			*/
			
			addKeyboardSetup();
		}
		
		private function addKeyboardSetup():void 
		{
			_keyInput = GameKeyInput.getIntance();
			_keyInput.initKeyboardListener( stage );
			
			_es = EventSatellite.getInstance();
			_es.addEventListener(GameEvent.PRESS_WHAT, onPressKeyboard);		
		}	
		
		private function removeKeyboardSetup():void 
		{
			_keyInput.clearKeyboardListener();
		}
		
		private function addWorld():void 
		{
			_worldHolder = new Sprite();
			_worldHolder.graphics.lineStyle( 1, 0xFF0000 );
			_worldHolder.graphics.beginFill( 0x000000 );
			_worldHolder.graphics.drawRect( 0 , 0, 3000, 3000 );		
			this.addChild( _worldHolder );
			
			_world = new MyWorld();
			_world.allowSleep  = true;
			_world.gravityX = 0;
			_world.gravityY = 10;
			_world.positionIterations = 15;
			_world.scale = 60;
			_world.timeStep = 0.05;
			_world.velocityIterations = 15;
			_world.scrolling = true;
			_world.orientToGravity = false;
			_world.paused = false;
			_world.mouseNudgeX = 0;
			_world.mouseNudgeY = 0;
			_world.allowDragging = false;
			_world.debugDraw = false;
			_world.disabled = false;
			_worldHolder.addChild( _world );
			
			b2Base.initialize();
			Input.initialize(stage);
		}		
		
		private function removeDisplay():void 
		{			
			if ( _levelEditor != null ) {
				removeKeyboardSetup();				
				_bm.removeBtnListener( _levelEditor.floorBtn );
				_bm.removeBtnListener( _levelEditor.vPlatformBtn );
				_bm.removeBtnListener( _levelEditor.hPlatformBtn );
				_bm.removeBtnListener( _levelEditor.heroBtn );
				_bm.removeBtnListener( _levelEditor.generateXMLBtn );
				
				_bm.removeBtnListener( _levelEditor.item1Btn );
				_bm.removeBtnListener( _levelEditor.item2Btn );
				_bm.removeBtnListener( _levelEditor.item3Btn );
				_bm.removeBtnListener( _levelEditor.item4Btn );
				_bm.removeBtnListener( _levelEditor.item5Btn );
				_bm.removeBtnListener( _levelEditor.item6Btn );
				_bm.removeBtnListener( _levelEditor.item7Btn );
				_bm.removeBtnListener( _levelEditor.item8Btn );
				_bm.removeBtnListener( _levelEditor.item9Btn );
				_bm.removeBtnListener( _levelEditor.item10Btn );
				
				_bm.removeEventListener( ButtonEvent.CLICK_BUTTON, onClickBtn );
				_bm.removeEventListener( ButtonEvent.ROLL_OVER_BUTTON, onRollOverBtn );
				_bm.removeEventListener( ButtonEvent.ROLL_OUT_BUTTON, onRollOutBtn );
				_bm.clearButtons();
				_bm = null;	
				
				if ( this.contains( _levelEditor ) ) {
					this.removeChild( _levelEditor );
					_mc = null;
				}
			}			
		}
		
		override public function initWindow():void 
		{
			super.initWindow();
			initControllers();
			setDisplay(  );				
			trace( windowName + " init!!" );
		}
		
		override public function clearWindow():void 
		{			
			super.clearWindow();			
			removeDisplay();
			trace( windowName + " destroyed!!" );
		}
		
		private function initControllers():void 
		{
			_dm = DisplayManager.getInstance();
		}        
        
		
		private function createHero():void 
		{
			hero = new MonsterMC();
			hero.type = "Dynamic";
			hero.active = true;
			hero.allowDragging = false;
			hero.angularDamping = 0;
			hero.applyGravity = true;
			hero.autoSleep = true;
			hero.awake = true;
			hero.bubbleContacts = true;
			hero.bullet = false;
			hero.density = 1;
			hero.disabled = false;
			hero.conveyorBeltSpeed = 0;
			hero.customGravityName = '';
			hero.fixedRotation = false;
			hero.friction = 0.2;
			hero.gravityAngle = 0;
			hero.gravityMod = false;
			hero.gravityScale = 1;
			hero.groupIndex = 0;
			hero.inertiaScale = 1;
			hero.isGround = false;
			hero.isGuideShape = false;
			hero.isGuideShape = false;
			hero.isSensor = false;
			hero.linearDamping = 1000;
			hero.linearVelocityX = 0;
			hero.linearVelocityY = 0;
			hero.maskBits = 0xFFFF;
			hero.regions = '';
			hero.reportBeginContact = true;
			hero.reportEndContact = true;
			hero.reportPostSolve = false;
			hero.reportPreSolve = false;
			hero.restitution = 0;
			hero.name = "player";
			
			Util.addChildAtPosOf( _world, hero, this, -1, new Point( 300 , 450 ) );
			hero.addEventListener( MouseEvent.MOUSE_DOWN, onDragHero );
			hero.addEventListener( MouseEvent.MOUSE_UP, onDropHero );
			
			
			_world.focusOn = "player";
		}	
		
		private function onDropHero(e:MouseEvent):void 
		{
			hero.stopDrag();
		}
		
		private function onDragHero(e:MouseEvent):void 
		{
			hero.startDrag();
		}
		
		private function createPlatform():void 
		{
			if (  _grassPlatformSmallplatformSet == null ) {
				_grassPlatformSmallplatformSet = new Vector.<grassPlatformSmallMC>();
			}
			
			var platform:grassPlatformSmallMC = new grassPlatformSmallMC();			
			Util.addChildAtPosOf( _world, platform, this, -1, new Point( 100 , 450 ) );			
			platform.addEventListener( MouseEvent.MOUSE_DOWN, onDragPlatform );
			platform.addEventListener( MouseEvent.MOUSE_UP, onDropPlatform );			
			trace( " _world child #: " + _world.numChildren );
			_grassPlatformSmallplatformSet.push( platform );
			
		}		
		
		private function moveWorldOn():void 
		{			
			_worldHolder.addEventListener( MouseEvent.MOUSE_DOWN, onDragWorld );
			_worldHolder.addEventListener( MouseEvent.MOUSE_UP, onDropWorld );
		}
		
		private function moveWorldOff():void 
		{
			_worldHolder.removeEventListener( MouseEvent.MOUSE_DOWN, onDragWorld );
			_worldHolder.removeEventListener( MouseEvent.MOUSE_UP, onDropWorld );
		}
		
		/*----------------------------------------------------------Setters---------------------------------------------------------------*/
		
		/*----------------------------------------------------------Getters---------------------------------------------------------------*/		
		
		
		/*----------------------------------------------------------EventHandlers---------------------------------------------------------------*/		
		
		
		private function onRollOutBtn(e:ButtonEvent):void 
		{
			var btnName:String = e.obj.name;
			
			switch ( btnName ) 
			{                  
				case "floorBtn":
					_levelEditor.floorBtn.gotoAndStop( 1 );
				break;
                
				case "vPlatformBtn":
					_levelEditor.vPlatformBtn.gotoAndStop( 1 );
				break;
				
				case "hPlatformBtn":
					_levelEditor.hPlatformBtn.gotoAndStop( 1 );
				break;
				
				case "heroBtn":
					_levelEditor.heroBtn.gotoAndStop( 1 );
				break;
				
				case "item1Btn":
					_levelEditor.item1Btn.gotoAndStop( 1 );
				break;
				
				case "item2Btn":
					_levelEditor.item2Btn.gotoAndStop( 1 );
				break;
				
				default:
				break;
			}
		}
		
		private function onRollOverBtn(e:ButtonEvent):void 
		{
			var btnName:String = e.obj.name;
			
			switch ( btnName ) 
			{                  
				case "floorBtn":
					_levelEditor.floorBtn.gotoAndStop( 2 );
				break;
                
				case "vPlatformBtn":
					_levelEditor.vPlatformBtn.gotoAndStop( 2 );
				break;
				
				case "hPlatformBtn":
					_levelEditor.hPlatformBtn.gotoAndStop( 2 );
				break;
				
				case "heroBtn":
					_levelEditor.heroBtn.gotoAndStop( 2 );
				break;
				
				case "item1Btn":
					_levelEditor.item1Btn.gotoAndStop( 2 );
				break;
				
				case "item2Btn":
					_levelEditor.item2Btn.gotoAndStop( 2 );
				break;
				
				default:
				break;
			}
		}
		
		private function onClickBtn(e:ButtonEvent):void 
		{			
			var btnName:String = e.obj.name;
			
			switch ( btnName ) 
			{                  
				case "floorBtn":					
					_levelEditor.floorBtn.gotoAndStop( 3 );
				break;
                
				case "vPlatformBtn":
					_levelEditor.vPlatformBtn.gotoAndStop( 3 );
				break;
				
				case "hPlatformBtn":
					createPlatform();
					_levelEditor.hPlatformBtn.gotoAndStop( 3 );
				break;
				
				case "heroBtn":
					_levelEditor.heroBtn.gotoAndStop( 3 );
					createHero();
				break;
				
				case "generateXMLBtn":
					_levelEditor.generateXMLBtn.gotoAndStop( 3 );
					genXML();
				break;			
				
				case "item1Btn":
					_levelEditor.item1Btn.gotoAndStop( 3 );
				break;
				
				case "item2Btn":
					_levelEditor.item2Btn.gotoAndStop( 3 );
				break;
				
				default:
				break;
			}
		}
		
		private function genXML():void 
		{
			
		}
		
		private function onDropWorld(e:MouseEvent):void
		{
			_worldHolder.stopDrag();
		}
		
		private function onDragWorld(e:MouseEvent):void 
		{
			_worldHolder.startDrag();
		}
		
		private function onPressKeyboard(e:GameEvent):void 
		{
			var key:String = e.obj.key;
			
			switch ( key ) 
			{
				case "=+":
					_worldHolder.scaleX += .05; 
					_worldHolder.scaleY += .05; 
				break;
				
				case "-_":
					_worldHolder.scaleX -= .05;
					_worldHolder.scaleY -= .05;
				break;
				
				case "H":
					if ( !_isMoveWorldOn ) {
						_isMoveWorldOn = true;
						moveWorldOn();
					}else {
						moveWorldOff();
						_isMoveWorldOn = false;
					}
				break;
				
				default:
			}
		}
		
		private function onDropPlatform(e:MouseEvent):void 
		{
			//e.target.stopDrag();
			e.currentTarget.stopDrag();
			//platform.stopDrag();
			trace( " platfrom position: " + e.currentTarget.b2body.GetPosition() + " p2 x: " + e.currentTarget.x + " y: " + e.currentTarget.y );
		}
		
		private function onDragPlatform(e:MouseEvent):void 
		{
			//e.target.startDrag();
			e.currentTarget.startDrag();
			//platform.startDrag();
		}
		
	}

}