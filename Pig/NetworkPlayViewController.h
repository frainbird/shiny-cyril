//
//  NetworkPlayViewController.h
//  Pig
//
//  Created by  on 9/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import "Constants.h"
@interface NetworkPlayViewController : UIViewController
{
    IBOutlet UIButton    *exitButton;
    IBOutlet UITextField *messageText;
    NSString    *gamePeerID;
    GKSession   *gameSession;
}

@property UIButton *exitButton;
@property UITextField *messageText;
@property(nonatomic,retain) GKSession   *gameSession;
@property(nonatomic,copy)   NSString    *gamePeerID;


-(void)startPicker;
-(void)invalidateSession:(GKSession *)session;
-(IBAction)exitButtonPressed:(id)sender;

@end
