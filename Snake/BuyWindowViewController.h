//
//  BuyWindowViewController.h
//  Snake
//
//  Created by Dylan Chong on 18/05/13.
//  Copyright (c) 2013 Dylan Chong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "iAPBundleIDs.h"

@protocol BuyWindowViewControllerDelegate <NSObject>

- (void)refreshAdButton;
- (void)refreshCash;

@end

@interface BuyWindowViewController : UIViewController <SKPaymentTransactionObserver, SKProductsRequestDelegate>
- (IBAction)closeButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *spinnerLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) UIView *spinnerBackground;

@property (weak, nonatomic) IBOutlet UIButton *doubleUpgradePointsButton;
@property (weak, nonatomic) IBOutlet UIButton *removeAdsButton;

- (IBAction)restoreButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *restoreButton;
@property (weak, nonatomic) IBOutlet UILabel *titleBar;
- (IBAction)infoButtonPressed:(UIButton *)sender;
- (IBAction)purchaseButtonPressed:(UIButton *)sender;

@property (strong, nonatomic) NSArray *products;
@property (strong, nonatomic) NSString *productID;
@property (strong, nonatomic) NSSet *productIDs;
@property int whichProduct;

- (void)getProductID;

@property id<BuyWindowViewControllerDelegate> delegate;

@end