//
//  AboutViewController.h
//  Pig
//
//  Created by  on 9/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController
{
        IBOutlet UIButton *backButton;
}

@property UIButton *backButton;

-(IBAction)backButtonPressed:(id)sender;

@end
