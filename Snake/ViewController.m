//
//	ViewController.m
//	Snake
//
//	Created by Dylan Chong on 3/10/12.
//	Copyright (c) 2012 Dylan Chong. All rights reserved.
//

#import "ViewController.h"
#define moneyHack NO

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - Load

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
    
    NSUserDefaults *tempDefaults = [NSUserDefaults standardUserDefaults];
    
    if (moneyHack == YES) [tempDefaults setInteger:99999 forKey:cashKey];
    
    if ([[tempDefaults objectForKey:adsPurchased] boolValue] != YES) {
        _mainAdBanners = [[MultiAdHandler alloc] initAtTopOfScreen:YES andRootViewController:self];
        
        if ([[tempDefaults objectForKey:gamesPlayedKey] integerValue] > 2) {
            mainFullScreenAd = [[ADInterstitialAd alloc] init];
            mainFullScreenAd.delegate = self;
        }
    }
    
    background = [[UIImageView alloc] initWithFrame:self.view.frame];
    background.image = [UIImage imageNamed:@"1.png"];
    
    //set to NO to freeze background
    if (YES) background.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"1.png"], [UIImage imageNamed:@"2.png"], [UIImage imageNamed:@"3.png"], [UIImage imageNamed:@"4.png"], [UIImage imageNamed:@"5.png"], [UIImage imageNamed:@"6.png"], [UIImage imageNamed:@"7.png"], [UIImage imageNamed:@"8.png"], [UIImage imageNamed:@"9.png"], [UIImage imageNamed:@"10.png"], nil];
    background.animationDuration = 2.5;
    background.animationRepeatCount = 0;
    [background startAnimating];
    background.clipsToBounds = NO;
    [background setFrame:CGRectMake(2, 4, 1020, 760)];
    [self.view addSubview:background];
    [self.view sendSubviewToBack:background];
    
    //tab stuff
    blackFader = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
    blackFader.image = [UIImage imageNamed:@"black.png"];
    blackFader.hidden = YES;
    blackFader.opaque = YES;
    [self.view addSubview:blackFader];
    
    viewBackground = [[UIImageView alloc] initWithFrame:CGRectMake(-2000, -2000, 1020, 760)];
    viewBackground.contentMode = UIViewContentModeTopLeft;
    viewBackground.image = [UIImage imageNamed:@"1.png"];
    viewBackground.opaque = YES;
    viewBackground.userInteractionEnabled = YES;
    [self.view addSubview:viewBackground];
    
    [self.view bringSubviewToFront:_border];
    
    creditsLabel = [[UILabel alloc] initWithFrame:CGRectMake(1020 - 310 - 10, 760 - 72 - 10, 310, 72)];
    creditsLabel.text = @"Programmed by Dylan Chong \rGraphics By Max McMillan \rSound Effects from as3sfxr (by Tom Vian) \rMusic by Kevin Macleod (Incompetech)";
    creditsLabel.backgroundColor = [UIColor clearColor];
    creditsLabel.numberOfLines = 4;
    creditsLabel.textColor = [UIColor whiteColor];
    creditsLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0f];
    creditsLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:creditsLabel];
    
    //*************************************************************** Play Tab ***************************************************************
    playOptionsView = [[UIScrollView alloc] initWithFrame:CGRectMake((1020 - 460) / 2, 290, 460, 400)];
    playOptionsView.contentSize = CGSizeMake(450, 525);
    UIColor *menuBackgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.75f];
    playOptionsView.backgroundColor = menuBackgroundColor;
    playOptionsView.clipsToBounds = YES;
    playOptionsView.bounces = YES;
    
    playOptionsTitle = [[UILabel alloc] initWithFrame:CGRectMake(playOptionsView.frame.origin.x + 100, playOptionsView.frame.origin.y - 50, 260, 50)];
    [playOptionsTitle setText:@"Gameplay Options"];
    [playOptionsTitle setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Button 260x50 Blue.png"]]];
    playOptionsTitle.font = [UIFont fontWithName:@"Helvetica" size:20];
    [playOptionsTitle setTextColor:[UIColor whiteColor]];
    playOptionsTitle.textAlignment = NSTextAlignmentCenter;
    
    startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    startButton.frame = CGRectMake(playOptionsTitle.frame.origin.x + playOptionsTitle.frame.size.width, playOptionsTitle.frame.origin.y, 100, 50);
    [startButton setTitle:@"Start" forState:UIControlStateNormal];
    [startButton setBackgroundImage:[UIImage imageNamed:@"Button 100x50 Blue.png"] forState:UIControlStateNormal];
    [startButton addTarget:self action:@selector(startButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [startButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:22]];
    
    helpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    helpButton.frame = CGRectMake(playOptionsTitle.frame.origin.x - 100, playOptionsTitle.frame.origin.y, 100, 50);
    [helpButton setTitle:@"Help" forState:UIControlStateNormal];
    helpButton.tag = helpGameOptions;
    [helpButton setBackgroundImage:[UIImage imageNamed:@"Button 100x50 Blue.png"] forState:UIControlStateNormal];
    [helpButton addTarget:self action:@selector(showHelp:) forControlEvents:UIControlEventTouchUpInside];
    
    snakeSpeedSliderDescription = [[UILabel alloc] initWithFrame:CGRectMake(70, 30, 320, 70)];
    snakeSpeedSliderDescription.text = @"Select the speed of the snake below: 0 is the fastest and 15 is the slowest, with 8 being recommended for beginner.";
    snakeSpeedSliderDescription.backgroundColor = [UIColor clearColor];
    snakeSpeedSliderDescription.textColor = [UIColor whiteColor];
    snakeSpeedSliderDescription.textAlignment = NSTextAlignmentCenter;
    snakeSpeedSliderDescription.numberOfLines = 0;
    snakeSpeedSliderDescription.font = [UIFont fontWithName:@"Helvetica" size:16];
    [playOptionsView addSubview:snakeSpeedSliderDescription];
    
    snakeSpeedButtonDown = [UIButton buttonWithType:UIButtonTypeCustom];
    snakeSpeedButtonDown.frame = CGRectMake(120, snakeSpeedSliderDescription.frame.origin.y * 2 + snakeSpeedSliderDescription.frame.size.height, 75, 40);
    [snakeSpeedButtonDown setBackgroundImage:[UIImage imageNamed:@"Button 75x40"] forState:UIControlStateNormal];
    [snakeSpeedButtonDown setTitle:@"<" forState:UIControlStateNormal];
    [snakeSpeedButtonDown addTarget:self action:@selector(speedDown) forControlEvents:UIControlEventTouchUpInside];
    [playOptionsView addSubview:snakeSpeedButtonDown];
    
    snakeSpeedButtonUp = [UIButton buttonWithType:UIButtonTypeCustom];
    snakeSpeedButtonUp.frame = CGRectMake(460 - 120 - 75, snakeSpeedButtonDown.frame.origin.y, 75, 40);
    [snakeSpeedButtonUp setBackgroundImage:[UIImage imageNamed:@"Button 75x40"] forState:UIControlStateNormal];
    [snakeSpeedButtonUp setTitle:@">" forState:UIControlStateNormal];
    [snakeSpeedButtonUp addTarget:self action:@selector(speedUp) forControlEvents:UIControlEventTouchUpInside];
    [playOptionsView addSubview:snakeSpeedButtonUp];
    
    snakeSpeedSliderDisplay = [[UILabel alloc] initWithFrame:CGRectMake(snakeSpeedButtonDown.frame.origin.x + snakeSpeedButtonDown.frame.size.width, snakeSpeedButtonDown.frame.origin.y - 5, snakeSpeedButtonUp.frame.origin.x - snakeSpeedButtonUp.frame.size.width - snakeSpeedButtonDown.frame.origin.x, 50)];
    snakeSpeedSliderDisplay.backgroundColor = [UIColor clearColor];
    if ([tempDefaults objectForKey:snakeSpeedDefaultKey]) {
        snakeSpeedSliderDisplay.text = [NSString stringWithFormat:@"%li",(long)[[tempDefaults objectForKey:snakeSpeedDefaultKey] integerValue]];
    } else {
        snakeSpeedSliderDisplay.text = @"8";
    }
    snakeSpeedSliderDisplay.textColor = [UIColor whiteColor];
    snakeSpeedSliderDisplay.font = [UIFont fontWithName:@"Helvetica" size:16];
    snakeSpeedSliderDisplay.textAlignment = NSTextAlignmentCenter;
    [playOptionsView addSubview:snakeSpeedSliderDisplay];
    [self snakeSpeedValueChanged:[snakeSpeedSliderDisplay.text longLongValue]];
    
    if ([tempDefaults objectForKey:obstacleKey]) {
        obstaclesOn = [[tempDefaults objectForKey:obstacleKey] boolValue];
    } else {
        obstaclesOn = YES;
    }
    if ([tempDefaults objectForKey:borderKey]) {
        borderOn = [[tempDefaults objectForKey:borderKey] boolValue];
    } else {
        borderOn = YES;
    }
    if ([tempDefaults objectForKey:powerUpKey]) {
        powerUpsOn = [[tempDefaults objectForKey:powerUpKey] boolValue];
    } else {
        powerUpsOn = YES;
    }
    if ([tempDefaults objectForKey:enemyKey]) {
        enemiesOn = [[tempDefaults objectForKey:enemyKey] boolValue];
    } else {
        enemiesOn = YES;
    }
    
    skipNotPurchasedAlert = YES;
    
    obstacleSwitch = [[UISwitch alloc] initWithFrame:CGRectMake((460 / 2) + 35, snakeSpeedButtonDown.center.y + 55, 79, 39)];
    obstacleSwitch.onTintColor = [UIColor colorWithRed:0.0 green:162.0/255 blue:232.0/255 alpha:1.0];
    [obstacleSwitch addTarget:self action:@selector(obstacleSwitchToggled) forControlEvents:UIControlEventValueChanged];
    [playOptionsView addSubview:obstacleSwitch];
    obstacleSwitchLabel = [[UILabel alloc] initWithFrame:CGRectMake(obstacleSwitch.frame.origin.x - 170, obstacleSwitch.frame.origin.y - 7, 150, 39)];
    obstacleSwitchLabel.text = @"Generate Obstacles";
    obstacleSwitchLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
    obstacleSwitchLabel.backgroundColor = [UIColor clearColor];
    obstacleSwitchLabel.textColor = [UIColor whiteColor];
    obstacleSwitchLabel.textAlignment = NSTextAlignmentRight;
    obstacleSwitch.on = obstaclesOn;
    [self obstacleSwitchToggled];
    [playOptionsView addSubview:obstacleSwitchLabel];
    
    borderSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(obstacleSwitch.frame.origin.x, obstacleSwitch.center.y + 46, 79, 39)];
    borderSwitch.onTintColor = [UIColor colorWithRed:0.0 green:162.0/255 blue:232.0/255 alpha:1.0];
    [borderSwitch addTarget:self action:@selector(borderSwitchToggled) forControlEvents:UIControlEventValueChanged];
    [playOptionsView addSubview:borderSwitch];
    borderSwitchLabel = [[UILabel alloc] initWithFrame:CGRectMake(obstacleSwitch.frame.origin.x - 170, borderSwitch.frame.origin.y - 7, 150, 39)];
    borderSwitchLabel.text = @"Obstacle Border";
    borderSwitchLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
    borderSwitchLabel.backgroundColor = [UIColor clearColor];
    borderSwitchLabel.textColor = [UIColor whiteColor];
    borderSwitchLabel.textAlignment = NSTextAlignmentRight;
    borderSwitch.on = borderOn;
    [self borderSwitchToggled];
    [playOptionsView addSubview:borderSwitchLabel];
    
    powerUpSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(obstacleSwitch.frame.origin.x, borderSwitch.center.y + 46, 79, 39)];
    powerUpSwitch.onTintColor = [UIColor colorWithRed:0.0 green:162.0/255 blue:232.0/255 alpha:1.0];
    [powerUpSwitch addTarget:self action:@selector(powerUpSwitchToggled) forControlEvents:UIControlEventValueChanged];
    [playOptionsView addSubview:powerUpSwitch];
    powerUpSwitchLabel = [[UILabel alloc] initWithFrame:CGRectMake(obstacleSwitch.frame.origin.x - 170, powerUpSwitch.frame.origin.y - 7, 150, 39)];
    powerUpSwitchLabel.text = @"Power Ups";
    powerUpSwitchLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
    powerUpSwitchLabel.backgroundColor = [UIColor clearColor];
    powerUpSwitchLabel.textColor = [UIColor whiteColor];
    powerUpSwitchLabel.textAlignment = NSTextAlignmentRight;
    powerUpSwitch.on = powerUpsOn;
    [self powerUpSwitchToggled];
    [playOptionsView addSubview:powerUpSwitchLabel];
    
    enemySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(obstacleSwitch.frame.origin.x, powerUpSwitch.center.y + 46, 79, 39)];
    enemySwitch.onTintColor = [UIColor colorWithRed:0.0 green:162.0/255 blue:232.0/255 alpha:1.0];
    [enemySwitch addTarget:self action:@selector(enemySwitchToggled) forControlEvents:UIControlEventValueChanged];
    [playOptionsView addSubview:enemySwitch];
    enemySwitchLabel = [[UILabel alloc] initWithFrame:CGRectMake(obstacleSwitch.frame.origin.x - 170, enemySwitch.frame.origin.y - 7, 150, 39)];
    enemySwitchLabel.text = @"Spawn Enemies";
    enemySwitchLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
    enemySwitchLabel.backgroundColor = [UIColor clearColor];
    enemySwitchLabel.textColor = [UIColor whiteColor];
    enemySwitchLabel.textAlignment = NSTextAlignmentRight;
    enemySwitch.on = enemiesOn;
    [self enemySwitchToggled];
    [playOptionsView addSubview:enemySwitchLabel];
    
    ruinsSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(obstacleSwitch.frame.origin.x, enemySwitch.center.y + 46, 79, 39)];
    ruinsSwitch.onTintColor = [UIColor colorWithRed:0.0 green:162.0/255 blue:232.0/255 alpha:1.0];
    [ruinsSwitch addTarget:self action:@selector(ruinsSwitchToggled) forControlEvents:UIControlEventValueChanged];
    [playOptionsView addSubview:ruinsSwitch];
    ruinsSwitchLabel = [[UILabel alloc] initWithFrame:CGRectMake(obstacleSwitch.frame.origin.x - 170, ruinsSwitch.frame.origin.y - 7, 150, 39)];
    ruinsSwitchLabel.text = @"Obstacle Ruins";
    ruinsSwitchLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
    ruinsSwitchLabel.backgroundColor = [UIColor clearColor];
    ruinsSwitchLabel.textColor = [UIColor whiteColor];
    ruinsSwitchLabel.textAlignment = NSTextAlignmentRight;
    ruinsSwitch.on = enemiesOn;
    [playOptionsView addSubview:ruinsSwitchLabel];
    [self ruinsSwitchToggled];
    
    [self updatePlayTabSwitchLabelTextColours];
    skipNotPurchasedAlert = NO;
    
    //***************************************************************** Achievements Tab ***************************************************************
    //achievement list
    achievementsView = [[UIScrollView alloc] initWithFrame:CGRectMake(30, 30 + 50, 250, 805 - 75 - 30 - 50)];
    achievementsView.contentSize = CGSizeMake(250, 1000);
    achievementsView.backgroundColor = menuBackgroundColor;
    achievementsView.bounces = YES;
    achievementsViewTitle = [[UILabel alloc] initWithFrame:CGRectMake(achievementsView.frame.origin.x, achievementsView.frame.origin.y - 50, 250, 50)];
    achievementsViewTitle.text = @"Achievements";
    achievementsViewTitle.textColor = [UIColor whiteColor];
    achievementsViewTitle.textAlignment = NSTextAlignmentCenter;
    achievementsViewTitle.font = [UIFont fontWithName:@"Helvetica" size:20];
    achievementsViewTitle.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Button 250x50.png"]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(75, 20, 150, 50)];
    label.text = @"Coming soon";
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    [achievementsView addSubview:label];
    
    //high score list
    highScoreView = [[UIScrollView alloc] initWithFrame:CGRectMake(30 + 250 + 30, 30 + 50, 250, 805 - 75 - 30 - 50)];
    highScoreView.contentSize = CGSizeMake(250, 1000);
    highScoreView.backgroundColor = menuBackgroundColor;
    highScoreView.bounces = YES;
    highScoreViewTitle = [[UILabel alloc] initWithFrame:CGRectMake(highScoreView.frame.origin.x, highScoreView.frame.origin.y - 50, 250, 50)];
    highScoreViewTitle.text = @"High Scores";
    highScoreViewTitle.textColor = [UIColor whiteColor];
    highScoreViewTitle.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Button 250x50.png"]];
    highScoreViewTitle.textAlignment = NSTextAlignmentCenter;
    highScoreViewTitle.font = [UIFont fontWithName:@"Helvetica" size:20];
    highScoresBlockList = [[NSArray alloc] init];
    [self addHighScores];
    
