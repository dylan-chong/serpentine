//
//  AchievementObject.m
//  Snake
//
//  Created by Dylan Chong on 12/12/12.
//  Copyright (c) 2012 Dylan Chong. All rights reserved.
//

#import "AchievementObject.h"

@implementation AchievementObject

- (id)initWithName:(NSString *)name andCompleted:(BOOL)completed {
    self = [super init];
    if (self) {
        self.name = name;
        self.completed = completed;
    }
    return self;
}

@end