//
//  CDEmployee.h
//  CoreData8
//
//  Created by John Chen on 4/29/14.
//  Copyright (c) 2014 GLSX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDManager;

@interface CDEmployee : NSManagedObject

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) CDManager *manager;

@end
