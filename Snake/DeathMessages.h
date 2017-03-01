//
//  DeathMessages.h
//  Snake
//
//  Created by Dylan Chong on 12/04/13.
//  Copyright (c) 2013 Dylan Chong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeathMessages : NSObject
+ (NSString *)randomObstacleDeathMessage;
+ (NSString *)randomSnakeBodyDeathMessage;
+ (NSString *)randomCheaterDeathMessage;
@end