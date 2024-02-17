//
//  NUCExponentPart.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2024/02/12.
//

#import "NUCExponentPart.h"
#import "NUCFloatingConstant.h"
#import <Foundation/NSString.h>

@implementation NUCExponentPart

+ (BOOL)expornentPartFrom:(NSString *)aString into:(NSString **)aSmallEOrLargeE into:(NSString **)aSign into:(NSString **)aDigitSequence location:(NSUInteger *)aLocationPointer
{
    if (!aLocationPointer || *aLocationPointer >= [aString length])
        return NO;
    
    NSUInteger aLocation = *aLocationPointer;
    NSString *aSmallEOrLageEToReturn = nil;
    NSRange aRange = NSMakeRange(aLocation, 1);
    
    if ([aString compare:NUCSmallE options:NSAnchoredSearch range:aRange] == NSOrderedSame)
        aSmallEOrLageEToReturn = NUCSmallE;
    else if ([aString compare:NUCLargeE options:NSAnchoredSearch range:aRange] == NSOrderedSame)
        aSmallEOrLageEToReturn = NUCLargeE;
    else
        return NO;
    
    aLocation++;
    
    NSString *aSignToReturn = nil;
    [NUCFloatingConstant signFrom:aString into:&aSignToReturn location:&aLocation];
    
    NSString *aDigitSequenceToReturn = nil;
    if (aLocation < [aString length] && [NUCFloatingConstant digitSequenceFrom:aString at:&aLocation into:&aDigitSequenceToReturn])
    {
        *aLocationPointer = aLocation;
        
        if (aDigitSequence)
            *aDigitSequence = aDigitSequenceToReturn;
        
        return  YES;
    }
    
    return NO;
}

+ (instancetype)exponentPartWith:(NSString *)aString location:(NSUInteger *)aLocationPointer
{
    NSString *aSmallEOrLargeE = nil, *aSign = nil, *aDigitSequence = nil;;
    if ([self expornentPartFrom:aString into:&aSmallEOrLargeE into:&aSign into:&aDigitSequence location:aLocationPointer])
        return [self exponentPartWithSmallEOrLargeE:aSmallEOrLargeE sign:aSign digitSequence:aDigitSequence];
    else
        return nil;
}

+ (instancetype)exponentPartWithSmallEOrLargeE:(NSString *)aSmallEOrLargeE sign:(NSString *)aSign digitSequence:(NSString *)aDigitSequence
{
    return [[[self alloc] initWithType:NUCLexicalElementNone smallEOrLargeE:aSmallEOrLargeE sign:aSign digitSequence:aDigitSequence] autorelease];
}

- (instancetype)initWithType:(NUCLexicalElementType)aType smallEOrLargeE:(NSString *)aSmallEOrLargeE sign:(NSString *)aSign digitSequence:(NSString *)aDigitSequence
{
    if (self = [super initWithType:NUCLexicalElementNone])
    {
        _smallEOrLargeE = [aSmallEOrLargeE copy];
        _sign = [aSign copy];
        _digitSequence = [aDigitSequence copy];
    }
    
    return self;
}

- (void)dealloc
{
    [_smallEOrLargeE release];
    [_sign release];
    [_digitSequence release];
    
    [super dealloc];
}

@end
