//
//  HighScoreObject.h
//  Snake
//
//  Created by Dylan Chong on 18/11/12.
//  Copyright (c) 2012 Dylan Chong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HighScoreObject : NSObject {
}
@property NSString *name;
@property int score;
-(id)initWithScore:(long long)score andName:(NSString *)name;
-(void)encodeWithCoder:(NSCoder *)encoder;
@end