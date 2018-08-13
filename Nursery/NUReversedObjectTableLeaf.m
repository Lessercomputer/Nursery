//
//  NUReversedObjectTableLeaf.m
//  Nursery
//
//  Created by Akifumi Takata on 2013/01/12.
//
//

#import <Foundation/NSString.h>

#import "NUReversedObjectTableLeaf.h"
#import "NUObjectTable.h"
#import "NUIndexArray.h"
#import "NUBellBallArray.h"
#import "NUBellBall.h"

@implementation NUReversedObjectTableLeaf

+ (NUUInt64)nodeOOP
{
	return NUReversedObjectTableLeafNodeOOP;
}

- (NUOpaqueArray *)makeValueArray
{
	return [[[NUBellBallArray alloc] initWithCapacity:[self valueCapacity] comparator:[[self tree] comparator]] autorelease];
}

- (NSString *)description
{
    NSMutableString *aString = [NSMutableString stringWithFormat:
                                @"<%@:%p>{", NSStringFromClass([self class]), self];
    NUUInt32 i = 0;
    
    for (; i < [self keyCount]; i++)
    {
        [aString appendFormat:@"(%llu, %@}",
         [(NUIndexArray *)[self keys] indexAt:i],
         NUStringFromBellBall([(NUBellBallArray *)[self values] bellBallAt:i])];
        if (i != [self keyCount] - 1)
            [aString appendString:@", "];
    }
    
    [aString appendString:@")"];
    
    return aString;
}

@end
