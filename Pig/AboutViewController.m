//
//  AboutViewController.m
//  Pig
//
//  Created by  on 9/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end


NSString *externalURL = @"http://lawson.cis.utas.edu.au/~mjvalk/pig/index.html";

@implementation AboutViewController

@synthesize aboutWebView;
@synthesize networkUP;
@synthesize backButton;

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
    [self initSound];
    [self showNetworkPage];
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
#pragma mark Other Methods

-(void)initSound
{
    clickSoundURL = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                            pathForResource:@"buttonClick" 
                                            ofType:@"wav"]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef) clickSoundURL, &clickSoundID);       
}

-(void)playSound:(SystemSoundID)soundID
{
    bool sound = [[NSUserDefaults standardUserDefaults] boolForKey:SOUND_ON_OFF_KEY];
    NSLog(@"sound is %d", sound);
    if (sound)
    {
        AudioServicesPlaySystemSound(soundID);
    }
}

- (void)showNetworkPage
{
    //show external page if network up, otherwise local page
    NSURL *theURL;
    if (networkUP)
    {
        theURL = [NSURL URLWithString:externalURL];
    }
    else 
    {
        theURL = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                pathForResource:@"index" ofType:@"html"]];
    }
    
    //theURL = [NSURL fileURLWithPath:[[NSBundle mainBundle]
    //                                pathForResource:@"index" ofType:@"html"]];
    
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:theURL];
    [aboutWebView loadRequest:theRequest];
}

-(IBAction)backButtonPressed:(id)sender
{
    [self playSound:clickSoundID];
    [self exitToMenu];
}

-(void)exitToMenu
{
    //call main menu view
    [self.navigationController popViewControllerAnimated:NO];
}

@end
