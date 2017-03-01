//
//  HelpPage.m
//  Snake
//
//  Created by Dylan Chong on 25/07/13.
//  Copyright (c) 2013 Dylan Chong. All rights reserved.
//

#import "HelpPage.h"

@implementation HelpPage

- (HelpPage *)initWithPage:(int)page {
    self = [super initWithFrame:CGRectMake((page - 1) * 500 + 10, 0, 480, 482)];
    
    if (self) {
        _title = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.frame.size.width - 20, 50)];
        _title.font = [UIFont fontWithName:@"Helvetica-Bold" size:36.0f];
        _title.textAlignment = NSTextAlignmentCenter;
        _title.textColor = [UIColor whiteColor];
        _title.backgroundColor = [UIColor clearColor];
        
        int size = -10;
        int width = 400 + (size * 4);
        int height = 300 + (size * 3);
        _image = [[UIImageView alloc] initWithFrame:CGRectMake((460 - width) / 2, 0, width, height)];
        _image.backgroundColor = [UIColor clearColor];
        _image.layer.borderColor = [[UIColor blackColor] CGColor];
        _image.layer.borderWidth = 2.0;
        
        _text = [[UITextView alloc] initWithFrame:CGRectMake(10, _title.frame.origin.y + _title.frame.size.height + 10, self.frame.size.width - 20, 482 - (_title.frame.origin.y + _title.frame.size.height + 10) + 8)];
        _text.font = [UIFont fontWithName:@"Helvetica" size:16.0f];
        _text.textAlignment = NSTextAlignmentLeft;
        _text.textColor = [UIColor whiteColor];
        _text.editable = NO;
        _text.backgroundColor = [UIColor clearColor];
        _text.text = @"\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n";
        
        if (page == helpMainMenu) {
            _title.text = @"The Main Menu";
            _image.image = [UIImage imageNamed:@"Help Main Menu.png"];
            _text.text = [_text.text stringByAppendingString:@"\tThis screen is of course the first you see when you open the app and is used to navigate between the four main sections.\n\tTap on the Play tab and a window will slide out showing your gameplay options (see next page for more info) and a button allowing you to begin playing. The high scores tab pulls out a long list of your best scores and a list of random statistics such as number of deaths. Options lets you change sound settings, control type, and send us feedback (please do). The shop is where you spend upgrade points earned by playing in order to unlock more fun features to keep the game interesting.\n\tTo close a window, just touch on the tab and it will slide back to its normal position."];
            
        } else if (page == helpGameOptions) {
            _title.text = @"Gameplay Options";
            _image.image = [UIImage imageNamed:@"Help Game Options.png"];
            _text.text = [_text.text stringByAppendingString:@"\tThis is where you select your gameplay options before starting a game. \n\tThe first option, the speed of your snake, determines the difficulty and the score you get for eating food. To earn upgrade points (to spend in the shop) quickly use a faster speed, but to earn a higher score use a slower speed to make survival easier.\n\tThe switches are toggles for in-game features that you can buy in the shop (see the shop help page for more details). The more features you enable, the more your score will increase when you eat food. Features that you haven't unlocked will be greyed out."];
            
        } else if (page == helpGamePlay) {
            _title.text = @"Game Play";
            _image.image = [UIImage imageNamed:@"Help Gameplay.png"];
            _text.text = [_text.text stringByAppendingString:@"\tThe basic principals of Serpentine are very basic - eat as much food (green blocks) as possible can and avoid dying. For every piece of food you eat your score will increase, and this increase is determined by the speed of the snake and how many in-game features you have enabled (see the next page for more information).\n\tYou control the snake by using the up/down/left/right buttons on the bottom right of the screen or by swiping in the corresponding direction. If the buttons are in the way of the snake or you want to use your left hand to control it, you can move them sideways towards the left of the screen by dragging it with three fingers. Tip: your snake can go through one side of the screen and out the opposite as long as there is nothing in its path that will cause it to die.\n\tThe button on the left of the screen speeds up time when you hold it down. This speeds up the snake so you can get to the food faster if it is far away.\n\tThe green block of food will appear in a random spot, somewhere on the screen. It will periodically teleport somewhere else to avoid permanently being in an unreachable place (when some of the in-game features are enabled). The snake also has a blue head for a few seconds at the beginning of the game, providing invincibility. This is to avoid the possibility of an accidental and instant death possible when some in-game features are enabled.\n\tWhen the snake dies by crashing into itself or a red obstacle block (requires unlocking some of the obstacle features) it will flash for a few seconds and a death screen will fade in showing you your score and a death message below it. The amount of upgrade points you have will be at the top left of the screen, including the ones you just earned. You earn one for every thousand points in your score. Enter your name and the score will be saved in the high score tab (see the high score help page for more info). If you don't enter a name, it will be saved under the name 'Player'."];
            
        } else if (page == helpShop) {
            _title.text = @"The Shop";
            _image.image = [UIImage imageNamed:@"Help Shop.png"];
            _text.text = [_text.text stringByAppendingString:@"\tThe shop is a very important part of Serpentine. It allows you to unlock features that add to the game and make it unique. To buy a feature just tap on one of the yellow blocks. If you do not have enough upgrade points to buy a feature, simply play a few games or buy some using the tall button in the middle of the store.\n\tThe Obstacle Border feature is recommended to be either the first or second feature to buy - due to its low cost. And just like all the other features, it increases the amount your score goes up when you eat food, and makes earning more upgrade points easier. The obstacle border is simply a rectangle around the edge of the screen, made of harmful red obstacle blocks - don't try to eat them!. It also prevents you from going through one end of the screen and out the other.\n\tObstacle Formations are randomly generated groups of red blocks. If you crash into one you will die, just like the obstacle border. They make gameplay more difficult and interesting as the area will look completely different every time you play. It is recommended that this is either the first or second feature you buy.\n\tPower ups appear randomly from time on the screen - eat them to activate them. There are three types: invincibility (blue block) which is automatically granted at the start of the game for a few seconds to avoid an immediate crash into an obstacle when starting the game, and allows you to travel through obstacles and through yourself for a certain period of time; double score (yellow block) which doubles the increase in score when eating; and time shift (purple block) which slows down time allowing you to navigate more easily. It also prevents the enemy (more info further down) from moving. When you eat the power up the head of the snake will change to the corresponding colour, and will flash orange before running out.\n\tThe Obstacle Ruins feature requires the Obstacle Formations feature to work properly. It makes the map look like ancient ruins by randomly scattering and deleting obstacle blocks.\n\tThe Enemy (white block) spawns at random times throughout the game, moving around while attempting to shoot at you. If it hits you, you lose a considerable amount of score. If it hits an obstacle block however, it will either create another obstacle in front of it, or destroy it. Eating the enemy will give you a very large amount of points."];
            
        } else if (page == helpAchievements) {
            _title.text = @"High Scores";
            _image.image = [UIImage imageNamed:@"Help Achievements.png"];
            _text.text = [_text.text stringByAppendingString:@"\tThe High Scores column shows a scrollable list of your best 99 scores. If you want to clear them, simply swipe sideways along one of your scores. The statistics column counts random things such as deaths."];
            
        }
        
        [self addSubview:_title];
        [self addSubview:_text];
        [_text addSubview:_image];
    }
    return self;
}

@end
