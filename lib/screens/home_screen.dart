import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:hangman_pidgin/components/action_button.dart';
import 'package:hangman_pidgin/utilities/hangman_words.dart';
import 'game_screen.dart';
import 'loading_screen.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audio_cache.dart';

const String testDevice = '90EDAB237832B1C94B8C789F47A6E1E0';

class HomeScreen extends StatefulWidget {
  final HangmanWords hangmanWords = HangmanWords();

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: testDevice != null ? <String>[testDevice] : null,
    nonPersonalizedAds: true,
    keywords: <String>['Game', 'Mario'],
  );

  BannerAd _bannerAd;
  InterstitialAd _interstitialAd;

  BannerAd createBannerAd() {
    return BannerAd(
        adUnitId: "ca-app-pub-5496491526622452/4549192591",
        //Change BannerAd adUnitId with Admob ID
        size: AdSize.banner,
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event) {
          print("BannerAd $event");
        });
  }

  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
        adUnitId: "ca-app-pub-5496491526622452/7311087306",
        //Change Interstitial AdUnitId with Admob ID
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event) {
          print("InterstialAd $event");
        });
  }

  @override
  void initState() {
    FirebaseAdMob.instance
        .initialize(appId: 'ca-app-pub-5496491526622452~4033638530');
    //Change appId With Admob Id
    _bannerAd = createBannerAd()
      ..load()
      ..show();
    super.initState();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    _interstitialAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    widget.hangmanWords.readWords();
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: <Widget>[
          Center(
            child: Container(
              margin: EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 8.0),
              child: Text(
                'HANGMAN PIDGIN',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 38.0,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 3.0),
              ),
            ),
          ),
          SizedBox(
            height: height * 0.012,
          ),
          Center(
            child: Container(
              padding: EdgeInsets.all(5.0),
              child: Image.asset(
                'images/gallow.png',
                height: height * 0.5,
              ),
            ),
          ),
          SizedBox(
            height: height * 0.049,
          ),
          Center(
            child: IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
//                    width: 155,
                    height: 64,
                    child: ActionButton(
                      buttonTitle: 'Start',
                      onPress: () {
                        createInterstitialAd()
                          ..load()
                          ..show();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GameScreen(
                              hangmanObject: widget.hangmanWords,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 18.0,
                  ),
                  Container(
//                    width: 155,
                    height: 64,
                    child: ActionButton(
                      buttonTitle: 'High Scores',
                      onPress: () {
                        createInterstitialAd()
                          ..load()
                          ..show();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoadingScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
