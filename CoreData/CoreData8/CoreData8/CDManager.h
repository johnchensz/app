//
//  CDManager.h
//  CoreData8
//
//  Created by John Chen on 4/29/14.
//  Copyright (c) 2014 GLSX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CDManager : NSManagedObject

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSSet *employees;
@end

@interface CDManager (CoreDataGeneratedAccessors)

- (void)addEmployeesObject:(NSManagedObject *)value;
- (void)removeEmployeesObject:(NSManagedObject *)value;
- (void)addEmployees:(NSSet *)values;
- (void)removeEmployees:(NSSet *)values;

@end
