//
//  Glow Effect.m
//  Serpentine!
//
//  Created by Dylan Chong on 6/11/13.
//  Copyright (c) 2013 Dylan Chong. All rights reserved.
//

#import "Glow Effect.h"

@implementation Glow_Effect {

}

- (id)initWithFrame:(CGRect)frame andColour:(UIColor *)colour
{
    self = [super initWithFrame:frame];
    if (self) {
        int diameter = 150;
        self.frame = CGRectMake(self.frame.origin.x - (diameter / 2), self.frame.origin.y - (diameter / 2), diameter + 10, diameter + 10);
        self.alpha = 0.5;
        self.colour = colour;
        self.backgroundColor = colour;//[UIColor blueColor];
    }
    return self;
}

/*
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor *fillColour = self.colour;
    CGContextSetLineWidth(context, 3.0);
    
    //CGContextAddEllipseInRect(context, CGRectMake(5, 5, self.frame.size.width - 10, self.frame.size.height - 10));
    CGContextAddRect(context, CGRectMake(5, 5, self.frame.size.width - 10, self.frame.size.height - 10));
    
    [fillColour setFill];
    
    CGContextFillPath(context);
}*/

+ (Glow_Effect *)returnGlowObjectAt:(CGPoint)point withColourText:(NSString *)text {
    Glow_Effect *glow = [[Glow_Effect alloc] initWithFrame:CGRectMake(point.x, point.y, 10, 10) andColour:[Glow_Effect getColourWithText:text]];
    return glow;
}

+ (UIColor *)getColourWithText:(NSString *)text {
    UIColor *colour;
    
    if ([text isEqualToString:@"blue"]) {
        colour = [UIColor colorWithRed:0.0 green:162.0/255 blue:232.0/255 alpha:1.0];
    } else if ([text isEqualToString:@"green"]) {
        colour = [UIColor colorWithRed:35.0/255 green:166.0/255 blue:59.0/255 alpha:1.0];
    } else if ([text isEqualToString:@"yellow"]) {
        colour = [UIColor colorWithRed:255.0/255 green:243.0/255 blue:10.0/255 alpha:1.0];
    } else if ([text isEqualToString:@"purple"]) {
        colour = [UIColor colorWithRed:165.0/255 green:64.0/255 blue:167.0/255 alpha:1.0];
    } else if ([text isEqualToString:@"white"]) {
        colour = [UIColor colorWithRed:255.0/255 green:255.0/255 blue:255.0/255 alpha:1.0];
    } else if ([text isEqualToString:@"orange"]) {
        colour = [UIColor colorWithRed:242.0/255 green:110.0/255 blue:52.0/255 alpha:1.0];
    }
    
    return colour;
}

- (void)startAnimation {
    if (_reversed == YES) {
        self.alpha = 0;
        [UIView animateWithDuration:1.0f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
            self.transform = CGAffineTransformMakeScale(0.001, 0.001);
            self.alpha = 0.5;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    } else {
        self.transform = CGAffineTransformMakeScale(0.001, 0.001);
        [UIView animateWithDuration:1.0f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
            self.transform = CGAffineTransformMakeScale(1.0, 1.0);
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

@end
