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

//local variables

//local constants
const int PLAYER1 = 1;
const int PLAYER2 = 2;
const int WINNING_SCORE = 100;

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
NSString *Player1Name = @"";
NSString *Player2Name = @"";

//main game variables ints
int currentPlayer;  
int die1;           //value of die face
int die2;           //value of die face
int roundScore;     
int player1Total;
int player2Total;
int ones; //how many dice with face "1" were rolled (values 0, 1, 2)

NSString *rollResultMessage[3]={@"Roll score:", @"A one! Score nothing", @"Two ones! Lose all points"};

BOOL rollAgain; //controls if the player may roll again this turn


@implementation LocalPlayViewController

//buttons
@synthesize rollButton;
@synthesize holdButton;
@synthesize exitButton;

//dice images
@synthesize die1View;
@synthesize die2View;

//screen labels
@synthesize rollResultLabel;
@synthesize roundScoreLabel;
@synthesize player1ScoreLabel;
@synthesize player2ScoreLabel;
@synthesize player1NameLabel;
@synthesize player2NameLabel;


#pragma mark -
#pragma mark View Controller Methods

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

#pragma mark -
#pragma mark Button Press Methods

-(IBAction)rollButtonPressed:(id)sender
{
    NSLog(@"roll button pressed");
    AudioServicesPlaySystemSound(rollSoundID);
    [self rollDice];
    [self showDice];
    [self evaluateDice];
    [self calculateScore:true]; //true: roll press is sending the message
    [self showRollResult];
    [self showScoreLabels];
    [self playResultSound];
    if (!rollAgain)
    {
        [self changePlayers];
    }
}

-(IBAction)holdButtonPressed:(id)sender
{
    NSLog(@"hold button pressed");
    [self calculateScore:false]; //false: roll press isn't sending the message
    [self showScoreLabels];
    [self evaluateRound];
    [self playSound:holdSoundID];
}

-(IBAction)exitButtonPressed:(id)sender
{
    [self exitToMenu];
}



#pragma mark -
#pragma mark Sound Methods

-(void)initialiseSounds
{
    rollSoundURL = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                             pathForResource:@"rollSound2" 
                             ofType:@"wav"]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef) rollSoundURL, &rollSoundID);    
    
    holdSoundURL = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                           pathForResource:@"holdSound" 
                                           ofType:@"wav"]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef) holdSoundURL, &holdSoundID);    
    
    pigSound1URL = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                           pathForResource:@"pigSound1" 
                                           ofType:@"wav"]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef) pigSound1URL, &pigSound1ID);
    
    pigSound2URL = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                              pathForResource:@"pigSound2" 
                                              ofType:@"wav"]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef) pigSound2URL, &pigSound2ID); 
}

-(void)playResultSound
{
    NSLog(@"playResultSound, ones is: %d",ones);
    if (ones == 0)
    {
        //AudioServicesPlaySystemSound(pigSound1ID);
    }
    
    if (ones == 1)
    {
        AudioServicesPlaySystemSound(pigSound1ID);
    }
    if (ones == 2)
    {
        AudioServicesPlaySystemSound(pigSound2ID);
    }
}

-(void)playSound:(SystemSoundID)soundID
{
    AudioServicesPlaySystemSound(soundID);
}

#pragma mark -
#pragma mark Basic UI Methods


-(void)showPlayerNames
{
    player1NameLabel.text = Player1Name;
    player2NameLabel.text = Player2Name;
}


-(void)showDice
{
    NSLog(@"showDice started");
    //display dice on screen
    
    die1View.image=[UIImage imageNamed:[NSString stringWithFormat:@"dice%d.png", die1]];
    die2View.image=[UIImage imageNamed:[NSString stringWithFormat:@"dice%d.png", die2]];
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


-(void)showScoreLabels
{
    NSLog(@"showScoreLabels started");
    //if (!rollAgain)
    //{
    //    rollResultLabel.text = [NSString stringWithFormat:@"Player %d to roll", currentPlayer];
    // }
    roundScoreLabel.text = [NSString stringWithFormat:@"Round: %d", roundScore];
    player1ScoreLabel.text = [NSString stringWithFormat:@"%@: %d", Player1Name, player1Total];
    player2ScoreLabel.text = [NSString stringWithFormat:@"%@: %d", Player2Name, player2Total];
}

-(void)showWinnerMessage:(int)winningPlayer
{
    NSLog(@"Player %d wins", winningPlayer);
    if (winningPlayer == PLAYER1)
    {
        NSLog(@"%@ wins!", Player1Name);
    }
    if (winningPlayer == PLAYER2) 
    {
        NSLog(@"%@ wins!", Player2Name);
    }
    
    NSLog(@"Please press exit");
}

-(void)highlightCurrentPlayer:(int)player
{
    NSLog(@"highlightCurrentPlayer started");
    if (currentPlayer == PLAYER1)
    {
        player1NameLabel.textColor = [UIColor redColor];
        player2NameLabel.textColor = [UIColor whiteColor];
    }
    
    if (currentPlayer == PLAYER2)
    {
        player1NameLabel.textColor = [UIColor whiteColor];
        player2NameLabel.textColor = [UIColor redColor];
    }
}

#pragma mark -
#pragma mark Animation Methods

#pragma mark -
#pragma mark Init/Exit Methods


- (void)resetGame
{
    NSLog(@"resetGame started");
    currentPlayer = 1;
    roundScore = 0;
    player1Total = 0; //start at 0
    player2Total = 0; //start at 0
    die1 = 0;
    die2 = 0;
}


-(void)exitToMenu
{
    //call main menu view
    [self resetGame];
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark -
#pragma mark Game Logic Methods

- (void)playGame
{
    NSLog(@"Play game started");
    [self getStartingPlayer];
    [self resetGame];
    [self loadGameElements];
    [self initialiseSounds];
}

- (void)getStartingPlayer
{
    NSLog(@"getStartingPlayer started");
    //check for both player names
    [self readNames];
    [self chooseStartingPlayer];

}

-(void)loadGameElements
{
    NSLog(@"loadGameElements started");
    rollResultLabel.text=[NSString stringWithFormat:@"%@ to go first", Player1Name]; //NOTE: just a place-holder message
    [self showScoreLabels];
    [self showPlayerNames];
    [self highlightCurrentPlayer:currentPlayer];
}


-(void)readNames 
{
    //read in names from user defaults
    NSLog(@"readNames started");
        
    Player1Name = [[NSUserDefaults standardUserDefaults] stringForKey:PLAYER1_KEY];
    Player2Name = [[NSUserDefaults standardUserDefaults] stringForKey:PLAYER2_KEY];
}

-(void)chooseStartingPlayer
{
    NSLog(@"chooseStartingPlayer started");
    //show a view to choose who is starting
    //players can choose either player, or flip a coin to determine    
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


-(void)evaluateDice
{
    //check to see how many ones we've rolled
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


-(void)calculateScore:(BOOL)rollPress
{
    //calculate a player's score depending on what button was pressed and dice that were rolled
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
    //set chosen player's score to zero
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


-(void)evaluateRound
{
    //see if the round resulted in a win, if not change players and keep going
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


-(int)checkWinner
{
    //see if a player has reached the winning score
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
    //switch players
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
    [self highlightCurrentPlayer:currentPlayer];
}

@end
