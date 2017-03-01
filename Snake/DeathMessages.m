//
//  DeathMessages.m
//  Snake
//
//  Created by Dylan Chong on 12/04/13.
//  Copyright (c) 2013 Dylan Chong. All rights reserved.
//

#import "DeathMessages.h"

@implementation DeathMessages

+ (NSString *)randomObstacleDeathMessage {
    int a = arc4random() % 5;
    if (a == 0) {
        return @"Walls ARE edible, you just didn't chew hard enough.";
    } else if (a == 1) {
        return @"Walls aren't the best food to eat.";
    } else if (a == 2) {
        return @"Remember: The red things are not your friends and will not become so, no matter how hard you hug them.";
    } else if (a == 3) {
        return @"Don't eat THAT! You don't know where it's been!";
    } else {
        return @"Why did you eat that? It's been there for more than five seonds!";
    }
}

+ (NSString *)randomSnakeBodyDeathMessage {
    int a = arc4random() % 5;
    if (a == 0) {
        return @"Cannibalism is bad, auto-cannibalism is doubly bad. Because you die.";
    } else if (a == 1) {
        return @"Eating yourself is not a good idea.";
    } else if (a == 2) {
        return @"I've heard it say that snake tastes like chicken. Is chicken really worth dying for? No, it isn't.";
    } else if (a == 3) {
        return @"See what raw snake meat does to a person? Food safety, guys, food safety.";
    } else {
        return @"No, you do not eat yourself to increase your length, you eat yourself to die.";
    }
}

+ (NSString *)randomCheaterDeathMessage {
    int a = arc4random() % 5;
    if (a == 0) {
        return @"You cheater.";
    } else if (a == 1) {
        return @"Stop cheating!";
    } else if (a == 2) {
        return @"Seriously! You're ruining the game!";
    } else if (a == 3) {
        return @"Yea, you totally didn't cheat.";
    } else {
        return @"Sigh.";
    }
}

@end
