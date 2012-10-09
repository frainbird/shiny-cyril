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

@implementation LocalPlayViewController

//buttons
@synthesize rollButton;
@synthesize holdButton;
@synthesize exitButton;

//dice images
@synthesize die1View;
@synthesize die2View;

//screen labels
@synthesize coinImageView;
@synthesize flipCoinView;
@synthesize coinMessageLabel;

@synthesize player1View;
@synthesize player2View;
@synthesize rollResultLabel;
@synthesize rollScoreLabel;
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

-(IBAction)flipButtonPressed:(id)sender
{
    [self chooseStartingPlayer];
}

-(IBAction)rollButtonPressed:(id)sender
{
    NSLog(@"roll button pressed");
    AudioServicesPlaySystemSound(rollSoundID);
    rollResultLabel.text = rollResultMessage[3];
    [self rollDice];
    [self showDice]; //do all our animating etc.
    
}

-(IBAction)holdButtonPressed:(id)sender
{
    NSLog(@"hold button pressed");
    rollAgain = false;
    [self calculateTotalScore]; //calculate player's total score
    [self playSound:holdSoundID];
    [self animateRoundScore]; //animate the round score to the player's total
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
    //the animation just cycles through each dice an equal number of times.
    //thus the dice at the end are the same as the dice at the start
    
    die1View.image=[UIImage imageNamed:[NSString stringWithFormat:@"dice%d.png", die1]];
    die2View.image=[UIImage imageNamed:[NSString stringWithFormat:@"dice%d.png", die2]];
    
    [self animateDice];
}


