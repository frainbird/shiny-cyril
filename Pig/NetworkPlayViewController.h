//
//  NetworkPlayViewController.h
//  Pig
//
//  Created by  on 9/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Constants.h"
#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "NamesViewController.h"


@interface NetworkPlayViewController : UIViewController
{
    //local variables
    
    //network variables
    NSString    *gamePeerID;
    GKSession   *gameSession;
    
    //sound variables
    NSURL           *rollSoundURL;
    SystemSoundID    rollSoundID;
    
    NSURL           *holdSoundURL;
    SystemSoundID    holdSoundID;
    
    NSURL           *pigSound1URL; //sound for one 'pig' die
    SystemSoundID    pigSound1ID;
    
    NSURL           *pigSound2URL; //sound for two 'pig' dice
    SystemSoundID    pigSound2ID;
    
    //player names
    NSString *player1Name;
    NSString *player2Name;
    
    //main game variables ints
    int currentPlayer;  
    int die1;           //value of die face
    int die2;           //value of die face
    int roundScore;     
    int player1Total;
    int player2Total;
    int ones; //how many dice with face "1" were rolled (values 0, 1, 2)
    
    BOOL rollAgain; //controls if the player may roll again this turn
    
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

@property(nonatomic,retain) GKSession   *gameSession;
@property(nonatomic,copy)   NSString    *gamePeerID;

-(void)playGame;

-(IBAction)holdButtonPressed:(id)sender;
-(IBAction)rollButtonPressed:(id)sender;
-(IBAction)exitButtonPressed:(id)sender;

-(void)startPicker;
-(void)invalidateSession:(GKSession *)session;
-(IBAction)exitButtonPressed:(id)sender;

@end