#pragma mark - Game Centre
    gameCentreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    gameCentreButton.frame = CGRectMake(0, 0, 250, 50);
    gameCentreButton.backgroundColor = [UIColor grayColor];
    [gameCentreButton addTarget:self action:@selector(gameCentreButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [gameCentreButton setTitle:@"Game Centre" forState:UIControlStateNormal];
    gameCentreButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 34, 34)];
    img.image = [UIImage imageNamed:@"Game Centre.png"];
    [gameCentreButton addSubview:img];
    
    gameCentreEnabled = NO;
    [self authenticateLocalPlayer];
    [highScoreView addSubview:gameCentreButton];
    
    //statistics list
    statisticsView = [[UIScrollView alloc] initWithFrame:CGRectMake(30 + 250 + 30 + 250 + 30, 30 + 50, 250, 805 - 75 - 30 - 50)];
    statisticsView.contentSize = CGSizeMake(250, 101 * 10);
    statisticsView.backgroundColor = menuBackgroundColor;
    statisticsView.bounces = YES;
    statisticsViewTitle = [[UILabel alloc] initWithFrame:CGRectMake(statisticsView.frame.origin.x, statisticsView.frame.origin.y - 50, 250, 50)];
    statisticsViewTitle.text = @"Statistics";
    statisticsViewTitle.textColor = [UIColor whiteColor];
    statisticsViewTitle.textAlignment = NSTextAlignmentCenter;
    statisticsViewTitle.font = [UIFont fontWithName:@"Helvetica" size:20];
    statisticsViewTitle.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Button 250x50.png"]];
    [self createAllStatisticsBlocks];
    
    //***************************************************************** Options Tab ******************************************************************
    
    optionsControlTypeSegmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Buttons", @"Swiping", @"Both", nil]];
