//
//	GameViewController.m
//	Snake
//
//	Created by Dylan Chong on 7/10/12.
//	Copyright (c) 2012 Dylan Chong. All rights reserved.
//

#import "GameViewController.h"

//debug options
#define powerUpSpawnsInstantly NO
#define enemySpawnsInstantly NO
#define quickFood NO
#define cheatScore NO
#define instantDeath NO
#define addLotsOfScores YES
#define startWithCheaterScore NO

@interface GameViewController ()

@end

@implementation GameViewController

#pragma mark - Important View and Loading Stuff

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
    
    fadeSpeed = 0.025;
    
    self.view.multipleTouchEnabled = YES;
    
    delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.shouldPause = NO;
    
    border = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
    border.image = [UIImage imageNamed:@"border.png"];
    [self.view addSubview:border];
    background = [[UIImageView alloc] initWithFrame:CGRectMake(2, 4, 1020, 760)];
    background.image = [UIImage imageNamed:@"1.png"];
    [self.view addSubview:background];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:adsPurchased] boolValue] != YES) {
        _gameAdBanners = [[MultiAdHandler alloc] initAtTopOfScreen:NO andRootViewController:self];
        
        _fullScreenAd = [[ADInterstitialAd alloc] init];
        _fullScreenAd.delegate = self;
    }
    
    float buttonAlpha = 0.45;
    
    pauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [pauseButton addTarget:self action:@selector(threeFingerDoubleTap) forControlEvents:UIControlEventTouchUpInside];
    [pauseButton setFrame:CGRectMake(972, 14, 40, 40)];
    pauseButton.alpha = buttonAlpha;
    [pauseButton setBackgroundImage:[UIImage imageNamed:@"Pause Button.png"] forState:UIControlStateNormal];
    [self.view addSubview:pauseButton];
    
    NSError *error;
    NSUserDefaults *tempDefaults = [NSUserDefaults standardUserDefaults];
    soundEffectsOn = [[tempDefaults objectForKey:soundEffectsToggle] boolValue];
    
    boostButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    boostButton.frame = CGRectMake(2 + 50, 768 - 4 - 100 - 50, 100, 100);
    [boostButton addTarget:self action:@selector(boostButtonDown) forControlEvents:UIControlEventTouchDown];
    [boostButton addTarget:self action:@selector(boostButtonUp) forControlEvents:UIControlEventTouchUpInside];
    [boostButton addTarget:self action:@selector(boostButtonUp) forControlEvents:UIControlEventTouchUpOutside];
    boostButton.alpha = buttonAlpha;
    [boostButton setBackgroundImage:[UIImage imageNamed:@"Control Image Boost.png"] forState:UIControlStateNormal];
    
    [self.view addSubview:boostButton];
    
    directionArray = [[NSMutableArray alloc] init];
    
    //swipes
    if ([[tempDefaults objectForKey:snakeControlStyle] isEqualToString:controlStyleSwipe] || [[tempDefaults objectForKey:snakeControlStyle] isEqualToString:controlStyleBoth]) {
        leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft)];
        leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
        [self.view addGestureRecognizer:leftSwipe];
        rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight)];
        rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
        [self.view addGestureRecognizer:rightSwipe];
        downSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDown)];
        downSwipe.direction = UISwipeGestureRecognizerDirectionDown;
        [self.view addGestureRecognizer:downSwipe];
        upSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUp)];
        upSwipe.direction = UISwipeGestureRecognizerDirectionUp;
        [self.view addGestureRecognizer:upSwipe];
    }
    
    if ([[tempDefaults objectForKey:snakeControlStyle] isEqualToString:controlStyleButtons] || [[tempDefaults objectForKey:snakeControlStyle] isEqualToString:controlStyleBoth]) {
        //buttons
        leftButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        leftButton.frame = CGRectMake(1024 - 300 - 2 - 50, 768 - 4 - 100 - 50, 100, 100);
        [leftButton addTarget:self action:@selector(swipeLeft) forControlEvents:UIControlEventTouchDown];
        leftButton.alpha = buttonAlpha;
        [leftButton setBackgroundImage:[UIImage imageNamed:@"Control Image.png"] forState:UIControlStateNormal];
        [self.view addSubview:leftButton];
        
        rightButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        rightButton.frame = CGRectMake(1024 - 100 - 2 - 50, 768 - 4 - 100 - 50, 100, 100);
        [rightButton addTarget:self action:@selector(swipeRight) forControlEvents:UIControlEventTouchDown];
        rightButton.alpha = buttonAlpha;
        [rightButton setBackgroundImage:[UIImage imageNamed:@"Control Image.png"] forState:UIControlStateNormal];
        [self.view addSubview:rightButton];
        
        downButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        downButton.frame = CGRectMake(1024 - 2 - 200 - 50, 768 - 4 - 100 - 50, 100, 100);
        [downButton addTarget:self action:@selector(swipeDown) forControlEvents:UIControlEventTouchDown];
        downButton.alpha = buttonAlpha - 0.1;
        [downButton setBackgroundImage:[UIImage imageNamed:@"Control Image.png"] forState:UIControlStateNormal];
        [self.view addSubview:downButton];
        
        upButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        upButton.frame = CGRectMake(1024 - 2 - 200 - 50, 768 - 4 - 200 - 50, 100, 100);
        [upButton addTarget:self action:@selector(swipeUp) forControlEvents:UIControlEventTouchDown];
        upButton.alpha = buttonAlpha;
        [upButton setBackgroundImage:[UIImage imageNamed:@"Control Image.png"] forState:UIControlStateNormal];
        [self.view addSubview:upButton];
        
        //button dragger
        directionButtonDrag = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(directionButtonDragPan:)];
        directionButtonDrag.minimumNumberOfTouches = 3;
        directionButtonDrag.maximumNumberOfTouches = 3;
        [self.view addGestureRecognizer:directionButtonDrag];
    }
    
    //statistics
    steps = [[tempDefaults objectForKey:stepsKey] longValue];
    if (!steps) steps = 0;
    foodEaten = [[tempDefaults objectForKey:foodEatenKey] longValue];
    if (!foodEaten) foodEaten = 0;
    enemiesEaten = [[tempDefaults objectForKey:enemiesEatenKey] longValue];
    if (!enemiesEaten) enemiesEaten = 0;
    hitsByBullet = [[tempDefaults objectForKey:hitsByBulletKey] longValue];
    if (!hitsByBullet) hitsByBullet = 0;
    powerUpsEaten = [[tempDefaults objectForKey:powerUpsEatenKey] longValue];
    if (!powerUpsEaten) powerUpsEaten = 0;
    deathsByObstacle = [[tempDefaults objectForKey:deathsByObstacleKey] longValue];
    if (!deathsByObstacle) deathsByObstacle = 0;
    deathsBySelf = [[tempDefaults objectForKey:deathsBySelfKey] longValue];
    if (!deathsBySelf) deathsBySelf = 0;
    
    //get toggle values
    obstaclesOn = [[tempDefaults objectForKey:obstacleKey] boolValue];
    borderOn = [[tempDefaults objectForKey:borderKey] boolValue];
    powerUpsOn = [[tempDefaults objectForKey:powerUpKey] boolValue];
    ruinsOn = [[tempDefaults objectForKey:ruinsKey] boolValue];
    enemiesOn = [[tempDefaults objectForKey:enemyKey] boolValue];
    if ([tempDefaults objectForKey:cashKey]) {
        cash = [[tempDefaults objectForKey:cashKey] intValue];
    } else {
        cash = 0;
    }
    
    //create snake head and body
	listOfSnakeParts = nil;
    UIImageView *snakePartTempStorage;
    snakePartTempStorage = [[UIImageView alloc] initWithFrame:CGRectMake(512, 374, 10, 10)];
    snakePartTempStorage.image = [UIImage imageNamed:@"bluedot.png"];
    snakePartTempStorage.opaque = TRUE;
    listOfSnakeParts = nil;
    listOfSnakeParts = [[NSMutableArray alloc] initWithObjects:snakePartTempStorage, nil];
    for (int i = 0; i < 10; i++) {
        [self createSnakePart];
        snakePartTempStorage = [listOfSnakeParts lastObject];
        snakePartTempStorage.center = CGPointMake(snakePartTempStorage.center.x - 10, snakePartTempStorage.center.y);
    }
    [self.view addSubview:listOfSnakeParts[0]];
    [self.view bringSubviewToFront:listOfSnakeParts[0]];
    [self.view bringSubviewToFront:border];
    
    //obstacles
	listOfObstacles = nil;
    if (obstaclesOn == YES) {
        UIImageView *obstacleTempStorage = [[UIImageView alloc] initWithFrame:CGRectMake(2, 4, 10, 10)];
        int randomNumber = arc4random() % 5 + 1;
        if (randomNumber == 1) obstacleTempStorage.image = [UIImage imageNamed:@"reddot.png"];
        if (randomNumber == 2) obstacleTempStorage.image = [UIImage imageNamed:@"reddot2.png"];
        if (randomNumber == 3) obstacleTempStorage.image = [UIImage imageNamed:@"reddot3.png"];
        if (randomNumber == 4) obstacleTempStorage.image = [UIImage imageNamed:@"reddot4.png"];
        if (randomNumber == 5) obstacleTempStorage.image = [UIImage imageNamed:@"reddot5.png"];
        listOfObstacles = [[NSMutableArray alloc] initWithObjects:obstacleTempStorage, nil];
        [listOfObstacles removeLastObject];
        for (int a = 0; a < 10 + arc4random() % 20; a++) {
            [self createObstacleFormation];
        }
    }
    if (borderOn == YES) {
        if (!listOfObstacles) listOfObstacles = [[NSMutableArray alloc] init];
        [self createBorder];
    }
    
    //ruins
    if (ruinsOn == YES && (borderOn == YES || obstaclesOn == YES)) {
        for (int a = 0; a < (50 + arc4random() % 50); a++) {
            if (arc4random() % 3 == 0) {
                
                //remove object
                if (listOfObstacles.count > 25) {
                    int b = arc4random() % (listOfObstacles.count - 1);
                    [listOfObstacles[b] removeFromSuperview];
                    [listOfObstacles removeObjectAtIndex:b];
                }
            } else {
                if (arc4random() % 3 != 0) {
                    //create object
                    UIImageView *temp = listOfObstacles[arc4random() % (listOfObstacles.count - 1)];
                    int direction;
                    CGPoint location;
                    do {
                        direction = arc4random() % 4;
                        if (arc4random() % 50 == 0) {
                            direction = -1;
                            location = CGPointZero;
                            break;
                        }
                        
                        if (direction == 0) {
                            location = CGPointMake(temp.frame.origin.x, temp.frame.origin.y - 10);
                        } else if (direction == 1) {
                            location = CGPointMake(temp.frame.origin.x + 10, temp.frame.origin.y);
                        } else if (direction == 2) {
                            location = CGPointMake(temp.frame.origin.x, temp.frame.origin.y + 10);
                        } else {
                            location = CGPointMake(temp.frame.origin.x - 10, temp.frame.origin.y);
                        }
                    } while ([self squareIsEmpty:location] == NO);
                    
                    if (location.x != 0 && location.y != 0) {
                        [self createObstaclePart:location];
                    }
                } else {
                    [self createObstaclePart:[self getRandomEmptySquare]];
                }
            }
        }
    }
    
    //power ups
	powerUp = nil;
    powerUpTime = 25;
    powerUpType = 1;
    powerUpDescription = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    powerUp.center = CGPointMake(-20, -20);
    powerUpDescription.text = @"Invincibility";
    powerUpDescription.font = [UIFont fontWithName:@"Helvetica" size:25];
    powerUpDescription.textAlignment = NSTextAlignmentCenter;
    powerUpDescription.textColor = [UIColor whiteColor];
    powerUpDescription.backgroundColor = [UIColor clearColor];
    if (powerUpsOn == YES) {
        powerUp = [[UIImageView alloc] initWithFrame:CGRectMake(-10, -10, 10, 10)];
        powerUpSpawnTime = 500;
        powerUpAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Power Up.wav", [[NSBundle mainBundle] resourcePath]]] error:&error];
        powerUpAudioPlayer.numberOfLoops = 0;
    }
    
    //food
	food = nil;
    food = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    food.image = [UIImage imageNamed:@"greendot.png"];
    [self createFoodWithGlow:NO];
    [self.view addSubview:food];
    
    //set snake speed
    NSUserDefaults *snakeSpeedDefault = [NSUserDefaults standardUserDefaults];
    snakeSpeed = [[snakeSpeedDefault objectForKey:snakeSpeedDefaultKey] intValue];
    snakeSpeedDefault = nil;
    nextDirection = 1;
    snakeDirection = 1;
    if (snakeSpeed == 0) snakeSpeed = 0.1;
    snakeSpeed /= 75;
    
    //score label
    scoreLabel = nil;
    scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(105, 25, 900, 20)];
    scoreLabel.text = @"0";
    int x = 1000000 + arc4random() % 1000000;
    if (startWithCheaterScore == YES) scoreLabel.text = [NSString stringWithFormat:@"%i", x];
    scoreLabel.backgroundColor = [UIColor clearColor];
    scoreLabel.textColor = [UIColor whiteColor];
    scoreLabel.font = [UIFont fontWithName:@"Helvetica" size:25];
    scoreLabel.alpha = 0.75;
    scoreLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:scoreLabel];
    [self.view bringSubviewToFront:scoreLabel];
    
    scoreLabelLabel = nil;
    scoreLabelLabel = [[UILabel alloc] initWithFrame:CGRectMake(23, 25, 100, 20)];
    scoreLabelLabel.text = @"Score:";
    scoreLabelLabel.backgroundColor = [UIColor clearColor];
    scoreLabelLabel.textColor = [UIColor whiteColor];
    scoreLabelLabel.font = [UIFont fontWithName:@"Helvetica" size:25];
    scoreLabelLabel.alpha = 0.75;
    scoreLabelLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:scoreLabelLabel];
    [self.view bringSubviewToFront:scoreLabelLabel];
    
    scoreLabel2 = nil;
    scoreLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];
    scoreLabel2.backgroundColor = [UIColor clearColor];
    scoreLabel2.textColor = [UIColor whiteColor];
    scoreLabel2.font = [UIFont fontWithName:@"Helvetica" size:25];
    scoreLabel2.hidden = YES;
    scoreLabel2.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:scoreLabel2];
    [self.view bringSubviewToFront:scoreLabel2];
    
    pauseMenuBackground = nil;
    pauseMenuBackground = [[UIImageView alloc] initWithFrame:CGRectMake(2, 4, 1020, 760)];
    pauseMenuBackground.backgroundColor = [UIColor blackColor];
    pauseMenuBackground.alpha = 0;
	
    for (int a = 0; a < listOfSnakeParts.count; a++) {
        [self.view bringSubviewToFront:[listOfSnakeParts objectAtIndex:a]];
    }
    [self.view sendSubviewToBack:background];
    
    quitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [quitButton setBackgroundImage:[UIImage imageNamed:@"Button 200x50"] forState:UIControlStateNormal];
    quitButton.alpha = 0;
    quitButton.frame = CGRectMake(512 - 100, 450, 200, 50);
    [quitButton setTitle:@"Hold to Quit" forState:UIControlStateNormal];
    UILongPressGestureRecognizer *quitPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(quitButtonHeld)];
    quitPress.numberOfTouchesRequired = 1;
    quitPress.minimumPressDuration = 0.6;
    [quitButton addGestureRecognizer:quitPress];
    
    resumeLabel = nil;
    resumeLabel = [[UILabel alloc] initWithFrame:CGRectMake(512 - 230, 275, 460, 100)];
	resumeLabel.backgroundColor = [UIColor clearColor];
    resumeLabel.textAlignment = NSTextAlignmentCenter;
    resumeLabel.textColor = [UIColor whiteColor];
    resumeLabel.font = [UIFont fontWithName:@"Helvetica" size:40];
	resumeLabel.alpha = 0;
    resumeLabel.text = @"Paused";
    
	//enemy stuff
    [_enemy removeFromSuperview];
    _enemy = nil;
    _enemyBullet = nil;
    enemyWillMoveNext = nil;
    enemyAlive = nil;
    enemyBulletAlive = nil;
    enemyBulletSpawnTime = nil;
    enemyMoveDirection = nil;
    enemyMoveStepsLeft = nil;
    enemyBulletDirection = nil;
    
    if (enemiesOn == YES) {
        _enemy= [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        _enemy.image = [UIImage imageNamed:@"whitedot.png"];
        if (enemySpawnsInstantly == YES) enemySpawnTime = 10;
        else enemySpawnTime = 1000;
        enemyWillMoveNext = NO;
        _enemyBullet = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        _enemyBullet.image = [UIImage imageNamed:@"bulletwhite.png"];
        
        enemySpawnAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Enemy Spawn.wav", [[NSBundle mainBundle] resourcePath]]] error:&error];
        enemySpawnAudioPlayer.numberOfLoops = 0;
        
        shootAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Shoot.wav", [[NSBundle mainBundle] resourcePath]]] error:&error];
        shootAudioPlayer.numberOfLoops = 0;
    }
	
    dead = NO;
    
    [self.view bringSubviewToFront:leftButton];
    [self.view bringSubviewToFront:rightButton];
    [self.view bringSubviewToFront:downButton];
    [self.view bringSubviewToFront:upButton];
    [self.view bringSubviewToFront:boostButton];
    
    //audio
    buttonPressAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Press.wav", [[NSBundle mainBundle] resourcePath]]] error:&error];
    buttonPressAudioPlayer.numberOfLoops = 0;
    
    crashAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Crash.wav", [[NSBundle mainBundle] resourcePath]]] error:&error];
    crashAudioPlayer.numberOfLoops = 0;
    
    eatAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Eat.wav", [[NSBundle mainBundle] resourcePath]]] error:&error];
    eatAudioPlayer.numberOfLoops = 0;
    
    if ([[tempDefaults objectForKey:musicToggle] boolValue] != NO) {
        if (arc4random() % 2 == 0) backgroundAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/8bit Dungeon Boss.mp3", [[NSBundle mainBundle] resourcePath]]] error:&error];
        else backgroundAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Video Dungeon Boss.mp3", [[NSBundle mainBundle] resourcePath]]] error:&error];
        backgroundAudioPlayer.numberOfLoops = -1;
        [backgroundAudioPlayer play];
    }
    
    //tap to start
    self.view.userInteractionEnabled = NO;
    _tutorialImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Tap to Start.png"]];
    _tutorialImage.frame = CGRectMake(0, 0, 1024, 768);
    _tutorialImage.userInteractionEnabled = YES;
    _tutorialImage.alpha = 0;
    [self.view addSubview:_tutorialImage];
    [self.view bringSubviewToFront:_tutorialImage];
    [UIView animateWithDuration:0.5f animations:^{
        _tutorialImage.alpha = 1;
    } completion:^(BOOL finished) {
        if ([[tempDefaults objectForKey:willSkipTutorial] boolValue] != YES) {
            [_tutorialImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endLoading)]];
        } else {
            [_tutorialImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeTutorial)]];
        }
        
        [self.view addSubview:_tutorialImage];
        self.view.userInteractionEnabled = YES;
    }];
}

