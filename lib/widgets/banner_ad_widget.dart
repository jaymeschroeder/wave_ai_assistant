import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:wave_ai_assistant/constants/constants.dart';

class BannerAdWidget extends StatefulWidget {
  @override
  _BannerAdWidgetState createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    _bannerAd = BannerAd(
      adUnitId: AD_UNIT_ID,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          // Ad has been loaded successfully.
          print("GOOGLE ADS: ${ad.responseInfo}");
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          // Ad failed to load. Handle the error.
          print("GOOGLE ADS: ${error.message}");
        },
      ),
    );

    _bannerAd?.load();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: AdWidget(ad: _bannerAd!),
      width: _bannerAd?.size.width.toDouble(),
      height: _bannerAd?.size.height.toDouble(),
    );
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }
}