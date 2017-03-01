//
//  BuyWindowViewController.m
//  Snake
//
//  Created by Dylan Chong on 18/05/13.
//  Copyright (c) 2013 Dylan Chong. All rights reserved.
//

#import "BuyWindowViewController.h"

@interface BuyWindowViewController ()

@end

@implementation BuyWindowViewController

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
    
    [_closeButton setTitle:@"Close" forState:UIControlStateNormal];
    [_closeButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:16.0f]];
    [_titleBar setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Button 400x50 Yellow.png"]]];
    
    _productIDs = [iAPBundleIDs returnAllIDs];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:doubleUpgradePointsPurchased] boolValue]) [self disableButton:_doubleUpgradePointsButton];
    if ([[defaults objectForKey:adsPurchased] boolValue]) [self disableButton:_removeAdsButton];
    
    _spinnerBackground = [[UIView alloc] initWithFrame:CGRectMake(10, 60, 520, 550)];
    _spinnerBackground.backgroundColor = [UIColor blackColor];
    _spinnerBackground.alpha = 0.9;
    [self.view addSubview:_spinnerBackground];
    
    _spinner.frame = CGRectMake(242, 256, 37, 37);
    [_spinner startAnimating];
    [_spinnerBackground addSubview:_spinner];
    
    _spinnerLabel.frame = CGRectMake(93, 218, 335, 21);
    [_spinnerBackground addSubview:_spinnerLabel];
    
    @try {
        [self getProductID];
    }
    @catch (NSException *exception) {
        NSLog(@"iAP cancel button crash");
    }
}

- (void)disableButton:(UIButton *)button {
    button.userInteractionEnabled = NO;
    [button setTitle:[button.titleLabel.text stringByAppendingString:@" Purchased"] forState:UIControlStateNormal];
    
    UIView *cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, button.frame.size.width + 60, button.frame.size.height)];
    cover.alpha = 0.5;
    cover.backgroundColor = [UIColor blackColor];
    [button addSubview:cover];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidUnload {
    [self setTitleBar:nil];
    [super viewDidUnload];
    
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (IBAction)infoButtonPressed:(UIButton *)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Serpentine!" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    if (sender.tag == 1) {
        //buy 20
        alert.title = @"Instantly get 20 Upgrade Points to spend in the Shop!";
    } else if (sender.tag == 2) {
        //buy 45
        alert.title = @"Instantly get 45 Upgrade Points to spend in the Shop!";
    } else if (sender.tag == 3) {
        //buy 100
        alert.title = @"Instantly get 100 Upgrade Points to spend in the Shop!";
    } else if (sender.tag == 4) {
        //double
        alert.title = @"Permanently double the upgrade points you receive at the end of each game!";
    } else if (sender.tag == 5) {
        //remove ads + 20
        alert.title = @"Remove those annoying iAds and get 20 upgrade points with one purchase!";
    }
    [alert show];
}

- (IBAction)purchaseButtonPressed:(UIButton *)sender {
    _whichProduct = 0;
    if (sender.tag == 1) {
        //buy 20
        _whichProduct = 1;
    } else if (sender.tag == 2) {
        //buy 45
        _whichProduct = 2;
    } else if (sender.tag == 3) {
        //buy 100
        _whichProduct = 0;
    } else if (sender.tag == 4) {
        //double
        _whichProduct = 3;
    } else if (sender.tag == 5) {
        //remove ads + 20
        _whichProduct = 4;
    }
    
    SKPayment *payment = [SKPayment paymentWithProduct:_products[_whichProduct]];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
    [self showLoadingWithText:@"Purchasing item..."];
}

#pragma mark - Loading Stuff

- (void)couldNotConnectToStoreWithText:(NSString *)text {
    [_spinner removeFromSuperview];
    [_spinner stopAnimating];
    [_spinnerLabel setText:text];
}

- (void)hideLoading {
    [UIView animateWithDuration:0.5f animations:^{
        _spinnerBackground.alpha = 0;
    } completion:^(BOOL finished) {
        [_spinnerBackground removeFromSuperview];
    }];
}

