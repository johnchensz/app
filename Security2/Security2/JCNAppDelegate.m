//
//  JCNAppDelegate.m
//  Security2
//
//  Created by John Chen on 4/14/14.
//  Copyright (c) 2014 JohnChen. All rights reserved.
//

#import "JCNAppDelegate.h"

#import <Security/Security.h>

@implementation JCNAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    [self savePassword];
    
    [self getKeyChainInfo];
    
    [self getPassword];
    
    [self getAllPasswordForKey];
    
    // Override point for customization after application launch.
    return YES;
}

-(void)getAllPasswordForKey
{
    NSString* keyForSearchFor = @"PhoneNumber";
    NSString* sevice = [[NSBundle mainBundle] bundleIdentifier];
    
    NSDictionary* query = @{(__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
                            (__bridge id)kSecAttrService: sevice,
                            (__bridge id)kSecAttrAccount: keyForSearchFor,
                            (__bridge id)kSecReturnData: (__bridge id)kCFBooleanTrue,
                            (__bridge id)kSecMatchLimit: (__bridge id)kSecMatchLimitAll
                            };
    
    CFArrayRef allCfMatches = NULL;
    OSStatus results = SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef *)&allCfMatches);
    
    if (results==errSecSuccess) {
        NSArray* allMatches = (__bridge_transfer NSArray*)allCfMatches;
        for (NSData* itemData in allMatches) {
            NSString* itemValue = [[NSString alloc] initWithData:itemData encoding:NSUTF8StringEncoding];
            NSLog(@"value = %@",itemValue);
        }
        
    } else {
        NSLog(@"Error happened with code: %ld",(long)results);
    }
    
}

-(void)getPassword
{
    NSString* keyForSearchFor = @"PhoneNumber";
    NSString* sevice = [[NSBundle mainBundle] bundleIdentifier];
    
    NSDictionary* query = @{(__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
                            (__bridge id)kSecAttrService: sevice,
                            (__bridge id)kSecAttrAccount: keyForSearchFor,
                            (__bridge id)kSecReturnData: (__bridge id)kCFBooleanTrue
                            };
    
    CFDataRef cfValue = NULL;
    OSStatus results = SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef *)&cfValue);
    
    if (results==errSecSuccess) {
        NSString* value = [[NSString alloc] initWithData:(__bridge_transfer NSData*)cfValue encoding:NSUTF8StringEncoding];
        NSLog(@"password = %@",value);
        
    } else {
        NSLog(@"Error happend with code: %ld",(long)results);
    }

}

-(void)getKeyChainInfo
{
    NSString* keyForSearchFor = @"PhoneNumber";
    NSString* sevice = [[NSBundle mainBundle] bundleIdentifier];
    
    NSDictionary* query = @{(__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
                            (__bridge id)kSecAttrService: sevice,
                            (__bridge id)kSecAttrAccount: keyForSearchFor,
                            (__bridge id)kSecReturnAttributes: (__bridge id)kCFBooleanTrue
                            };
    
    CFDictionaryRef valueAttributes = NULL;
    OSStatus results = SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef *)&valueAttributes);
    
    NSDictionary* attributes = (__bridge_transfer NSDictionary*)valueAttributes;
    
    if (results==errSecSuccess) {
        NSString* key, *accessGroup, *creationDate, *modifiedDate, *service;
        
        key = attributes[(__bridge id)kSecAttrAccount];
        accessGroup = attributes[(__bridge id)kSecAttrAccessGroup];
        creationDate = attributes[(__bridge id)kSecAttrCreationDate];
        modifiedDate = attributes[(__bridge id)kSecAttrModificationDate];
        service = attributes[(__bridge id)kSecAttrService];
        
        NSLog(@"Key = %@\n \
              Access Group = %@\n \
              Creation Date = %@\n \
              Modification Date = %@\n \
              Service = %@",key,accessGroup,creationDate,modifiedDate,service);
        
    } else {
        NSLog(@"Error happend with code: %ld",(long)results);
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
