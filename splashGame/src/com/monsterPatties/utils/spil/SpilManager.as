package com.monsterPatties.utils.spil 
{
	import com.monsterPatties.controllers.GameDataController;
	import com.monsterPatties.events.GameEvent;
	import com.monsterPatties.utils.eventSatellite.EventSatellite;
	import com.spilgames.api.AwardsService;
	import com.spilgames.api.DataService;
	import com.spilgames.api.ScoreService;
	import com.spilgames.api.SpilGamesServices;
	import com.spilgames.api.User;
	import com.spilgames.bs.BrandingManager;
	import com.spilgames.bs.comps.LanguageSelect;
	import com.spilgames.bs.comps.Logo;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	/**
	 * ...
	 * @author ...
	 */
	public class SpilManager extends Sprite
	{
		/*---------------------------------------------------------------Constant-----------------------------------------------------------------*/
		private static var _instance:SpilManager;
		public var spilGamesServices:SpilGamesServices;
		public var brandingManager:BrandingManager;
		public var isServiceReady:Boolean = false;
		private var isGuest:Boolean;
		private var _gdc:GameDataController;
		
		private var languageSelector:LanguageSelect;
		private var userDataPaneGui:UserDataPane;
		private var _stage:DisplayObject;
		//private var _holder:Sprite;
		public var isBrandingReady:Boolean = false;
		
		public static const AWARD1:String = "award1";
		public static const AWARD2:String = "award2";
		public static const AWARD3:String = "award3";
		public static const AWARD4:String = "award4";
		public static const AWARD5:String = "award5";
		private var _es:EventSatellite;
		/*---------------------------------------------------------------Properties-----------------------------------------------------------------*/
		
		/*---------------------------------------------------------------Constructor-----------------------------------------------------------------*/
		
		public function SpilManager( enforcer:SingletonEnforcer  )
		{
		}
		
		public static function getInstance(  ):SpilManager
		{
			if ( SpilManager._instance == null ) {
				SpilManager._instance = new SpilManager( new SingletonEnforcer() );
			}
			
			return SpilManager._instance;
		}
		
		/*---------------------------------------------------------------Methods-----------------------------------------------------------------*/
		public function init(_root:DisplayObject):void {
			_stage = _root;			
			trace("init spil manager");
			_gdc = GameDataController.getInstance();
			_es = EventSatellite.getInstance();
			
			spilGamesServices = SpilGamesServices.getInstance();
			brandingManager = BrandingManager.getInstance();
			brandingManager.addEventListener(SpilGamesServices.COMPONENTS_READY, onBrandingComponentsReady);
			spilGamesServices.addEventListener(SpilGamesServices.COMPONENTS_READY, onComponentsReady);
			spilGamesServices.addEventListener(SpilGamesServices.SERVICES_READY, onServicesReady);
			spilGamesServices.addEventListener(SpilGamesServices.SERVICE_ERROR, onServicesFailed);
			
			//TEST
			//var gameid:String = "ed6375ea45c4523710921289cfe73010";
			
			//REAL
			var gameid:String = "7ec3605665781a11d6acd22f1443e573";
			
			// connecting to the API with a specified game ID
			//7ec3605665781a11d6acd22f1443e573
			//test - ed6375ea45c4523710921289cfe73010
			//spilGamesServices.connect(_root, "ed6375ea45c4523710921289cfe73010",false, new LocalizationPack());			
			
			//orig
			spilGamesServices.connect(_root, gameid, false, new LocalizationPack());
			
			trace("current gameid:==> " + gameid );
		}
		
		private function onServicesFailed(e:ErrorEvent):void{
			trace(" spil onServicesFailed!");
		}
		
		private function onServicesReady(e:Event):void {
			isServiceReady = true;
			trace(" spil onServicesReady!");
			checkIfGuest();
			//submitScore(99);
			//submitAward("winner!!");
			//saveGame();
		}
		
		private function onComponentsReady(e:Event):void{
			trace(" spil onComponentsReady!");
		}
		
		private function onBrandingComponentsReady(e:Event):void {
			if (brandingManager.isReady()) {
				isBrandingReady = true;
				trace(" spil onBrandingComponentsReady!");
				_es.dispatchESEvent( new GameEvent(GameEvent.SPIL_BRANDING_READY) );
			}else {
				trace(" spil BrandingComponents not available!");
			}			
		}
		
		public function  addSpilLogo(holder:Sprite, logoPosition:int = 0):void {
			trace(" spil adding SpilLogo!");
			if (brandingManager.isReady()){
				trace(" spil addSpilLogo!");
				var logo:Logo = new Logo();
				holder.addChild(logo);
				
				if(logoPosition==0){
					logo.x = 7;
					logo.y = 495;
				}else {
					logo.x = 260;
					logo.y = 260;
				}				
			}else {
				trace(" spil failed adding SpilLogo!");
			}
		}
		
		public function addLanguageSelector (holder:Sprite):void{
			languageSelector = new LanguageSelect();
			languageSelector.x = (_stage.stage.stageWidth / 2 - languageSelector.width / 2) + 220;
			languageSelector.y = 500;
			//languageSelector.direction = LanguageSelect.DROP_DOWN_DIRECTION_DOWN;
			languageSelector.direction = LanguageSelect.DROP_DOWN_DIRECTION_UP;
			holder.addChild(languageSelector);
			//languageSelector.visible = false;
		}
		
		public function showHideLanguageSelector(val:Boolean):void {
			if (languageSelector!=null) {
				languageSelector.visible = val;
				trace( "showhide lang selector val " + val );
			}			
		}
		
		private function checkIfGuest():void{
			if(User.isAvailable() && isServiceReady){
				//Get the users name
				var userName:String = User.getUserName();
				 
				//Check to see if a user is logged in or not
				isGuest = User.isGuest();
				
				trace("username " + userName + " isLogin " + isGuest );
			}
		}
		
		public function submitScore(score:int):void {
			trace( "submiting total score " + score );
			if (ScoreService.isAvailable() && isServiceReady && isGuest) {
				trace("spil can send score!!");
				var scoreStatus:int = ScoreService.submitScore(score, scoreSubmissionCallback);
				trace(" spil submiting score!! scoreStatus: " + scoreStatus );
			}else {
				trace("spil cannot send score not available!!");
			}			
		}		
		
		public function submitAward(awardName:String):void 
		{
			if(AwardsService.isAvailable() && isServiceReady && isGuest ){
				// Submits award tag of 'award2'
				trace("submiting what awardname:====>> " + awardName);
				var awardStatus:int = AwardsService.submitAward(awardName, awardSubmissionCallback);
				trace(" spil submiting awardStatus!! awardStatus: " + awardStatus );
			}
		}
		
		public function saveGame():void{
			// Create a XMl object to save.
			var gameSave:XML = 
				<saveData>
					<currentlevel>_gdc.getCurrLevel();</currentlevel>
					<gold>_gdc.getGold();</gold>
					<totalcrystal>_gdc.getTotalCollectedCrystal();</totalcrystal>
					<totalscore>_gdc.getTotalScore();()</totalscore>
					<jump>_gdc.hasDoubleJump();</jump>
					<throwhammer>_gdc.hasThrowWeapon();</throwhammer>
					<combo>_gdc.hasComboAttack();</combo>
					<bomb>_gdc.hasBomber();</bomb>
					<extralives>_gdc.getAdditionalLive();</extralives>					
				</saveData>;

			if(DataService.isAvailable() && isServiceReady && isGuest ){
				// Submit the XML to be saved.
				var saveStatus:int =  DataService.saveData(gameSave, null, saveDataCallback);
				trace("spil saving game data... saveStatus " + saveStatus);
				
				DataService.getDataID(loadDataIDCallback);
				trace("spil getting load data id callback...");
			}
		}

		/*---------------------------------------------------------------Setters-----------------------------------------------------------------*/
		
		/*---------------------------------------------------------------Getters-----------------------------------------------------------------*/
		
		/*---------------------------------------------------------------EventHandlers-----------------------------------------------------------*/
		private function scoreSubmissionCallback(callbackID:int, data:Object):void {
			trace(" spil submiting score call back!! ");
			if (!data.success){
				trace(" Score submission failed!! " +data.errorMessage + " callbackID " + callbackID );
			}else{
				// data.xml holds XML returned from the service
				trace("Score submitted: " + data.xml + " callbackID " + callbackID);
			}
		}		
		
		private function awardSubmissionCallback(callbackID:int,data:Object):void{
			if (!data.success){
				trace( " award submission failed!! " +  data.errorMessage);
			}else{
				// data.xml holds XML returned from the service
				trace("award submitted: " + data.xml);
			}
		}
		
		
		private function saveDataCallback(callbackID:int,data:Object):void{
			if (!data.success){
				 trace("Data saved failed!!!: " + data.errorMessage);
			 }else{
				 // data.xml holds XML returned from the service
				 trace("Data saved: " + data.xml);
			}
		}
		
		private function loadDataIDCallback(callbackID:int,data:Object):void{
			if(data.success){
				trace("We have retrieved the dataID and can now"); 
				// use it to load the data.
				trace("DataID: " + data.dataID);
				if(DataService.isAvailable()){
					DataService.loadData(data.dataID, loadDataCallback);
					trace("spil loading data... : " + data.xml);
				}
		   }
		}
		
		private function loadDataCallback(callbackID:int,data:Object):void{
			if (data.success){
				trace("load Data successfully!! : " + data.xml);
				var myXML:XML = new XML(data.xml);
				trace("check gold " + myXML.gold);
				trace("check currentlevel " + myXML.currentlevel);
				trace("check totalcrystal " + myXML.totalcrystal);					
		   }
		}
		
	}

}

class SingletonEnforcer { }