- (void)showLoadingWithText:(NSString *)text {
    NSLog(@"show");
    [self.view addSubview:_spinnerBackground];
    [self.view bringSubviewToFront:_spinnerBackground];
    
    [_spinnerBackground addSubview:_spinner];
    [_spinnerBackground addSubview:_spinnerLabel];
    _spinnerLabel.text = text;
    
    [UIView animateWithDuration:0.5f animations:^{
        _spinnerBackground.alpha = 0.9;
    }];
}


#pragma mark - iAP

- (void)getProductID {
    if ([SKPaymentQueue canMakePayments]) {
        SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:_productIDs];
        request.delegate = self;
        
        [request start];
        
        [self restoreButtonClicked:nil];
    } else {
        [self couldNotConnectToStoreWithText:@"Error: Could not connect to store. Parental Controls may be on."];
    }
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSArray *products = response.products;
    if (products.count != 0) {
        _products = products;
    } else {
        [self couldNotConnectToStoreWithText:@"Error: Could not connect to iTunes"];
    }
    
    products = response.invalidProductIdentifiers;
    
    for (SKProduct *product in products) {
        NSLog(@"Product not found: %@", product);
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    NSLog(@"queue");
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:[self unlockPurchase];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateFailed:NSLog(@"Transaction Failed");//[[[UIAlertView alloc] initWithTitle:@"Serpentine" message:@"Error: Transaction Failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                [self hideLoading];
        }
    }
}

- (void)unlockPurchase {
    NSLog(@"unlocked:");
    
    if (_whichProduct == 1) {
        NSLog(@"  buy20");
        [self addMoney:20];
    } else if (_whichProduct == 2) {
        NSLog(@"  buy45");
        [self addMoney:45];
    } else if (_whichProduct == 0) {
        NSLog(@"  buy100");
        [self addMoney:100];
    } else if (_whichProduct == 3) {
        NSLog(@"  buydouble");
        [self buyDouble];
    } else if (_whichProduct == 4) {
        NSLog(@"  buyads");
        [self buyAds];
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Serpentine!" message:@"Purchase successful!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    [self hideLoading];
}

- (void)addMoney:(int)cash {
    [[NSUserDefaults standardUserDefaults] setInteger:[[[NSUserDefaults standardUserDefaults] objectForKey:cashKey] integerValue] + cash forKey:cashKey];
    [self.delegate refreshCash];
}

- (void)buyDouble {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:doubleUpgradePointsPurchased];
    [self disableButton:_doubleUpgradePointsButton];
}

- (void)buyAds {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:adsPurchased];
    [self disableButton:_removeAdsButton];
    [self addMoney:20];
    [self.delegate refreshAdButton];
}

#pragma mark - Restoring Purchases

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
    NSMutableArray *purchasedItemIDs = [[NSMutableArray alloc] init];
    NSLog(@"received restored transactions: %lu", (unsigned long)queue.transactions.count);
    
    for (SKPaymentTransaction *transaction in queue.transactions) {
        NSString *productID = transaction.payment.productIdentifier;
        [purchasedItemIDs addObject:productID];
        NSLog(@"%@", productID);
    }
    
    //restoring purchases
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([[defaults objectForKey:doubleUpgradePointsPurchased] boolValue] == NO && [purchasedItemIDs containsObject:[iAPBundleIDs buyDoubleID]]) {
        [defaults setBool:YES forKey:doubleUpgradePointsPurchased];
        [self buyDouble];
    }
    
    if ([[defaults objectForKey:adsPurchased] boolValue] == NO && [purchasedItemIDs containsObject:[iAPBundleIDs buyiAdsID]]) {
        [defaults setBool:YES forKey:adsPurchased];
        [self buyAds];
    }

    [self hideLoading];
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {
    NSLog(@"%@", error);
    [self hideLoading];
}

- (IBAction)restoreButtonClicked:(id)sender {
    [self showLoadingWithText:@"Restoring Purchases"];
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}


@end
