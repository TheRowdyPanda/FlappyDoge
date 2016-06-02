//
//  MyScene.h
//  FlappyDoge_Version2
//

//  Copyright (c) 2014 Rijul Gupta. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h>
#import <GameKit/GameKit.h>
#import <Social/Social.h>
#import <FacebookSDK/FacebookSDK.h>
#import "GADInterstitial.h"
#import <RevMobAds/RevMobAds.h>
#include "Reachability.h"

//#import "GameCenterFiles.h"



SKLabelNode *largerLabel;

@interface flappyDogeDebug2 : SKScene <GADInterstitialDelegate, GKGameCenterControllerDelegate>{
    GADInterstitial *adMobinterstitial_;
    GADRequest *request;
}

//@property (nonatomic, retain) GameCenterFiles *gameCenterManager;
@property (nonatomic, retain) NSString* currentLeaderBoard;






//@property (nonatomic, weak) SpriteViewController *GameCenterFiles;
//@property (nonatomic, weak) GameCenterFiles *spriteViewController;

@end
