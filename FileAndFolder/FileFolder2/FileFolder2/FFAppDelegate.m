//
//  FFAppDelegate.m
//  FileFolder2
//
//  Created by John Chen on 5/6/14.
//  Copyright (c) 2014 GLSX. All rights reserved.
//

#import "FFAppDelegate.h"

@implementation FFAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
//    [self readWriteTextFile];
//    [self readWriteArray];
//    [self readWriteDictionary];
    
    [self readWriteBytes];
    
    return YES;
}

-(void)readWriteTextFile
{
    NSString* text = @"Hello Morning";
    
    NSString* tmppath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"hello.txt"];
    BOOL saveresult = [text writeToFile:tmppath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    if (saveresult) {
        NSString* txt2 = [NSString stringWithContentsOfFile:tmppath encoding:NSUTF8StringEncoding error:nil];
        
        NSLog(@"hello.txt content: %@",txt2);
    }
}

-(void)readWriteArray
{
    NSArray* arrays = @[@"liu bei",@"zhang fei",@"guan yu"];
    NSString* tmppath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"hello.txt"];

    BOOL saveresult = [arrays writeToFile:tmppath atomically:YES];
    if (saveresult) {
        NSArray* array2 = [[NSArray alloc] initWithContentsOfFile:tmppath];
        
        if ([arrays isEqualToArray:array2]) {
            NSLog(@"save array load is ok");
        } else {
            NSLog(@"save file broken");
        }
    }
}

-(void)readWriteDictionary
{
    NSDictionary* dic1 = @{ @"key1": @12, @"key2":@14, @"key3": @25};
    NSString* tmppath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"hello.txt"];
    
    BOOL saveresult = [dic1 writeToFile:tmppath atomically:YES];
    if (saveresult) {
        NSDictionary* dic2 = [NSDictionary dictionaryWithContentsOfFile:tmppath];
        
        if ([dic2 isEqualToDictionary:dic1]) {
            NSLog(@"save dictionary is ok");
        } else {
            NSLog(@"save broken");
        }
    }
}

-(void)readWriteBytes
{
    char bytes[4] = { 'a','b','c','d'};
    NSData* data = [NSData dataWithBytes:bytes length:sizeof(bytes)];
    
    NSString* tmppath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"hello.txt"];

    BOOL saveresult = [data writeToFile:tmppath atomically:YES];
    if (saveresult) {
        NSData* data2 = [NSData dataWithContentsOfFile:tmppath];
        
        if ([data2 isEqualToData:data]) {
            NSLog(@"save bytes ok");
        } else {
            NSLog(@"save bytes failed");
        }
        
//        char byte2[4] ;
//        [data2 getBytes:byte2 length:sizeof(byte2)];
//        
//        for (int i=0; i<sizeof(byte2); i++) {
//            if (i > 0) printf(":");
//            printf("%02X", byte2[i]);
//
//        }
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