//    optionsControlTypeSegmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    optionsControlTypeSegmentedControl.frame = CGRectMake(330, 130, 300, 50);
//    [optionsControlTypeSegmentedControl setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor lightGrayColor] forKey:UITextAttributeTextColor] forState:UIControlStateSelected];
    optionsControlTypeSegmentedControl.tintColor = [UIColor clearColor];
    [optionsControlTypeSegmentedControl setBackgroundImage:[UIImage imageNamed:@"Button 100x50 Orange.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//    [optionsControlTypeSegmentedControl setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica" size:16.0f], UITextAttributeFont, [UIColor whiteColor], UITextAttributeTextColor, nil] forState:UIControlStateNormal];
    [optionsControlTypeSegmentedControl addTarget:self action:@selector(setOptionsControlTypeSegmentControl) forControlEvents:UIControlEventValueChanged];
    if ([tempDefaults objectForKey:snakeControlStyle]) {
        if ([[tempDefaults objectForKey:snakeControlStyle] isEqualToString: controlStyleButtons]) {
            [optionsControlTypeSegmentedControl setSelectedSegmentIndex:0];
        } else if ([[tempDefaults objectForKey:snakeControlStyle] isEqualToString: controlStyleSwipe]) {
            [optionsControlTypeSegmentedControl setSelectedSegmentIndex:1];
        } else if ([[tempDefaults objectForKey:snakeControlStyle] isEqualToString: controlStyleBoth]) {
            [optionsControlTypeSegmentedControl setSelectedSegmentIndex:2];
        }
    } else {
        [optionsControlTypeSegmentedControl setSelectedSegmentIndex:2];
        [tempDefaults setObject:controlStyleBoth forKey:snakeControlStyle];
    }
    
    optionsControlTypeSegmentedControlLabel = [[UILabel alloc] initWithFrame:CGRectMake(optionsControlTypeSegmentedControl.frame.origin.x - 160, 0, 150, 25)];
    optionsControlTypeSegmentedControlLabel.center = CGPointMake(optionsControlTypeSegmentedControlLabel.center.x, optionsControlTypeSegmentedControl.center.y);
    optionsControlTypeSegmentedControlLabel.text = @"Control Scheme";
    optionsControlTypeSegmentedControlLabel.backgroundColor = [UIColor clearColor];
    optionsControlTypeSegmentedControlLabel.textColor = [UIColor whiteColor];
    
    optionsSoundEffectSegmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"On", @"Off", nil]];
//    optionsSoundEffectSegmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    optionsSoundEffectSegmentedControl.frame = CGRectMake(380, optionsControlTypeSegmentedControl.frame.origin.y + 100, 200, 50);
//    [optionsSoundEffectSegmentedControl setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor lightGrayColor] forKey:UITextAttributeTextColor] forState:UIControlStateSelected];
    [optionsSoundEffectSegmentedControl setBackgroundImage:[UIImage imageNamed:@"Button 100x50 Orange.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//    [optionsSoundEffectSegmentedControl setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica" size:16.0f], UITextAttributeFont, [UIColor whiteColor], UITextAttributeTextColor, nil] forState:UIControlStateNormal];
    [optionsSoundEffectSegmentedControl addTarget:self action:@selector(setOptionsSoundEffectSegmentControl) forControlEvents:UIControlEventValueChanged];
    optionsSoundEffectSegmentedControl.tintColor = [UIColor clearColor];
    if ([tempDefaults objectForKey:soundEffectsToggle]) {
        if ([[tempDefaults objectForKey:soundEffectsToggle] boolValue] == YES) {
            [optionsSoundEffectSegmentedControl setSelectedSegmentIndex:0];
            soundEffectsOn = YES;
        } else {
            [optionsSoundEffectSegmentedControl setSelectedSegmentIndex:1];
            soundEffectsOn = NO;
        }
    } else {
        [optionsSoundEffectSegmentedControl setSelectedSegmentIndex:0];
        [tempDefaults setBool:YES forKey:soundEffectsToggle];
    }
    
    optionsSoundEffectSegmentedControlLabel = [[UILabel alloc] initWithFrame:CGRectMake(optionsSoundEffectSegmentedControl.frame.origin.x - 160, 0, 150, 25)];
    optionsSoundEffectSegmentedControlLabel.center = CGPointMake(optionsSoundEffectSegmentedControlLabel.center.x, optionsSoundEffectSegmentedControl.center.y);
    optionsSoundEffectSegmentedControlLabel.text = @"Sound Effects";
    optionsSoundEffectSegmentedControlLabel.backgroundColor = [UIColor clearColor];
    optionsSoundEffectSegmentedControlLabel.textColor = [UIColor whiteColor];
    
    optionsMusicSegmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"On", @"Off", nil]];
//    optionsMusicSegmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    optionsMusicSegmentedControl.frame = CGRectMake(380, optionsSoundEffectSegmentedControl.frame.origin.y + 100, 200, 50);
    optionsMusicSegmentedControl.tintColor = [UIColor clearColor];
//    [optionsMusicSegmentedControl setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor lightGrayColor] forKey:UITextAttributeTextColor] forState:UIControlStateSelected];
    [optionsMusicSegmentedControl setBackgroundImage:[UIImage imageNamed:@"Button 100x50 Orange.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//    [optionsMusicSegmentedControl setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica" size:16.0f], UITextAttributeFont, [UIColor whiteColor], UITextAttributeTextColor, nil] forState:UIControlStateNormal];
    [optionsMusicSegmentedControl addTarget:self action:@selector(setOptionsMusicSegmentControl) forControlEvents:UIControlEventValueChanged];
    if ([tempDefaults objectForKey:musicToggle]) {
        if ([[tempDefaults objectForKey:musicToggle] boolValue] == YES) {
            [optionsMusicSegmentedControl setSelectedSegmentIndex:0];
        } else {
            [optionsMusicSegmentedControl setSelectedSegmentIndex:1];
        }
    } else {
        [optionsMusicSegmentedControl setSelectedSegmentIndex:0];
        [tempDefaults setBool:YES forKey:musicToggle];
    }
    
    optionsMusicSegmentedControlLabel = [[UILabel alloc] initWithFrame:CGRectMake(optionsMusicSegmentedControl.frame.origin.x - 85, 0, 75, 25)];
    optionsMusicSegmentedControlLabel.center = CGPointMake(optionsMusicSegmentedControlLabel.center.x, optionsMusicSegmentedControl.center.y);
    optionsMusicSegmentedControlLabel.text = @"Music";
    optionsMusicSegmentedControlLabel.backgroundColor = [UIColor clearColor];
    optionsMusicSegmentedControlLabel.textColor = [UIColor whiteColor];
    
    contactButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [contactButton setTitle:@"Contact Us" forState:UIControlStateNormal];
    [contactButton setBackgroundImage:[UIImage imageNamed:@"Button 100x50 Orange.png"] forState:UIControlStateNormal];
    [contactButton setFrame:CGRectMake(360, optionsMusicSegmentedControl.frame.origin.y + 100, 100, 50)];
    [contactButton addTarget:self action:@selector(contactButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    contactButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0f];
    
    facebookPageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [facebookPageButton setTitle:@"Visit FB Page" forState:UIControlStateNormal];
    [facebookPageButton setBackgroundImage:[UIImage imageNamed:@"Button 100x50 Orange.png"] forState:UIControlStateNormal];
    [facebookPageButton setFrame:CGRectMake(500, optionsMusicSegmentedControl.frame.origin.y + 100, 100, 50)];
    [facebookPageButton addTarget:self action:@selector(facebookButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    facebookPageButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0f];
    
    pleaseSendFeedbackLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 600, 100)];
    pleaseSendFeedbackLabel.numberOfLines = 2;
    [pleaseSendFeedbackLabel setText:@"Serpentine is a very new game and we would much appreciate feedback on our game. We would like this to be the best it can possibly be."];
    pleaseSendFeedbackLabel.textAlignment = NSTextAlignmentCenter;
    pleaseSendFeedbackLabel.center = CGPointMake((contactButton.center.x + facebookPageButton.center.x) / 2, contactButton.center.y + 80);
    pleaseSendFeedbackLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0f];
    pleaseSendFeedbackLabel.textColor = [UIColor whiteColor];
    pleaseSendFeedbackLabel.backgroundColor = [UIColor clearColor];
    
    resetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [resetButton setBackgroundImage:[UIImage imageNamed:@"Button 100x50 Orange.png"] forState:UIControlStateNormal];
    [resetButton addTarget:self action:@selector(resetButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    resetButton.frame = CGRectMake(360, 600, 100, 50);
    [resetButton setTitle:@"Reset Game" forState:UIControlStateNormal];
    [resetButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:14.0f]];
    
    showTutorialButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [showTutorialButton setBackgroundImage:[UIImage imageNamed:@"Button 100x50 Orange.png"] forState:UIControlStateNormal];
    [showTutorialButton addTarget:self action:@selector(showTutorialButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    showTutorialButton.frame = CGRectMake(500, 600, 100, 50);
    [showTutorialButton setTitle:@"Show Tutorial" forState:UIControlStateNormal];
    [showTutorialButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:14.0f]];
    
    //****************************************************************** Shop tab ******************************************************************************
    
    amountOfUpgradePointsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 1000, 25)];
    amountOfUpgradePointsLabel.textColor = [UIColor whiteColor];
    amountOfUpgradePointsLabel.backgroundColor = [UIColor clearColor];
    amountOfUpgradePointsLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
    [self setUpgradePointsLabelText];
    
    adsPurchasedButton = [[ShopButton alloc] initWithTitle:adShopTitle row:1 column:1];
    obstacleBorderPurchasedButton = [[ShopButton alloc] initWithTitle:obstacleBorderShopTitle row:1 column:2];
    obstaclesPurchasedButton = [[ShopButton alloc] initWithTitle:obstaclesShopTitle row:2 column:1];
    powerUpsPurchasedButton = [[ShopButton alloc] initWithTitle:powerUpsShopTitle row:2 column:2];
    obstacleRuinsPurchasedButton = [[ShopButton alloc] initWithTitle:obstacleRuinsShopTitle row:3 column:1];
    enemyPurchasedButton = [[ShopButton alloc] initWithTitle:enemiesShopTitle row:3 column:2];
    [adsPurchasedButton addTarget:self action:@selector(playButtonPressSound) forControlEvents:UIControlEventTouchUpInside];
    [obstacleBorderPurchasedButton addTarget:self action:@selector(playButtonPressSound) forControlEvents:UIControlEventTouchUpInside];
    [obstaclesPurchasedButton addTarget:self action:@selector(playButtonPressSound) forControlEvents:UIControlEventTouchUpInside];
    [obstacleRuinsPurchasedButton addTarget:self action:@selector(playButtonPressSound) forControlEvents:UIControlEventTouchUpInside];
    [powerUpsPurchasedButton addTarget:self action:@selector(playButtonPressSound) forControlEvents:UIControlEventTouchUpInside];
    [enemyPurchasedButton addTarget:self action:@selector(playButtonPressSound) forControlEvents:UIControlEventTouchUpInside];
    adsPurchasedButton.delegate = self;
    obstacleBorderPurchasedButton.delegate = self;
    obstaclesPurchasedButton.delegate = self;
    powerUpsPurchasedButton.delegate = self;
    obstacleRuinsPurchasedButton.delegate = self;
    enemyPurchasedButton.delegate = self;
    
    buyMoreUpgradePointsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [buyMoreUpgradePointsButton setTitle:@"Get more Upgrade Points" forState:UIControlStateNormal];
    [buyMoreUpgradePointsButton.titleLabel setFont:adsPurchasedButton.titleLabel.font];
    [buyMoreUpgradePointsButton addTarget:self action:@selector(notEnoughMoney) forControlEvents:UIControlEventTouchUpInside];
    [buyMoreUpgradePointsButton setBackgroundImage:[UIImage imageNamed:@"Button Buy More.png"] forState:UIControlStateNormal];
    buyMoreUpgradePointsButton.frame = CGRectMake(0, 0, 470, 60);
    buyMoreUpgradePointsButton.transform = CGAffineTransformMakeRotation(90 * (M_PI/180)); //radians = degrees * (pi/180)
    buyMoreUpgradePointsButton.frame = CGRectMake(512 - 30 - 2, 50, buyMoreUpgradePointsButton.frame.size.width, buyMoreUpgradePointsButton.frame.size.height);
    [buyMoreUpgradePointsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    //audio
    NSError *error;
    buttonPressAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Press.wav", [[NSBundle mainBundle] resourcePath]]] error:&error];
    buttonPressAudioPlayer.numberOfLoops = 0;
    
    backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Menu Music.mp3", [[NSBundle mainBundle] resourcePath]]] error:&error];
    backgroundMusicPlayer.numberOfLoops = -1;
    
    [self.view bringSubviewToFront:blackFader];
    [self.view bringSubviewToFront:viewBackground];
    [self.view bringSubviewToFront:_border];
    
    if ([[tempDefaults objectForKey:willSkipTutorial] boolValue] != YES) {
        
        tutorialAskAlert = [[UIAlertView alloc] initWithTitle:@"Serpentine!"
                                                      message:@"Since this is your first time opening this app, would you like to play the tutorial? You can always play it from the options menu at any time."
                                                     delegate:self
                                            cancelButtonTitle:@"No"
                                            otherButtonTitles:@"Yes", nil];
        tutorialAskAlert.tag = 3;
        [tutorialAskAlert show];
    }
}

