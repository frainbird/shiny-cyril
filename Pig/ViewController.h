//
//  ViewController.h
//  Pig
//
//  Created by  on 9/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <GameKit/GameKit.h>

#import "AboutViewController.h"
#import "LocalPlayViewController.h"
#import "NamesViewController.h"
#import "NetworkPlayViewController.h"


@interface ViewController : UIViewController<UIAccelerometerDelegate,GKPeerPickerControllerDelegate,GKSessionDelegate>
{
    
    AboutViewController     *aboutVC;
    LocalPlayViewController *localPlayVC;
    NamesViewController     *namesVC;
    NetworkPlayViewController *networkPlayVC;
    

    
    IBOutlet UIButton       *aboutButton;
    IBOutlet UIButton       *localPlayButton;
    IBOutlet UIButton       *namesButton;
    IBOutlet UIButton       *networkPlayButton;
}



@property (nonatomic,retain) UIButton *aboutButton;
@property (nonatomic,retain) UIButton *localPlayButton;
@property (nonatomic,retain) UIButton *namesButton;
@property (nonatomic,retain) UIButton *networkPlayButton;


-(IBAction)localPlayPressed:(id)sender;
-(IBAction)networkPlayPressed:(id)sender;
-(IBAction)namesPressed:(id)sender;
-(IBAction)aboutPressed:(id)sender;

@end