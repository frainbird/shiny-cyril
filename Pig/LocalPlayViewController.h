//
//  LocalPlayViewController.h
//  Pig
//
//  Created by  on 9/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Constants.h"
#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "NamesViewController.h"

@interface LocalPlayViewController : UIViewController
{
    IBOutlet UIButton *exitButton;
    IBOutlet UIButton *holdButton;
    IBOutlet UIButton *rollButton;
    IBOutlet UIImageView *die1View;
    IBOutlet UIImageView *die2View;
    IBOutlet UILabel *rollResultLabel;
    IBOutlet UILabel *roundScoreLabel;
    IBOutlet UILabel *player1ScoreLabel;
    IBOutlet UILabel *player2ScoreLabel;
    IBOutlet UILabel *player1NameLabel;
    IBOutlet UILabel *player2NameLabel;
    
        
}

@property UIButton *exitButton;
@property UIButton *holdButton;
@property UIButton *rollButton;
@property UIImageView *die1View;
@property UIImageView *die2View;
@property UILabel  *rollResultLabel;
@property UILabel  *roundScoreLabel;
@property UILabel *player1ScoreLabel;
@property UILabel *player2ScoreLabel;
@property UILabel *player1NameLabel;
@property UILabel *player2NameLabel;

-(void)playGame;


-(IBAction)holdButtonPressed:(id)sender;
-(IBAction)rollButtonPressed:(id)sender;
-(IBAction)exitButtonPressed:(id)sender;

@end
