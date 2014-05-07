//
//  FFAppDelegate.m
//  FileFolder5
//
//  Created by John Chen on 5/6/14.
//  Copyright (c) 2014 JohnChen. All rights reserved.
//

#import "FFAppDelegate.h"

@interface FFAppDelegate ()
@property(nonatomic,strong) NSFileManager* fileManager;
@end

@implementation FFAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.fileManager = [[NSFileManager alloc] init];
    
    //1.在tmp目录下创建txt文件夹，专门用来保存app产生的text文件；2.模拟创建5个text文件。创建后列出这些文件，以确定文件创建成功；3.删除5个text文件，并检验是否文件夹是否清空；4.删除txt文件夹。
    
    [self createFolder];
    [self createFiles];
    [self listAllTextFiles];
    
    [self deleteAllTextFiles];
    [self listAllTextFiles];
    
    [self deleteTextFolder];
    [self checkFolderExist];
    
    
    // Override point for customization after application launch.
    return YES;
}

-(void)checkFolderExist
{
    NSString* txtFolder = [NSTemporaryDirectory() stringByAppendingPathComponent:@"txt"];
    NSLog(@"folder path - %@",txtFolder);
    NSError* error=nil;
    NSArray* files = [self.fileManager contentsOfDirectoryAtPath:txtFolder error:&error];
    if (files.count>0) {
        NSLog(@"folder is exist, and has files.");
    } else if (files.count==0){
        NSLog(@"folder may or may not exist.");
    } else if (error){
        NSLog(@"folder not exist - %@",error);
    } else {
        NSLog(@"folder does not exist");
    }

}

-(void)createFolder
{
    NSString* txtFolder = [NSTemporaryDirectory() stringByAppendingPathComponent:@"txt"];
    NSLog(@"folder path - %@",txtFolder);
    NSError* error=nil;
    NSArray* files = [self.fileManager contentsOfDirectoryAtPath:txtFolder error:&error];
    if (files.count>0) {
        NSLog(@"folder is exist, and has files.");
    } else if (files.count==0){
        NSLog(@"folder may or may not exist.");
        NSError* errorcreate = nil;
        BOOL result = [self.fileManager createDirectoryAtPath:txtFolder withIntermediateDirectories:YES attributes:nil error:&errorcreate];
        if (result) {
            NSLog(@"folder is created.");
        } else {
            NSLog(@"folder create fail - %@",errorcreate);
        }
    } else if (error){
        NSLog(@"folder not exist - %@",error);
    } else {
        NSLog(@"folder does not exist");
    }
}

-(void)createFiles
{
    NSString* txtFolder = [NSTemporaryDirectory() stringByAppendingPathComponent:@"txt"];
 
    for (NSInteger i=1; i<6; i++) {
        NSString* filename = [NSString stringWithFormat:@"%d.txt",i];
        NSString* filepath = [txtFolder stringByAppendingPathComponent:filename];
//        NSLog(@"new file - %@",filename);
        
        NSString* filebody = @"WORK HARD";
        NSError* error = nil;
        BOOL result = [filebody writeToFile:filepath atomically:YES encoding:NSUTF8StringEncoding error:&error];
        if (result) {
//            NSLog(@"created file - %@",filepath);
        } else {
            NSLog(@"create file failed - %@",error);
        }
    }
}

-(void)listAllTextFiles
{
    NSString* txtFolder = [NSTemporaryDirectory() stringByAppendingPathComponent:@"txt"];

    NSError* error = nil;
    NSArray* files = [self.fileManager contentsOfDirectoryAtPath:txtFolder error:&error];
    if (files.count>0) {
        for (NSString* filename in files) {
            NSLog(@"file - %@",filename);
        }
    } else {
        NSLog(@"no file - error: %@",error);
    }
    
}

-(void)deleteAllTextFiles
{
    NSString* txtFolder = [NSTemporaryDirectory() stringByAppendingPathComponent:@"txt"];
    
    NSError* error = nil;
    NSArray* files = [self.fileManager contentsOfDirectoryAtPath:txtFolder error:&error];
    if (files.count>0) {
        for (NSString* filename in files) {

            NSString* filepath = [txtFolder stringByAppendingPathComponent:filename];
            NSError* error = nil;
            BOOL result = [self.fileManager removeItemAtPath:filepath error:&error];
            if (result==NO) {
                NSLog(@"delete file error - %@",error);
            }
        }
    }
}

-(void)deleteTextFolder
{
    NSString* txtFolder = [NSTemporaryDirectory() stringByAppendingPathComponent:@"txt"];
    NSError* error = nil;
    BOOL result = [self.fileManager removeItemAtPath:txtFolder error:&error];
    if (result==NO) {
        NSLog(@"delete folder error - %@",error);
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