- (void)showGlowWithColourAt:(CGPoint)point colourText:(NSString *)text andReversed:(BOOL) reversed {
    Glow_Effect *glow = [Glow_Effect returnGlowObjectAt:point withColourText:text];
    [self.view addSubview:glow];
    [self.view bringSubviewToFront:glow];
    if (reversed) glow.reversed = YES;
    [glow startAnimation];
}

- (void)closeTutorial {
    self.view.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.5f animations:^{
        _tutorialImage.alpha = 0;
    } completion:^(BOOL finished) {
        [self startGame];
        self.view.userInteractionEnabled = YES;
        [_tutorialImage removeFromSuperview];
        _tutorialImage = nil;
    }];
}

- (void)endLoading {
    if (soundEffectsOn == YES) [buttonPressAudioPlayer play];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:willSkipTutorial] boolValue] != YES) {
        self.view.userInteractionEnabled = NO;
        [UIView animateWithDuration:0.5f animations:^{
            _tutorialImage.alpha = 0;
        } completion:^(BOOL finished) {
            [_tutorialImage removeFromSuperview];
            _tutorialImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Game Start Help.png"]];
            _tutorialImage.frame = CGRectMake(0, 0, 1024, 768);
            _tutorialImage.userInteractionEnabled = YES;
            _tutorialImage.alpha = 0;
            [self.view addSubview:_tutorialImage];
            [UIView animateWithDuration:0.5f animations:^{
                _tutorialImage.alpha = 1;
            } completion:^(BOOL finished) {
                self.view.userInteractionEnabled = YES;
                [_tutorialImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeTutorial)]];
            }];
        }];
    } else {
        [self.view removeGestureRecognizer:tapToStart];
        [self startGame];
    }
    
}