-(void)showRollResult
{
    NSLog(@"showRollResult started");
    NSLog(@"SRR: ones is %d", ones);
    NSString *message;
    
    switch (ones)
    {
        case 0:
            message = rollResultMessage[0];
            //[self showRollScore];
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

-(void)setRoundScoreLabelText:(NSString*)value
{
    roundScoreLabel.text = value;
    
}



-(void)updateScoreLabels
{
    NSLog(@"updateScoreLabels started");
    [self showRollScore];
    [self showRoundScore];
    [self showTotalScoreLabels];
}

-(void)showRollScore
{
    rollScoreLabel.text = [NSString stringWithFormat:@"%d", rollScore];
}

-(void)showRoundScore
{
    roundScoreLabel.text = [NSString stringWithFormat:@"%d", roundScore];
}

-(void)showTotalScoreLabels
{
    player1ScoreLabel.text = [NSString stringWithFormat:@"%d", player1Total];
    player2ScoreLabel.text = [NSString stringWithFormat:@"%d", player2Total];
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



#pragma mark -
#pragma mark Animation Methods

-(void)animateDice
{
    self.view.userInteractionEnabled=NO;
    NSArray *diceImages=[NSArray arrayWithObjects:[UIImage imageNamed:@"dice1.png"],[UIImage imageNamed:@"dice2.png"],[UIImage imageNamed:@"dice3.png"],[UIImage imageNamed:@"dice4.png"],[UIImage imageNamed:@"dice5.png"],[UIImage imageNamed:@"dice6.png"],nil];

    die1View.animationImages=diceImages;
    die1View.animationDuration=0.5;
    die1View.animationRepeatCount=2;
    
    die2View.animationImages=diceImages;
    die2View.animationDuration=0.5;
    die2View.animationRepeatCount=2;
    
    [die1View startAnimating];
    [die2View startAnimating];

    [self performSelector:@selector(animateDiceEnds) withObject:nil afterDelay:1.0];//do this when animation ends

}


-(void)animateDiceEnds{
    [self evaluateDice]; //check how many ones, update roll score accordingly
    [self calculateRoundScore]; //calculate round score
    [self showRollResult];
    [self showRollScore];
    [self animateRollScore];
    [self playResultSound];
    
    self.view.userInteractionEnabled=YES;
    

}

-(void)animateRollScore
{
    //move roll Score onto Round score, then increment
    
    [UILabel animateWithDuration:0.5
                          delay: 0.5
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         rollScoreLabel.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(.221, 0.221), CGAffineTransformTranslate(rollScoreLabel.transform, 0, 80));
                     }
                     completion:^(BOOL finished){
                         
                         //update round score
                         [self showRoundScore];
                         rollScoreLabel.text = @""; //set rollscore to blank
                         
                         //need to reset rollResult label position
                         [UILabel animateWithDuration:0.0
                                                delay: 0.1
                                              options: UIViewAnimationCurveEaseOut
                                           animations:^{
                                               rollScoreLabel.transform = CGAffineTransformMakeTranslation(0, 0);
                                           }
                                           completion:^(BOOL finished){
                                               //nothing
                                               if(!rollAgain)
                                               {
                                                   [self animateRoundScore];
                                               }
                                           }];
                         

                     }];  
}

-(void)animateRoundScore
{
    //more Round Score onto current player's total score, then change players
    NSLog(@"animateRoundScore started, ones is %d",ones);
    if (ones == 1) //animate the round score to the right
    {
        //animate ones away
        [UILabel animateWithDuration:0.8
                               delay: 0.1
                             options: UIViewAnimationCurveEaseOut
                          animations:^{
                              roundScoreLabel.transform = CGAffineTransformMakeTranslation(150, 0);
                          }
                          completion:^(BOOL finished){
                              [self setRoundScoreLabelText:@""]; //clear round score label text
                                                            
                              //reset position (i'm sure there's an easier way to do this)
                              roundScoreLabel.hidden = YES;
                              [UILabel animateWithDuration:0.0
                                                     delay: 0.5
                                                   options: UIViewAnimationCurveEaseOut
                                                animations:^{
                                                    roundScoreLabel.transform = CGAffineTransformMakeTranslation(0, 0);
                                                }
                                                completion:^(BOOL finished){
                                                    //update total scores
                                                    [self showTotalScoreLabels];
                                                    [self evaluateRound];
                                                    roundScoreLabel.hidden = NO;
                                                }];
                          }];
        
    }
    else {
            
    [UILabel animateWithDuration:0.5
                           delay: 0.1
                         options: UIViewAnimationCurveEaseOut
                      animations:^{
                          roundScoreLabel.transform = CGAffineTransformMakeTranslation(30, 60);
                      }
                      completion:^(BOOL finished){
                          //need to reset roundScore label position
                          [UILabel animateWithDuration:0.0
                                                 delay: 0.1
                                               options: UIViewAnimationCurveEaseOut
                                            animations:^{
                                                roundScoreLabel.transform = CGAffineTransformMakeTranslation(0, 0);
                                            }
                                            completion:^(BOOL finished){
                                                //update total scores
                                                [self showTotalScoreLabels];
                                                [self evaluateRound];
                                            }];

                      }];
    
    }
}


-(void)showFlipCoinView
{
    //animate flip view onto screen
    [UIView animateWithDuration:1.0
                          delay: 0.1
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         flipCoinView.transform = CGAffineTransformMakeTranslation(0, -450);
                     }
                     completion:^(BOOL finished){
                         //do nothing
                     }];  
    
}

-(void)hideFlipCoinView
{
    [UIView animateWithDuration:1.0
                          delay: 1.0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         flipCoinView.transform = CGAffineTransformMakeTranslation(0, 0);
                     }
                     completion:^(BOOL finished){
                         [self afterHideCoinView];
                     }];  
}

-(void)afterHideCoinView
{
    rollResultLabel.text = [NSString stringWithFormat:@"%@ to roll", [self getPlayerName:currentPlayer]];
    [self swapPlayerNames:currentPlayer];
}


-(void)animateCoin:(int)player
{
    //1 for heads, 2 for tails
    float spinSpeed = 0.2;
    [UIImageView animateWithDuration:spinSpeed
                               delay: 0.0
                             options: UIViewAnimationCurveEaseIn
                          animations:^{
                              coinImageView.transform = CGAffineTransformMakeScale(0.01, 1.0);
                              
                          }
                          completion:^(BOOL finished){
                              [UIImageView animateWithDuration:spinSpeed
                                                         delay: 0.0
                                                       options: UIViewAnimationCurveEaseOut
                                                    animations:^{
                                                        coinImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                                        
                                                    }
                                                    completion:^(BOOL finished){
                                                        [self afterCoinFlipComplete];
                                                    }];
                              
                          }];
}

