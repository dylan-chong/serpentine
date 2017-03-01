//
//  ShopButton.m
//  Snake
//
//  Created by Dylan Chong on 14/04/13.
//  Copyright (c) 2013 Dylan Chong. All rights reserved.
//

#import "ShopButton.h"

@implementation ShopButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)refreshAdButtonWithTitle:(NSString *)title {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.type = adsPurchased;
    if ([[defaults objectForKey:adsPurchased] boolValue] == YES) {
        [self setTitle:@"Ads Removed" forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"Button 420x50 Tinted"] forState:UIControlStateNormal];
    } else {
        [self setTitle:title forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"Button 420x50"] forState:UIControlStateNormal];
    }
}

- (id)initWithTitle:(NSString *)title row:(int)row column:(int)column {
    self = [super init];
    if (self) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([title isEqualToString:adShopTitle]) {
            [self refreshAdButtonWithTitle:title];
        } else if ([title isEqualToString:obstacleBorderShopTitle]) {
            self.type = obstacleBorderPurchased;
            if ([[defaults objectForKey:obstacleBorderPurchased] boolValue] == YES) {
                [self setTitle:@"Obstacle Border Unlocked" forState:UIControlStateNormal];
                [self setBackgroundImage:[UIImage imageNamed:@"Button 420x50 Tinted"] forState:UIControlStateNormal];
            } else {
                [self setTitle:title forState:UIControlStateNormal];
                [self setBackgroundImage:[UIImage imageNamed:@"Button 420x50"] forState:UIControlStateNormal];
            }
        } else if ([title isEqualToString:obstaclesShopTitle]) {
            self.type = obstaclesPurchased;
            if ([[defaults objectForKey:obstaclesPurchased] boolValue] == YES) {
                [self setTitle:@"Obstacle Formations Unlocked" forState:UIControlStateNormal];
                [self setBackgroundImage:[UIImage imageNamed:@"Button 420x50 Tinted"] forState:UIControlStateNormal];
            } else {
                [self setTitle:title forState:UIControlStateNormal];
                [self setBackgroundImage:[UIImage imageNamed:@"Button 420x50"] forState:UIControlStateNormal];
            }
        } else if ([title isEqualToString:obstacleRuinsShopTitle]) {
            self.type = obstacleRuinsPurchased;
            if ([[defaults objectForKey:obstacleRuinsPurchased] boolValue] == YES) {
                [self setTitle:@"Ruin-Style Obstacles Unlocked" forState:UIControlStateNormal];
                [self setBackgroundImage:[UIImage imageNamed:@"Button 420x50 Tinted"] forState:UIControlStateNormal];
            } else {
                [self setTitle:title forState:UIControlStateNormal];
                [self setBackgroundImage:[UIImage imageNamed:@"Button 420x50"] forState:UIControlStateNormal];
            }
        } else if ([title isEqualToString:powerUpsShopTitle]) {
            self.type = powerUpsPurchased;
            if ([[defaults objectForKey:powerUpsPurchased] boolValue] == YES) {
                [self setTitle:@"Power Ups Unlocked" forState:UIControlStateNormal];
                [self setBackgroundImage:[UIImage imageNamed:@"Button 420x50 Tinted"] forState:UIControlStateNormal];
            } else {
                [self setTitle:title forState:UIControlStateNormal];
                [self setBackgroundImage:[UIImage imageNamed:@"Button 420x50"] forState:UIControlStateNormal];
            }
        } else if ([title isEqualToString:enemiesShopTitle]) {
            self.type = enemiesPurchased;
            if ([[defaults objectForKey:enemiesPurchased] boolValue] == YES) {
                [self setTitle:@"Enemies Unlocked" forState:UIControlStateNormal];
                [self setBackgroundImage:[UIImage imageNamed:@"Button 420x50 Tinted"] forState:UIControlStateNormal];
            } else {
                [self setTitle:title forState:UIControlStateNormal];
                [self setBackgroundImage:[UIImage imageNamed:@"Button 420x50"] forState:UIControlStateNormal];
            }
        }
        
        self.row = row;
        self.column = column;
        CGRect frame = CGRectMake(0, 0, 420, 50);
        if (column == 1) {
            frame.origin.x = 512 - (450 + 10) - 2;
        } else { //column == 2
            frame.origin.x = 512 + 40 - 2;
        }
        frame.origin.y = (100 * row) + 60;//(70 * row) - 20;
        self.frame = frame;
        
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:16.0f]];
        
        [self addTarget:self action:@selector(clicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)clicked {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Serpentine!" message:@"Temp message" delegate:self cancelButtonTitle:@"No, don't buy it" otherButtonTitles:@"Yes buy it", nil];
    
    if ([self.type isEqualToString:adsPurchased]) {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:adsPurchased] boolValue] != YES) {
            [self.delegate adsButtonPressed];
        }
    } else if ([self.type isEqualToString:obstacleBorderPurchased]) {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:obstacleBorderPurchased] boolValue] != YES) {
            alert.message = [NSString stringWithFormat:@"Are you sure you want to buy the Obstacle Border for %i upgrade points?", obstacleBorderPrice];
            alert.tag = 1;
            [alert show];
        }
    } else if ([self.type isEqualToString:obstaclesPurchased]) {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:obstaclesPurchased] boolValue] != YES) {
            alert.message = [NSString stringWithFormat:@"Are you sure you want to buy Obstacle Formations for %i upgrade points?", obstaclesPrice];
            alert.tag = 2;
            [alert show];
        }
    } else if ([self.type isEqualToString:obstacleRuinsPurchased]) {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:obstacleRuinsPurchased] boolValue] != YES) {
            alert.message = [NSString stringWithFormat:@"Are you sure you want to buy Ruin-Style Obstacles for %i upgrade points? Note: this feature requires 'Obstacle Formations' to be unlocked to work.", obstacleRuinsPrice];
            alert.tag = 3;
            [alert show];
        }
    } else if ([self.type isEqualToString:powerUpsPurchased]) {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:powerUpsPurchased] boolValue] != YES) {
            alert.message = [NSString stringWithFormat:@"Are you sure you want to buy Invincibility, Double Score, and Time Shift Power Ups for %i upgrade points?", powerUpsPrice];
            alert.tag = 4;
            [alert show];
        }
    } else if ([self.type isEqualToString:enemiesPurchased]) {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:enemiesPurchased] boolValue] != YES) {
            alert.message = [NSString stringWithFormat:@"Are you sure you want to unlock shooting Enemies for %i upgrade points?", enemyPrice];
            alert.tag = 5;
            [alert show];
        }
    }
    
    
    [self.delegate hide8UpgradePointTutorial];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        //ignore ad tag (gone)
        [self.delegate updateUpgradePointLabelWithPurchasedButtonTitle:self.titleLabel.text];
        
        if (alertView.tag == 1) {
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:cashKey] intValue] >= obstacleBorderPrice) {
                [[NSUserDefaults standardUserDefaults] setInteger:[[[NSUserDefaults standardUserDefaults] objectForKey:cashKey] integerValue] - obstacleBorderPrice forKey:cashKey];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:obstacleBorderPurchased];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Serpentine!" message:@"Purchased!" delegate:nil cancelButtonTitle:@"Yay!" otherButtonTitles:nil];
                [alert show];
                [self setTitle:@"Obstacle Border Unlocked" forState:UIControlStateNormal];
                [self setBackgroundImage:[UIImage imageNamed:@"Button 420x50 Tinted"] forState:UIControlStateNormal];
            } else {
                [self youDoNotHaveEnoughMoney];
            }
        } else if (alertView.tag == 2) {
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:cashKey] intValue] >= obstaclesPrice) {
                [[NSUserDefaults standardUserDefaults] setInteger:[[[NSUserDefaults standardUserDefaults] objectForKey:cashKey] integerValue] - obstaclesPrice forKey:cashKey];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:obstaclesPurchased];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Serpentine!" message:@"Purchased!" delegate:nil cancelButtonTitle:@"Yay!" otherButtonTitles:nil];
                [alert show];
                [self setTitle:@"Obstacle Formations Unlocked" forState:UIControlStateNormal];
                [self setBackgroundImage:[UIImage imageNamed:@"Button 420x50 Tinted"] forState:UIControlStateNormal];
            } else {
                [self youDoNotHaveEnoughMoney];
            }
        } else if (alertView.tag == 3) {
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:cashKey] intValue] >= obstacleRuinsPrice) {
                [[NSUserDefaults standardUserDefaults] setInteger:[[[NSUserDefaults standardUserDefaults] objectForKey:cashKey] integerValue] - obstacleRuinsPrice forKey:cashKey];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:obstacleRuinsPurchased];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Serpentine!" message:@"Purchased!" delegate:nil cancelButtonTitle:@"Yay!" otherButtonTitles:nil];
                [alert show];
                [self setTitle:@"Obstacle Ruins Unlocked" forState:UIControlStateNormal];
                [self setBackgroundImage:[UIImage imageNamed:@"Button 420x50 Tinted"] forState:UIControlStateNormal];
            } else {
                [self youDoNotHaveEnoughMoney];
            }
        } else if (alertView.tag == 4) {
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:cashKey] intValue] >= powerUpsPrice) {
                [[NSUserDefaults standardUserDefaults] setInteger:[[[NSUserDefaults standardUserDefaults] objectForKey:cashKey] integerValue] - powerUpsPrice forKey:cashKey];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:powerUpsPurchased];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Serpentine!" message:@"Purchased!" delegate:nil cancelButtonTitle:@"Yay!" otherButtonTitles:nil];
                [alert show];
                [self setTitle:@"Power Ups Unlocked" forState:UIControlStateNormal];
                [self setBackgroundImage:[UIImage imageNamed:@"Button 420x50 Tinted"] forState:UIControlStateNormal];
            } else {
                [self youDoNotHaveEnoughMoney];
            }
        } else if (alertView.tag == 5) {
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:cashKey] intValue] >= enemyPrice) {
                [[NSUserDefaults standardUserDefaults] setInteger:[[[NSUserDefaults standardUserDefaults] objectForKey:cashKey] integerValue] - enemyPrice forKey:cashKey];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:enemiesPurchased];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Serpentine!" message:@"Purchased!" delegate:nil cancelButtonTitle:@"Yay!" otherButtonTitles:nil];
                [alert show];
                [self setTitle:@"Enemies Unlocked" forState:UIControlStateNormal];
                [self setBackgroundImage:[UIImage imageNamed:@"Button 420x50 Tinted"] forState:UIControlStateNormal];
            } else {
                [self youDoNotHaveEnoughMoney];
            }
        }
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.delegate updateUpgradePointLabelWithPurchasedButtonTitle:@""];
    }
}

- (void)youDoNotHaveEnoughMoney {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Serpentine!" message:@"You don't have enough money to buy this." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [self.delegate notEnoughMoney];
}

@end