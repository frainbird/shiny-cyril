//
//  ViewController.m
//  Pig
//
//  Created by  on 9/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end


BOOL networkUp;
BOOL musicPlay = true;

//AVAudioPlayer           *audioPlayer;

@implementation ViewController

@synthesize muteButton;
@synthesize localPlayButton;
@synthesize networkPlayButton;
@synthesize aboutButton;
@synthesize namesButton;
@synthesize namesMessageLabel;

#pragma mark -
#pragma mark View Controller Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    namesMessageLabel.text = @"";
    [self initialiseReachability];
    [self initMusic];
    [self playMusic];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)viewDidAppear:(BOOL)animated
{
    [self resetMessage];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark -
#pragma mark Button Press Methods

- (IBAction)localPlayPressed:(id)sender
{
    NSLog(@"Local play pressed");
    [self doLocalPlay];
}

- (IBAction)networkPlayPressed:(id)sender
{
    NSLog(@"Network play pressed");
    [self doNetworkPlay];
}

- (IBAction)namesPressed:(id)sender
{
    NSLog(@"Player names play pressed");    
    [self pushView:namesVC :NAMES_VC]; 
}

- (IBAction)aboutPressed:(id)sender
{
    NSLog(@"About game pressed");
    [self pushView:aboutVC :ABOUT_VC]; 
}

-(IBAction)muteButtonPressed:(id)sender
{
    NSLog(@"Mute button pressed: %d",musicPlay);
    if (musicPlay)
    {
        [self stopMusic];
         musicPlay = false;
        
        //swap images         
        UIImage * btnImage1 = [UIImage imageNamed:@"sound_mute.png"];
        [muteButton setImage:btnImage1 forState:UIControlStateNormal];
        
    }
    else
    {
        [self playMusic];
        UIImage * btnImage2 = [UIImage imageNamed:@"sound.png"];
        
        //swap images
        [muteButton setImage:btnImage2 forState:UIControlStateNormal];
        musicPlay = true;
    }

        
}

#pragma mark -
#pragma mark Sound Methods

-(void)initMusic
{

    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                         pathForResource:@"theme1"
                                         ofType:@"mp3"]];

	NSError *error;
	audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    if (error)
    {
        NSLog(@"Error in audioPlayer: %@", 
              [error localizedDescription]);
    } else {
        audioPlayer.delegate = self;
        [audioPlayer prepareToPlay];
    }
}

-(void)playMusic
{
    [audioPlayer play];
}

-(void)stopMusic
{
    [audioPlayer stop];
}

#pragma mark -
#pragma mark Menu Methods

-(void)resetMessage
{
    namesMessageLabel.text = @"";
}

-(void)doLocalPlay
{
    //proceed if both names aren't blank
    if ([[[NSUserDefaults standardUserDefaults] stringForKey:PLAYER1_KEY] length] != 0 && 
        [[[NSUserDefaults standardUserDefaults] stringForKey:PLAYER2_KEY] length] != 0)
    {
        [self resetMessage];
        [self pushView:localPlayVC :LOCAL_VC];
    }
    //otherwise print a message
    else 
    {
        namesMessageLabel.text = @"Need both player names!";
    }
}

-(void)doNetworkPlay
{
    NSString *name1 = [[NSUserDefaults standardUserDefaults] stringForKey:PLAYER1_KEY];
    NSString *name2 = [[NSUserDefaults standardUserDefaults] stringForKey:PLAYER2_KEY];
    
    //proceed if both names aren't blank
    if ([name1 length] != 0 || [name2 length] != 0)
    {
        namesMessageLabel.text = @"";
        
        if (!networkUp)
        {
            NSLog(@"Network unavailable");
            namesMessageLabel.text = @"Network unavailable";
        }
        else
        {
            [self pushView:networkPlayVC :NETWORK_VC];
        }        
    }
    else 
    {
        namesMessageLabel.text = @"Need a player name!";
    }
}

- (void)pushView:(UIViewController*)nextVC:(int)viewControllerNum
{

        switch (viewControllerNum){
            
            case 1: //LOCAL_VC
                
                localPlayVC=[[LocalPlayViewController alloc] init];
                nextVC=localPlayVC;
                break;
                
            case 2: //NETWORK_VC
                networkPlayVC=[[NetworkPlayViewController alloc] init];
                nextVC=networkPlayVC;
                break;
            
            case 3: //NAMES_VC
                namesVC=[[NamesViewController alloc] init];
                nextVC=namesVC;
                break;
                
            case 4: //ABOUT_VC
                aboutVC=[[AboutViewController alloc] init];
                nextVC=aboutVC;
                //add network status iVar
                aboutVC.networkUP = networkUp;
                
                break;
            
            default:
                break;
        }
        
    [self.navigationController pushViewController:nextVC animated:NO];
}

#pragma mark -
#pragma mark Network Methods

-(void)initialiseReachability
{
    // Our code to get updates from the reachability class go here
    
    // First, register to receive "kReachabilityChangedNotification" notifications
    // - we tell the notification center to call our checkNetworkStatus: selector
    [[NSNotificationCenter defaultCenter] 
     addObserver:self 
     selector:@selector(checkNetworkStatus:)
     name:kReachabilityChangedNotification
     object:nil];
    
    // now create an instance of the reachability class that will monitor for
    // changes to internet connectivity
    internetReachable = [Reachability reachabilityForInternetConnection];
    
    // now that the reachability object exists, tell it to start it's notifier
    [internetReachable startNotifier];
    
    // let's just check right now whether the network is up or down by asking directly
    // but note that the checkNetworkStatus selector will be called automatically
    // whenever the network status changes
    [self checkNetworkStatus:nil];
}

// this selector is called 
- (void) checkNetworkStatus:(NSNotification *)notice
{
	NetworkStatus netStat = [internetReachable currentReachabilityStatus];
	switch (netStat)
	{
		case NotReachable:
		{
			NSLog(@"The network is down.");
            networkUp = false;
			break;
		}
		default:
		{
			NSLog(@"The network is up.");
            networkUp = true;
			break;
		}
	}
}


@end
