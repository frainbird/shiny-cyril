//
//  NamesViewController.m
//  Pig
//
//  Created by  on 9/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NamesViewController.h"


@interface NamesViewController ()

@end
//local variables
NSString* P1Name = @"";
NSString* P2Name = @"";

const int VALID = 0;
const int BOTH_SAME = 1;
const int BOTH_BLANK = 2;

@implementation NamesViewController


@synthesize P1NameField;
@synthesize P2NameField;
@synthesize messageLabel;

@synthesize acceptButton;

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
    [self readNames]; //get names from file
    [self setNames];
    [self resetMessage];
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

-(IBAction)acceptButtonPressed:(id)sender
{
    int result = [self validateNames];
    
    if (result == VALID)
    {
        [self getNames];
        [self writeNames];
        [self resetMessage];
        [self exitToMenu];
    }
    else if (result == BOTH_SAME)
    {
        messageLabel.text = @"Names cannot be the same";
    }
    else
    {
        messageLabel.text=@"Please enter a player name";
    }
    
}

#pragma mark -
#pragma mark Name Validation Methods

-(int)validateNames
{
    [self getNames];
    if ([P1Name isEqualToString:P2Name])
    {
        if([P1Name isEqualToString:@""])
        {
            return BOTH_BLANK;
        }
        return BOTH_SAME;
    }
    return VALID;
}

-(void)setNames
{
    P1NameField.text = P1Name;
    P2NameField.text = P2Name;
}

-(void)getNames
{
    P1Name = P1NameField.text;
    P2Name = P2NameField.text;
}

-(void)readNames
{
    //read in names
    
    NSString *name1 = [[NSUserDefaults standardUserDefaults] stringForKey:PLAYER1_KEY];
    NSString *name2 = [[NSUserDefaults standardUserDefaults] stringForKey:PLAYER2_KEY];
    
    //store them in variables if something is in them
    if (![name1 length] == 0)
    {
        P1Name = name1;
    }
    
    if (![name2 length] == 0)
    {
        P2Name = name2;
    }
    
}

-(void)writeNames
{   
    //write names to file
    [[NSUserDefaults standardUserDefaults] setObject:P1Name forKey:PLAYER1_KEY];
    [[NSUserDefaults standardUserDefaults] setObject:P2Name forKey:PLAYER2_KEY];
}

#pragma mark -
#pragma mark Init/Exit Methods

-(void)resetMessage
{
    messageLabel.text = @"Please enter player names";
}

-(void)exitToMenu
{
    [self.navigationController popViewControllerAnimated:NO];
}

@end
