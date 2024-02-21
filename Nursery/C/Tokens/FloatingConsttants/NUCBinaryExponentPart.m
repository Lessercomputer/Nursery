//
//  NUCBinaryExponentPart.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2024/02/17.
//

#import "NUCBinaryExponentPart.h"
#import <Foundation/NSString.h>

@implementation NUCBinaryExponentPart

+ (BOOL)eOrPFrom:(NSString *)aString into:(NSString **)aSmallPOrLargeP location:(NSUInteger *)aLocationPointer
{
    NSString *aSmallPOrLargePToReturn = nil;
    
    if (!aLocationPointer)
        return NO;
    
    if ([aString compare:NUCSmallP options:NSAnchoredSearch range:NSMakeRange(*aLocationPointer, 1)] == NSOrderedSame)
        aSmallPOrLargePToReturn = NUCSmallP;
    else if ([aString compare:NUCLargeP options:NSAnchoredSearch range:NSMakeRange(*aLocationPointer, 1)] == NSOrderedSame)
        aSmallPOrLargePToReturn = NUCLargeP;
    else
        return NO;
    
    if (aSmallPOrLargePToReturn)
        *aSmallPOrLargeP = aSmallPOrLargePToReturn;
    *aLocationPointer = *aLocationPointer + 1;
    
    return YES;
}

- (NSString *)smallPOrLargeP
{
    return [self eOrP];
}

@end
