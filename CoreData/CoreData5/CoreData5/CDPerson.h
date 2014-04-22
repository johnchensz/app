//
//  CDPerson.h
//  CoreData5
//
//  Created by John Chen on 4/22/14.
//  Copyright (c) 2014 GLSX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CDPerson : NSManagedObject

@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSNumber * age;

@end
