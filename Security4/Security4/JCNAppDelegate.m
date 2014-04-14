//
//  JCNAppDelegate.m
//  Security4
//
//  Created by John Chen on 4/14/14.
//  Copyright (c) 2014 JohnChen. All rights reserved.
//

#import "JCNAppDelegate.h"

@implementation JCNAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    [self savePassword];
    
    NSString* keyForSearchFor = @"PhoneNumber";
    NSString* service = [[NSBundle mainBundle] bundleIdentifier];
    NSDictionary* query = @{(__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword ,
                              (__bridge id)kSecAttrService : service ,
                              (__bridge id)kSecAttrAccount : keyForSearchFor
                              };
    
    OSStatus found = SecItemCopyMatching((__bridge CFDictionaryRef)query, NULL);
    if (found==errSecSuccess) {
        
        NSData* newData = [@"15323438578" dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary* update = @{
                                 (__bridge id)kSecValueData : newData,
                                 (__bridge id)kSecAttrComment : @"this is special comment for account"
                                 };
        OSStatus updated = SecItemUpdate((__bridge CFDictionaryRef)query,(__bridge CFDictionaryRef)update);
        
        if (updated==errSecSuccess) {
            [self readExistingValue];
        } else {
            NSLog(@"Failed to update the value. Error = %ld",(long)update);
        }
    
    } else {
        NSLog(@"Failure to store the value with code: %ld",(long)found);
    }
    
    
    
    // Override point for customization after application launch.
    return YES;
}

-(void)readExistingValue
{
    NSString* keyForSearchFor = @"PhoneNumber";
    NSString* service = [[NSBundle mainBundle] bundleIdentifier];
    NSDictionary* query = @{(__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword ,
                            (__bridge id)kSecAttrService : service ,
                            (__bridge id)kSecAttrAccount : keyForSearchFor ,
                            (__bridge id)kSecReturnAttributes : (__bridge id)kCFBooleanTrue
                            };
    
    CFDictionaryRef cfAttributes = NULL;
    OSStatus found = SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef *)&cfAttributes);
    if (found==errSecSuccess) {
        NSDictionary* attributes = (__bridge_transfer NSDictionary*)cfAttributes;
        NSString* comment = attributes[(__bridge id)kSecAttrComment];
        NSLog(@"comment = %@",comment);
    } else {
        NSLog(@"Error happened with code: %ld", (long)found);
    }
}

-(void)savePassword
{
    NSString* key = @"PhoneNumber";
    NSString* value = @"18620306015";
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