- (void)authenticateLocalPlayer {
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
        if (localPlayer.isAuthenticated) {
            gameCentreEnabled = YES;
            NSLog(@"gc enabled");
            
        } else {
            gameCentreEnabled = NO;
            NSLog(@"gc disabled");
            [UIView animateWithDuration:0.5f animations:^{
                gameCentreButton.alpha = 0.25f;
            }];
        }
    };
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)reportScore:(int)score forLeaderboardID: (NSString *) identifier
{
    GKScore *scoreReporter = [[GKScore alloc] initWithLeaderboardIdentifier: identifier];
    scoreReporter.value = score;
    scoreReporter.context = 0;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([[defaults objectForKey:lastSubmittedScore] integerValue] != score && score != 0) {
        [GKScore reportScores:[NSArray arrayWithObject:scoreReporter] withCompletionHandler:^(NSError *error) {
            if (!error) {
                NSLog(@"submitted high score successfully");
                [defaults setObject:[NSNumber numberWithInt:score] forKey:lastSubmittedScore];
            } else {
                NSLog(@"couldn't submit high score with error: %@", error);
            }
        }];
    } else {
        if (score == 0) {
            NSLog(@"won't submit a score of 0");
        } else {
            NSLog(@"already submitted high score: %i", score);
        }
    }
}

- (IBAction)gameCentreButtonPressed:(id)sender {
    if (gameCentreEnabled == YES) {
        GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
        gameCenterController.gameCenterDelegate = self;
        if (gameCenterController != nil)
        {
            [self presentViewController: gameCenterController animated: YES completion:nil];
        }
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Serpentine!" message:@"Error: Could not connect to Game Centre Network. Make sure you are connected to the internet and are signed into Game Centre. Trying to connect again..." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        [self authenticateLocalPlayer];
    }
}

- (void)showTutorial {
    tutorialImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Press Play.png"]];
    tutorialImage.frame = CGRectMake(0, 0, 1024, 768);
    tutorialImage.alpha = 0;
    tutorialImage.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *gestureBlocker = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(blankMethod)];
    [tutorialImage addGestureRecognizer:gestureBlocker];
    
    [self.view addSubview:tutorialImage];
    [self.view bringSubviewToFront:tutorialImage];
    [self.view bringSubviewToFront:_playTab];
    
    [UIView animateWithDuration:0.5f animations:^{
        tutorialImage.alpha = 1;
    }];
}

- (void)blankMethod {}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)playBackgroundMusic {
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:musicToggle] boolValue] != NO) [backgroundMusicPlayer play];
}

- (void)playButtonPressSound {
    if (soundEffectsOn == YES) [buttonPressAudioPlayer play];
}

- (void)viewDidAppear:(BOOL)animated {
    [self playBackgroundMusic];
    gameController = nil;
    [self addHighScores];
    [self createAllStatisticsBlocks];
    [self setUpgradePointsLabelText];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:cashKey] longValue] == 8 && [[defaults objectForKey:obstaclesPurchased] boolValue] != YES && [[defaults objectForKey:hasAskedAboutPurchasingObstacles] boolValue] != YES) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Serpentine!" message:@"Looks like you have enough Upgrade Points do unlock the obstacles. Would you like to get it now?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        alert.tag = 5;
        [alert show];
        
    } else if ([[defaults objectForKey:hasAskedAboutFacebook] boolValue] != YES && [[defaults objectForKey:gamesPlayedKey] integerValue] > 10) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Serpentine!" message:@"Serpentine is a new game and needs some help in spreading the word. It would be much appreciated if you liked our Facebook Page. Would you like to go there now?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        alert.tag = 6;
        [alert show];
        
        [defaults setBool:YES forKey:hasAskedAboutFacebook];
        
    } else if ([[defaults objectForKey:hasAskedAboutRating] boolValue] != YES && [[defaults objectForKey:gamesPlayedKey] integerValue] > 20) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Serpentine!" message:@"Do you like Serpentine? If you do could you rate it on the App Store, it would help a lot. Would you like to do that now?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        alert.tag = 7;
        [alert show];
        
        [defaults setBool:YES forKey:hasAskedAboutRating];
    }
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated
}

#pragma mark - Play Tab //***********************************************************************************************************

