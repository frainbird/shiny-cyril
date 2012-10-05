//
//  NetworkPlayViewController.m
//  Pig
//
//  Created by  on 9/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NetworkPlayViewController.h"

@interface NetworkPlayViewController ()

@end

NSString *PlayerName = @"Michael";
#define kMaxTankPacketSize 1024
int gamePacketNumber = 0;

@implementation NetworkPlayViewController

@synthesize messageText;
@synthesize gamePeerID;
@synthesize gameSession;
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
    
    gameSession = nil;
    gamePeerID = nil;
    
    //find another player
    [self startPicker];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


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
    GKSession *session = [[GKSession alloc] initWithSessionID:nil displayName:PlayerName sessionMode:GKSessionModePeer]; 
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
}




- (IBAction)sendMessage:(id)sender
{
    NSLog(@"sendMessage sent");
    
    NSString *textToSend = [NSString stringWithString:[messageText text]];
    [messageText setText:@""];
    
    NSData *block = [textToSend dataUsingEncoding:NSUTF8StringEncoding];
    [gameSession sendData:block toPeers:[NSArray arrayWithObject:gamePeerID] withDataMode:GKSendDataReliable error:nil];
}

#pragma mark -
#pragma mark Action Methods

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
