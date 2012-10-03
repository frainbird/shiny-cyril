//
//  LocalPlayViewController.h
//  Pig
//
//  Created by  on 9/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocalPlayViewController : UIViewController
{
    IBOutlet UIButton *exitButton;
    IBOutlet UIButton *holdButton;
    IBOutlet UIButton *rollButton;
}

@property UIButton *exitButton;
@property UIButton *holdButton;
@property UIButton *rollButton;

-(void)playGame;


-(IBAction)holdButtonPressed:(id)sender;
-(IBAction)rollButtonPressed:(id)sender;
-(IBAction)exitButtonPressed:(id)sender;

@end