- (void)startGame {
    delegate.shouldPause = NO;
    tapToStart = nil;
    
    //set up timer
    snakeMoveTimer = [NSTimer scheduledTimerWithTimeInterval:snakeSpeed target:self selector:@selector(snakeMoveTimerTick) userInfo:nil repeats:YES];
    [self powerUpDescriptionPopup];
    threeFingerDoubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(threeFingerDoubleTap)];
    threeFingerDoubleTap.numberOfTapsRequired = 2;
    threeFingerDoubleTap.numberOfTouchesRequired = 3;
    [self.view addGestureRecognizer:threeFingerDoubleTap];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

#pragma mark - Creation and Checking

- (void)createSnakePart {
    snakePartTemplate = [[UIImageView alloc] initWithFrame:[[listOfSnakeParts objectAtIndex:listOfSnakeParts.count - 1] frame]];
    snakePartTemplate.image = [UIImage imageNamed:@"orangedot2.png"];
    snakePartTemplate.opaque = TRUE;
    [listOfSnakeParts addObject:snakePartTemplate];
    [self.view addSubview:listOfSnakeParts.lastObject];
}

- (void)addSnakeParts:(int)parts {
    for (int a = 0; a < parts; a++) {
        [self createSnakePart];
    }
    
    //bring parts to front
    for (UIImageView *img in listOfSnakeParts) {
        [self.view bringSubviewToFront:img];
    }
}

- (void)createFoodWithGlow:(BOOL)glow {
    timeSinceFoodSpawn = 0;
    CGPoint randomPoint;
    BOOL placeIsAcceptable = NO;
    CGRect frame = CGRectMake(0, 0, 0, 0);
    while (placeIsAcceptable == NO) {
        randomPoint = [self getRandomEmptySquare];
        frame = CGRectMake(randomPoint.x, randomPoint.y, 10, 10);
        if ((frame.origin.x > 180 && frame.origin.x < 600) || frame.origin.y < 450) {
            placeIsAcceptable = YES;
        }
    }
    
    if (quickFood == YES) {
        //food spawn in front of snake
        UIImageView *img = listOfSnakeParts[0];
        frame = img.frame;
        if (snakeDirection == 0) frame.origin.y -= 20;
        if (snakeDirection == 1) frame.origin.x += 20;
        if (snakeDirection == 2) frame.origin.y += 20;
        if (snakeDirection == 3) frame.origin.x -= 20;
    }
    
    food.frame = frame;
    
    if (glow == YES) [self showGlowWithColourAt:frame.origin colourText:@"green" andReversed:NO];
    
}

- (CGPoint)getRandomEmptySquare {
    CGPoint randomPoint;
    do {
        randomPoint = CGPointMake((arc4random() % 102 + 1) * 10 + 2, (arc4random() % 76 + 1) * 10 + 4);
    } while ([self squareIsEmpty:randomPoint] == NO);
    
    return randomPoint;
}

- (BOOL)squareIsEmpty:(CGPoint)pointToCheck {
    UIImageView *snakePartTempStorage;
	
    //check snake head and body
    for (int i = 0; i < listOfSnakeParts.count; i++) {
        snakePartTempStorage = listOfSnakeParts[i];
        if (snakePartTempStorage.frame.origin.x == pointToCheck.x  && snakePartTempStorage.frame.origin.y == pointToCheck.y) {
            return NO;
        }
    }
    
    //check food
    if (food.frame.origin.x == pointToCheck.x && food.frame.origin.y == pointToCheck.y) return NO;
    
    //check obstacles
    if (listOfObstacles.count > 0) {
        for (int i = 0; i < listOfObstacles.count; i++) {
            snakePartTempStorage = listOfObstacles[i];
            if (snakePartTempStorage.frame.origin.x == pointToCheck.x && snakePartTempStorage.frame.origin.y == pointToCheck.y) {
                return NO;
            }
        }
    }
    
    //check power up
    if (pointToCheck.x == powerUp.frame.origin.x && pointToCheck.y == powerUp.frame.origin.y) return NO;
    
    //check for enemy and bullet
    if (pointToCheck.x == _enemy.frame.origin.x && pointToCheck.y == _enemy.frame.origin.y && enemyAlive == YES) return NO;
    if (pointToCheck.x == _enemyBullet.frame.origin.x && pointToCheck.y == _enemyBullet.frame.origin.y && enemyBulletAlive == YES) return NO;;
    
    //check screen bounds
    if (pointToCheck.x < 2 || pointToCheck.x > 1012 || pointToCheck.y < 4 || pointToCheck.y > 754) return NO;
    
    return YES;
}

- (void)createBorder {
    //top border
    for (int i = 2; i <= 1012; i += 10) {
        [self createObstaclePart:CGPointMake(i, 4)];
    }
    
    //bottom border
    for (int i = 2; i <= 1012; i += 10) {
        [self createObstaclePart:CGPointMake(i, 754)];
    }
    
    //left border
    for (int i = 14; i <= 754; i += 10) {
        [self createObstaclePart:CGPointMake(2, i)];
    }
    
    //right border
    for (int i = 4; i <= 754; i += 10) {
        [self createObstaclePart:CGPointMake(1012, i)];
    }
}

- (void)createObstaclePart:(CGPoint)atLocation {
    if ([self squareIsEmpty:atLocation] == YES) {
        UIImageView *obstacleTempStorage = [[UIImageView alloc] initWithFrame:CGRectMake(atLocation.x, atLocation.y, 10, 10)];
        int randomNumber = arc4random() % 5 + 1;
        if (randomNumber == 1) obstacleTempStorage.image = [UIImage imageNamed:@"reddot.png"];
        if (randomNumber == 2) obstacleTempStorage.image = [UIImage imageNamed:@"reddot2.png"];
        if (randomNumber == 3) obstacleTempStorage.image = [UIImage imageNamed:@"reddot3.png"];
        if (randomNumber == 4) obstacleTempStorage.image = [UIImage imageNamed:@"reddot4.png"];
        if (randomNumber == 5) obstacleTempStorage.image = [UIImage imageNamed:@"reddot5.png"];
        [listOfObstacles addObject:obstacleTempStorage];
        [self.view addSubview:[listOfObstacles lastObject]];
    }
}

- (void)createObstacleFormation {
    [self createObstaclePart:[self getRandomEmptySquare]];
    [self.view addSubview:[listOfObstacles lastObject]];
    
    UIImageView *tempObstacle = [listOfObstacles lastObject];
    CGPoint temp = tempObstacle.frame.origin;
    tempObstacle = nil;
    int direction = (arc4random() % 4);
    
    for (int a = 0; a < (arc4random() % 25) + 25; a++) {
        if (direction == 0) {
            if ([self squareIsEmpty:CGPointMake(temp.x, temp.y - 10)] == YES) {
                [self createObstaclePart:CGPointMake(temp.x, temp.y - 10)];
                temp = CGPointMake(temp.x, temp.y - 10);
            } else {
                direction = (arc4random() % 4);
                a--;
            }
        } else if (direction == 1) {
            if ([self squareIsEmpty:CGPointMake(temp.x + 10, temp.y)] == YES) {
                [self createObstaclePart:CGPointMake(temp.x + 10, temp.y)];
                temp = CGPointMake(temp.x + 10, temp.y);
            } else {
                direction = (arc4random() % 4);
                a--;
            }
        } else if (direction == 2) {
            if ([self squareIsEmpty:CGPointMake(temp.x, temp.y + 10)] == YES) {
                [self createObstaclePart:CGPointMake(temp.x, temp.y + 10)];
                temp = CGPointMake(temp.x, temp.y + 10);
            } else {
                direction = (arc4random() % 4);
                a--;
            }
        } else if (direction == 3) {
            if ([self squareIsEmpty:CGPointMake(temp.x - 10, temp.y)] == YES) {
                [self createObstaclePart:CGPointMake(temp.x - 10, temp.y)];
                temp = CGPointMake(temp.x - 10, temp.y);
            } else {
                direction = (arc4random() % 4);
                a--;
            }
        }
        
        if (arc4random() % 8 == 1) {
            direction = (arc4random() % 4);
        }
        
        if (arc4random() % 100 == 1) {
            break;
        }
    }
}

- (void)createPowerUp {
    powerUpSpawnTime = 300 + arc4random() % 200;
    CGPoint powerUpLocation = [self getRandomEmptySquare];
    powerUp.frame = CGRectMake(powerUpLocation.x, powerUpLocation.y, 10, 10);
    powerUpType = 1 + arc4random() % 3;
    if (powerUpType == 1) powerUp.image = [UIImage imageNamed:@"bluedot.png"]; //invincibility
    if (powerUpType == 2) powerUp.image = [UIImage imageNamed:@"yellowdot.png"]; //double score
    if (powerUpType == 3) powerUp.image = [UIImage imageNamed:@"purpledot.png"]; //slow down
    
    if (powerUpType == 1) [self showGlowWithColourAt:powerUpLocation colourText:@"blue" andReversed:NO];
    if (powerUpType == 2) [self showGlowWithColourAt:powerUpLocation colourText:@"yellow" andReversed:NO];
    if (powerUpType == 3) [self showGlowWithColourAt:powerUpLocation colourText:@"purple" andReversed:NO];
    
    [self.view addSubview:powerUp];
    [self.view bringSubviewToFront:powerUp];
}

