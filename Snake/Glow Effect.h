//
//  Glow Effect.h
//  Serpentine!
//
//  Created by Dylan Chong on 6/11/13.
//  Copyright (c) 2013 Dylan Chong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Glow_Effect : UIView
+ (Glow_Effect *)returnGlowObjectAt:(CGPoint)point withColourText:(NSString *)text;
+ (UIColor *)getColourWithText:(NSString *)text;
- (void)startAnimation;
@property (strong, nonatomic) UIColor *colour;
@property BOOL reversed;

@end
