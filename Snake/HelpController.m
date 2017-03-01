//
//  HelpController.m
//  Snake
//
//  Created by Dylan Chong on 25/07/13.
//  Copyright (c) 2013 Dylan Chong. All rights reserved.
//

#import "HelpController.h"

@interface HelpController ()

@end

@implementation HelpController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    int numberOfPages = 5;
    
    [_titleBar setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Button 400x50 White.png"]]];
    [_pageControl setNumberOfPages:numberOfPages];
    [self scrollViewDidEndDecelerating:_scrollView];
    
    //********************************************************************
    _mainMenuHelpView = [[HelpPage alloc] initWithPage:helpMainMenu];
    _gameOptionsHelpView = [[HelpPage alloc] initWithPage:helpGameOptions];
    _gameStartHelpView = [[HelpPage alloc] initWithPage:helpGamePlay];
    _shopHelpView = [[HelpPage alloc] initWithPage:helpShop];
    _achievementsHelpView = [[HelpPage alloc] initWithPage:helpAchievements];
    
    [_scrollView addSubview:_mainMenuHelpView];
    [_scrollView addSubview:_gameOptionsHelpView];
    [_scrollView addSubview:_gameStartHelpView];
    [_scrollView addSubview:_shopHelpView];
    [_scrollView addSubview:_achievementsHelpView];
    //********************************************************************
    
    [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width * numberOfPages, _scrollView.frame.size.height)];
    [_scrollView flashScrollIndicators];
    _scrollView.delegate = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeButtonPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)goToPage:(long long)page {
    [_scrollView scrollRectToVisible:CGRectMake((page - 1) * 500, 0, _scrollView.frame.size.width, _scrollView.frame.size.height) animated:NO];
    [self scrollViewDidEndDecelerating:[[UIScrollView alloc] init]];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _pageControl.currentPage = _scrollView.contentOffset.x / _scrollView.frame.size.width;
}

@end
