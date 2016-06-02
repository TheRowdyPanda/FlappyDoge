//
//  MyScene.h
//  FlappyDoge_Version2
//

//  Copyright (c) 2014 Rijul Gupta. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
//#import "GameCenterFiles.h"



SKLabelNode *largerLabel;
@class SpriteViewController;

@interface flappyDogeDebug2 : SKScene

//@property (nonatomic, retain) GameCenterFiles *gameCenterManager;
@property (nonatomic, retain) NSString* currentLeaderBoard;


+ (BOOL) isGameCenterAvailable;




//@property (nonatomic, weak) SpriteViewController *GameCenterFiles;
//@property (nonatomic, weak) GameCenterFiles *spriteViewController;

@end