- (IBAction)playTapTapped:(UITapGestureRecognizer *)sender {
    _shopTab.userInteractionEnabled = NO;
    if (soundEffectsOn == YES) [buttonPressAudioPlayer play];
    
    if (_playTab.center.y < 300) {
        [self updatePlayTabSwitchLabelTextColours];
        viewBackground.contentMode = UIViewContentModeBottomLeft;
        viewBackground.frame = CGRectMake(2, -760, 1020, 760);
        [self removeAllControls];
        [self addPlayTabControls];
        blackFader.alpha = 0;
        blackFader.hidden = NO;
        [self.view bringSubviewToFront:blackFader];
        [self.view bringSubviewToFront:_playTab];
        [self.view bringSubviewToFront:viewBackground];
        [self.view bringSubviewToFront:_border];
        
        //if tutorial
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:willSkipTutorial] boolValue] != YES) {
            [UIView animateWithDuration:0.5f animations:^{
                viewBackground.center = CGPointMake(512, 764 - _playTab.frame.size.height - (viewBackground.frame.size.height / 2));
                _playTab.center = CGPointMake(512, 764 - (_playTab.frame.size.height / 2));
                blackFader.alpha = 0.75;
                tutorialImage.alpha = 0;
            } completion:^(BOOL finished) { //tutorial
                [self.view bringSubviewToFront:_border];
                
                [tutorialImage setImage:[UIImage imageNamed:@"Press Start.png"]];
                
                [tutorialImage removeFromSuperview];
                tutorialImage.frame = CGRectMake(-2, 146, 1024, 768);
                [viewBackground addSubview:tutorialImage];
                [viewBackground bringSubviewToFront:tutorialImage];
                [viewBackground bringSubviewToFront:startButton];
                _playTab.userInteractionEnabled = NO;
                _shopTab.userInteractionEnabled = NO;
                
                [UIView animateWithDuration:0.5f animations:^{
                    tutorialImage.alpha = 1;
                }];
            }];
        } else {
            //if not tutorial
            [UIView animateWithDuration:0.5f animations:^{
                viewBackground.center = CGPointMake(512, 764 - _playTab.frame.size.height - (viewBackground.frame.size.height / 2));
                _playTab.center = CGPointMake(512, 764 - (_playTab.frame.size.height / 2));
                blackFader.alpha = 0.75;
            } completion:^(BOOL finished) { //ad
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:adsPurchased] boolValue] != YES) {
                    [_mainAdBanners setTop];
                    _mainAdBanners.alpha = 0;
                }
                [self.view addSubview:_mainAdBanners];
                [self.view bringSubviewToFront:_mainAdBanners];
                [self.view bringSubviewToFront:_border];
                [_mainAdBanners addAdsToSubview];
                [UIView animateWithDuration:0.25f animations:^{
                    _mainAdBanners.alpha = 1;
                } completion:^(BOOL finished) {
                    [playOptionsView flashScrollIndicators];
                }];
            }];
        }
        
    } else {
        [UIView animateWithDuration:0.25f animations:^{_mainAdBanners.alpha = 0;} completion:^(BOOL finished) { //ad
            [_mainAdBanners removeFromSuperview];
            [UIView animateWithDuration:0.5f animations:^{
                viewBackground.center = CGPointMake(512, 4 - (viewBackground.frame.size.height / 2));
                _playTab.center = CGPointMake(512, _playTab.frame.size.height / 2 + 4);
                blackFader.alpha = 0.0;
            } completion:^(BOOL finished) {
                _shopTab.userInteractionEnabled = YES;
                if (autoOpenShopTab == YES) {
                    [self shopTapTapped:nil];
                }
            }];
        }];
    }
}

- (void)speedUp {
    long long a = [snakeSpeedSliderDisplay.text longLongValue];
    if (a < 15) {
        a++;
        [self snakeSpeedValueChanged:a];
    }
}

- (void)speedDown {
    long long a = [snakeSpeedSliderDisplay.text longLongValue];
    if (a > 0) {
        a--;
        [self snakeSpeedValueChanged:a];
    }
}

- (void)snakeSpeedValueChanged:(long long)b {
    if (soundEffectsOn == YES) [buttonPressAudioPlayer play];
    snakeSpeedSliderDisplay.text = [NSString stringWithFormat:@"%lli", b];
    if (b == 0) {
        snakeSpeedSliderDisplay.text = @"Turbo!";
    }
    NSUserDefaults *snakeSpeedDefault = [NSUserDefaults standardUserDefaults];
    [snakeSpeedDefault setInteger:b forKey:snakeSpeedDefaultKey];
    [snakeSpeedDefault synchronize];
}

- (void)obstacleSwitchToggled {
    if (soundEffectsOn == YES) [buttonPressAudioPlayer play];
    NSUserDefaults *tempDefaults = [NSUserDefaults standardUserDefaults];
    if ([[tempDefaults objectForKey:obstaclesPurchased] boolValue] != YES) {
        [tempDefaults setBool:NO forKey:obstacleKey];
        [obstacleSwitch setOn:NO];
        if (skipNotPurchasedAlert == NO) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Serpentine!" message:@"You haven't unlocked this yet. Earn upgrade points by eating food then buy this from the shop." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
    } else {
        [tempDefaults setBool:obstacleSwitch.on forKey:obstacleKey];
    }
    
    if (obstacleSwitch.on == NO && ruinsSwitch.on == YES){
        ruinsSwitch.on = NO;
        [self ruinsSwitchToggled];
    }
    [tempDefaults synchronize];
}

- (void)borderSwitchToggled {
    if (soundEffectsOn == YES) [buttonPressAudioPlayer play];
    NSUserDefaults *tempDefaults = [NSUserDefaults standardUserDefaults];
    if ([[tempDefaults objectForKey:obstacleBorderPurchased] boolValue] != YES) {
        [tempDefaults setBool:NO forKey:borderKey];
        [borderSwitch setOn:NO];
        if (skipNotPurchasedAlert == NO) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Serpentine!" message:@"You haven't unlocked this yet. Earn upgrade points by eating food then buy this from the shop." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
    } else {
        [tempDefaults setBool:borderSwitch.on forKey:borderKey];
    }
    [tempDefaults synchronize];
}

- (void)powerUpSwitchToggled {
    if (soundEffectsOn == YES) [buttonPressAudioPlayer play];
    NSUserDefaults *tempDefaults = [NSUserDefaults standardUserDefaults];
    if ([[tempDefaults objectForKey:powerUpsPurchased] boolValue] != YES) {
        [tempDefaults setBool:NO forKey:powerUpKey];
        [powerUpSwitch setOn:NO];
        if (skipNotPurchasedAlert == NO) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Serpentine!" message:@"You haven't unlocked this yet. Earn upgrade points by eating food then buy this from the shop." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
    } else {
        [tempDefaults setBool:powerUpSwitch.on forKey:powerUpKey];
    }
    [tempDefaults synchronize];
}

- (void)ruinsSwitchToggled {
    if (soundEffectsOn == YES) [buttonPressAudioPlayer play];
    NSUserDefaults *tempDefaults = [NSUserDefaults standardUserDefaults];
    if ([[tempDefaults objectForKey:obstacleRuinsPurchased] boolValue] != YES) {
        [tempDefaults setBool:NO forKey:ruinsKey];
        [ruinsSwitch setOn:NO];
        if (skipNotPurchasedAlert == NO) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Serpentine!" message:@"You haven't unlocked this yet. Earn upgrade points by eating food then buy this from the shop." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
    } else {
        [tempDefaults setBool:ruinsSwitch.on forKey:ruinsKey];
    }
    
    if (obstacleSwitch.on == NO && ruinsSwitch.on == YES){
        ruinsSwitch.on = NO;
        [self ruinsSwitchToggled];
    }
    [tempDefaults synchronize];
}


- (void)enemySwitchToggled {
    if (soundEffectsOn == YES) [buttonPressAudioPlayer play];
    NSUserDefaults *tempDefaults = [NSUserDefaults standardUserDefaults];
    if ([[tempDefaults objectForKey:enemiesPurchased] boolValue] != YES) {
        [tempDefaults setBool:NO forKey:enemyKey];
        [enemySwitch setOn:NO];
        if (skipNotPurchasedAlert == NO) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Serpentine!" message:@"You haven't unlocked this yet. Earn upgrade points by eating food then buy this from the shop." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
    } else {
        [tempDefaults setBool:enemySwitch.on forKey:enemyKey];
    }
    [tempDefaults synchronize];
}

- (void)updatePlayTabSwitchLabelTextColours {
    NSUserDefaults *tempDefaults = [NSUserDefaults standardUserDefaults];
    if ([[tempDefaults objectForKey:obstaclesPurchased] boolValue] != YES) {obstacleSwitchLabel.textColor = [UIColor lightGrayColor];obstacleSwitch.alpha = 0.5;}
    if ([[tempDefaults objectForKey:obstacleBorderPurchased] boolValue] != YES) {borderSwitchLabel.textColor = [UIColor lightGrayColor];borderSwitch.alpha = 0.5;}
    if ([[tempDefaults objectForKey:powerUpsPurchased] boolValue] != YES) {powerUpSwitchLabel.textColor = [UIColor lightGrayColor];powerUpSwitch.alpha = 0.5;}
    if ([[tempDefaults objectForKey:enemiesPurchased] boolValue] != YES) {enemySwitchLabel.textColor = [UIColor lightGrayColor];enemySwitch.alpha = 0.5;}
    if ([[tempDefaults objectForKey:obstacleRuinsPurchased] boolValue] != YES) {ruinsSwitchLabel.textColor = [UIColor lightGrayColor];ruinsSwitch.alpha = 0.5;}
    
    if ([[tempDefaults objectForKey:obstaclesPurchased] boolValue] == YES) {obstacleSwitchLabel.textColor = [UIColor whiteColor];obstacleSwitch.alpha = 1;}
    if ([[tempDefaults objectForKey:obstacleBorderPurchased] boolValue] == YES) {borderSwitchLabel.textColor = [UIColor whiteColor];borderSwitch.alpha = 1;}
    if ([[tempDefaults objectForKey:powerUpsPurchased] boolValue] == YES) {powerUpSwitchLabel.textColor = [UIColor whiteColor];powerUpSwitch.alpha = 1;}
    if ([[tempDefaults objectForKey:enemiesPurchased] boolValue] == YES) {enemySwitchLabel.textColor = [UIColor whiteColor];enemySwitch.alpha = 1;}
    if ([[tempDefaults objectForKey:obstacleRuinsPurchased] boolValue] == YES) {ruinsSwitchLabel.textColor = [UIColor whiteColor];ruinsSwitch.alpha = 1;}
}

