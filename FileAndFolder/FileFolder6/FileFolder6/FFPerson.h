//
//  FFPerson.h
//  FileFolder6
//
//  Created by John Chen on 5/7/14.
//  Copyright (c) 2014 JohnChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFPerson : NSObject <NSCoding>
@property (nonatomic,copy) NSString* firstName;
@property (nonatomic,copy) NSString* lastName;
@end
