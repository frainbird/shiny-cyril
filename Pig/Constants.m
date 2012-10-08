//
//  Constants.m
//  Pig
//
//  Created by  on 10/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

NSString *const PLAYER1_KEY = @"player1key";
NSString *const PLAYER2_KEY = @"player2key";

//used in net/local play
NSString *const rollResultMessage[4]={@"Score points!", @"A one! Score nothing", @"Two ones! Lose all points", @"Rolling..."};

const int PLAYER1 = 1;
const int PLAYER2 = 2;
const int WINNING_SCORE = 100;

//used in namesViewController
const int VALID = 0;
const int BOTH_SAME = 1;
const int BOTH_BLANK = 2;

//used in (menu) viewController
const int LOCAL_VC   = 1;
const int NETWORK_VC = 2;
const int NAMES_VC   = 3;
const int ABOUT_VC   = 4;