- (void)startButtonPressed {
    [backgroundMusicPlayer stop];
    if (soundEffectsOn == YES) [buttonPressAudioPlayer play];
    gameController = nil;
    gameController = [[GameViewController alloc] initWithNibName:nil bundle:nil];
    [self presentViewController:gameController animated:YES completion:^{[self setPlayAndShopTabInteractionToYes];}];
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(setPlayAndShopTabInteractionToYes) userInfo:nil repeats:NO];
}

- (void)setPlayAndShopTabInteractionToYes {
    [_playTab setUserInteractionEnabled:YES];
    _shopTab.userInteractionEnabled = NO;
    [tutorialImage removeFromSuperview];
}

#pragma mark - Achievements Tab //********************************************************************************************

- (IBAction)achievementTapTapped:(UITapGestureRecognizer *)sender {
    if (soundEffectsOn == YES) [buttonPressAudioPlayer play];
    if (_achievementTab.center.x < 300) {
        viewBackground.contentMode = UIViewContentModeTopRight;
        viewBackground.frame = CGRectMake(2 - (1020 - _achievementTab.frame.size.width), 4, 1020 - _achievementTab.frame.size.width, 760);
        [self removeAllControls];
        [self addAchievementTabControls];
        blackFader.alpha = 0;
        blackFader.hidden = NO;
        [self.view bringSubviewToFront:blackFader];
        [self.view bringSubviewToFront:_achievementTab];
        [self.view bringSubviewToFront:viewBackground];
        [self.view bringSubviewToFront:_border];
        [UIView animateWithDuration:0.5f animations:^{
            viewBackground.center = CGPointMake(1022 - _achievementTab.frame.size.width - (viewBackground.frame.size.width / 2), 768 / 2);
            _achievementTab.center = CGPointMake(1022 - (_achievementTab.frame.size.width / 2), 768 / 2);
            blackFader.alpha = 0.75;
        }];
    } else {
        [UIView animateWithDuration:0.5f animations:^{
            viewBackground.center = CGPointMake(0 - (viewBackground.frame.size.width / 2), 768 / 2);
            _achievementTab.center = CGPointMake(2 + (_achievementTab.frame.size.width / 2), 768 / 2);
            blackFader.alpha = 0.0;
        }];
    }
}

- (void)addHighScores {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *arrayOfScores = [[NSMutableArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:highScoreKey]]];
    [self removeAllHighScoreBlocks];
    
    //filter out 0's and hackers' scores
    
    if (arrayOfScores.count > 0) {
        BOOL scoresAreFine = NO;
        while (scoresAreFine == NO) {
            for (int a = 0; a < arrayOfScores.count; a++) {
                HighScoreObject *obj = arrayOfScores[a];
                if (obj.score == 0 || obj.score > cheatingThreshold) {
                    [arrayOfScores removeObjectAtIndex:a];
                    break;
                } else if (a == arrayOfScores.count - 1) {
                    scoresAreFine = YES;
                }
            }
        }
    }
    
    if (arrayOfScores.count > 0) {
        for (int a = 0; a < arrayOfScores.count && a < 100; a++) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 101 * a + 51, 250, 100)];
            view.backgroundColor = [UIColor grayColor];
            [highScoreView addSubview:view];
            UISwipeGestureRecognizer *leftDeleteGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(askDeleteHighScores)];
            leftDeleteGesture.direction = UISwipeGestureRecognizerDirectionLeft;
            [view addGestureRecognizer:leftDeleteGesture];
            UISwipeGestureRecognizer *rightDeleteGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(askDeleteHighScores)];
            rightDeleteGesture.direction = UISwipeGestureRecognizerDirectionRight;
            [view addGestureRecognizer:rightDeleteGesture];
            
            HighScoreObject *highScoreObject = arrayOfScores[a];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 30, 150, 50)];
            label.text = [NSString stringWithFormat:@"%@", highScoreObject.name];
            label.textColor = [UIColor whiteColor];
            label.backgroundColor = [UIColor clearColor];
            label.textAlignment = NSTextAlignmentLeft;
            label.font = [UIFont fontWithName:@"Helvetica" size:17];
            label.textAlignment = NSTextAlignmentLeft;
            label.numberOfLines = 0;
            [label sizeToFit];
            [view addSubview:label];
            UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(100, 60, 150, 40)];
            label2.text = [NSString stringWithFormat:@"%i", highScoreObject.score];
            label2.textColor = [UIColor whiteColor];
            label2.backgroundColor = [UIColor clearColor];
            label2.textAlignment = NSTextAlignmentLeft;
            label2.font = [UIFont fontWithName:@"Helvetica" size:24];
            [view addSubview:label2];
            
            //game centre
            if (gameCentreEnabled == YES && a == 0) [self reportScore:highScoreObject.score forLeaderboardID:@"SHS"];
            
            UIImageView *greyBack = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 90, 90)];
            greyBack.backgroundColor = [UIColor darkGrayColor];
            greyBack.image = [UIImage imageNamed:@"90x90square.png"];
            greyBack.clipsToBounds = YES;
            greyBack.contentMode = UIViewContentModeTopLeft;
            [view addSubview:greyBack];
            if (a < 9) {
                UIImageView *num = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 50)];
                num.center = CGPointMake(45, 45);
                
                NSString *string = @"n";
                string = [string stringByAppendingString:[NSString stringWithFormat:@"%i", a + 1]];
                string = [string stringByAppendingString:@".png"];
                
                num.image = [UIImage imageNamed:string];
                [greyBack addSubview:num];
            } else {
                int b = a + 1;
                int firstDigit = b;
                do {
                    firstDigit -= 10;
                    if (firstDigit == 10) firstDigit = 0;
                    if (firstDigit == 0) break;
                } while (firstDigit > 10);
                int secondDigit = floor(b / 10);
                
                UIImageView *num = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 50)];
                num.center = CGPointMake(45 + 20, 45);
                NSString *string = @"n";
                string = [string stringByAppendingString:[NSString stringWithFormat:@"%i", firstDigit]];
                string = [string stringByAppendingString:@".png"];
                num.image = [UIImage imageNamed:string];
                [greyBack addSubview:num];
                
                UIImageView *num2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 50)];
                num2.center = CGPointMake(45 - 20, 45);
                string = @"n";
                string = [string stringByAppendingString:[NSString stringWithFormat:@"%i", secondDigit]];
                string = [string stringByAppendingString:@".png"];
                num2.image = [UIImage imageNamed:string];
                [greyBack addSubview:num2];
            }
            
            highScoresBlockList = [highScoresBlockList arrayByAddingObject:view];
        }
    }
    highScoreView.contentSize = CGSizeMake(250, 101 * arrayOfScores.count + 51);
}

- (void)removeAllHighScoreBlocks {
    if (highScoresBlockList.count != 0) {
        for (int a = 0; a <= highScoresBlockList.count - 1; a++) {
            [highScoresBlockList[a] removeFromSuperview];
        }
    }
}

- (void)askDeleteHighScores {
    if (soundEffectsOn == YES) [buttonPressAudioPlayer play];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Serpentine!" message:@"Are you sure you want to delete all high scores?" delegate:self cancelButtonTitle:@"No!" otherButtonTitles:@"Yes", nil];
    [alert show];
}

- (void)createAllStatisticsBlocks {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [self createStatisticBlock:0 Title:@"Squares moved" andScore:[[defaults objectForKey:stepsKey] longValue]];
    [self createStatisticBlock:1 Title:@"Food blocks eaten" andScore:[[defaults objectForKey:foodEatenKey] integerValue]];
    [self createStatisticBlock:2 Title:@"Enemies eaten" andScore:[[defaults objectForKey:enemiesEatenKey] integerValue]];
    [self createStatisticBlock:3 Title:@"Bullet wounds" andScore:[[defaults objectForKey:hitsByBulletKey] integerValue]];
    [self createStatisticBlock:4 Title:@"Power ups eaten" andScore:[[defaults objectForKey:powerUpsEatenKey] integerValue]];
    [self createStatisticBlock:5 Title:@"Deaths by obstacle" andScore:[[defaults objectForKey:deathsByObstacleKey] integerValue]];
    [self createStatisticBlock:6 Title:@"Deaths by self" andScore:[[defaults objectForKey:deathsBySelfKey] integerValue]];
    [self createStatisticBlock:7 Title:@"Current Upgrade Points" andScore:[[defaults objectForKey:cashKey] integerValue]];
    [self createStatisticBlock:8 Title:@"Total Upgrade Points Earned" andScore:[[defaults objectForKey:cashEarnedKey] integerValue]];
    [self createStatisticBlock:9 Title:@"Games Played" andScore:[[defaults objectForKey:gamesPlayedKey] integerValue]];
}

