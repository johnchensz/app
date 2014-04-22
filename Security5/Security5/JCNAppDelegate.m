//
//  JCNAppDelegate.m
//  Security5
//
//  Created by John Chen on 4/15/14.
//  Copyright (c) 2014 Chen. All rights reserved.
//

#import "JCNAppDelegate.h"

#import <Security/Security.h>

@implementation JCNAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
//    [self savePassword];
    
//    [self deletePassword];
    
    
    //------------
    [self saveGroupTypePassword];
    //------------
    
    // Override point for customization after application launch.
    return YES;
}

-(void)deletePassword
{
    NSString* key = @"PhoneNumber";
    NSString* service = [[NSBundle mainBundle] bundleIdentifier];
    
    NSDictionary* query = @{(__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword ,
                            (__bridge id)kSecAttrService : service ,
                            (__bridge id)kSecAttrAccount : key
                            };
    
    OSStatus foundExisting = SecItemCopyMatching((__bridge CFDictionaryRef)query, NULL);
    if (foundExisting==errSecSuccess) {
        OSStatus deleted = SecItemDelete((__bridge CFDictionaryRef)query);
        if(deleted==errSecSuccess){
            NSLog(@"Successfully deleted the item");
        } else {
            NSLog(@"Failed to delete the item");
        }
    }else{
        NSLog(@"Did not found the existing value.");
    }
    
}

-(void)savePassword
{
    NSString* key = @"PhoneNumber";
    NSString* value = @"13800138000";
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

-(void)saveGroupTypePassword
{
    NSString* key = @"PhoneNumber";
    NSString* service = [[NSBundle mainBundle] bundleIdentifier];
    NSString* accessGroup = @"QHWR2FWBM6.com.johnchensz.Security5";
    
//    NSDictionary* query1 = @{(__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword ,
//                            (__bridge id)kSecAttrService : service ,
//                            (__bridge id)kSecAttrAccount : key ,
//                            (__bridge id)kSecAttrAccessGroup : accessGroup ,
//                            (__bridge id)kSecReturnAttributes : (__bridge id)kCFBooleanTrue
//                            };
//    
//    CFDictionaryRef cfAttributes = NULL;
//    OSStatus found1 = SecItemCopyMatching((__bridge CFDictionaryRef)query1, (CFTypeRef *)&cfAttributes);
//    if (found1==errSecSuccess) {
//        NSDictionary* attributes = (__bridge_transfer NSDictionary*)cfAttributes;
//        NSLog(@"attributes = %@",attributes);
//    } else {
//        NSLog(@"Error happened with code: %ld", (long)found1);
//    }

    
    
//    NSDictionary* queryDictionary = @{(__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword ,
//                                      (__bridge id)kSecAttrService : service ,
//                                      (__bridge id)kSecAttrAccessGroup : accessGroup ,
//                                      (__bridge id)kSecAttrAccount : key
//                                      };
//    SecItemDelete((__bridge CFDictionaryRef)queryDictionary);
    
    
    NSString* value = @"13800138000";
    NSData* valueData = [value dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* secItem = @{(__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword ,
                              (__bridge id)kSecAttrService : service ,
                              (__bridge id)kSecAttrAccessGroup : accessGroup ,
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
