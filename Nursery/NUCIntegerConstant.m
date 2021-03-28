//
//  NUCIntegerConstant.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/03/12.
//  Copyright © 2021 Nursery-Framework. All rights reserved.
//

#import "NUCIntegerConstant.h"

@implementation NUCIntegerConstant

+ (instancetype)constantWithPpNumber:(NUCDecomposedPreprocessingToken *)aPpNumber value:(NUUInt64)aValue
{
    return [[[self alloc] initWithPpNumber:aPpNumber value:aValue] autorelease];
}

- (instancetype)initWithPpNumber:(NUCDecomposedPreprocessingToken *)aPpNumber value:(NUUInt64)aValue
{
    if (self = [super initWithType:NUCLexicalElementIntegerConstantType])
    {
        ppNumber = [aPpNumber retain];
        value = aValue;
    }
    
    return self;
}

- (void)dealloc
{
    [ppNumber release];
    
    [super dealloc];
}

@end
