//
//  AppDelegate.h
//  Spritemation
//
//  Created by Craig Hinrichs on 7/15/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import <DropboxSDK/DropboxSDK.h>

@interface AppController : NSObject <UIApplicationDelegate, CCDirectorDelegate, DBSessionDelegate, DBNetworkRequestDelegate>
{
	UIWindow *window_;
	UINavigationController *navController_;

	CCDirectorIOS	*director_;							// weak ref
    NSString *relinkUserId;
}

@property (nonatomic, retain) UIWindow *window;
@property (readonly) UINavigationController *navController;
@property (readonly) CCDirectorIOS *director;

@end
