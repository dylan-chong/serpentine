//
//  HighScoreObject.m
//  Snake
//
//  Created by Dylan Chong on 18/11/12.
//  Copyright (c) 2012 Dylan Chong. All rights reserved.
//

#import "HighScoreObject.h"

@implementation HighScoreObject

- (id)initWithScore:(long long)score andName:(NSString *)name {
    self = [super init];
    if (self) {
        self.name = name;
        self.score = score;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)encoder {
	self = [super init];
    if (self) {
		self.name = [encoder decodeObjectForKey:@"name"];
        self.score = [encoder decodeIntForKey:@"score"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeInt:self.score forKey:@"score"];
}

@end