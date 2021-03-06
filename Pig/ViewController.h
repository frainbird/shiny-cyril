//
//  ViewController.h
//  Pig
//
//  Created by  on 9/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

#import "Constants.h"
#import "Reachability.h"
#import "AboutViewController.h"
#import "LocalPlayViewController.h"
#import "NamesViewController.h"
#import "NetworkPlayViewController.h"


@interface ViewController : UIViewController<UIAccelerometerDelegate,GKPeerPickerControllerDelegate,GKSessionDelegate,AVAudioPlayerDelegate>
{
    BOOL musicPlay;
    AboutViewController     *aboutVC;
    LocalPlayViewController *localPlayVC;
    NamesViewController     *namesVC;
    NetworkPlayViewController *networkPlayVC;
    
    Reachability            *internetReachable;
    AVAudioPlayer           *audioPlayer;
    
    IBOutlet UIButton       *muteButton;
    IBOutlet UIButton       *aboutButton;
    IBOutlet UIButton       *localPlayButton;
    IBOutlet UIButton       *namesButton;
    IBOutlet UIButton       *networkPlayButton;
    IBOutlet UILabel        *namesMessageLabel;
    
    NSURL           *clickSoundURL; //sound for one 'pig' die
    SystemSoundID    clickSoundID;

}


@property (nonatomic,retain) UIButton *muteButton;
@property (nonatomic,retain) UIButton *aboutButton;
@property (nonatomic,retain) UIButton *localPlayButton;
@property (nonatomic,retain) UIButton *namesButton;
@property (nonatomic,retain) UIButton *networkPlayButton;
@property (nonatomic,retain) UILabel  *namesMessageLabel;  


-(IBAction)localPlayPressed:(id)sender;
-(IBAction)networkPlayPressed:(id)sender;
-(IBAction)namesPressed:(id)sender;
-(IBAction)aboutPressed:(id)sender;
-(IBAction)muteButtonPressed:(id)sender;

@end