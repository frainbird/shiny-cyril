//
//  NamesViewController.h
//  Pig
//
//  Created by  on 9/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NamesViewController : UIViewController

{
    IBOutlet UITextField *P1NameField;
    IBOutlet UITextField *P2NameField;
    
    UIButton *acceptButton;

    
}


@property UITextField *P1NameField;
@property UITextField *P2NameField;

@property UIButton    *acceptButton;

-(IBAction)acceptButtonPressed:(id)sender;

@end
