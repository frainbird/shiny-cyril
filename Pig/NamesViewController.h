//
//  NamesViewController.h
//  Pig
//
//  Created by  on 9/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Constants.h"
#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@interface NamesViewController : UIViewController

{
    IBOutlet UITextField *P1NameField;
    IBOutlet UITextField *P2NameField;
    IBOutlet UILabel *messageLabel;
    
    UIButton *acceptButton;
    
    NSString* P1Name;
    NSString* P2Name;
    
    NSURL           *clickSoundURL; //sound for click buttons
    SystemSoundID    clickSoundID;
}


@property UITextField *P1NameField;
@property UITextField *P2NameField;
@property UILabel *messageLabel;

@property UIButton    *acceptButton;

-(IBAction)acceptButtonPressed:(id)sender;

@end
