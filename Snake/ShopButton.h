//
//  ShopButton.h
//  Snake
//
//  Created by Dylan Chong on 14/04/13.
//  Copyright (c) 2013 Dylan Chong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol shopButtonProtocol
- (void)updateUpgradePointLabelWithPurchasedButtonTitle:(NSString *)title;
- (void)adsJustPurchased;
- (void)notEnoughMoney;
- (void)adsButtonPressed;
- (void)hide8UpgradePointTutorial;
@end

@interface ShopButton : UIButton <UIAlertViewDelegate>
- (id)initWithTitle:(NSString *)title row:(int)row column:(int)column;
@property (strong, nonatomic) NSString *type;
@property int row;
@property int column;
@property id<shopButtonProtocol> delegate;

- (void)refreshAdButtonWithTitle:(NSString *)title;
@end