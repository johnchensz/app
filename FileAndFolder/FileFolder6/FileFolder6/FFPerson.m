//
//  FFPerson.m
//  FileFolder6
//
//  Created by John Chen on 5/7/14.
//  Copyright (c) 2014 JohnChen. All rights reserved.
//

#import "FFPerson.h"

NSString* const kFirstNameKey = @"FirstNameKey";
NSString* const kLastNameKey = @"LastNameKey";

@implementation FFPerson

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_firstName forKey:kFirstNameKey];
    [aCoder encodeObject:_lastName forKey:kLastNameKey];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self!=nil) {
        _firstName = [aDecoder decodeObjectForKey:kFirstNameKey];
        _lastName = [aDecoder decodeObjectForKey:kLastNameKey];
    }
    return self;
}


@end
