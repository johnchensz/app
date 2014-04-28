//
//  CDPerson.h
//  CoreData6
//
//  Created by John Chen on 4/25/14.
//  Copyright (c) 2014 GLSX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CDPerson : NSManagedObject

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSNumber * age;

@end