- (void)eatPowerUp {
    soundToPlay = @"Power Up";
    powerUpsEaten += 1;
    powerUpSpawnTime = -1;
    [powerUp removeFromSuperview];
    powerUpTime = round(500 + ([scoreLabel.text integerValue] / 100));
    powerUp.center = CGPointMake(-20, -20);
    UIImageView *tempSnakeHead = listOfSnakeParts[0];
    if (powerUpType == 1) tempSnakeHead.image = [UIImage imageNamed:@"bluedot.png"];
    if (powerUpType == 2) tempSnakeHead.image = [UIImage imageNamed:@"yellowdot.png"];
    if (powerUpType == 3) tempSnakeHead.image = [UIImage imageNamed:@"purpledot.png"];
    
    UIImageView *img = listOfSnakeParts[0];
    CGPoint location = img.frame.origin;
    if (powerUpType == 1) [self showGlowWithColourAt:location colourText:@"blue" andReversed:NO];
    if (powerUpType == 2) [self showGlowWithColourAt:location colourText:@"yellow" andReversed:NO];
    if (powerUpType == 3) [self showGlowWithColourAt:location colourText:@"purple" andReversed:NO];
    
    listOfSnakeParts[0] = tempSnakeHead;
    [self powerUpDescriptionPopup];
    
    if (powerUpType == 3) {
        [snakeMoveTimer invalidate];
        snakeMoveTimer = nil;
        snakeMoveTimer = [NSTimer scheduledTimerWithTimeInterval:snakeSpeed * 2 target:self selector:@selector(snakeMoveTimerTick) userInfo:nil repeats:YES];
    }
}

- (void)removePowerUp {
    powerUpSpawnTime = 300 + arc4random() % 200;
    if (powerUpSpawnsInstantly == YES) powerUpSpawnTime = 10;
    powerUpTime = -1;
    powerUp.frame = CGRectMake(-10, -10, 10, 10);
}

- (void)powerUpDescriptionPopup {
    [powerUpPopupTimer invalidate];
    powerUpPopupTimer = nil;
    
    UIImageView *tempSnakePart = listOfSnakeParts[0];
    
    if (powerUpType == 1) powerUpDescription.text = @"Invincibility!";
    if (powerUpType == 2) powerUpDescription.text = @"Double score!";
    if (powerUpType == 3) powerUpDescription.text = @"Time shift!";
    powerUpDescription.alpha = 0.6;
    powerUpDescription.center = tempSnakePart.center;
    [self.view addSubview:powerUpDescription];
    
    if (tempSnakePart.center.y > 200) {
        powerUpPopupTimer = [NSTimer scheduledTimerWithTimeInterval:(1.0f / 60.0f) target:self selector:@selector(powerUpDescriptionMoveUp) userInfo:nil repeats:YES];
    } else {
        powerUpPopupTimer = [NSTimer scheduledTimerWithTimeInterval:(1.0f / 60.0f) target:self selector:@selector(powerUpDescriptionMoveDown) userInfo:nil repeats:YES];
    }
}

- (void)powerUpDescriptionMoveDown {
    powerUpDescription.alpha -= 0.005;
    powerUpDescription.center = CGPointMake(powerUpDescription.center.x, powerUpDescription.center.y - 1);
    
    if (powerUpDescription.frame.origin.x <= 10) {
        powerUpDescription.center = CGPointMake(100, powerUpDescription.center.y);
    } else if (powerUpDescription.frame.origin.x + powerUpDescription.frame.size.width >= 950) {
        powerUpDescription.center = CGPointMake(950, powerUpDescription.center.y);
    }
    powerUpDescription.hidden = NO;
    
    if (powerUpDescription.alpha <= 0) {
        [powerUpPopupTimer invalidate];
        powerUpPopupTimer = nil;
        powerUpDescription.hidden = YES;
    }
}

- (void)powerUpDescriptionMoveUp {
    powerUpDescription.alpha -= 0.005;
    powerUpDescription.center = CGPointMake(powerUpDescription.center.x, powerUpDescription.center.y - 1);
    
    if (powerUpDescription.frame.origin.x <= 10) {
        powerUpDescription.center = CGPointMake(100, powerUpDescription.center.y);
    } else if (powerUpDescription.frame.origin.x + powerUpDescription.frame.size.width >= 950) {
        powerUpDescription.center = CGPointMake(950, powerUpDescription.center.y);
    }
    powerUpDescription.hidden = NO;
    
    if (powerUpDescription.alpha <= 0) {
        [powerUpPopupTimer invalidate];
        powerUpPopupTimer = nil;
        powerUpDescription.hidden = YES;
    }
}

#pragma mark - Enemy

- (void)spawnEnemy {
	CGPoint location = [self getRandomEmptySquare];
	_enemy.frame = CGRectMake(location.x, location.y, 10, 10);
	[self.view addSubview:_enemy];
	enemyBulletSpawnTime = 5 + arc4random() % 25;
    enemySpawnTime = 500;
    enemyAlive = YES;
    enemyWillMoveNext = NO;
    enemyMoveDirection = 0;
    soundToPlay = @"Enemy Spawn";
    
    [self showGlowWithColourAt:location colourText:@"white" andReversed:NO];
}

- (void)removeEnemy {
    soundToPlay = @"Eat";
    enemySpawnTime = 300 + arc4random() % 100;
    if (enemySpawnsInstantly == YES) enemySpawnTime = 10;
    [_enemy removeFromSuperview];
    enemyAlive = NO;
    _enemy.frame = CGRectMake(-10, -10, 0, 0);
    UIImageView *snakePartTempStorage = listOfSnakeParts[0];
    scoreDifference = [scoreLabel.text integerValue];
    if (powerUpType == 2 && powerUpTime > 0) {
        [self adjustScore:16];
    } else {
        [self adjustScore:8];
    }
    scoreLabel2.text = [NSString stringWithFormat:@"%lli", [scoreLabel.text longLongValue] - scoreDifference];
    scoreLabel2.alpha = 0.6;
    [scoreChangedTimer invalidate];
    scoreChangedTimer = nil;
    if (snakePartTempStorage.center.y > 200) {
		scoreLabel2.center = CGPointMake(snakePartTempStorage.center.x, snakePartTempStorage.center.y - 10);
		scoreChangedTimer = [NSTimer scheduledTimerWithTimeInterval:(1.0f/60.0f) target:self selector:@selector(scoreChangedMoveUp) userInfo:nil repeats:YES];
    } else {
		scoreLabel2.center = CGPointMake(snakePartTempStorage.center.x, snakePartTempStorage.center.y + 10);
		scoreChangedTimer = [NSTimer scheduledTimerWithTimeInterval:(1.0f/60.0f) target:self selector:@selector(scoreChangedMoveDown) userInfo:nil repeats:YES];
    }
    [self addSnakeParts:4];
}

- (int)selectEnemyDirection {
    int direction;
    CGPoint location;
    do {
        direction = arc4random() % 4;
        if (arc4random() % 50 == 0) {
            direction = -1;
            location = _enemy.frame.origin;
            break;
        }
        
        if (direction == 0) {
            location = CGPointMake(_enemy.frame.origin.x, _enemy.frame.origin.y - 10);
        } else if (direction == 1) {
            location = CGPointMake(_enemy.frame.origin.x + 10, _enemy.frame.origin.y);
        } else if (direction == 2) {
            location = CGPointMake(_enemy.frame.origin.x, _enemy.frame.origin.y + 10);
        } else {
            location = CGPointMake(_enemy.frame.origin.x - 10, _enemy.frame.origin.y);
        }
    } while ([self squareIsEmpty:location] == NO);
    return direction;
}

- (CGPoint)getNextEnemySquare {
    CGPoint location;
    if (enemyMoveDirection == 0) {
        location = CGPointMake(_enemy.frame.origin.x, _enemy.frame.origin.y - 10);
    } else if (enemyMoveDirection == 1) {
        location = CGPointMake(_enemy.frame.origin.x + 10, _enemy.frame.origin.y);
    } else if (enemyMoveDirection == 2) {
        location = CGPointMake(_enemy.frame.origin.x, _enemy.frame.origin.y + 10);
    } else if (enemyMoveDirection == 3) {
        location = CGPointMake(_enemy.frame.origin.x - 10, _enemy.frame.origin.y);
    }
    return location;
}

- (int)enemyBulletSelectDirection {
    int direction = 0;
    UIImageView *temp = listOfSnakeParts[0];
    CGPoint sl = temp.frame.origin; //snake location
    CGPoint el = _enemy.frame.origin; //enemy location
    
    if (sl.x < el.x) {
        if (sl.y < el.y) {
            if (snakeDirection == 0) {
                direction = 3;
            } else if (snakeDirection == 1) {
                direction = 0;
            } else if (snakeDirection == 3) {
                direction = 0;
            } else if (snakeDirection == 2) {
                direction = 3;
            }
        } else if (sl.y == el.y) {
            direction = 3;
        } else if (sl.y > el.y) {
            if (snakeDirection == 2) {
                direction = 3;
            } else if (snakeDirection == 1) {
                direction = 2;
            } else if (snakeDirection == 3) {
                direction = 2;
            } else if (snakeDirection == 0) {
                direction = 3;
            }
        }
    } else if (sl.x == el.x) {
        if (sl.y < el.y) {
            direction = 0;
        } else if (sl.y > el.y) {
            direction = 2;
        }
    } else if (sl.x > el.x) {
        if (sl.y < el.y) {
            if (snakeDirection == 3) {
                direction = 0;
            } else if (snakeDirection == 2) {
                direction = 1;
            } else if (snakeDirection == 1) {
                direction = 0;
            } else if (snakeDirection == 0) {
                direction = 1;
            }
        } else if (sl.y == el.y) {
            direction = 1;
        } else if (sl.y > el.y) {
            if (snakeDirection == 3) {
                direction = 2;
            } else if (snakeDirection == 0) {
                direction = 1;
            } else if (snakeDirection == 2) {
                direction = 1;
            } else if (snakeDirection == 1) {
                direction = 2;
            }
        }
    }
    
    if ([self squareIsEmpty:[self getNextBulletSquare:direction]] == NO) direction = -1;
    return direction;
}

