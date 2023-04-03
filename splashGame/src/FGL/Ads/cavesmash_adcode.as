
	var ads = new FGLAds(stage, "FGL-282");

	//When the API is ready, show the ad!
	ads.addEventListener(FGLAds.EVT_API_READY, showStartupAd);

	function showStartupAd(e:Event):void
	{
		ads.showAdPopup();
	}