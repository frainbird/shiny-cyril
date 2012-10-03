//
//  LocalPlayViewController.m
//  Pig
//
//  Created by  on 9/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LocalPlayViewController.h"

@interface LocalPlayViewController ()

@end

Boolean currentPlayer; //may be better to implement as int
int dice1;
int dice2;
int roundScore;
int player1Total = 50;
int player2Total = 101;
static int PLAYER1 = 1;
static int PLAYER2 = 2;
static int WINNING_SCORE = 100;
int ones; //0, 1, 2

@implementation LocalPlayViewController

@synthesize rollButton;
@synthesize holdButton;
@synthesize exitButton;

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
    [self playGame];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)playGame
{
    NSLog(@"Play game started");
    [self getStartingPlayer];
    [self resetGame];
    [self loadGameElements];
}

- (void)getStartingPlayer
{
    NSLog(@"getStartingPlayer started");
    //check for both player names
    //if invalid names, get player names
    
}

- (void)resetGame
{
    NSLog(@"resetGame started");
    
}

-(void)loadGameElements
{
    NSLog(@"loadGameElements started");
}

-(IBAction)rollButtonPressed:(id)sender
{
    NSLog(@"roll button pressed");
    [self rollDice];
    [self evaluateDice];
}

-(IBAction)holdButtonPressed:(id)sender
{
    NSLog(@"hold button pressed");
}

-(void)rollDice
{
    NSLog(@"rollDice started");
    
    
}

-(void)evaluateDice
{
    NSLog(@"evaluateDice started");
    if (dice1 == 1 && dice1 == 1)
    {
        ones=2;
    }
    
    else if (dice1 == 1 || dice2 == 1)
    {
        ones=1;
    }

    else
    {
        ones=0;
    }
}

-(int)checkWinner
{
    NSLog(@"checkWinner started");
    int winner;
    
    if (player1Total >= WINNING_SCORE)
    {
        winner = PLAYER1;
    }
    
    else if (player2Total >= WINNING_SCORE)
    {
        winner = PLAYER2;
    }
    
    else 
    {
        winner = 0;
    }
    
    return winner;
}

-(void)changePlayers
{
    NSLog(@"changePlayers started");
    if (currentPlayer) //may be better to implement as int
    {
        currentPlayer = false;
    }
    else 
    {
        currentPlayer = true;
    }
}

-(IBAction)exitButtonPressed:(id)sender
{
    [self exitToMenu];
}

-(void)exitToMenu
{
    //call main menu view
    [self.navigationController popViewControllerAnimated:NO];
}

@end