- (void)enemyBulletSpawn {
    soundToPlay = @"Shoot";
    _enemyBullet.frame = CGRectMake(_enemy.frame.origin.x, _enemy.frame.origin.y, 10, 10);
    enemyBulletDirection = [self enemyBulletSelectDirection];
    if (enemyBulletDirection != -1) {
        _enemyBullet.frame = CGRectMake([self getNextBulletSquare:enemyBulletDirection].x, [self getNextBulletSquare:enemyBulletDirection].y, 10, 10);
        [self.view addSubview:_enemyBullet];
        [self.view bringSubviewToFront:_enemyBullet];
        enemyBulletSpawnTime = -1;
        enemyBulletAlive = YES;
    }
    
    [self showGlowWithColourAt:CGPointMake(_enemy.frame.origin.x, _enemy.frame.origin.y) colourText:@"white" andReversed:NO];
}

- (CGPoint)getNextBulletSquare:(int)direction {
    CGPoint location;
    if (direction == 0) {
        location = CGPointMake(_enemyBullet.frame.origin.x, _enemyBullet.frame.origin.y - 10);
    } else if (direction == 1) {
        location = CGPointMake(_enemyBullet.frame.origin.x + 10, _enemyBullet.frame.origin.y);
    } else if (direction == 2) {
        location = CGPointMake(_enemyBullet.frame.origin.x, _enemyBullet.frame.origin.y + 10);
    } else if (direction == 3) {
        location = CGPointMake(_enemyBullet.frame.origin.x - 10, _enemyBullet.frame.origin.y);
    }
    return location;
}

- (BOOL)removeEnemyBullet {
    soundToPlay = @"Crash";
    enemyBulletSpawnTime = 5 + arc4random() % 10;
    [_enemyBullet removeFromSuperview];
    enemyBulletAlive = NO;
    
    UIImageView *temp;
    
	//check screen bounds
	if ([self getNextBulletSquare:enemyBulletDirection].x < 2 || [self getNextBulletSquare:enemyBulletDirection].x > 1012 || [self getNextBulletSquare:enemyBulletDirection].y < 4 || [self getNextBulletSquare:enemyBulletDirection].y > 754) {
		[self createObstaclePart:_enemyBullet.frame.origin];
		return YES;
	}
	
	if ([self getNextBulletSquare:enemyBulletDirection].x == food.frame.origin.x && [self getNextBulletSquare:enemyBulletDirection].y == food.frame.origin.y) {
		[self createFoodWithGlow:YES];
		return YES;
	}
	
	//check snake
    for (int a = 0; a < listOfSnakeParts.count; a++) {
        temp = [listOfSnakeParts objectAtIndex:a];
        if (temp.frame.origin.x == [self getNextBulletSquare:enemyBulletDirection].x && temp.frame.origin.y == [self getNextBulletSquare:enemyBulletDirection].y) {
            scoreDifference = [scoreLabel.text integerValue];
            if (!(powerUpType == 1 && powerUpTime > 0)) {
                hitsByBullet += 1;
                [self adjustScore:-6];
                
                scoreLabel2.text = [NSString stringWithFormat:@"%i", [scoreLabel.text integerValue] - scoreDifference];
                scoreLabel2.alpha = 0.6;
                [scoreChangedTimer invalidate];
                scoreChangedTimer = nil;
                if (temp.center.y > 200) {
                    scoreLabel2.center = CGPointMake(temp.center.x, temp.center.y - 10);
                    scoreChangedTimer = [NSTimer scheduledTimerWithTimeInterval:(1.0f/60.0f) target:self selector:@selector(scoreChangedMoveUp) userInfo:nil repeats:YES];
                } else {
                    scoreLabel2.center = CGPointMake(temp.center.x, temp.center.y + 10);
                    scoreChangedTimer = [NSTimer scheduledTimerWithTimeInterval:(1.0f/60.0f) target:self selector:@selector(scoreChangedMoveDown) userInfo:nil repeats:YES];
                }
            }
            
            return YES;
        }
	}
	//check obstacle
	if (arc4random() % 2 == 0) {
		for (int a = 0; a < listOfObstacles.count; a++) {
			temp = listOfObstacles[a];
			if (temp.frame.origin.x == [self getNextBulletSquare:enemyBulletDirection].x && temp.frame.origin.y == [self getNextBulletSquare:enemyBulletDirection].y) {
				[[listOfObstacles objectAtIndex:a] removeFromSuperview];
				[listOfObstacles removeObjectAtIndex:a];
				return YES;
			}
		}
	} else {
		for (int a = 0; a < listOfObstacles.count; a++) {
			temp = listOfObstacles[a];
			if (temp.frame.origin.x == [self getNextBulletSquare:enemyBulletDirection].x && temp.frame.origin.y == [self getNextBulletSquare:enemyBulletDirection].y) {
				[_enemyBullet removeFromSuperview];
				[self createObstaclePart:_enemyBullet.frame.origin];
				return YES;
			}
		}
	}
    
    return NO;
}

#pragma mark - In Game

