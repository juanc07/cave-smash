// Copyright 2010 Spil Games BV
package com.spilgames.api
{
	import com.spilgames.bs.BrandingManager;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.GradientType;
	import flash.display.InterpolationMethod;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.system.SecurityDomain;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.*;
	
	/**
	 * Dispatched when the connection SWF could not be loaded.
	 * 
	 * @eventType flash.events.IOErrorEvent.IO_ERROR
	 */
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	
	/**
	 * Dispatched when the intialization of the connection fails. The
	 * <code>text</code> property of the ErrorEvent signals what type
	 * of error occurred.
	 * 
	 * @eventType initializationFailed
	 */
	[Event(name="initializationFailed", type="flash.events.ErrorEvent")]
	
	/**
	 * Dispatched when the components provided by Spil Games are ready.
	 * 
	 * @eventType componentsReady
	 */
	[Event(name="componentsReady", type="flash.events.Event")]
	
	/**
	 * Dispatched when the intialization of the components fails. The
	 * <code>text</code> property of the ErrorEvent signals what type
	 * of error occurred.
	 * 
	 * @eventType componentsFailed
	 */
	[Event(name="componentsFailed", type="flash.events.ErrorEvent")]
	
	/**
	 * Dispatched when the services provided by Spil Games are ready to receive
	 * requests.
	 * 
	 * @eventType servicesReady
	 */
	[Event(name="servicesReady", type="flash.events.Event")]
	
	/**
	 * Dispatched when all the components and services of Spil Games are ready to be used.
	 * 
	 * @eventType complete
	 */
	//[Event(name="complete", type="flash.events.Event")]
	
	/**
	 * Dispatched when the services provided by Spil Games encounter an error.
	 * 
	 * @eventType serviceError
	 */
	[Event(name="serviceError", type="flash.events.ErrorEvent")]
	
	/**
	 * SpilGamesServices class is the main class to communicate with services
	 * provided by Spil Games. This class provides the ability to setup a
	 * connection and send requests to the provided services.
	 * 
	 * <p>SpilGamesServices is a singleton class. This means only a single instance of
	 * the class can exist. This ensures your game communicates with the Spil Games
	 * services over a single connection. To obtain the single instance you call
	 * <code>SpilGamesService.getInstance()</code>.</p>
	 * 
	 * @since 1.3
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @see #getInstance()
	 * @includeExample spilGamesServices_example1.as
	 */
	public class SpilGamesServices extends MovieClip
	{
		// ====================================
		// CLASS CONSTANTS
		// ====================================
		/**
		 * Defines the event type that is dispatched when the locale is changed.
		 * 
		 * Although mostly for internal use within the branding system,
		 * this constant is exposed to notify of user locale change.
		 */
		public static const LOCALE_CHANGED		: String = "localeChanged";
		
		/**
		 * Defines a default config ID for a game that has not been assigned one yet.
		 * */
		public static const DEFAULT_CONFIG_ID	: String = "f91d4382c704d7e567a5a58246e939d5";
		
		/**
		 * Signals an invalid game ID is returned. In most cases this means that
		 * the connection is not ready yet.
		 */
		public static const INVALID_ITEM_ID					: String = "";
		
		/**
		 * Signals an invalid ID is returned. In most cases this means that
		 * the connection is not ready yet.
		 */
		public static const INVALID_ID						: int = 0;
		
		/**
		 * Defines the error message when the game is running at an invalid
		 * domain regarding usage of the Spil Games services.
		 */
		public static const INVALID_DOMAIN					: String = "invalidDomain";
		
		/**
		 * Defines the error message when the connection fails to configure
		 * itself. This can be due to failure to load the configuration
		 * settings, which happen when the configuration fails to load.
		 */
		public static const CONFIGURATION_FAILED			: String = "configurationFailure";
		
		/**
		 * Defines the type of event that is dispatched when initialization of the
		 * SpilGamesServices fails.
		 */
		public static const INITIALIZATION_FAILED			: String = "initializationFailed";
		
		/**
		 * Defines the type of event that is dispatched when components such as
		 * <code>BrandLogo</code>, <code>LocaleComboBox</code> and
		 * <code>LocalizedTextField</code> are ready to be displayed.
		 */
		public static const COMPONENTS_READY				: String = "componentsReady";
		
		/**
		 * Defines the type of event that is dispatched when loading and/or configuring
		 * components  such as <code>BrandLogo</code>, <code>LocaleComboBox</code> and
		 * <code>LocalizedTextField</code> fail.
		 */
		public static const COMPONENTS_FAILED				: String = "componentsFailed";
		
		/**
		 * Defines the type of event that is dispatched when the Spil Games services such
		 * as <code>ScoreService</code> and <code>AwardsService</code> are ready to be used.
		 * 
		 * @see ScoreService
		 * @see AwardsService
		 */
		public static const SERVICES_READY					: String = "servicesReady";
		
		/**
		 * Defines the type of event that is dispatched when the Spil Games components and services
		 * are ready to be used.
		 */
		//public static const COMPLETE						: String = "complete";
		
		/**
		 * Defines the type of event that is dispatched when an error occurs in one of the
		 * services. Normally you don't need to listen for such events, unless you want to
		 * debug the services.
		 */
		public static const SERVICE_ERROR					: String = "serviceError";
		
		/**
		 * Portal specific calls ID
		 **/
		private static const PORTALSERVICE					: String = "portalservice";
		
		/**
		 * The query string required to retrieve config data for this game.
		 * */
		private static const CONFIG_QUERY_STRING			: String = "?type=live&nocache=" + String(int(Math.random() * 1000));;
		
		/**
		 * The URL of the web service that serves config data for games that use the SPIL API
		 * */
		private static const CONFIG_URL						: String = "http://api.configar.org/cf/pb/1/settings";
		
		// ====================================
		// PRIVATE VARS
		// ====================================
		
		/**
		 * A local object which collects each of the flashvars together
		 * */
		private var _flashVars								: Object;
		
		/**
		 * 
		 * */
		private static var _instance						: SpilGamesServices = null;
		
		/**
		 * Defines the default location of Spil APIs on Spil Servers
		 * */
		private const DEFAULT_CONNECTION_LOCATION			: String = 
			"../../../../sdk/spilapi/" + BuildVersion.BUILD_NUMBER + "/ServicesConnection.swf";
		
		/**
		 * Defines the fallback URL of the APIs 
		 * */
		private const FALLBACK_CONNECTION_LOCATION			: String = 
			"http://www8.agame.com/sdk/spilapi/1.3.1/ServicesConnection.swf";
		
		/**
		 * Defines the fallback state in the sequence of attempted connections to valid Spil APIs
		 * 0: default state 0 - configar is requested and apiLocation is used
		 * 1: fallback state 1 - DEFAULT_CONNECTION_LOCATION is used
		 * 2: fallback state 2 - FALLBACK_CONNECTION_LOCATION is used
		 * */
		private var _fallbackState							: int = 0;
		
		private static const MAX_CONNECTION_LOAD_RETRIES	: uint = 1;
		
		private var _servicesConnection						: * = null;
		private var _debugMode								: Boolean = false;
		private var _options								: Object = null;
		private var _loader									: Loader;
		private var _request								: URLRequest;
		private var _connecting								: Boolean = false;
		private var _connected								: Boolean = false;
		private var _numConnectionLoadTries					: uint = 0;
		
		private var _embeddedLocalizationPack				: *;
		private var _configXML								: XML;
		private var _configID								: String;
		private var _alwaysInFront							: Boolean = false;
		private var _context								: LoaderContext;
		
		// ====================================
		// GETTER/SETTER
		// ====================================
		
		public function get configXML():XML
		{
			
			return _configXML;
			
		}
		/**
		 * Returns the version of the SpilGamesServices class.
		 * 
		 * @return A string containing the version number, ie. '1.3'.
		 * @see BuildVersion
		 */
		public function get version():String
		{
			return BuildVersion.BUILD_NUMBER;
		}
		
		/**
		 * Indicates whether or not the Spil Games services connection is being
		 * setup.
		 * 
		 * @return <code>true</code> when the connection is being established.
		 */
		public function get connecting():Boolean
		{
			return _connecting;
		}
		
		/**
		 * Indicates whether or not the Spil Games services connection is established.
		 * 
		 * @return <code>true</code> when the connection is established.
		 */
		public function get connected():Boolean
		{
			return _connected;
		}
		
		/**
		 * Returns the instance of the services connection.
		 * 
		 * @return The instance of the services connection, or <code>null</code> if
		 *         one doesn't exist.
		 */
		public function get connection():*
		{
			return _servicesConnection;
		}
		
		/**
		 * When set to <code>true</code>, dynamic graphics that are part of the SpilGamesServices
		 * will always be in front of the other visuals in your game. This allows dynamic generated
		 * UI's to be displayed upon request, without the need to call <code>bringToFront()</code>.
		 *
		 * @see #bringToFront()
		 */
		public function set alwaysInFront(value:Boolean):void
		{
			if (_alwaysInFront != value)
			{
				_alwaysInFront = value;
				if (_alwaysInFront)
				{
					addEventListener(Event.ENTER_FRAME, bringToFront);
				}
				else
				{
					removeEventListener(Event.ENTER_FRAME, bringToFront);
				}
			}
		}
		public function get alwaysInFront():Boolean
		{
			return _alwaysInFront;
		}
		
		/**
		 * Constructor.
		 * 
		 * @param access
		 * @throws Error Cannot instantiate class directly, use
		 *         <code>getInstance()</code> instead.
		 * @see #getInstance()
		 */
		public function SpilGamesServices(access:Private = null)
		{
			super();
			
			initConstructor(access);
		}
		
		// ====================================
		// STATIC METHODS
		// ====================================
		
		/**
		 * Returns the sole instance of the SpilGamesServices class.
		 * 
		 * @return Instance of the SpilGamesServices class.
		 */
		public static function getInstance():SpilGamesServices
		{
			if (!_instance)
			{
				_instance = new SpilGamesServices(new Private());
			}
			
			return _instance;
		}
		
		// ====================================
		// PUBLIC METHODS
		// ====================================
		
		/**
		 * @private
		 * 
		 * @param apiLocation
		 * @param debugMode
		 * 
		 */
		private function loadAPI(apiLocation:String, debugMode:Boolean = false):void
		{
			if (!_connecting && !_connected)
			{				
				// Provide (by displaying) feedback towards the user if it is a valid clip.
				if(this.parent)
				{
					validateOptions(this.parent, _configID);
				}
				
				_connecting = true;
				
				// Initialise singletons
				BrandingManager.getInstance();
				
				// We want to get notified when we are removed from stage
				addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
				
				var connectionLocation:String;
				
				if(apiLocation != "")
				{
					connectionLocation = apiLocation;
				}
				else if (root.loaderInfo.parameters["servicesLoc"] &&
					root.loaderInfo.parameters["servicesLoc"].length > 0)
				{
					connectionLocation = root.loaderInfo.parameters["servicesLoc"];
				}
				else
				{
					connectionLocation = DEFAULT_CONNECTION_LOCATION;
					
					var urlVariables:URLVariables = new URLVariables();
					var date:Date = new Date();
					urlVariables.nocache = date.milliseconds;
					
					urlVariables.useDraft = debugMode;
					
					_request = new URLRequest(connectionLocation);
					_request.data = urlVariables;
				}
				
				allowDomain();
				
				if(!_request)
				{
					_request = new URLRequest(connectionLocation);
				}
				
				_context = new LoaderContext(false, ApplicationDomain.currentDomain);
				if (Security.sandboxType == Security.REMOTE)
					_context.securityDomain = SecurityDomain.currentDomain;
				
				_loader = new Loader();
				_loader.contentLoaderInfo.addEventListener(Event.INIT, onLoadComplete);
				_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
				_loader.load(_request, _context);
			}
		}
		
		/**
		 * Use this function to connect to Spil Games suite of services. 
		 * 
		 * @param clip The main parent movieclip of the game.
		 * 
		 * @param configID The Spil Games assigned configID for your game. 
		 * Please email your Spil contact if you have not been provided a gameID. 
		 * You may use the <code>DEFAULT_CONFIG_ID</code> 
		 * defined in this class for testing purposes if your actual gameID is not available yet.
		 * 
		 * @param debugMode This flag may be set to true during development and local 
		 * testing of a game which implements the Spil Games API. It will disable all 
		 * calls to external services (e.g. score submission, award submission etc) 
		 * and simply trace a message which indicates that the call was made 
		 * successfully. 
		 * 
		 * <p>This flag must be enabled for local testing to avoid Security
		 * sandbox errors related to the local filesystem attempting to access a hosted
		 * service. Alternatively the game may be hosted on a local or public server
		 * and tested without this flag.</p>
		 * 
		 * @param embeddedLocalizationPack You need to pass this parameter in order to embed
		 * the game localization pack in your game. Once you have embedded the appropriate SWF file (Flex)
		 * or SWC library (Flash), both files provided to you by SpilGames,
		 * pass here a new instance of it e.g. <code>new LocalizationPack()</code>. Omitting this parameter
		 * will make use of the game localization pack set in Configar.
		 * 
		 * <p>For more information about embedding the game localization pack, please refer to the Manual.</p>
		 * 
		 * */
		public function connect(
			clip						: DisplayObject,
			configID					: String,
			debugMode					: Boolean		= false,
			embeddedLocalizationPack	: *				= null
		):void 
		{
			// Add ourselves directly to the stage object
			clip.stage.addChild(this);
			
			getFlashVars();
			
			if ( configID == null )
			{
				throw new TypeError("You must supply a configID");
			}
			
			_embeddedLocalizationPack = embeddedLocalizationPack;
			
			if( !debugMode )
			{
				//Set default values in case flashVars don't exist
				if(!_flashVars.channelID) _flashVars.channelID = "0";
				if(!_flashVars.siteID) _flashVars.siteID = "0";
				
				var url :String = CONFIG_URL + "/" + _flashVars.channelID 
					+ "/" + _flashVars.siteID + "/" + configID + CONFIG_QUERY_STRING;
				
				var loader:URLLoader = new URLLoader();
				loader.addEventListener(Event.COMPLETE, onConfigurationLoaded)
				loader.load(new URLRequest(url));
			} 
			else 
			{
				_debugMode = true;
				trace("DEBUG: Succesfully connected to the API.");
			}
		}
		
		private function onConfigurationLoaded(evt:Event):void
		{
			var config: String = evt.currentTarget.data;
			var regExp:RegExp = /(\t|\n|\s{2,})/g;
			config = config.replace(regExp, "");
			_configXML = new XML(config);
			
			var configurator:XMLList = _configXML..component.(@name == "Configurator");
			var apiLocation:String = configurator..property.(@name == "apiLocation").@value.toString();
			
			loadAPI(apiLocation);
		}
		
		/**
		 * Disconnects the SpilGamesServices. Removes all references to the services
		 * connection object. To make use of the services you need to call
		 * <code>connect()</code> again.
		 * 
		 * @see #connect()
		 */
		public function disconnect():void
		{
			if (_servicesConnection)
			{
				_servicesConnection.removeEventListener(Event.COMPLETE, onServicesReady);
				_servicesConnection.removeEventListener(ErrorEvent.ERROR, onInitializationError);
				_servicesConnection.removeEventListener("serviceError", onServiceError);
				_servicesConnection.removeEventListener(COMPONENTS_READY, onComponentsReady);
				
				if (_connected)
				{
					_servicesConnection.disconnect();
				}
				removeChild(_servicesConnection);
			}
			
			_servicesConnection = null;
			
			if (_loader)
			{
				try
				{
					_loader.close();
				}
				catch (e:Error)
				{
				}
				finally
				{
					_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadComplete);
					_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
				}
				
				_loader = null;
			}
			
			removeEventListener(Event.ENTER_FRAME, bringToFront);
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			
			if (parent)
			{
				parent.removeChild(this);
			}
			
			_connected = _connecting = false;
			
			if(isDebugMode())
			{
				trace("DEBUG: Disconnected from the API");
			}
		}
		
		/**
		 * Retrieves the ID of the Spil Games channel on which the game is running.
		 * 
		 * @return The ID of the Spil Games channel on which the game is running,
		 *         or an INVALID_ID when the game is not running on a Spil Games
		 *         channel.
		 * 
		 * @see #INVALID_ID
		 */
		public function getChannelID():int
		{
			var result:int = INVALID_ID;
			
			if (_servicesConnection != null)
			{
				result = _servicesConnection.getChannelID();
			}
			
			if(isDebugMode())
			{
				trace("DEBUG: getChannelID(); returns 0");
				return 0;
			} else {
				return result;
			}
		}
		
		/**
		 * Retrieves the ID of the Spil Games site or portal on which the game
		 * is running.
		 * 
		 * @return The ID of the Spil Games site on which the game is running,
		 * or an INVALID_ID when the game is not running on a Spil Games site.
		 * 
		 * @see #INVALID_ID
		 */
		public function getSiteID():int
		{
			var result:int = INVALID_ID;
			
			if (_servicesConnection != null)
			{
				result = _servicesConnection.getSiteID();
			}
			
			if(isDebugMode())
			{
				trace("DEBUG: getSiteID(); returns 0");
				return 0;
			} else {
				return result;
			}
		}
		
		/**
		 * Returns the ID of the game when the game is played on a
		 * Spil Games website.
		 * 
		 * @return The ID of the game or INVALID_ITEM_ID when the game is not
		 *         running on a Spil Games site.
		 * @see #INVALID_ITEM_ID
		 */
		public function getItemID():String
		{
			var result:String = INVALID_ITEM_ID;
			
			if (_servicesConnection != null)
			{
				result = _servicesConnection.getItemID();
			}
			
			if(isDebugMode())
			{
				trace("DEBUG: getItemID(); returns \"\"");
				return INVALID_ITEM_ID;
			} else {
				return result;
			}
		}
		
		/**
		 * Indicates whether or not the SpilGamesServices connection has been
		 * established successfully and the services are ready to be used.
		 * 
		 * @return Returns <code>true</code> if the service is ready to be used,
		 * 		   <code>false</code> otherwise.
		 */
		public function isReady():Boolean
		{
			if(isDebugMode())
			{
				trace("DEBUG: isReady(); returns 'true'");
				return true;
			}else {
				return (_servicesConnection != null &&
					_servicesConnection.isReady());
			}
		}
		
		/**
		 * Indicates whether or not the domain on which the game is running is
		 * allowed to use the Spil Games services.
		 * 
		 * @return Returns <code>true</code> if the domain is allowed for usage,
		 *         <code>false</code> otherwise.
		 */
		public function isDomainAllowed():Boolean
		{
			if(isDebugMode())
			{
				trace("DEBUG: isDomainAllowed(); returns 'true'");
				return true;
			} else {
				return (_servicesConnection != null &&
					_servicesConnection.isDomainValid());
			}
		}
		
		/**
		 * Indicates whether or not a service with the given <code>serviceID</code>
		 * is available for use.
		 * 
		 * @param serviceID The ID of the service to verify availability.
		 * @return Returns <code>true</code> if the requested service is available
		 *         for usage, <code>false</code> otherwise.
		 */
		public function isServiceAvailable(serviceID:String):Boolean
		{
			if(isDebugMode())
			{
				trace("DEBUG: isServiceAvailable(); returns 'true'");
				return true;
			}else {
				return (isReady() &&
					_servicesConnection.isServiceAvailable( serviceID ));
			}
		}
		
		/**
		 * Returns a Boolean which indicates if a connection 
		 * to the Spil services has been made in debug mode
		 * 
		 * <p>In debug mode all external requests will be supressed
		 * and replaced with a traced message indicating successful 
		 * use of the API. This variable exists for developers testing 
		 * their games locally and should be set to false in the 
		 * <code>SpilGamesServices.connect()</code> method when preparing 
		 * a build for release or testing on a hosted page. </p>
		 * 
		 * @return Indicator of debug mode status.
		 * */
		public function isDebugMode():Boolean
		{
			return _debugMode;
		}
		
		/**
		 * Sends a request to the Spil Games services.
		 * 
		 * <p>Normally you don't call this function in your game, but use one
		 * of the service classes. See detailed documentation at each service
		 * class regarding their specific usage, which wrap this function.</p>
		 
		 * @param serviceID A String identifier for the specific service to use.
		 * @param functionName A String specifying the function to call.
		 * @param callback A Function with the signature <code>(int, Object):void</code>
		 *                 which handles the returned data.
		 * @param args [optional] An Object holding arguments to submit to the
		 *             service function.
		 * @return An identifier of the request, or an INVALID_ID if the
		 *         connection is not ready yet. This identifier can be used
		 *         to keep track of which request calls the given callback.
		 *
		 * @see AlbumService
		 * @see AwardsService
		 * @see DateService
		 * @see ScoreService
		 * @see #INVALID_ID
		 */
		public function send(serviceID:String, functionName:String,
							 callback:Function, args:Object = null):int
		{			
			var result:int = INVALID_ID;
			
			if ( isReady() && !isDebugMode())
			{
				result = _servicesConnection.send(serviceID, functionName,
					callback, args);
			} else {
				trace("DEBUG: Succesfully called '"+functionName+"' on service "+serviceID+".");
			}
			
			return result;
		}
		
		/**
		 * Sends a request for calling a portal specific method.
		 * Supported methods are defined in the PortalMethods class.
		 * 
		 * @param methodName The name of the portal method to call as defined in the PortalMethod class.
		 * @param callback A Function with the signature <code>(int, Object):void</code>
		 *                 which handles the returned data.
		 * @param args [optional] An Object holding arguments to submit to the
		 *             service function.
		 * 
		 * @return An identifier of the request, or an INVALID_ID if the
		 *         connection is not ready yet. This identifier can be used
		 *         to keep track of which request calls the given callback.
		 * 		   Please notice that if you don't use a callback it will
		 *		   return an INVALID_ID as well.
		 * 
		 * @see PortalMethods
		 **/
		
		public function callPortalMethod(methodName:String, callback:Function = null, args:Object = null):int
		{
			return send(PORTALSERVICE, methodName, callback, args);
		}
		
		/**
		 * Returns a named property from the specified service. If the property could not be found
		 * or the connection has not yet been established, the given default value is returned.
		 * 
		 * <p>Normally you don't call this function in your game, but use one of the service
		 * classes. See detailed documentation for each service class regarding their specific
		 * usage, which wraps this function.</p>
		 * 
		 * @param serviceID A String identifier for the specific service to use.
		 * @param propertyName The name of the property to retrieve.
		 * @param defaultValue A default value to be returned if the value could not be obtained.
		 * 
		 * @return Named property from the specified service.
		 */
		public function getProperty(serviceID:String, propertyName:String,
									defaultValue:*):*
		{
			var result:* = defaultValue;
			
			if ( isReady() && _servicesConnection.hasOwnProperty( "getProperty" ) && !isDebugMode())
			{
				result = _servicesConnection.getProperty(serviceID, propertyName,
					defaultValue);
			} else {
				trace("Debug: called getProperty(); returns object.");				
				result = new Object();
				result.serviceID = 0;
				result.propertyName = "DebugObject";
				result.defaultValue = 0;
			}
			
			return result;
		}
		
		/**
		 * Sets the given domain as allowed in the security sandbox of the
		 * current game.
		 * 
		 * @param domain The domain name that is allowed to share the current
		 *               game's sandbox.
		 */
		public function allowDomain(domain:String = "*"):void
		{
			Security.allowDomain(domain);
			Security.allowInsecureDomain(domain);
		}
		
		// ====================================
		// PRIVATE METHODS
		// ====================================
		
		/**
		 * Initialize the constructor.
		 * 
		 * @param access
		 * @throws Error Cannot instantiate this class directly, use
		 *               <code>SpilGamesServices.getInstance()</code> instead.
		 */		
		private function initConstructor(access:Private):void
		{
			if (!access)
			{
				throw new Error("Cannot instantiate this class directly, " +
					"use SpilGamesServices.getInstance() instead.");
			}
		}
		
		/**
		 * Method to validate the given options when <code>connect()</code> is called.
		 * 
		 * @param clip 			Target object.
		 * @param portalGroup 	Portal group ID. See <code>PortalGroup</code>
		 *                      for available values
		 * @param configID 		Configuration ID.
		 * @throws Error The <code>clip</code> parameter cannot be <code>null</code>.
		 * @throws Error The given clip mist be present in the display list (and
		 *               added to the stage).
		 * @throws Error The <code>portalGroup</code> parameter must be larger than 0.
		 * @see #connect()
		 * @see com.spilgames.api.PortalGroup PortalGroup
		 */
		private function validateOptions(clip:DisplayObjectContainer, configID:String ):void
		{
			if (!clip)
			{
				throw new Error("The 'clip' parameter cannot be null");
			}
			if (!clip.stage)
			{
				throw new Error("The given clip must be present in the " +
					"display list (added to stage)");
			}
			
			_options = new Object();
			_options.configID = configID;
			_options.hostApplicationDomain = ApplicationDomain.currentDomain;
			_options.embeddedLocalizationPack = _embeddedLocalizationPack;
		}
		
		// ====================================
		// EVENT HANDLERS
		// ====================================
		
		/**
		 * Sets the graphical representations used by SpilGamesServices at the
		 * front of the display list.
		 * 
		 * @param event
		 */
		public function bringToFront(event:Event = null):void
		{
			if (parent)
			{
				try
				{
					parent.setChildIndex(this, parent.numChildren - 1);
				}
				catch (error:Error)
				{
					removeEventListener(Event.ENTER_FRAME, bringToFront);
				}
			}
		}
		
		/**
		 * Invoked when the service is removed from the stage.
		 * 
		 * <p>Displays a warning message to the developer that the service
		 * should not be removed from the stage.</p>
		 * 
		 * @param event
		 */
		private function onRemovedFromStage(event:Event):void
		{
			trace("WARNING: Please do not remove SpilGamesServices from the stage!");
		}
		
		/**
		 * Invoked when the configuration loading process completed.
		 * 
		 * @param event
		 */
		private function onLoadComplete(event:Event):void
		{
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadComplete);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			
			_servicesConnection = LoaderInfo(event.target).content;
			_servicesConnection.addEventListener(Event.COMPLETE, onServicesReady);
			_servicesConnection.addEventListener(ErrorEvent.ERROR, onInitializationError);
			_servicesConnection.addEventListener("serviceError", onServiceError);
			_servicesConnection.addEventListener(COMPONENTS_READY, onComponentsReady);
			_servicesConnection.addEventListener(LOCALE_CHANGED, onLocaleChanged);
			
			// Start connection by adding the connection object to the stage
			if ( _servicesConnection.hasOwnProperty( "setOptions" ))
			{
				_servicesConnection.setOptions(_options);
			}
			addChild(_servicesConnection);
			
			//Pass the xml from configar to the API
			_servicesConnection.setConfig(_configXML, _embeddedLocalizationPack);
		}
		
		/**
		 * Invoked when an I/O error occured while downloading the configuration.
		 * 
		 * @param event
		 */
		private function onIOError(event:IOErrorEvent):void
		{
			++_numConnectionLoadTries;
			
			if ( _numConnectionLoadTries > MAX_CONNECTION_LOAD_RETRIES )
			{
				trace("ERROR: SpilGamesServices - Failed to load the connection object! Aborting initialization.");
				trace("ERROR: SpilGamesServices - Unknown connection object URL: " + _request.url);
				
				//Retry in fallback sequence
				_request = null;
				_connecting = false;
				switch(_fallbackState)
				{
					case 0:
						retryConnection(DEFAULT_CONNECTION_LOCATION);						
						break;
					case 1:
						retryConnection(FALLBACK_CONNECTION_LOCATION);
						break;
					case 2:
						trace("ERROR: No connection could be made to SPIL APIs!");
						_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadComplete);
						_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
						if ( hasEventListener( event.type ))
						{
							dispatchEvent(event);
						}
						break;
				}
			}
			else
			{
				trace("WARN: SpilGamesServices - Failed to load the connection object - retry #" +
					_numConnectionLoadTries);
				// Wait a few seconds and try again, start by setting the current
				// time on previous frame time else the difference is huge.
				previousFrameTime = getTimer();
				addEventListener(Event.ENTER_FRAME, updateConnectionRetry);
			}
		}
		
		/**
		 * Used to retry connections in the fallback sequence
		 * */
		private function retryConnection(url:String):void
		{
			_fallbackState++;
			_numConnectionLoadTries = 0;
			loadAPI(url);	
		}
		
		/**
		 * Tracks the delay before trying to connect. 
		 */		
		private var currentDelay			: Number = 0;
		
		/**
		 * Time of the previous frame. Used to calculate deltaTime. 
		 */		
		private var previousFrameTime		: Number;
		
		/**
		 * Invoked when another connection attempt is tried.
		 * 
		 * @param event
		 */		
		private function updateConnectionRetry(event:Event) : void
		{
			// calculate the time between frames.	
			var currentFrameTime:Number = getTimer();
			
			// from milliseconds to seconds
			var deltaTime:Number = (currentFrameTime - previousFrameTime) / 1000;
			
			currentDelay += deltaTime;
			if (currentDelay >= 2)	
			{
				trace("WARN: SpilGamesServices - Trying to reconnect after: " + currentDelay.toPrecision(4) + " sec.");
				
				_loader.load(_request, _context);
				removeEventListener(Event.ENTER_FRAME, updateConnectionRetry);
				currentDelay = 0;
			}			
			
			previousFrameTime = currentFrameTime;
		}
		
		/**
		 * Invoked when the services are ready to use.
		 * 
		 * @param event
		 */
		private function onServicesReady(event:Event):void
		{
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadComplete);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			
			_connected = true;
			_connecting = false;
			
			dispatchEvent(new Event( SERVICES_READY ));
			//dispatchEvent(new Event( COMPLETE ));
		}
		
		/**
		 * Invoked when an initialization error was encountered.
		 * 
		 * @param event
		 */
		private function onInitializationError(event:ErrorEvent):void
		{
			_servicesConnection.removeEventListener(Event.COMPLETE, onServicesReady);
			_servicesConnection.removeEventListener(ErrorEvent.ERROR, onInitializationError);
			_servicesConnection.removeEventListener("serviceError", onServiceError);
			_servicesConnection.removeEventListener(COMPONENTS_READY, onComponentsReady);
			
			_connecting = false;
			
			trace("ERROR: SpilGamesServices failed to initialize due to '" + event.text + "'");
			
			// Check, since we dispatch an error event (which must be handled for correct user experience)
			if (hasEventListener(INITIALIZATION_FAILED))
			{
				dispatchEvent(new ErrorEvent(INITIALIZATION_FAILED, false, false, event.text));
			}
		}
		
		/**
		 * Invoked when a service error was dispatched.
		 * 
		 * @param event
		 */
		private function onServiceError(event:Event):void
		{	
			if (hasEventListener(SERVICE_ERROR))
			{
				var message:String = "";
				if (event is ErrorEvent)
				{
					message = ErrorEvent(event).text;
				}
				else
				{
					message = event.toString();
				}
				
				dispatchEvent(new ErrorEvent(SERVICE_ERROR, false, false,
					message));
			}
		}
		
		/**
		 * Invoked when the components are ready to use.
		 * 
		 * @param event
		 */
		private function onComponentsReady(event:Event):void
		{
			_servicesConnection.removeEventListener(COMPONENTS_READY,
				onComponentsReady);
			
			if (hasEventListener(COMPONENTS_READY))
			{
				dispatchEvent( new Event(COMPONENTS_READY) );
			}
		}
		
		/**
		 * Invoked when the connection fires a LOCALE_CHANGED event.
		 * 
		 * @param event
		 **/
		private function onLocaleChanged(event:Event):void
		{
			//propagate the event
			if (hasEventListener(LOCALE_CHANGED))
			{
				dispatchEvent( new Event(LOCALE_CHANGED) );
			}
		}
		
		/**
		 * Returns the flashVars harvested from a SpilGames Portal page.
		 * */
		public function get flashVars():Object
		{
			if(!_flashVars)
				getFlashVars();
			
			return _flashVars;
		}
		
		
		/**
		 * @private Retrieve the flash vars
		 * */
		private function getFlashVars():void
		{
			_flashVars = new Object();
			
			// Obtain flash vars from root object
			if (parent && parent.loaderInfo)
			{
				var vars:Object = parent.loaderInfo.parameters;
				var localVars:Object = this.loaderInfo.parameters;
				
				// Obtain user data
				_flashVars.userName = (vars.username != null) ? vars.username : "";
				_flashVars.userHash = (vars.hash != null) ? vars.hash : "";
				_flashVars.channelID = vars.c;
				_flashVars.siteID = vars.s;
				_flashVars.itemID = vars.id;
				_flashVars.scoreDomain = vars.scoreDomain;
				_flashVars.debugMode = localVars.debugMode == "false" ? false : true;
				_flashVars.serviceOverwriteMask = (vars.som != null) ? vars.som : 0xFFFFFFFF;
				
				// Used by developers for testing against specific test environment
				_flashVars.serviceEnvironmentOverwriteID = (vars.dev != null) ? vars.dev : "UNKNOWN";
			}
			else
			{
				
			}
		}
	}
}

/**
 * @private
 */
internal class Private {}