//
//  AboutViewController.h
//  Pig
//
//  Created by  on 9/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "Constants.h"

@interface AboutViewController : UIViewController
{
    IBOutlet UIButton *backButton;
    IBOutlet UIWebView *aboutWebView;
    BOOL networkUP;
    NSURL           *clickSoundURL; //sound for click buttons
    SystemSoundID    clickSoundID;
}

@property UIButton *backButton;
@property UIWebView *aboutWebView;
@property BOOL networkUP;

-(IBAction)backButtonPressed:(id)sender;

@end
