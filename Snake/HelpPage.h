//
//  HelpPage.h
//  Snake
//
//  Created by Dylan Chong on 25/07/13.
//  Copyright (c) 2013 Dylan Chong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface HelpPage : UIView
@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UITextView *text;
@property (strong, nonatomic) UIImageView *image;

- (HelpPage *)initWithPage:(int)page;
@end
