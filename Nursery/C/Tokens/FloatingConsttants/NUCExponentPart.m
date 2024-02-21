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

+ (BOOL)expornentPartFrom:(NSString *)aString into:(NSString **)anEOrP into:(NSString **)aSign into:(NSString **)aDigitSequence location:(NSUInteger *)aLocationPointer
{
    if (!aLocationPointer || *aLocationPointer >= [aString length])
        return NO;
    
    NSString *aSmallEOrLageEToReturn = nil;
    
    [self eOrPFrom:aString into:&aSmallEOrLageEToReturn location:aLocationPointer];
    NSUInteger aLocation = *aLocationPointer;
    
    NSString *aSignToReturn = nil;
    [NUCFloatingConstant signFrom:aString into:&aSignToReturn location:&aLocation];
    
    NSString *aDigitSequenceToReturn = nil;
    if (aLocation < [aString length] && [NUCFloatingConstant digitSequenceFrom:aString at:&aLocation into:&aDigitSequenceToReturn])
    {
        *aLocationPointer = aLocation;
        
        if (anEOrP)
            *anEOrP = aSmallEOrLageEToReturn;
        if (aSign)
            *aSign = aSignToReturn;
        if (aDigitSequence)
            *aDigitSequence = aDigitSequenceToReturn;
        
        return  YES;
    }
    
    return NO;
}

+ (BOOL)eOrPFrom:(NSString *)aString into:(NSString **)aSmallPOrLargeP location:(NSUInteger *)aLocationPointer
{
    if (!aLocationPointer)
        return NO;
    
    NSString *aSmallEOrLageEToReturn = nil;
    NSRange aRange = NSMakeRange(*aLocationPointer, 1);
    
    if ([aString compare:NUCSmallE options:NSAnchoredSearch range:aRange] == NSOrderedSame)
        aSmallEOrLageEToReturn = NUCSmallE;
    else if ([aString compare:NUCLargeE options:NSAnchoredSearch range:aRange] == NSOrderedSame)
        aSmallEOrLageEToReturn = NUCLargeE;
    else
        return NO;
    
    if (aSmallPOrLargeP)
        *aSmallPOrLargeP = aSmallEOrLageEToReturn;
    *aLocationPointer = *aLocationPointer + 1;
    
    return YES;
}

+ (instancetype)exponentPartWith:(NSString *)aString location:(NSUInteger *)aLocationPointer
{
    NSString *aSmallEOrLargeE = nil, *aSign = nil, *aDigitSequence = nil;;
    if ([self expornentPartFrom:aString into:&aSmallEOrLargeE into:&aSign into:&aDigitSequence location:aLocationPointer])
        return [self exponentPartWithEOrP:aSmallEOrLargeE sign:aSign digitSequence:aDigitSequence];
    else
        return nil;
}

+ (instancetype)exponentPartWithEOrP:(NSString *)anEOrP sign:(NSString *)aSign digitSequence:(NSString *)aDigitSequence
{
    return [[[self alloc] initWithType:NUCLexicalElementNone eOrP:anEOrP sign:aSign digitSequence:aDigitSequence] autorelease];
}

- (instancetype)initWithType:(NUCLexicalElementType)aType eOrP:(NSString *)anEOrP sign:(NSString *)aSign digitSequence:(NSString *)aDigitSequence
{
    if (self = [super initWithType:NUCLexicalElementNone])
    {
        _eOrP = [anEOrP copy];
        _sign = [aSign copy];
        _digitSequence = [aDigitSequence copy];
    }
    
    return self;
}

- (NSString *)smallEOrLargeE
{
    return [self eOrP];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@ %p> %@%@%@", [self class], self, [self eOrP], [self sign], [self digitSequence]];
}

- (void)dealloc
{
    [_eOrP release];
    [_sign release];
    [_digitSequence release];
    
    [super dealloc];
}

@end
