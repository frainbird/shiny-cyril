//
//  NetworkPlayViewController.h
//  Pig
//
//  Created by  on 9/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NetworkPlayViewController : UIViewController
{
        IBOutlet UIButton *exitButton;
}

@property UIButton *exitButton;

-(IBAction)exitButtonPressed:(id)sender;

@end