- (void)snakeMoveTimerTick {
    soundToPlay = @"Move";
    steps += 1;
    //************************************************************* Move *********************************************************************
    //move body
    
    UIImageView *snakePartTempStorage;
    
    for (unsigned long i = listOfSnakeParts.count - 1; i > 0; i--) {
        snakePartTempStorage = listOfSnakeParts[i];
        UIImageView *img = [listOfSnakeParts objectAtIndex:i - 1];
        snakePartTempStorage.center = img.center;
        listOfSnakeParts[i] = snakePartTempStorage;
    }
    
    snakePartTempStorage = listOfSnakeParts[0];
    
    if (directionArray.count > 0) {
        nextDirection = [directionArray[0] integerValue];
        [directionArray removeObjectAtIndex:0];
    }
    
    //move without the snake eating the second part of the body
    if (nextDirection == 0) {
        if (snakeDirection != 2) {
            snakePartTempStorage.center = CGPointMake(snakePartTempStorage.center.x, snakePartTempStorage.center.y - 10);
            snakeDirection = 0;
        } else {
            snakePartTempStorage.center = CGPointMake(snakePartTempStorage.center.x, snakePartTempStorage.center.y + 10);
        }
    } else if (nextDirection == 1) {
        if (snakeDirection != 3) {
            snakePartTempStorage.center = CGPointMake(snakePartTempStorage.center.x + 10, snakePartTempStorage.center.y);
            snakeDirection = 1;
        } else {
            snakePartTempStorage.center = CGPointMake(snakePartTempStorage.center.x - 10, snakePartTempStorage.center.y);
        }
    } else if (nextDirection == 2) {
        if (snakeDirection != 0) {
            snakePartTempStorage.center = CGPointMake(snakePartTempStorage.center.x, snakePartTempStorage.center.y + 10);
            snakeDirection = 2;
        } else {
            snakePartTempStorage.center = CGPointMake(snakePartTempStorage.center.x, snakePartTempStorage.center.y - 10);
        }
    } else { // nextDirection == 3
        if (snakeDirection != 1) {
            snakePartTempStorage.center = CGPointMake(snakePartTempStorage.center.x - 10, snakePartTempStorage.center.y);
            snakeDirection = 3;
        } else {
            snakePartTempStorage.center = CGPointMake(snakePartTempStorage.center.x + 10, snakePartTempStorage.center.y);
        }
    }
    listOfSnakeParts[0] = snakePartTempStorage;
    
    //teleport snake to the other side if it's on the edge of the screen
    snakePartTempStorage = listOfSnakeParts[0];
    if (snakePartTempStorage.center.x < 2 + 5) { //left to right
        snakePartTempStorage.center = CGPointMake(1022 - 5, snakePartTempStorage.center.y);
        
    } else if (snakePartTempStorage.center.x > 1022 - 5) { //right to left
        snakePartTempStorage.center = CGPointMake(2 + 5, snakePartTempStorage.center.y);
        
    } else if (snakePartTempStorage.center.y < 4 + 5) { //top to bottom
        snakePartTempStorage.center = CGPointMake(snakePartTempStorage.center.x, 764 - 5);
        
    } else if (snakePartTempStorage.center.y > 764 - 5) { //bottom to top
        snakePartTempStorage.center = CGPointMake(snakePartTempStorage.center.x, 4 + 5);
    }
    
    //****************************************************************** Check for Collisions *******************************************************************
    //hits snake body
    if (!(powerUpType == 1 && powerUpTime > 0)) {
        UIImageView *snakePartTempStorage2 = listOfSnakeParts[0];
        for (int i = 2; i < listOfSnakeParts.count; i++) {
            snakePartTempStorage = listOfSnakeParts[i];
            if (snakePartTempStorage.center.x == snakePartTempStorage2.center.x && snakePartTempStorage.center.y == snakePartTempStorage2.center.y) {
                deathsBySelf += 1;
                causeOfDeath = [DeathMessages randomSnakeBodyDeathMessage];
                soundToPlay = @"Crash";
                [self die];
            }
        }
        snakePartTempStorage2 = nil;
        
        //hits obstacle
        snakePartTempStorage2 = listOfSnakeParts[0];
        if (listOfObstacles.count > 0) {
            for (int a = 0; a < listOfObstacles.count; a++) {
                snakePartTempStorage = listOfObstacles[a];
                if (snakePartTempStorage.frame.origin.x == snakePartTempStorage2.frame.origin.x && snakePartTempStorage.frame.origin.y == snakePartTempStorage2.frame.origin.y) {
                    deathsByObstacle += 1;
                    causeOfDeath = [DeathMessages randomObstacleDeathMessage];
                    soundToPlay = @"Crash";
                    [self die];
                }
            }
        }
    }
    
    //hits food
    snakePartTempStorage = listOfSnakeParts[0];
    if (food.frame.origin.x == snakePartTempStorage.frame.origin.x && food.frame.origin.y == snakePartTempStorage.frame.origin.y) {
        scoreDifference = [scoreLabel.text integerValue];
        if (powerUpType == 2 && powerUpTime > 0) {
            [self adjustScore:4];
        } else {
            [self adjustScore:2];
        }
        foodEaten += 1;
        scoreLabel2.text = [NSString stringWithFormat:@"%lli", [scoreLabel.text longLongValue] - scoreDifference];
        scoreLabel2.alpha = 0.6;
        [scoreChangedTimer invalidate];
        scoreChangedTimer = nil;
        if (snakePartTempStorage.center.y > 200) {
            scoreLabel2.center = CGPointMake(snakePartTempStorage.center.x, snakePartTempStorage.center.y - 10);
            scoreChangedTimer = [NSTimer scheduledTimerWithTimeInterval:(1.0f/60.0f) target:self selector:@selector(scoreChangedMoveUp) userInfo:nil repeats:YES];
        } else {
            scoreLabel2.center = CGPointMake(snakePartTempStorage.center.x, snakePartTempStorage.center.y + 10);
            scoreChangedTimer = [NSTimer scheduledTimerWithTimeInterval:(1.0f/60.0f) target:self selector:@selector(scoreChangedMoveDown) userInfo:nil repeats:YES];
        }
        
        soundToPlay = @"Eat";
        
        [self createFoodWithGlow:YES];
        [self addSnakeParts:2];
        
        if ([scoreLabel.text integerValue] - scoreChangeStorage > 2000 && !(powerUpType == 3 && powerUpTime > 0) && isBoosting != YES) {
            [snakeMoveTimer invalidate];
            snakeMoveTimer = nil;
            if (snakeSpeed > 0.02) {
                snakeSpeed -= 0.003;
                snakeMoveTimer = [NSTimer scheduledTimerWithTimeInterval:snakeSpeed target:self selector:@selector(snakeMoveTimerTick) userInfo:nil repeats:YES];
            }
            scoreChangeStorage = [scoreLabel.text longLongValue];
        }
    }
    timeSinceFoodSpawn ++;
    if (timeSinceFoodSpawn > 250 && obstaclesOn == YES) {
        [self createFoodWithGlow:YES];
    }
    
    //power up
    if (powerUpTime == 24) powerUpFlashStage = 2;
    if (powerUpTime > 0 && powerUpTime < 80) {
        //flash
        if ((powerUpFlashStage > 0 && powerUpFlashStage < 4) && powerUpTime > 1) {
            UIImageView *tempSnakeHead = listOfSnakeParts[0];
            if (powerUpType == 1) tempSnakeHead.image = [UIImage imageNamed:@"bluedot.png"];
            if (powerUpType == 2) tempSnakeHead.image = [UIImage imageNamed:@"yellowdot.png"];
            if (powerUpType == 3) tempSnakeHead.image = [UIImage imageNamed:@"purpledot.png"];
            listOfSnakeParts[0] = tempSnakeHead;
            powerUpFlashStage ++;
        } else {
            UIImageView *tempSnakeHead = listOfSnakeParts[0];
            tempSnakeHead.image = [UIImage imageNamed:@"orangedot.png"];
            listOfSnakeParts[0] = tempSnakeHead;
            powerUpFlashStage ++;
            if (powerUpFlashStage == 8) {
                powerUpFlashStage = 0;
                UIImageView *img = listOfSnakeParts[0];
                CGPoint location = img.frame.origin;
                [self showGlowWithColourAt:location colourText:@"orange" andReversed:NO];
            }
        }
    }
    if (powerUpTime == 0) [self removePowerUp];
    if (powerUpSpawnTime == 0 && powerUpsOn == YES) [self createPowerUp];
    if (powerUpTime > 0) powerUpTime --;
    if (powerUpSpawnTime > 0) powerUpSpawnTime --;
    snakePartTempStorage = listOfSnakeParts[0];
    if (snakePartTempStorage.frame.origin.x == powerUp.frame.origin.x && snakePartTempStorage.frame.origin.y == powerUp.frame.origin.y) [self eatPowerUp];
    if (powerUpType == 3 && powerUpTime == 0) {
        [snakeMoveTimer invalidate];
        snakeMoveTimer = nil;
        snakeMoveTimer = [NSTimer scheduledTimerWithTimeInterval:snakeSpeed target:self selector:@selector(snakeMoveTimerTick) userInfo:nil repeats:YES];
    }
    if (powerUpTime == 0 || powerUpTime == -1) [self.view bringSubviewToFront:scoreLabel];
    [self.view bringSubviewToFront:scoreLabel2];
    [self.view bringSubviewToFront:powerUpDescription];
    
    //enemy stuff
    if (enemiesOn == YES) {
        if (enemySpawnTime > 0) {
            enemySpawnTime -= 1;
        } else if (enemySpawnTime == 0) {
            [self spawnEnemy];
        }
        
        if (enemyAlive == YES) {
            UIImageView *temp = listOfSnakeParts[0];
            if (temp.frame.origin.x == _enemy.frame.origin.x && temp.frame.origin.y == _enemy.frame.origin.y) {
                enemiesEaten += 1;
                [self removeEnemy];
            } else if (enemyWillMoveNext == YES) {
                if (!(powerUpType == 3 && powerUpTime > 0 && arc4random() % 3 > 0)) {
                    CGPoint location = [self getNextEnemySquare];
                    if (enemyMoveStepsLeft == 0 || [self squareIsEmpty:location] == NO || enemyMoveDirection == -1) {
                        enemyMoveStepsLeft = 5 + arc4random() % 10;
                        enemyMoveDirection = [self selectEnemyDirection];
                        location = [self getNextEnemySquare];
                    }
                    if (enemyMoveDirection != -1) {
                        if ([self squareIsEmpty:location] == YES) {
                            _enemy.frame = CGRectMake(location.x, location.y, 10, 10);
                        }
                        
                        enemyMoveStepsLeft -= 1;
                        enemyWillMoveNext = NO;
                    }
                }
            } else {
                enemyWillMoveNext = YES;
                if (temp.frame.origin.x == _enemy.frame.origin.x && temp.frame.origin.y == _enemy.frame.origin.y) [self removeEnemy];
            }
        }
    }
    
    //bullet
    if (enemiesOn == YES) {
        if (enemyBulletAlive == YES) {
            CGPoint location = [self getNextBulletSquare:enemyBulletDirection];
            if ([self squareIsEmpty:location]) {
                _enemyBullet.frame = CGRectMake(location.x, location.y, 10, 10);
            } else {
                [self removeEnemyBullet];
                _enemyBullet.frame = CGRectMake(-10, -10, 10, 10);
            }
        } else if (enemyAlive == YES) {
            if (enemyBulletSpawnTime > 0) {
                enemyBulletSpawnTime --;
            } else if (enemyBulletSpawnTime == 0) {
                [self enemyBulletSpawn];
            }
        }
    }
    
    [self.view bringSubviewToFront:leftButton];
    [self.view bringSubviewToFront:rightButton];
    [self.view bringSubviewToFront:downButton];
    [self.view bringSubviewToFront:upButton];
    [self.view bringSubviewToFront:boostButton];
    [self.view bringSubviewToFront:pauseButton];
    [self.view bringSubviewToFront:scoreLabel];
    [self.view bringSubviewToFront:scoreLabelLabel];
    
    [self playDecidedSound];
    
    if (delegate.shouldPause == YES) {
        [self threeFingerDoubleTap];
        delegate.shouldPause = NO;
    }
    
    if (instantDeath == YES && !(powerUpTime > 0 && powerUpType == 1)) [self die];
} //**********************************************************************************************************************************************************

- (void)playDecidedSound {
    if (soundEffectsOn == YES) {
        if ([soundToPlay isEqualToString:@"Crash"]) {
            [crashAudioPlayer play];
        } else if ([soundToPlay isEqualToString:@"Eat"]) {
            [eatAudioPlayer play];
        } else if ([soundToPlay isEqualToString:@"Enemy Spawn"]) {
            [enemySpawnAudioPlayer play];
        } else if ([soundToPlay isEqualToString:@"Power Up"]) {
            [powerUpAudioPlayer play];
        } else if ([soundToPlay isEqualToString:@"Shoot"]) {
            [shootAudioPlayer play];
        }
    }
}

- (void)scoreChangedMoveUp {
    [self.view bringSubviewToFront:scoreLabel2];
    scoreLabel2.alpha -= 0.005;
    scoreLabel2.center = CGPointMake(scoreLabel2.center.x, scoreLabel2.center.y - 1);
    
    if (scoreLabel2.frame.origin.x <= 10) {
        scoreLabel2.center = CGPointMake(100, scoreLabel2.center.y);
    } else if (scoreLabel2.frame.origin.x + scoreLabel2.frame.size.width >= 950) {
        scoreLabel2.center = CGPointMake(950, scoreLabel2.center.y);
    }
    scoreLabel2.hidden = NO;
    
    if (scoreLabel2.alpha <= 0) {
        [scoreChangedTimer invalidate];
        scoreChangedTimer = nil;
        scoreLabel2.hidden = YES;
    }
}

- (void)scoreChangedMoveDown {
    [self.view bringSubviewToFront:scoreLabel2];
    scoreLabel2.alpha -= 0.005;
    scoreLabel2.center = CGPointMake(scoreLabel2.center.x, scoreLabel2.center.y + 1);
    
    if (scoreLabel2.frame.origin.x <= 10) {
        scoreLabel2.center = CGPointMake(100, scoreLabel2.center.y);
    } else if (scoreLabel2.frame.origin.x + scoreLabel2.frame.size.width >= 950) {
        scoreLabel2.center = CGPointMake(950, scoreLabel2.center.y);
    }
    scoreLabel2.hidden = NO;
    
    if (scoreLabel2.alpha <= 0) {
        [scoreChangedTimer invalidate];
        scoreChangedTimer = nil;
        scoreLabel2.hidden = YES;
    }
}

- (void)adjustScore:(float)multiplyBy {
    //note: due to the multiply typo for food, double what is calculated below is given as score
    long long a = 0;
    float b = 1;
    if (borderOn == YES) b += 0.2;
    if (enemiesOn == YES) b += 0.1;
    if (powerUpsOn == YES) b += 0.1;
    if (ruinsOn == YES) b += 0.1;
    if (obstaclesOn == YES) {
        a = 50 + floor(sqrt([scoreLabel.text integerValue] * b) / 2) + (0.7 * pow((snakeSpeed * 75) - 15, 2));
    } else {
        a = 50 + floor([scoreLabel.text integerValue] * b / 250) + (-2 * (snakeSpeed * 75) + 30);
    }
    a *= multiplyBy;
    a = [scoreLabel.text longLongValue] + a;
    scoreLabel.text = [NSString stringWithFormat:@"%lli", a];
}

