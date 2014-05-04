//
//  CDColorTransformer.m
//  CoreData10
//
//  Created by John Chen on 5/4/14.
//  Copyright (c) 2014 GLSX. All rights reserved.
//

#import "CDColorTransformer.h"

@implementation CDColorTransformer

+(BOOL)allowsWeakReference
{
    return YES;
}

+(Class)transformedValueClass
{
    return [NSData class];
}

-(id)transformedValue:(id)value
{
    UIColor* color = (UIColor*)value;
    CGFloat red,green,blue,alpha;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    CGFloat colorVal[4] = {red,green,blue,alpha};
    
    NSData* data = [[NSData alloc] initWithBytes:colorVal length:sizeof(colorVal)];
    return data;
}

-(id)reverseTransformedValue:(id)value
{
    NSData* data = (NSData*)value;
    CGFloat colorVal[4] = {0,0,0,0};
    [data getBytes:colorVal length:sizeof(colorVal)];
    
    UIColor* color = [UIColor colorWithRed:colorVal[0] green:colorVal[1] blue:colorVal[2] alpha:colorVal[3]];
    return color;
}

@end
