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

@implementation AboutViewController

@synthesize aboutWebView;


@synthesize backButton;

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

- (void)showNetworkPage
{
    NSURL *theURL = [NSURL URLWithString:@"http://lawson.cis.utas.edu.au/~mjvalk/pig/index.html"];
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:theURL];
    [aboutWebView loadRequest:theRequest];
}

-(IBAction)backButtonPressed:(id)sender
{
    [self exitToMenu];
}

-(void)exitToMenu
{
    //call main menu view
    [self.navigationController popViewControllerAnimated:NO];
}

@end
