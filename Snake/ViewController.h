//
//  ViewController.h
//  Snake
//
//  Created by Dylan Chong on 3/10/12.
//  Copyright (c) 2012 Dylan Chong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameViewController.h"
#import "HighScoreObject.h"
#import <iAd/iAd.h>
#import <AVFoundation/AVFoundation.h>
#import "ShopButton.h"
#import "BuyWindowViewController.h"
#import "HelpController.h"
#import "BuyWindowViewController.h"
#import <GameKit/GameKit.h>
#import "MultiAdHandler.h"

@interface ViewController : UIViewController <UIAlertViewDelegate, ADBannerViewDelegate, shopButtonProtocol, BuyWindowViewControllerDelegate, ADInterstitialAdDelegate, GKGameCenterControllerDelegate, TFTBannerDelegate>

//Main screen
@property (weak, nonatomic) IBOutlet UIImageView *playTab;
@property (weak, nonatomic) IBOutlet UIImageView *border;
@property (weak, nonatomic) IBOutlet UIImageView *achievementTab;
@property (weak, nonatomic) IBOutlet UIImageView *shopTab;
@property (weak, nonatomic) IBOutlet UIImageView *optionsTab;

@property (nonatomic, retain) MultiAdHandler *mainAdBanners;
@end

HelpController *helpController;
UIAlertView *tutorialAskAlert;
UIImageView *blackFader, *viewBackground, *background;
GameViewController *gameController;
ADInterstitialAd *mainFullScreenAd;
BOOL hasShownFullScreenAdToday;
AVAudioPlayer *buttonPressAudioPlayer, *backgroundMusicPlayer;
BOOL soundEffectsOn;
BOOL skipNotPurchasedAlert;
UIImageView *tutorialImage;
UIView *cover;
BOOL autoOpenShopTab;

//play tab stuff
UIButton *snakeSpeedButtonDown, *snakeSpeedButtonUp, *startButton, *helpButton;
UILabel *creditsLabel, *snakeSpeedSliderDisplay, *snakeSpeedSliderDescription, *obstacleSwitchLabel, *borderSwitchLabel, *powerUpSwitchLabel, *ruinsSwitchLabel, *enemySwitchLabel, *playOptionsTitle;
UISwitch *obstacleSwitch, *borderSwitch, *powerUpSwitch, *ruinsSwitch, *enemySwitch;

//achievements tab
UILabel *achievementsViewTitle, *highScoreViewTitle, *statisticsViewTitle;
UIScrollView *playOptionsView, *achievementsView, *highScoreView, *statisticsView;
NSArray *highScoresBlockList;
UIButton *gameCentreButton;
BOOL gameCentreEnabled;

//options tab
UISegmentedControl *optionsControlTypeSegmentedControl, *optionsSoundEffectSegmentedControl, *optionsMusicSegmentedControl;
UILabel *optionsControlTypeSegmentedControlLabel, *optionsSoundEffectSegmentedControlLabel, *optionsMusicSegmentedControlLabel, *pleaseSendFeedbackLabel;
UIButton *contactButton, *resetButton, *showTutorialButton, *facebookPageButton;

//shop tab
UIButton *buyMoreUpgradePointsButton;
UILabel *amountOfUpgradePointsLabel;
ShopButton *adsPurchasedButton, *obstaclesPurchasedButton, *obstacleBorderPurchasedButton, *obstacleRuinsPurchasedButton, *powerUpsPurchasedButton, *enemyPurchasedButton;
BuyWindowViewController *buyWindowController;