- (void)createStatisticBlock:(int)row Title:(NSString *)title andScore:(long)score {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 101 * row, 250, 100)];
    view.backgroundColor = [UIColor grayColor];
    [statisticsView addSubview:view];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 30, 150, 50)];
    label.text = [NSString stringWithFormat:@"%@", title];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont fontWithName:@"Helvetica" size:17];
    label.textAlignment = NSTextAlignmentLeft;
    label.numberOfLines = 0;
    [label sizeToFit];
    [view addSubview:label];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(100, 60, 150, 40)];
    label2.text = [NSString stringWithFormat:@"%li", score];
    label2.textColor = [UIColor whiteColor];
    label2.backgroundColor = [UIColor clearColor];
    label2.textAlignment = NSTextAlignmentLeft;
    label2.font = [UIFont fontWithName:@"Helvetica" size:24];
    [view addSubview:label2];
    
    UIImageView *greyBack = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 90, 90)];
    greyBack.backgroundColor = [UIColor darkGrayColor];
    if (row == 0) greyBack.image = [UIImage imageNamed:@"Squares Moved.png"];
    if (row == 1) greyBack.image = [UIImage imageNamed:@"Food Eaten.png"];
    if (row == 2) greyBack.image = [UIImage imageNamed:@"Enemies Eaten.png"];
    if (row == 3) greyBack.image = [UIImage imageNamed:@"Hits by Bullet.png"];
    if (row == 4) greyBack.image = [UIImage imageNamed:@"Power Ups Eaten.png"];
    if (row == 5) greyBack.image = [UIImage imageNamed:@"Obstacle Deaths.png"];
    if (row == 6) greyBack.image = [UIImage imageNamed:@"Self Deaths.png"];
    if (row == 7) greyBack.image = [UIImage imageNamed:@"Upgrade Points.png"];
    if (row == 8) greyBack.image = [UIImage imageNamed:@"Total Upgrade Points.png"];
    if (row == 9) greyBack.image = [UIImage imageNamed:@"Games Played.png"];
    greyBack.clipsToBounds = YES;
    greyBack.contentMode = UIViewContentModeTopLeft;
    [view addSubview:greyBack];
}


#pragma mark - Shop Tab //********************************************************************************************

- (IBAction)shopTapTapped:(UITapGestureRecognizer *)sender {
    _playTab.userInteractionEnabled = NO;
    if (soundEffectsOn == YES) [buttonPressAudioPlayer play];
    if (_shopTab.center.y > 500) {
        viewBackground.contentMode = UIViewContentModeBottomLeft;
        viewBackground.frame = CGRectMake(2, 764, 1020, 760);
        [self removeAllControls];
        [self addShopTabControls];
        blackFader.alpha = 0;
        blackFader.hidden = NO;
        [self.view bringSubviewToFront:blackFader];
        [self.view bringSubviewToFront:_shopTab];
        [self.view bringSubviewToFront:viewBackground];
        [self.view bringSubviewToFront:_border];
        [UIView animateWithDuration:0.5f animations:^{
            viewBackground.center = CGPointMake(512, 768 / 2 + _shopTab.frame.size.height);
            _shopTab.center = CGPointMake(512, 4 + (_shopTab.frame.size.height / 2));
            blackFader.alpha = 0.75;
        } completion:^(BOOL finished) {
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:adsPurchased] boolValue] != YES) {
                [_mainAdBanners setBottom];
                _mainAdBanners.alpha = 0;
            }
            [self.view addSubview:_mainAdBanners];
            [self.view bringSubviewToFront:_mainAdBanners];
            [self.view bringSubviewToFront:_border];
            [UIView animateWithDuration:0.25f animations:^{
                _mainAdBanners.alpha = 1;
            }];
            
            //8 upgrade points
            if (autoOpenShopTab == YES) {
                [self show8UpgradePointTutorial];
            }
        }];
        
    } else {
        [UIView animateWithDuration:0.25f animations:^{_mainAdBanners.alpha = 0;} completion:^(BOOL finished) {
            [_mainAdBanners removeFromSuperview];
            [UIView animateWithDuration:0.5f animations:^{
                viewBackground.center = CGPointMake(512, 764 + (760 / 2));
                _shopTab.center = CGPointMake(512, 764 - (_shopTab.frame.size.height / 2));
                blackFader.alpha = 0.0;
            } completion:^(BOOL finished) {
                _playTab.userInteractionEnabled = YES;
            }];
        }];
    }
}

- (void)show8UpgradePointTutorial {
    cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
    cover.backgroundColor = [UIColor blackColor];
    cover.alpha = 0;
    [viewBackground addSubview:cover];
    
    [viewBackground bringSubviewToFront:cover];
    [viewBackground bringSubviewToFront:obstaclesPurchasedButton];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:hasAskedAboutPurchasingObstacles];
    
    [UIView animateWithDuration:0.5f animations:^{
        cover.alpha = 0.75;
    }];
}

- (void)setUpgradePointsLabelText {
    amountOfUpgradePointsLabel.text = [NSString stringWithFormat:@"Upgrade Points: %i", [[[NSUserDefaults standardUserDefaults] objectForKey:cashKey] intValue]];
}

- (void)updateUpgradePointLabelWithPurchasedButtonTitle:(NSString *)title {
    [self setUpgradePointsLabelText];
    if ([title isEqualToString:obstacleBorderShopTitle]) borderSwitch.on = YES;
    if ([title isEqualToString:obstaclesShopTitle]) obstacleSwitch.on = YES;
    if ([title isEqualToString:obstacleRuinsShopTitle]) ruinsSwitch.on = YES;
    if ([title isEqualToString:powerUpsShopTitle]) powerUpSwitch.on = YES;
    if ([title isEqualToString:enemiesShopTitle]) enemySwitch.on = YES;
}

- (void)adsJustPurchased {
    [UIView animateWithDuration:0.25f animations:^{_mainAdBanners.alpha = 0;}];
    [_mainAdBanners removeFromSuperview];
    [_mainAdBanners setHidden:YES];
    _mainAdBanners = nil;
}

- (void)notEnoughMoney {
    buyWindowController = [[BuyWindowViewController alloc] initWithNibName:@"BuyWindowViewController" bundle:nil];
    buyWindowController.delegate = self;
    buyWindowController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    buyWindowController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:buyWindowController animated:YES completion:nil];
}

- (void)adsButtonPressed {
    [self notEnoughMoney];
}

- (void)refreshAdButton {
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:adsPurchased] boolValue]) {
        [self adsJustPurchased];
        [adsPurchasedButton refreshAdButtonWithTitle:adShopTitle];
    }
}

- (void)refreshCash {
    [self setUpgradePointsLabelText];
}

- (void)hide8UpgradePointTutorial {
    [UIView animateWithDuration:0.5f animations:^{
        cover.alpha = 0;
    } completion:^(BOOL finished) {
        [cover removeFromSuperview];
        cover = nil;
    }];
}

#pragma mark - Options Tab //********************************************************************************************

- (IBAction)optionsTapTapped:(UITapGestureRecognizer *)sender {
    if (soundEffectsOn == YES) [buttonPressAudioPlayer play];
    if (_optionsTab.center.x > 700) {
        viewBackground.contentMode = UIViewContentModeBottomLeft;
        viewBackground.frame = CGRectMake(1022, 2, 1020 - _optionsTab.frame.size.width, 760);
        [self removeAllControls];
        [self addOptionsTabControls];
        blackFader.alpha = 0;
        blackFader.hidden = NO;
        [self.view bringSubviewToFront:blackFader];
        [self.view bringSubviewToFront:_optionsTab];
        [self.view bringSubviewToFront:viewBackground];
        [self.view bringSubviewToFront:_border];
        [UIView animateWithDuration:0.5f animations:^{
            viewBackground.center = CGPointMake((1024 + _achievementTab.frame.size.width) / 2, 768 / 2);
            _optionsTab.center = CGPointMake(2 + (_optionsTab.frame.size.width / 2), 768 / 2);
            blackFader.alpha = 0.6;
        }];
    } else {
        [UIView animateWithDuration:0.5f animations:^{
            viewBackground.center = CGPointMake(1022 + (viewBackground.frame.size.width / 2), 768 / 2);
            _optionsTab.center = CGPointMake(1022 - (_achievementTab.frame.size.width / 2), 768 / 2);
            blackFader.alpha = 0.0;
        }];
    }
}

- (void)resetButtonPressed {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Serpentine!" message:@"Are you sure you want to reset all your progress? The double upgrade points and remove iAds feature will not be reset if you have purchased them." delegate:self cancelButtonTitle:@"No!" otherButtonTitles:@"Yes", nil];
    alert.delegate = self;
    alert.tag = 2;
    [alert show];
}

- (void)showTutorialButtonPressed {
    cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
    cover.backgroundColor = [UIColor blackColor];
    cover.alpha = 0;
    [self.view addSubview:cover];
    [UIView animateWithDuration:0.5f animations:^{cover.alpha = 1;} completion:^(BOOL finished) {
        if (finished == YES) {
            self.view.alpha = 0;
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:willSkipTutorial];
            [self optionsTapTapped:nil];
            [self showTutorial];
            [self.view bringSubviewToFront:cover];
            [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(showTutorial2) userInfo:nil repeats:NO];
        }
    }];
}

- (void)showTutorial2 {
    self.view.alpha = 1;
    [UIView animateWithDuration:1.0f animations:^{cover.alpha = 0;} completion:^(BOOL finished) {
        if (finished) [cover removeFromSuperview];
    }];
}

- (void)setOptionsControlTypeSegmentControl {
    if (soundEffectsOn == YES) [buttonPressAudioPlayer play];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (optionsControlTypeSegmentedControl.selectedSegmentIndex == 0) {
        [defaults setObject:controlStyleButtons forKey:snakeControlStyle];
    } else if (optionsControlTypeSegmentedControl.selectedSegmentIndex == 1) {
        [defaults setObject:controlStyleSwipe forKey:snakeControlStyle];
    } else if (optionsControlTypeSegmentedControl.selectedSegmentIndex == 2) {
        [defaults setObject:controlStyleBoth forKey:snakeControlStyle];
    }
}