-(void)afterCoinFlipComplete
{
    coinImageView.image = [UIImage imageNamed:@"heads.png"];
    [self setCoinMessage];
    [self hideFlipCoinView];
    NSLog(@"Coin flip done, current player is %@ (%d)", [self getPlayerName:currentPlayer], currentPlayer);
}

-(void)setCoinMessage
{
    coinMessageLabel.text = [NSString stringWithFormat:@"%@ starts!", [self getPlayerName:currentPlayer]];
}


-(void)swapPlayerNames:(int)player
{
    NSLog(@"swap names, currentPlayer is %@ (%d)", [self getPlayerName:player],player);
    float xpos1;
    float ypos1;
    float xpos2;
    float ypos2; 
    
    if (player == PLAYER1) //inverse as we've just swapped players with changePlayer
    {
        xpos1 = 0;
        ypos1 = 0;
        xpos2 = 0;
        ypos2 = 0;
    }
    else {
        xpos1 = 0;
        ypos1 = 60;
        xpos2 = 0;
        ypos2 = -60;
    }
   
    [UIView animateWithDuration:0.7
                          delay: 0.3
                        options: UIViewAnimationCurveEaseInOut
                     animations:^{
                         player1View.transform = CGAffineTransformMakeTranslation(xpos1, ypos1);
                     }
                     completion:^(BOOL finished){
                         //do nothing
                     }];
    [UIView animateWithDuration:0.7
                           delay: 0.3
                         options: UIViewAnimationCurveEaseInOut
                      animations:^{
                          player2View.transform = CGAffineTransformMakeTranslation(xpos2, ypos2);
                      }
                      completion:^(BOOL finished){
                          //do nothing
                      }]; 
}


#pragma mark -
#pragma mark Init/Exit Methods


- (void)resetGame
{
    NSLog(@"resetGame started");
    rollScore = 0;
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
    [self showFlipCoinView];
    [self readNames];
}

-(void)loadGameElements
{
    NSLog(@"loadGameElements started");
    [self updateScoreLabels];
    [self showPlayerNames];
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
    
    currentPlayer = arc4random() % 2 + 1; //randomly choose starting player
    [self animateCoin:currentPlayer];
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
        rollScore = 0;
        rollAgain = false;
    }
    
    else if (die1 == 1 || die2 == 1)
    {
        ones = 1;
        rollScore = 0;
        rollAgain = false;
    }

    else
    {
        ones = 0;
        rollScore = die1 + die2;
        rollAgain = true;
    }
}


//-(void)calculateScore
//{
//    //calculate a player's score depending on what button was pressed and dice that were rolled
//    NSLog(@"calculateScore, %d");
//        
//    if (rollPress) //if roll was pressed
//    {
//        switch (ones)
//        {
//            case 0:
//                roundScore = roundScore + rollScore;
//                break;
//            
//            case 1:
//                roundScore = 0;
//                break;
//            
//            case 2:
//                roundScore = 0;
//                [self resetTotalScore:currentPlayer];
//                break;
//            
//            default:
//                NSLog(@"CS: An error occured");
//        }
//    }
//
//    if (!rollPress) //if hold was pressed
//    {      
//        NSLog(@"CS: currentPlayer is %d", currentPlayer);
//        //add add roundscore to current player's total
//        if (currentPlayer == PLAYER1)
//        {
//            player1Total = player1Total + roundScore;
//        }
//        if (currentPlayer == PLAYER2)
//        {
//            player2Total = player2Total + roundScore;
//        }
//        //reset roundscore
//        roundScore = 0;
//    }
//        
//}

-(void)calculateRoundScore
{
    NSLog(@"calculateRound score starts");
    
        switch (ones)
        {
            case 0:
                roundScore = roundScore + rollScore;
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



//calculate total
-(void)calculateTotalScore
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
    NSLog(@"evaluateRound started");
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
    [self swapPlayerNames:currentPlayer];
}

-(NSString*)getPlayerName:(int)playerNum
{
    
    NSString* playerName;
    if (playerNum == PLAYER1)
    {
        playerName = Player1Name;
    }
    else 
    {
        playerName = Player2Name;
    }
    
    return playerName;
}

@end
