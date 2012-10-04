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

static NSString *P1Key = @"player1Name";
static NSString *P2Key = @"player2Name";


@implementation NamesViewController


@synthesize P1NameField;
@synthesize P2NameField;
@synthesize messageLabel;

@synthesize acceptButton;


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


-(void)resetMessage
{
    messageLabel.text = @"Please enter player names";
}

-(IBAction)acceptButtonPressed:(id)sender
{
    if ([self validateNames])
    {
        [self getNames];
        [self writeNames];
        [self resetMessage];
        [self exitToMenu];
    }
    else 
    {
        messageLabel.text = @"Names cannot be the same!";
    }
}

-(BOOL)validateNames
{
    [self getNames];
    if ([P1Name isEqualToString:P2Name])
    {
        return false;
    }
    return true;
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
    
    NSString *name1 = [[NSUserDefaults standardUserDefaults] stringForKey:P1Key];
    NSString *name2 = [[NSUserDefaults standardUserDefaults] stringForKey:P2Key];
    
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
    [[NSUserDefaults standardUserDefaults] setObject:P1Name forKey:P1Key];
    [[NSUserDefaults standardUserDefaults] setObject:P2Name forKey:P2Key];
}

-(void)exitToMenu
{
    [self.navigationController popViewControllerAnimated:NO];
}

@end
