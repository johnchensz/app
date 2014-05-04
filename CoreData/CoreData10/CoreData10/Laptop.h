//
//  Laptop.h
//  CoreData10
//
//  Created by John Chen on 5/4/14.
//  Copyright (c) 2014 GLSX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Laptop : NSManagedObject

@property (nonatomic, retain) NSString * model;
@property (nonatomic, retain) UIColor* color;

@end
