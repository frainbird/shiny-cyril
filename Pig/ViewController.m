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

static int LOCAL_VC = 1;
static int NETWORK_VC = 2;
static int NAMES_VC = 3;
static int ABOUT_VC = 4;

static NSString *P1Key = @"player1Name";
static NSString *P2Key = @"player2Name";

@implementation ViewController

@synthesize localPlayButton;
@synthesize networkPlayButton;
@synthesize aboutButton;
@synthesize namesButton;
@synthesize namesMessageLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    namesMessageLabel.text = @"";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)localPlayPressed:(id)sender
{
    NSLog(@"Local play pressed");
    
    //check names
    NSString *name1 = [[NSUserDefaults standardUserDefaults] stringForKey:P1Key];
    NSString *name2 = [[NSUserDefaults standardUserDefaults] stringForKey:P2Key];
    
    //if neither name is blank
    if ([name1 length] != 0 && [name2 length] != 0)
    {
        namesMessageLabel.text = @"";
        [self pushView:localPlayVC :LOCAL_VC];
    }
    
    else 
    {
        namesMessageLabel.text = @"Need both player names!";
    }
}

- (IBAction)networkPlayPressed:(id)sender
{
    NSLog(@"Network play pressed");  
    
    [self pushView:networkPlayVC :NETWORK_VC];
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


- (void)pushView:(UIViewController*)nextVC:(int)viewControllerNum
{
    if (nil == nextVC)
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
                break;
            
            default:
                break;
        }
    }
        
    [self.navigationController pushViewController:nextVC animated:NO];
}





@end
