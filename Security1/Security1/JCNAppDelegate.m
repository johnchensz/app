//
//  JCNAppDelegate.m
//  Security1
//
//  Created by John Chen on 4/13/14.
//  Copyright (c) 2014 JohnChen. All rights reserved.
//

#import "JCNAppDelegate.h"

#import <Security/Security.h>

@implementation JCNAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSString* key = @"Full Name";
    NSString* value = @"John Chen";
    NSData* valueData = [value dataUsingEncoding:NSUTF8StringEncoding];
    NSString* service = [[NSBundle mainBundle] bundleIdentifier];
    NSDictionary* secItem = @{(__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword ,
                              (__bridge id)kSecAttrService : service ,
                              (__bridge id)kSecAttrAccount : key ,
                              (__bridge id)kSecValueData : valueData
                              };
    
    CFTypeRef result = NULL;
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)secItem, &result);
    if (status==errSecSuccess) {
        NSLog(@"Successfully stored the value");
    } else {
        NSLog(@"Failure to store the value with code: %ld",(long)status);
    }
    
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
