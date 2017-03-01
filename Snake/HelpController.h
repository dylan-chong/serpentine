//
//  HelpController.h
//  Snake
//
//  Created by Dylan Chong on 25/07/13.
//  Copyright (c) 2013 Dylan Chong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HelpPage.h"

@interface HelpController : UIViewController <UIScrollViewDelegate, UIPageViewControllerDelegate>
- (void)goToPage:(long long)page;
- (IBAction)closeButtonPressed:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *titleBar;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (strong, nonatomic) HelpPage *mainMenuHelpView, *gameOptionsHelpView, *gameStartHelpView, *shopHelpView, *achievementsHelpView;
@end