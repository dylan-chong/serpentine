//
//  MultiAdHandler.h
//  Serpentine!
//
//  Created by Dylan Chong on 12/11/13.
//  Copyright (c) 2013 Dylan Chong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "GADBannerView.h"
#import "SampleConstants.h"
#import "TFTTapForTap.h"

@protocol MultiAdHandlerDelegate <NSObject>

- (void)pauseGame;

@end

@interface MultiAdHandler : UIView <GADBannerViewDelegate, TFTBannerDelegate>
@property (weak, nonatomic) UIViewController *rootController;
@property (strong, nonatomic) GADBannerView *adMob;
@property (strong, nonatomic) TFTBanner *tft;
@property BOOL adMobHasLoaded, tftHasLoaded;
@property id<MultiAdHandlerDelegate> delegate;

- (id)initAtTopOfScreen:(BOOL)top andRootViewController:(UIViewController *)controller;
- (void)setTop;
- (void)setBottom;
- (void)addAdsToSubview;

@end
