//
//  GameViewController.h
//  Snake
//
//  Created by Dylan Chong on 7/10/12.
//  Copyright (c) 2012 Dylan Chong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HighScoreObject.h"
#import "AppDelegate.h"
#import <iAd/iAd.h>
#import "DeathMessages.h"
#import <AVFoundation/AVFoundation.h>
#import "Glow Effect.h"
#import "MultiAdHandler.h"

@interface GameViewController : UIViewController <UITextFieldDelegate, ADBannerViewDelegate, ADInterstitialAdDelegate>
@property (strong, nonatomic) UIImageView *tutorialImage;
@property (strong, nonatomic) ADInterstitialAd *fullScreenAd;
@property (strong, nonatomic) MultiAdHandler *gameAdBanners;
@property (strong, nonatomic) UIImageView *enemy;
@property (strong, nonatomic) UIImageView *enemyBullet;
@end

//Settings
AppDelegate *delegate;
BOOL obstaclesOn, borderOn, powerUpsOn, ruinsOn, enemiesOn;
float snakeSpeed;

//Audio
AVAudioPlayer *buttonPressAudioPlayer, *shootAudioPlayer, *crashAudioPlayer, *eatAudioPlayer, *enemySpawnAudioPlayer, *powerUpAudioPlayer, *shootAudioPlayer, *backgroundAudioPlayer;
NSString *soundToPlay;
BOOL soundEffectsOn;

//Game stuff
UITapGestureRecognizer *tapToStart, *threeFingerDoubleTap;
UISwipeGestureRecognizer *leftSwipe, *rightSwipe, *upSwipe, *downSwipe;
UIPanGestureRecognizer *directionButtonDrag;
UIButton *pauseButton, *quitButton, *quitYesButton, *quitNoButton, *leftButton, *rightButton, *downButton, *upButton, *boostButton;
BOOL dead, pauseMenuTransitioning, enemyWillMoveNext, enemyAlive, enemyBulletAlive, isBoosting;
NSTimer *snakeMoveTimer, *dieFlashTimer, *scoreChangedTimer, *powerUpPopupTimer, *fadeInEndMenuTimer;
int snakeDirection, nextDirection, dieFlashCounter, scoreChangeStorage, powerUpTime, powerUpType, powerUpSpawnTime, powerUpFlashStage, cash, enemySpawnTime, enemyBulletSpawnTime, enemyMoveDirection, enemyMoveStepsLeft, enemyBulletDirection, timeSinceFoodSpawn;
NSMutableArray *listOfSnakeParts, *listOfObstacles, *directionArray;
UIImageView *border, *background, *snakePartTemplate, *food, *powerUp, *endMenuBackground, *pauseMenuBackground;
UILabel *scoreLabel, *scoreLabel2, *scoreLabelLabel, *powerUpDescription, *deathScoreLabel, *deathCommentLabel, *resumeLabel, *cashLabel;
UITextField *nameField;
int scoreDifference;

//directions: 0 = up, 1 = right, 2 = down, 3 = left
//power up times are in snake square movements
//power up flash stage: 0, 1 on; 2, 3 off;

//Statistics
long foodEaten, enemiesEaten, hitsByBullet, powerUpsEaten;
long deathsByObstacle, deathsBySelf;
long steps;

float fadeSpeed;
NSString *causeOfDeath;