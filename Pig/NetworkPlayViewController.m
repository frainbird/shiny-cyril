//
//  LocalPlayViewController.m
//  Pig
//
//  Created by  on 9/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//



#import "NetworkPlayViewController.h"


@interface NetworkPlayViewController ()

@end

NSString *localPlayerName = @"";
NSString *remotePlayerName = @"";

@implementation NetworkPlayViewController

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
@synthesize messageLabel;

//network
@synthesize gamePeerID;
@synthesize gameSession;


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
    [self buildData]; //send data
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
    player1NameLabel.text = player1Name;
    player2NameLabel.text = player2Name;
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
    player1ScoreLabel.text = [NSString stringWithFormat:@"%@: %d", player1Name, player1Total];
    player2ScoreLabel.text = [NSString stringWithFormat:@"%@: %d", player2Name, player2Total];
}

-(void)showWinnerMessage:(int)winningPlayer
{
    NSLog(@"Player %d wins", winningPlayer);
    if (winningPlayer == PLAYER1)
    {
        NSLog(@"%@ wins!", player1Name);
    }
    if (winningPlayer == PLAYER2) 
    {
        NSLog(@"%@ wins!", player2Name);
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
#pragma mark Peer Picker methods

// this method is called by our code when we need to start looking for someome to play with
-(void)startPicker
{
    NSLog (@"starting the peer picker");
    GKPeerPickerController *picker;
    
    picker = [[GKPeerPickerController alloc] init];
    
    // note that the picker is released in the various picker delegate methods when the picker is done with
    
    picker.delegate = self;
    [picker show];
}


// this delegate method is called at the user clicks the "cancel" button while the picker is displayed
- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker 
{ 
    NSLog (@"the peer picker controller was cancelled by the user");
    
    picker.delegate = nil;
    
    // invalidate and release game session if one is around.
    if (self.gameSession != nil)
    {
        [self invalidateSession:self.gameSession];
        self.gameSession = nil;
    }
    
    // at this point, you would pop back to your previous view controller
    // if you are part of a hierarchy of view controllers
    // we'll just start the picker again
    [self exitToMenu];
    
} 

// Peer-to-peer comms requires a unique session ID, and it's up to our App to provide it
// This delegate method is called by the peer picker controller when it wants that session ID
// We can provide a session with a custom display name, so the display the user sees is relevant to our program
- (GKSession *)peerPickerController:(GKPeerPickerController *)picker sessionForConnectionType:(GKPeerPickerConnectionType)type 
{ 
    NSLog (@"creating a session ID for Game Kit");
    GKSession *session = [[GKSession alloc] initWithSessionID:nil displayName:localPlayerName sessionMode:GKSessionModePeer]; 
    return session;
}


// When a peer is connected to the session, this delegate method is called
// Our application must now take ownership of the session, dismiss the peer picker, and 
// use the session to communicate with the other peer
- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session 
{ 
    NSLog (@"the peer picker has connected with another game");
    
    // remember the current peer
    self.gamePeerID = peerID;
    
    // make sure we have a reference to the game session and it is set up
    self.gameSession = session; // retain
    self.gameSession.delegate = self; 
    [self.gameSession setDataReceiveHandler:self withContext:NULL];
    
    // dismiss the peer picker and deregister ourselves as it's delegate
    [picker dismiss];
    picker.delegate = nil;
    
    // we now have a session that is communicating with the other player
    
    [self getStartingPlayer];
    
} 


#pragma mark -
#pragma mark Session-related and GKSessionDelegate Methods

// we call this method under various circumstances (for example, when our view controller is about to
// go away
- (void)invalidateSession:(GKSession *)session
{
    NSLog (@"invalidateSession: called");
    if (session != nil)
    {
        [session disconnectFromAllPeers]; 
        session.available = NO; 
        [session setDataReceiveHandler: nil withContext: NULL]; 
        session.delegate = nil; 
    }
}


// this is a delegate method for the gamekit session and it's called when
// there's been a state change in the session
- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state 
{ 
    NSLog (@"the Game Kit session has changed state!");
    
    // have we lost our connection to the other player?
    if (state == GKPeerStateDisconnected) 
    {
        // throw a alert if it isn't already up
        NSString *message = [NSString stringWithFormat:@"Lost connection with %@.", [session displayNameForPeer:peerID]];
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:@"Lost Connection" 
                              message:message 
                              delegate:nil 
                              cancelButtonTitle:@"End Game" 
                              otherButtonTitles:nil];
        [alert show];
        
        // invalidate and release play session if one is around.
        if (self.gameSession != nil)
        {
            [self invalidateSession:self.gameSession];
            self.gameSession = nil;
        }
        
        // at this point, you would pop back to your previous view controller
        // if you are part of a hierarchy of view controllers
        // we'll just start the picker again
        [self startPicker];
        
    }
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error
{
    NSLog (@"the game session has failed!");
    // Update user alert or throw alert if it isn't already up
    UIAlertView *alert = [[UIAlertView alloc] 
                          initWithTitle:@"Session Failure" 
                          message:[error localizedDescription] 
                          delegate:nil 
                          cancelButtonTitle:@"End Game" 
                          otherButtonTitles:nil];
    [alert show];
    
    // at this point, you would pop back to your previous view controller
    // if you are part of a hierarchy of view controllers
    // we'll just start the picker again
    [self startPicker];
    
}

#pragma mark -
#pragma mark Data Send/Receive Methods

// This method is called when a packet of data is being received from the GKSession
// We don't call this directly (since we don't know when a packet will arrive) - instead it's called 
// automatically so long as we've previously registered it as the receive data handler.
// We've did that in the peerPickerController:didConnectPeer:toSession method (above) when the connection
// with the other player was formed

- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession:(GKSession *)session context:(void *)context 
{ 
    NSLog (@"received some data from the other player");
    NSString *receivedString = [NSString stringWithUTF8String:[data bytes]];
    NSLog(@"Received string was: %@",receivedString);
    
    
    char dataChar = [receivedString characterAtIndex:0];
    
    switch (dataChar) 
    {
        case 'c': //cointoss, first thing done is determine starting player based off peer id
            //Player 1 is local, player 2 is foriegn
            switch (([gamePeerID intValue] > [peer intValue]) ? PLAYER_SERVER : PLAYER_CLIENT)
        {
            case PLAYER_SERVER:
                [self startPlayer:PLAYER1];
                break;
            case PLAYER_CLIENT:
                [self startPlayer:PLAYER2];
                break;
        }
            break;
        
        case 'r': //die1 value
            die1 = dataChar;
            break;
            
        case 'p': //die1 value
            die2 = dataChar;
            break;
            
        default:
            break;
    }
}


- (void)sendData:(NSString*)dataString
{
    NSLog(@"data sent");
    
    NSData *block = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    [gameSession sendData:block toPeers:[NSArray arrayWithObject:gamePeerID] withDataMode:GKSendDataReliable error:nil];
}

-(void)buildData
{
    
    NSString *pPressed;
    //if lastButtonPressed was hold
    pPressed = @"h";
    
    //if lastButtonPressed was roll
    pPressed = @"r";
    
    
    NSString *data = [NSString stringWithFormat:@"%@%d%d",pPressed,die1,die2];
    
    [self sendData:data];
}


#pragma mark -
#pragma mark Game Logic Methods

- (void)playGame
{
    NSLog(@"Play game started");
    gameSession = nil;
    gamePeerID = nil;
    [self startPicker];
    
    [self resetGame];
    [self loadGameElements];
    [self initialiseSounds];
}

- (void)getStartingPlayer
{
    NSLog(@"getStartingPlayer started");
    //check for both player names
    
    [self readNames];
    [self sendData:@"c"];
}

-(void)loadGameElements
{
    NSLog(@"loadGameElements started");
    rollResultLabel.text=[NSString stringWithFormat:@"%@ to go first", player1Name]; //NOTE: just a place-holder message
    [self showScoreLabels];
    [self showPlayerNames];
    [self highlightCurrentPlayer:currentPlayer];
}


-(void)readNames 
{
    //read in names from user defaults
    NSLog(@"readNames started");
    
    player1Name = [[NSUserDefaults standardUserDefaults] stringForKey:PLAYER1_KEY];
    player2Name = [[NSUserDefaults standardUserDefaults] stringForKey:PLAYER2_KEY];
}

-(void)startPlayer:(int)player
{
    NSLog(@"chooseStartingPlayer started");
        
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
