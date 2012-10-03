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

int currentPlayer; //may be better to implement as int
int die1; //value of die face
int die2; //value of die face
int roundScore;
int player1Total;
int player2Total;
static int PLAYER1 = 1;
static int PLAYER2 = 2;
static int WINNING_SCORE = 100;
int ones; //how many dice with face "1" were rolled (values 0, 1, 2)
NSString *rollResultMessage[3]={@"You score:", @"A one! Score nothing", @"Two ones! Lose all points"};
BOOL rollAgain;

@implementation LocalPlayViewController

@synthesize rollButton;
@synthesize holdButton;
@synthesize exitButton;

@synthesize die1View;
@synthesize die2View;
@synthesize rollResultLabel;
@synthesize roundScoreLabel;
@synthesize player1ScoreLabel;
@synthesize player2ScoreLabel;

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
    currentPlayer = 1;
    roundScore = 0;
    player1Total = 0; //start at 0
    player2Total = 0; //start at 0
    die1 = 0;
    die2 = 0;
    rollResultLabel.text=@"Player1 to go first";
    [self showScoreLabels];
}

-(void)loadGameElements
{
    NSLog(@"loadGameElements started");
}

-(IBAction)rollButtonPressed:(id)sender
{
    NSLog(@"roll button pressed");
    [self rollDice];
    [self showDice];
    [self evaluateDice];
    [self calculateScore:true];
    [self showRollResult];
    [self showScoreLabels];
    if (!rollAgain)
    {
        [self changePlayers];
    }
}

-(IBAction)holdButtonPressed:(id)sender
{
    NSLog(@"hold button pressed");
    [self calculateScore:false];
    [self showScoreLabels];
    [self evaluateRound];
}

-(void)rollDice
{
    NSLog(@"rollDice started");
    //generate random number between 0 and 5
	die1 = arc4random() % 6 + 1;
    die2 = arc4random() % 6 + 1;
    NSLog(@"RD: Die1 is a %d", die1);
    NSLog(@"RD: Die2 is a %d", die2);
}

-(void)showDice
{
    NSLog(@"showDice started");
    //display dice on screen
        
    die1View.image=[UIImage imageNamed:[NSString stringWithFormat:@"dice%d.png", die1]];
    die2View.image=[UIImage imageNamed:[NSString stringWithFormat:@"dice%d.png", die2]];
}

-(void)evaluateDice
{
    NSLog(@"evaluateDice started");
    if (die1 == 1 && die2 == 1)
    {
        ones = 2;
        rollAgain = false;
    }
    
    else if (die1 == 1 || die2 == 1)
    {
        ones = 1;
        rollAgain = false;
    }

    else
    {
        ones = 0;
        rollAgain = true;
    }
}


-(void)showRollResult
{
    NSLog(@"showRollResult started");
    NSLog(@"SRR: ones is %d", ones);
    NSString *message;
    
    switch (ones)
    {
        case 0:
            message = [NSString stringWithFormat:@"%@%d",rollResultMessage[0], die1+die2];
            break;
        case 1:
            message = rollResultMessage[1];
            break;
        case 2:
            message = rollResultMessage[2];
            break;
        default:
            message = @"an error occurred";
    }
    rollResultLabel.text = message;
}

-(void)calculateScore:(BOOL)rollPress
{
    NSLog(@"calculateScore, %d", rollPress);
    
    if (rollPress)
    {
        switch (ones)
        {
            case 0:
                roundScore = roundScore + die1 + die2;
                break;
            
            case 1:
                roundScore = 0;
                break;
            
            case 2:
                roundScore = 0;
                [self resetTotalScore:currentPlayer];
                break;
            
            default:
                NSLog(@"CS: An error occured");
        }
    }
    
    if (!rollPress)
    {      
        NSLog(@"CS: currentPlayer is %d", currentPlayer);
        //add add roundscore to current player's total
        if (currentPlayer == PLAYER1)
        {
            player1Total = player1Total + roundScore;
        }
        if (currentPlayer == PLAYER2)
        {
            player2Total = player2Total + roundScore;
        }
        //reset roundscore
        roundScore = 0;
    }
        
        
}

-(void)resetTotalScore:(int)player
{
    NSLog(@"resetTotalScore started");
    if (player == PLAYER1)
    {
        player1Total = 0;
    }
    if (player == PLAYER2)
    {
        player2Total = 0;
    }
}

-(void)showScoreLabels
{
    NSLog(@"showScoreLabels started");
    //if (!rollAgain)
    //{
    //    rollResultLabel.text = [NSString stringWithFormat:@"Player %d to roll", currentPlayer];
   // }
    roundScoreLabel.text = [NSString stringWithFormat:@"Round: %d", roundScore];
    player1ScoreLabel.text = [NSString stringWithFormat:@"Player1: %d", player1Total];
    player2ScoreLabel.text = [NSString stringWithFormat:@"Player2: %d", player2Total];
}

-(void)evaluateRound
{
    int winningPlayer = [self checkWinner];
    
    if (winningPlayer == 0)
    {
        NSLog(@"No winner yet");
        [self changePlayers];

    }
    
    else {
        [self showWinnerMessage:winningPlayer];
    }
    
}

-(void)showWinnerMessage:(int)winningPlayer
{
    NSLog(@"Player %d wins", winningPlayer);
    NSLog(@"Please press exit");
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
    NSLog(@"changePlayers started, currentplayer was %d", currentPlayer);
    if (currentPlayer == PLAYER1)
    {
        currentPlayer = PLAYER2;
    }
    else 
    {
        currentPlayer = PLAYER1;
    }
    NSLog(@"CP: currentplayer is now %d", currentPlayer);
}

-(void)playSound
{
    
}


-(IBAction)exitButtonPressed:(id)sender
{
    [self exitToMenu];
}

-(void)exitToMenu
{
    //call main menu view
    [self resetGame];
    [self.navigationController popViewControllerAnimated:NO];
}

@end
