//
//  iHypeAppDelegate.m
//  iHype
//
//  Created by Farid Zakaria on 11-04-14.
//  Copyright 2011 Setheron Media. All rights reserved.
//

#import "iHypeAppDelegate.h"
#import "SongTableViewController.h"
#import "SongDetailViewController.h"
#import <Three20/Three20.h>

@implementation iHypeAppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
    //This is how I found to add playing the music in the background
    UIDevice *thisDevice = [UIDevice currentDevice];
    if([thisDevice respondsToSelector:@selector(isMultitaskingSupported)]
       && thisDevice.multitaskingSupported)
    {
        UIBackgroundTaskIdentifier backgroundTask = [application beginBackgroundTaskWithExpirationHandler:^{
            /* just fail if this happens. */
            NSLog(@"BackgroundTask Expiration Handler is called");
            [application endBackgroundTask:backgroundTask];
        }];
    }
    
    
    TTNavigator* navigator = [TTNavigator navigator];
    navigator.persistenceMode = TTNavigatorPersistenceModeNone;
    
    TTURLMap* map = navigator.URLMap;
    
    //[map from:@"*" toViewController:[TTWebController class]];
    [map from:kAppRootURLPath toViewController:[SongTableViewController class]];
    
    [map from:kAppSongDetailURLPath toSharedViewController:[SongDetailViewController class]];
    
    if (![navigator restoreViewControllers]) {
        [navigator openURLAction:[TTURLAction actionWithURLPath:kAppRootURLPath]];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)navigator:(TTNavigator*)navigator shouldOpenURL:(NSURL*)URL {
    return YES;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)application:(UIApplication*)application handleOpenURL:(NSURL*)URL {
    [[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:URL.absoluteString]];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [super dealloc];
}

@end
