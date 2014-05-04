//
//  CDAppDelegate.m
//  CoreData9
//
//  Created by John Chen on 4/30/14.
//  Copyright (c) 2014 GLSX. All rights reserved.
//

#import "CDAppDelegate.h"
#import "CDPerson.h"

@implementation CDAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self createBatchPersons];
    
    __weak NSManagedObjectContext* mainContext = self.managedObjectContext;
    __weak CDAppDelegate* weakself = self;
    __block NSMutableArray* fetchPersons = nil;
    
    NSManagedObjectContext* backgroundContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    backgroundContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    [backgroundContext performBlock:^(void){
        NSFetchRequest* fetchRequest = [self fetchMatchPersons];
        NSError* error = nil;
        NSArray* personIds = [backgroundContext executeFetchRequest:fetchRequest error:&error];
        
        if (personIds!=nil && error==nil) {
            fetchPersons = [NSMutableArray arrayWithCapacity:personIds.count];
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                for (NSManagedObjectID* personid in personIds) {
                    CDPerson* person = (CDPerson*)[mainContext objectWithID:personid];
                    [fetchPersons addObject:person];
                }
                [weakself processPersonResults:fetchPersons];
            });
        }
    }];
    
    
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

-(NSFetchRequest*)fetchMatchPersons
{
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([CDPerson class])];
    fetchRequest.fetchBatchSize = 20;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(age>100) AND (age<200)"];
    [fetchRequest setPredicate:predicate];
    fetchRequest.resultType = NSManagedObjectIDResultType;
    
    return fetchRequest;
}

-(void)createBatchPersons{
    
    for (NSUInteger i=1; i<1001; i++) {
        CDPerson* person = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([CDPerson class]) inManagedObjectContext:self.managedObjectContext];
        person.firstName = [NSString stringWithFormat:@"first name %d",i];
        person.lastName = [NSString stringWithFormat:@"last name %d",i];
        person.age = @(i);
        
    }
    
    NSError* error = nil;
    [self.managedObjectContext save:&error];
    if (error) {
        NSLog(@"batch create failed - %@",error);
    } else {
        NSLog(@"create batch person finished.");
    }
    
}

-(void)processPersonResults:(NSArray*)persons
{
    for (CDPerson* person in persons) {
        NSLog(@"%d - %@ %@ (%d)",[person.age integerValue],person.firstName,person.lastName,person.age.integerValue);
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
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CoreData9" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CoreData9.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end