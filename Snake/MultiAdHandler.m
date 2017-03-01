//
//  MultiAdHandler.m
//  Serpentine!
//
//  Created by Dylan Chong on 12/11/13.
//  Copyright (c) 2013 Dylan Chong. All rights reserved.
//

#import "MultiAdHandler.h"

@implementation MultiAdHandler

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#define chanceOfAdmobOverTFT 0.0

//Change frame here according to screen size
#define screenWidth [[UIScreen mainScreen] bounds].size.height
#define screenHeight [[UIScreen mainScreen] bounds].size.width

- (id)initAtTopOfScreen:(BOOL)top andRootViewController:(UIViewController *)controller {
    self = [super initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    
    if (self) {
        self.rootController = controller;
        
        _adMobHasLoaded = NO;
        _tftHasLoaded = NO;
        
        // Use predefined GADAdSize constants to define the GADBannerView.
//        _adMob = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner origin:CGPointZero];
        
        // Note: Edit SampleConstants.h to provide a definition for kSampleAdUnitID
        // before compiling.
//        self.adMob.adUnitID = kSampleAdUnitID;
//        self.adMob.delegate = self;
//        [self.adMob setRootViewController:controller];
//        [self.adMob loadRequest:[self createRequest]];
//        [_adMob setHidden:YES];

        
        
        _tft = [[TFTBanner alloc] initWithFrame:CGRectMake(0, 0, 320, 50) delegate:self];
        [_tft setHidden:YES];
        
        if (top == YES) [self setTop];
        else [self setBottom];
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(logAdHiddenness)]];
    }
    
    return self;
}

- (void)logAdHiddenness {
    NSString *x = @"AdBannerHiddenness:";
    if (_adMob.hidden == YES) x = [x stringByAppendingString:@" AdMob=Hidden"];
    else x = [x stringByAppendingString:@" AdMob=Showing"];
    
    if (_tft.hidden == YES) x = [x stringByAppendingString:@" TFT=Hidden"];
    else x = [x stringByAppendingString:@" TFT=Showing"];
    NSLog(@"%@", x);
}

- (void)setTop {
    self.frame = CGRectMake(0, 0, screenWidth + 4, 50);
//    _adMob.frame = CGRectMake(0, 0, 320, 50);
//    _adMob.center = CGPointMake(screenWidth / 2, 25);
    _tft.frame = _adMob.frame;
}

- (void)setBottom {
    self.frame = CGRectMake(0, screenHeight - 50 - 4, screenWidth, 50);
//    _adMob.frame = CGRectMake(0, 0, 320, 50);
//    _adMob.center = CGPointMake(screenWidth / 2, 25);
    _tft.frame = _adMob.frame;
}

- (void)addAdsToSubview {
//    [self addSubview:_adMob];
    [self addSubview:_tft];
}

- (void)decideWhatAdToShow {
    if (_tftHasLoaded == YES && _adMobHasLoaded == NO) {
        //TFT only
        [_tft setHidden:NO];
        [_adMob setHidden:YES];
    } else if (_tftHasLoaded == NO && _adMobHasLoaded == YES) {
        //Admob only
//        [_adMob setHidden:NO];
        [_tft setHidden:YES];
    } else if (_tftHasLoaded == YES && _adMobHasLoaded == YES) {
        //Both
        if ((arc4random() % 100) < (chanceOfAdmobOverTFT * 100)) {
            //Admob
            [_adMob setHidden:NO];
            [_tft setHidden:YES];
        } else {
            //TFT
            [_tft setHidden:NO];
            [_adMob setHidden:YES];
        }
    }
}

#pragma mark - AdMob

- (GADRequest *)createRequest {
    GADRequest *request = [GADRequest request];
    
    // Make the request for a test ad. Put in an identifier for the simulator as
    // well as any devices you want to receive test ads.
    request.testDevices =
    @[GAD_SIMULATOR_ID,
     @"6de738bf28b3d399410b6b950d78c9b2",
     // TODO: Add your device/simulator test identifiers here. They are
     // printed to the console when the app is launched.
      ];
    return request;
}

// We've received an ad successfully.
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    NSLog(@"Received ad successfully");
    _adMobHasLoaded = YES;
    [self decideWhatAdToShow];
}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"Admob error %@", [error localizedFailureReason]);
    _adMobHasLoaded = NO;
    [_adMob setHidden:YES];
    [self decideWhatAdToShow];
}

- (void)adViewWillPresentScreen:(GADBannerView *)adView {
    [self.delegate pauseGame];
}

#pragma mark - TFT

- (void)tftBanner:(TFTBanner *)banner didFail:(NSString *)reason {
    NSLog(@"tft error: %@", reason);
    [_tft setHidden:YES];
    _tftHasLoaded = NO;
    [self decideWhatAdToShow];
}

- (void)tftBannerDidReceiveAd:(TFTBanner *)banner {
    NSLog(@"tft load");
    _tftHasLoaded = YES;
    [self decideWhatAdToShow];
}

- (void)tftBannerWasTapped:(TFTBanner *)banner {
    [self decideWhatAdToShow];
    [self.delegate pauseGame];
}

@end