- (void)swipeUp {
    if (snakeMoveTimer.isValid == YES) {
        //nextDirection = 0;
        [directionArray addObject:[NSNumber numberWithInt:0]];
    }
}
- (void)swipeRight {
    if (snakeMoveTimer.isValid == YES) {
        //nextDirection = 1;
        [directionArray addObject:[NSNumber numberWithInt:1]];
    }
}
- (void)swipeDown {
    if (snakeMoveTimer.isValid == YES) {
        //nextDirection = 2;
        [directionArray addObject:[NSNumber numberWithInt:2]];
    }
}
- (void)swipeLeft {
    if (snakeMoveTimer.isValid == YES) {
        //nextDirection = 3;
        [directionArray addObject:[NSNumber numberWithInt:3]];
    }
}

- (void)directionButtonDragPan:(UIPanGestureRecognizer *)sender {
    CGPoint translation = [sender translationInView:self.view];
    
    if (leftButton.frame.origin.x >= 252 && rightButton.frame.origin.x + rightButton.frame.size.width < 1024 - 52) {
        leftButton.center = CGPointMake(leftButton.center.x + translation.x, leftButton.center.y);
        rightButton.center = CGPointMake(rightButton.center.x + translation.x, rightButton.center.y);
        downButton.center = CGPointMake(downButton.center.x + translation.x, downButton.center.y);
        upButton.center = CGPointMake(upButton.center.x + translation.x, upButton.center.y);
    }
    
    if (leftButton.frame.origin.x < 252) {
        leftButton.center = CGPointMake(302, leftButton.center.y);
        rightButton.center = CGPointMake(502, rightButton.center.y);
        downButton.center = CGPointMake(402, downButton.center.y);
        upButton.center = CGPointMake(402, upButton.center.y);
    }
    if (rightButton.frame.origin.x + rightButton.frame.size.width > 1024 - 54) {
        leftButton.center = CGPointMake(1020 - 300, leftButton.center.y);
        rightButton.center = CGPointMake(1020 - 100, rightButton.center.y);
        downButton.center = CGPointMake(1020 - 200, downButton.center.y);
        upButton.center = CGPointMake(1020 - 200, upButton.center.y);
    }
    
    [sender setTranslation:CGPointZero inView:self.view];
}

- (void)boostButtonDown {
    if (dead != YES && snakeMoveTimer.isValid == YES) {
        isBoosting = YES;
        if (snakeSpeed >= 0.015) {
            [snakeMoveTimer invalidate];
            snakeMoveTimer = [NSTimer scheduledTimerWithTimeInterval:0.015 target:self selector:@selector(snakeMoveTimerTick) userInfo:nil repeats:YES];
            if (downButton) {
                [downButton removeFromSuperview];
                [upButton removeFromSuperview];
                [leftButton removeFromSuperview];
                [rightButton removeFromSuperview];
            }
            if (downSwipe) {
                [self.view removeGestureRecognizer:downSwipe];
                [self.view removeGestureRecognizer:upSwipe];
                [self.view removeGestureRecognizer:leftSwipe];
                [self.view removeGestureRecognizer:rightSwipe];
            }
        }
    }
}

- (void)boostButtonUp {
    if (dead != YES  && snakeMoveTimer.isValid == YES) {
        isBoosting = NO;
        if (snakeSpeed >= 0.015) {
            [snakeMoveTimer invalidate];
            if (downButton) {
                [self.view addSubview:downButton];
                [self.view addSubview:upButton];
                [self.view addSubview:leftButton];
                [self.view addSubview:rightButton];
            }
            if (downSwipe) {
                [self.view addGestureRecognizer:downSwipe];
                [self.view addGestureRecognizer:upSwipe];
                [self.view addGestureRecognizer:leftSwipe];
                [self.view addGestureRecognizer:rightSwipe];
            }
            if (powerUpType == 3 && powerUpTime > 0) {
                snakeMoveTimer = [NSTimer scheduledTimerWithTimeInterval:snakeSpeed * 2 target:self selector:@selector(snakeMoveTimerTick) userInfo:nil repeats:YES];
            } else {
                snakeMoveTimer = [NSTimer scheduledTimerWithTimeInterval:snakeSpeed target:self selector:@selector(snakeMoveTimerTick) userInfo:nil repeats:YES];
            }
        }
    }
}

- (void)die {
    dead = YES;
    [snakeMoveTimer invalidate];
    snakeMoveTimer = nil;
    
    dieFlashCounter = 0;
    dieFlashTimer = [NSTimer scheduledTimerWithTimeInterval:0.25f target:self selector:@selector(dieFlash) userInfo:nil repeats:YES];
}

- (void)dieFlash {
    UIImageView *snakePartTempStorage;
    snakePartTempStorage = [listOfSnakeParts lastObject];
    
    if (snakePartTempStorage.hidden == NO) {
        for (int i = 0; i < listOfSnakeParts.count; i++) {
            snakePartTempStorage = [listOfSnakeParts objectAtIndex:i];
            snakePartTempStorage.hidden = YES;
            listOfSnakeParts[i] = snakePartTempStorage;
        }
    } else {
        for (int i = 0; i < listOfSnakeParts.count; i++) {
            snakePartTempStorage = [listOfSnakeParts objectAtIndex:i];
            snakePartTempStorage.hidden = NO;
            listOfSnakeParts[i] = snakePartTempStorage;
        }
    }
    
    int dieLimit = 6;
    if (instantDeath == YES) dieLimit = 0;
    if (dieFlashCounter < dieLimit) {
        dieFlashCounter ++;
    } else {
        [dieFlashTimer invalidate];
        dieFlashTimer = nil;
        endMenuBackground = [[UIImageView alloc] initWithFrame:CGRectMake(2, 4, 1020, 760)];
        endMenuBackground.backgroundColor = [UIColor blackColor];
        endMenuBackground.alpha = 0;
        [self.view addSubview:endMenuBackground];
        [self.view bringSubviewToFront:endMenuBackground];
        
        [UIView animateWithDuration:0.75f animations:^{
            endMenuBackground.alpha = 0.75;
        } completion:^(BOOL finished) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[NSNumber numberWithLong:steps] forKey:stepsKey];
            [defaults setInteger:foodEaten forKey:foodEatenKey];
            [defaults setInteger:enemiesEaten forKey:enemiesEatenKey];
            [defaults setInteger:hitsByBullet forKey:hitsByBulletKey];
            [defaults setInteger:powerUpsEaten forKey:powerUpsEatenKey];
            [defaults setInteger:deathsByObstacle forKey:deathsByObstacleKey];
            [defaults setInteger:deathsBySelf forKey:deathsBySelfKey];
            [defaults setInteger:[[defaults objectForKey:gamesPlayedKey] integerValue] + 1 forKey:gamesPlayedKey];
            
            [self addUpgradePoints];
            deathScoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(512 - 505, 130, 1010, 150)];
            deathScoreLabel.text = [NSString stringWithFormat: @"You died with a score of %@",	scoreLabel.text];
            deathScoreLabel.backgroundColor = [UIColor clearColor];
            deathScoreLabel.textColor = [UIColor whiteColor];
            deathScoreLabel.font = [UIFont fontWithName:@"Helvetica" size:50];
            deathScoreLabel.textAlignment = NSTextAlignmentCenter;
            deathScoreLabel.alpha = 0;
            
            deathCommentLabel = [[UILabel alloc] initWithFrame:CGRectMake(deathScoreLabel.frame.origin.x, deathScoreLabel.frame.origin.y + deathScoreLabel.frame.size.height - 25, deathScoreLabel.frame.size.width, 100)];
            deathCommentLabel.text = causeOfDeath;
            if ([scoreLabel.text integerValue] > cheatingThreshold) deathCommentLabel.text = [DeathMessages randomCheaterDeathMessage];
            deathCommentLabel.backgroundColor = [UIColor clearColor];
            deathCommentLabel.textColor = [UIColor whiteColor];
            deathCommentLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
            deathCommentLabel.numberOfLines = 2;
            deathCommentLabel.textAlignment = NSTextAlignmentCenter;
            deathCommentLabel.alpha = 0;
            
            [self.view addSubview:quitButton];
            quitButton.center = CGPointMake(512, deathCommentLabel.center.y + 200);
            quitButton.gestureRecognizers = nil;
            [quitButton addTarget:self action:@selector(quitButtonHeld) forControlEvents:UIControlEventTouchUpInside];
            [quitButton setTitle:@"Quit" forState:UIControlStateNormal];
            
            nameField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 28)];
            nameField.center = CGPointMake(512, quitButton.center.y - 105);
            nameField.backgroundColor = [UIColor whiteColor];
            nameField.placeholder = @"Enter your name here";
            nameField.clearButtonMode = UITextFieldViewModeAlways;
            if ([defaults objectForKey:nameKey]) nameField.text = [defaults objectForKey:nameKey];
            nameField.textAlignment = NSTextAlignmentCenter;
            nameField.returnKeyType = UIReturnKeyDone;
            nameField.borderStyle = UITextBorderStyleRoundedRect;
            nameField.alpha = 0;
            nameField.delegate = self;
            [nameField addTarget:self action:@selector(textFieldEdited) forControlEvents:UIControlEventEditingChanged];
            
            cashLabel = [[UILabel alloc] initWithFrame:CGRectMake(23, 25, 900, 30)];
            cashLabel.textColor = [UIColor whiteColor];
            cashLabel.backgroundColor = [UIColor clearColor];
            cashLabel.text = [NSString stringWithFormat:@"Upgrade Points: %i", cash];
            cashLabel.font = [UIFont fontWithName:@"Helvetica" size:25];
            cashLabel.alpha = 0;
            
            [self.view addSubview:nameField];
            [self.view bringSubviewToFront:nameField];
            [self.view addSubview:deathScoreLabel];
            [self.view addSubview:deathCommentLabel];
            [self.view addSubview:cashLabel];
            
            if ([[defaults objectForKey:willSkipTutorial] boolValue] != YES) {
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:willSkipTutorial];
                _tutorialImage = nil;
                _tutorialImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Help Game End.png"]];
                _tutorialImage.frame = CGRectMake(0, 0, 1024, 768);
                _tutorialImage.alpha = 0;
                [self.view addSubview:_tutorialImage];
                [self.view bringSubviewToFront:_tutorialImage];
            }
            
            [defaults synchronize];
            
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:adsPurchased] boolValue] != YES) {
                [self.view addSubview:_gameAdBanners];
                [self.view bringSubviewToFront:_gameAdBanners];
                [_gameAdBanners addAdsToSubview];
                _gameAdBanners.alpha = 0.0;
            }
            
            if (_tutorialImage) {
                [UIView animateWithDuration:0.75f animations:^{
                    quitButton.alpha = 1;
                    deathScoreLabel.alpha = 1;
                    deathCommentLabel.alpha = 1;
                    nameField.alpha = 1;
                    cashLabel.alpha = 1;
                    _tutorialImage.alpha = 0.5;
                    if ([[[NSUserDefaults standardUserDefaults] objectForKey:adsPurchased] boolValue] != YES) _gameAdBanners.alpha = 1.0;
                }];
            } else {
                [UIView animateWithDuration:0.75f animations:^{
                    quitButton.alpha = 1;
                    deathScoreLabel.alpha = 1;
                    deathCommentLabel.alpha = 1;
                    nameField.alpha = 1;
                    cashLabel.alpha = 1;
                    if ([[[NSUserDefaults standardUserDefaults] objectForKey:adsPurchased] boolValue] != YES) _gameAdBanners.alpha = 1.0;
                } completion:^(BOOL finished) {
                    [self showFSAd];
                }];
            }
        }];
    }
    
}