- (void)setOptionsSoundEffectSegmentControl {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (optionsSoundEffectSegmentedControl.selectedSegmentIndex == 0) {
        [defaults setBool:YES forKey:soundEffectsToggle];
        soundEffectsOn = YES;
    } else {
        [defaults setBool:NO forKey:soundEffectsToggle];
        soundEffectsOn = NO;
    }
    if (optionsSoundEffectSegmentedControl.selectedSegmentIndex == 0) [buttonPressAudioPlayer play];
}

- (void)setOptionsMusicSegmentControl {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (optionsMusicSegmentedControl.selectedSegmentIndex == 0) {
        [defaults setBool:YES forKey:musicToggle];
    } else {
        [defaults setBool:NO forKey:musicToggle];
        [backgroundMusicPlayer stop];
    }
    if (optionsMusicSegmentedControl.selectedSegmentIndex == 0) [self playBackgroundMusic];
}

- (void)contactButtonPressed {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:piguygames@gmail.com?Subject=Serpentine%21%3A%20"]];
}

- (void)facebookButtonPressed {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.facebook.com/SerpentinePiGuyGames"]];
}

- (void)rateButtonPressed {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/serpentine!/id721180099?mt=8"]];
}

#pragma mark - Add/Remove Tab Controls //************************************************************************************

- (void)removeAllControls {
    [self removePlayTabControls];
    [self removeAchievementTabControls];
    [self removeShopTabControls];
    [self removeOptionsTabControls];
}

- (void)addPlayTabControls {
    [viewBackground addSubview:playOptionsView];
    [viewBackground addSubview:playOptionsTitle];
    [viewBackground addSubview:startButton];
    [viewBackground addSubview:helpButton];
}

- (void)removePlayTabControls {
    [playOptionsView removeFromSuperview];
    [playOptionsTitle removeFromSuperview];
    [startButton removeFromSuperview];
    [helpButton removeFromSuperview];
}

- (void)addAchievementTabControls {
    [viewBackground addSubview:achievementsView];
    [viewBackground addSubview:achievementsViewTitle];
    [viewBackground addSubview:highScoreView];
    [viewBackground addSubview:highScoreViewTitle];
    [viewBackground addSubview:statisticsView];
    [viewBackground addSubview:statisticsViewTitle];
}

- (void)removeAchievementTabControls {
    [achievementsView removeFromSuperview];
    [achievementsViewTitle removeFromSuperview];
    [highScoreView removeFromSuperview];
    [highScoreViewTitle removeFromSuperview];
    [statisticsView removeFromSuperview];
    [statisticsViewTitle removeFromSuperview];
}

- (void)addShopTabControls {
    [viewBackground addSubview:amountOfUpgradePointsLabel];
    [viewBackground addSubview:adsPurchasedButton];
    [viewBackground addSubview:obstacleBorderPurchasedButton];
    [viewBackground addSubview:obstaclesPurchasedButton];
    [viewBackground addSubview:obstacleRuinsPurchasedButton];
    [viewBackground addSubview:powerUpsPurchasedButton];
    [viewBackground addSubview:enemyPurchasedButton];
    [viewBackground addSubview:buyMoreUpgradePointsButton];
}

- (void)removeShopTabControls {
    [amountOfUpgradePointsLabel removeFromSuperview];
    [adsPurchasedButton removeFromSuperview];
    [obstacleBorderPurchasedButton removeFromSuperview];
    [obstaclesPurchasedButton removeFromSuperview];
    [obstacleRuinsPurchasedButton removeFromSuperview];
    [powerUpsPurchasedButton removeFromSuperview];
    [enemyPurchasedButton removeFromSuperview];
    [buyMoreUpgradePointsButton removeFromSuperview];
}

- (void)addOptionsTabControls {
    [viewBackground addSubview:optionsControlTypeSegmentedControl];
    [viewBackground addSubview:optionsControlTypeSegmentedControlLabel];
    [viewBackground addSubview:optionsSoundEffectSegmentedControl];
    [viewBackground addSubview:optionsSoundEffectSegmentedControlLabel];
    [viewBackground addSubview:contactButton];
    [viewBackground addSubview:optionsMusicSegmentedControlLabel];
    [viewBackground addSubview:optionsMusicSegmentedControl];
    [viewBackground addSubview:pleaseSendFeedbackLabel];
    [viewBackground addSubview:resetButton];
    [viewBackground addSubview:showTutorialButton];
    [viewBackground addSubview:facebookPageButton];
}

- (void)removeOptionsTabControls {
    [optionsControlTypeSegmentedControl removeFromSuperview];
    [optionsControlTypeSegmentedControlLabel removeFromSuperview];
    [optionsSoundEffectSegmentedControl removeFromSuperview];
    [optionsSoundEffectSegmentedControlLabel removeFromSuperview];
    [contactButton removeFromSuperview];
    [optionsMusicSegmentedControlLabel removeFromSuperview];
    [optionsMusicSegmentedControl removeFromSuperview];
    [pleaseSendFeedbackLabel removeFromSuperview];
    [resetButton removeFromSuperview];
    [showTutorialButton removeFromSuperview];
    [facebookPageButton removeFromSuperview];
}

#pragma mark - Other Stuff //*********************************************************************************************

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (soundEffectsOn == YES) [buttonPressAudioPlayer play];
    if (alertView.tag == 3) {
        //initial tutorial
        if (buttonIndex == 1) {
            [self showTutorial];
        } else {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:willSkipTutorial];
        }
    } else if (alertView.tag == 2) {
        if (buttonIndex == 1) {
            [self resetGame];
        }
    } else if (alertView.tag == 5) {
        //8 upgrade points
        if (buttonIndex == 1) {
            autoOpenShopTab = YES;
            
            if (_playTab.frame.origin.y > 400) {
                [self playTapTapped:nil];
            } else {
                [self shopTapTapped:nil];
            }
        }
    } else if (alertView.tag == 6) {
        //facebook prompt
        if (buttonIndex == 1) {
            [self facebookButtonPressed];
        }
        
    } else if (alertView.tag == 7) {
        //rate prompt
        if (buttonIndex == 1) {
            [self rateButtonPressed];
        }
        
    } else {
        if (buttonIndex == 1) { //yes
                                //reset high scores
            [self removeAllHighScoreBlocks];
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:highScoreKey];
        }
    }
}

- (void)resetGame {
    [self removeAllHighScoreBlocks];
    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    [d setObject:nil forKey:highScoreKey];
    
    [d setBool:NO forKey:willSkipTutorial];
    
    [d setInteger:0 forKey:stepsKey];
    [d setInteger:0 forKey:foodEatenKey];
    [d setInteger:0 forKey:enemiesEatenKey];
    [d setInteger:0 forKey:hitsByBulletKey];
    [d setInteger:0 forKey:powerUpsEatenKey];
    [d setInteger:0 forKey:deathsByObstacleKey];
    [d setInteger:0 forKey:deathsBySelfKey];
    [d setInteger:0 forKey:cashEarnedKey];
    [d setInteger:0 forKey:gamesPlayedKey];
    [d setInteger:0 forKey:cashKey];
    
    [d setBool:NO forKey:obstacleBorderPurchased];
    [d setBool:NO forKey:obstaclesPurchased];
    [d setBool:NO forKey:obstacleRuinsPurchased];
    [d setBool:NO forKey:powerUpsPurchased];
    [d setBool:NO forKey:enemiesPurchased];
    
    [d setBool:YES forKey:soundEffectsToggle];
    [d setBool:YES forKey:musicToggle];
    
    [d setInteger:0 forKey:lastDateShownFullScreenAdOnMainScreen];
    
    [d setObject:controlStyleBoth forKey:snakeControlStyle];
    
    [d synchronize];
    
    [UIView animateWithDuration:0.5f animations:^{
        viewBackground.center = CGPointMake(1022 + (viewBackground.frame.size.width / 2), 768 / 2);
        _optionsTab.center = CGPointMake(1022 - (_achievementTab.frame.size.width / 2), 768 / 2);
        blackFader.alpha = 0.0;
    } completion:^(BOOL finished) {
        [viewBackground removeFromSuperview];
        viewBackground = nil;
        [self viewDidLoad];
    }];
}

- (void)viewDidUnload {
    [self setAchievementTab:nil];
    [super viewDidUnload];
}

- (void)interstitialAd:(ADInterstitialAd *)interstitialAd didFailWithError:(NSError *)error {
    NSLog(@"main full screen error");
}

- (void)interstitialAdDidLoad:(ADInterstitialAd *)interstitialAd {
    NSLog(@"main full screen loaded");
    
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    NSString *dateString = [dateFormat stringFromDate:today];
    
    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    NSLog(@"date: %@ and %@", dateString, [d objectForKey:lastDateShownFullScreenAdOnMainScreen]);
    if (![dateString isEqualToString: [d objectForKey:lastDateShownFullScreenAdOnMainScreen]]) {
        [d setObject:dateString forKey:lastDateShownFullScreenAdOnMainScreen];
        NSLog(@"show");
        [self requestInterstitialAdPresentation];
    }
}

- (void)interstitialAdDidUnload:(ADInterstitialAd *)interstitialAd {
    NSLog(@"main full screen unloaded");
    
}

- (void)showHelp:(UIButton *)sender {
    helpController = [[HelpController alloc] initWithNibName:@"HelpController" bundle:nil];
    helpController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    helpController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:helpController animated:YES completion:nil];
    [helpController goToPage:sender.tag];
}

@end