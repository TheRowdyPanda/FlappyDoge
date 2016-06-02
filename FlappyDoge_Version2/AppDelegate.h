//
//  AppDelegate.h
//  FlappyDoge_Version2
//
//  Created by Rijul Gupta on 2/11/14.
//  Copyright (c) 2014 Rijul Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

#import <RevMobAds/RevMobAds.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error;


@end