#pragma mark - Menus

- (void)threeFingerDoubleTap {
    if (soundEffectsOn == YES) [buttonPressAudioPlayer play];
    if (dead == NO && pauseMenuTransitioning != YES) {
        if (snakeMoveTimer.isValid == YES) {
			[self pause];
        } else {
			[self unpause];
        }
    }
}

- (void)pause {
    if (dead != YES) {
        [self boostButtonUp];
    }
    pauseMenuTransitioning = YES;
    [snakeMoveTimer invalidate];
    snakeMoveTimer = nil;
    [self.view addSubview:pauseMenuBackground];
    pauseMenuBackground.alpha = 0;
    
    [self.view bringSubviewToFront:pauseButton];
    [self.view bringSubviewToFront:scoreLabel];
    [self.view bringSubviewToFront:scoreLabelLabel];
    
    [UIView animateWithDuration:0.5f animations:^{
        pauseMenuBackground.alpha = 0.75;
    } completion:^(BOOL finished) {
        [self.view addSubview:quitButton];
		[self.view addSubview:resumeLabel];
        [self.view bringSubviewToFront:resumeLabel];
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:adsPurchased] boolValue] != YES) {
            [self.view addSubview:_gameAdBanners];
            [self.view bringSubviewToFront:_gameAdBanners];
            [_gameAdBanners addAdsToSubview];
            _gameAdBanners.alpha = 0;
        }
        
        [UIView animateWithDuration:0.5f animations:^{
            quitButton.alpha = 1.0;
            resumeLabel.alpha = 1.0;
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:adsPurchased] boolValue] != YES) _gameAdBanners.alpha = 1.0;
        } completion:^(BOOL finished) {
            pauseMenuTransitioning = NO;
        }];
    }];
}

- (void)unpause {
	if (pauseMenuTransitioning != YES) {
		pauseMenuTransitioning = YES;
        delegate.shouldPause = NO;
        
        [UIView animateWithDuration:0.5f animations:^{
            quitButton.alpha = 0;
            resumeLabel.alpha = 0;
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:adsPurchased] boolValue] != YES) _gameAdBanners.alpha = 0;
        } completion:^(BOOL finished) {
            [quitButton removeFromSuperview];
            [resumeLabel removeFromSuperview];
            [_gameAdBanners removeFromSuperview];
            
            [UIView animateWithDuration:0.5f animations:^{
                pauseMenuBackground.alpha = 0;
            } completion:^(BOOL finished) {
                if (powerUpType == 3 && powerUpTime > 0) {
                    snakeMoveTimer = [NSTimer scheduledTimerWithTimeInterval:snakeSpeed * 2 target:self selector:@selector(snakeMoveTimerTick) userInfo:nil repeats:YES];
                } else {
                    snakeMoveTimer = [NSTimer scheduledTimerWithTimeInterval:snakeSpeed target:self selector:@selector(snakeMoveTimerTick) userInfo:nil repeats:YES];
                }
                pauseMenuTransitioning = NO;
            }];
        }];
	}
}

int distance = 145;

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.25 animations:^{
        deathScoreLabel.center = CGPointMake(512, deathScoreLabel.center.y - distance + 45);
        deathCommentLabel.center = CGPointMake(512, deathCommentLabel.center.y - distance + 30);
        quitButton.center = CGPointMake(512, quitButton.center.y - distance);
        nameField.center = CGPointMake(512, nameField.center.y - distance + 15);
    }];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    [UIView animateWithDuration:0.25 animations:^{
        deathScoreLabel.center = CGPointMake(512, deathScoreLabel.center.y + distance - 45);
        deathCommentLabel.center = CGPointMake(512, deathCommentLabel.center.y + distance - 30);
        quitButton.center = CGPointMake(512, quitButton.center.y + distance);
        nameField.center = CGPointMake(512, nameField.center.y + distance - 15);
    }];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldEdited {
    if (nameField.text.length > 28) {
        nameField.text = [nameField.text substringToIndex:nameField.text.length - 1];
    }
}

- (void)addUpgradePoints {
    int cashChange = floor([scoreLabel.text integerValue] / 1000);
    if (cashChange < 0) cashChange = 0;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:doubleUpgradePointsPurchased] boolValue] == YES) cashChange *= 2;
    cash += cashChange;
    [defaults setInteger:([defaults integerForKey:cashEarnedKey] + cashChange) forKey:cashEarnedKey];
    [defaults setInteger:cash forKey:cashKey];
}

- (void)quitButtonHeld {
    if (soundEffectsOn == YES) [buttonPressAudioPlayer play];
    if (dead != YES) [self addUpgradePoints];
    //high scores
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *name = nameField.text;
    [defaults setObject:name forKey:nameKey];
    if (name.length == 0) name = @"Player";
    
    //cheat
    if (cheatScore == YES) scoreLabel.text = nameField.text; name = @"Player";
    
    NSArray *beforeArray = [[NSArray alloc] init];
    if ([defaults objectForKey:highScoreKey]) {
        beforeArray = [[NSArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:highScoreKey]]];
        if (beforeArray.count < 99) {
            beforeArray = [beforeArray arrayByAddingObject:[[HighScoreObject alloc] initWithScore:[scoreLabel.text longLongValue] andName:name]];
            
        } else if (beforeArray.count > 99) {
            NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:beforeArray];
            do {
                [tempArray removeLastObject];
            } while (tempArray.count > 99);
            beforeArray = nil;
            beforeArray = [[NSArray alloc] initWithArray:tempArray];
        }
    } else {
        beforeArray = [[NSArray alloc] initWithObjects:[[HighScoreObject alloc] initWithScore:[scoreLabel.text integerValue] andName:name], nil];
    }
    
    if (addLotsOfScores == YES) {
        beforeArray = [beforeArray arrayByAddingObject:[[HighScoreObject alloc] initWithScore:0 andName:name]];
        beforeArray = [beforeArray arrayByAddingObject:[[HighScoreObject alloc] initWithScore:0 andName:name]];
        beforeArray = [beforeArray arrayByAddingObject:[[HighScoreObject alloc] initWithScore:0 andName:name]];
        
        beforeArray = [beforeArray arrayByAddingObject:[[HighScoreObject alloc] initWithScore:1 andName:name]];
        beforeArray = [beforeArray arrayByAddingObject:[[HighScoreObject alloc] initWithScore:2 andName:name]];
        beforeArray = [beforeArray arrayByAddingObject:[[HighScoreObject alloc] initWithScore:3 andName:name]];
        
        beforeArray = [beforeArray arrayByAddingObject:[[HighScoreObject alloc] initWithScore:9999999 andName:name]];
        beforeArray = [beforeArray arrayByAddingObject:[[HighScoreObject alloc] initWithScore:9999999 andName:name]];
        beforeArray = [beforeArray arrayByAddingObject:[[HighScoreObject alloc] initWithScore:9999999 andName:name]];
    }
    
    NSArray *descriptorArray = [[NSArray alloc] initWithObjects:[[NSSortDescriptor alloc] initWithKey:@"score" ascending:NO], nil];
    NSArray *afterArray = [beforeArray sortedArrayUsingDescriptors:descriptorArray];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:afterArray];
    if ([scoreLabel.text integerValue] != 0 && [scoreLabel.text integerValue] <= cheatingThreshold)
        [defaults setObject:data forKey:highScoreKey];
    [defaults setObject:[NSNumber numberWithLong:steps] forKey:stepsKey];
    [defaults setInteger:foodEaten forKey:foodEatenKey];
    [defaults setInteger:enemiesEaten forKey:enemiesEatenKey];
    [defaults setInteger:hitsByBullet forKey:hitsByBulletKey];
    [defaults setInteger:powerUpsEaten forKey:powerUpsEatenKey];
    [defaults setInteger:deathsByObstacle forKey:deathsByObstacleKey];
    [defaults setInteger:deathsBySelf forKey:deathsBySelfKey];
    [defaults synchronize];

    quitButton.gestureRecognizers = nil;
    [backgroundAudioPlayer stop];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)interstitialAdDidLoad:(ADInterstitialAd *)interstitialAd {
    NSLog(@"full screen ad loaded");
}

- (void)interstitialAd:(ADInterstitialAd *)interstitialAd didFailWithError:(NSError *)error {
    NSLog(@"full screen ad failed");
}

- (void)interstitialAdDidUnload:(ADInterstitialAd *)interstitialAd {
    NSLog(@"full screen ad unloaded");
}

- (BOOL)showFSAd {
    if (_fullScreenAd.isLoaded == YES && [[[NSUserDefaults standardUserDefaults] objectForKey:adsPurchased] boolValue] != YES && arc4random() % 3 != 0 && [[[NSUserDefaults standardUserDefaults] objectForKey:gamesPlayedKey] integerValue] > 6) {
        
        [self requestInterstitialAdPresentation];
        return true;
    } else {
        return false;
    }
}


@end
