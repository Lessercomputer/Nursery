//
//  NUCConstant.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/03/05.
//

#import "NUCConstant.h"
#import "NUCIntegerConstant.h"
#import "NUCFloatingConstant.h"
#import "NUCCharacterConstant.h"
#import "NUCDecomposedPreprocessingToken.h"
#import "NUCPreprocessingTokenStream.h"

@implementation NUCConstant

@synthesize content;

+ (BOOL)constantFrom:(NUCTokenStream *)aStream into:(NUCConstant **)aConstant
{
    if ([aStream isForPreprocessing])
    {
        if ([NUCIntegerConstant integerConstantFrom:aStream into:aConstant])
        {
            return YES;
        }
        else if ([[aStream peekNext] isCharacterConstant])
        {
            if (aConstant)
                *aConstant = [NUCConstant constantWithCharacterConstant:(NUCCharacterConstant *)[aStream next]];
            
            return YES;
        }
        
        return NO;
    }
    else
    {
        NSUInteger aPosition = [aStream position];
        id <NUCToken> aToken = [aStream next];
        
        if ([aToken isConstant])
        {
            if (aConstant)
                *aConstant = aToken;
            return YES;
        }
        else
        {
            [aStream setPosition:aPosition];
            return NO;
        }
    }
}

+ (instancetype)constantFromPpToken:(NUCDecomposedPreprocessingToken *)aPpToken
{
    NUCConstant *aConstant = nil;
    
    if ([aPpToken isCharacterConstant])
        aConstant = [NUCConstant constantWithCharacterConstant:(NUCCharacterConstant *)aPpToken];
    else if ([NUCFloatingConstant floatingConstantFromPpNumber:aPpToken into:&aConstant])
        ;
    else if ([NUCIntegerConstant integerConstantFromPpNumber:aPpToken into:&aConstant])
        ;
    
    return aConstant;
}

+ (instancetype)constantWithIntegerConstant:(NUCIntegerConstant *)anIntegerConstant
{
    return [[[self alloc] initWithContent:anIntegerConstant] autorelease];
}

+ (instancetype)constantWithFloatingConstant:(NUCFloatingConstant *)aFloatingConstant
{
    return [[[self alloc] initWithContent:aFloatingConstant] autorelease];
}

+ (instancetype)constantWithCharacterConstant:(NUCCharacterConstant *)aCharacterConstant
{
    return [[[self alloc] initWithContent:aCharacterConstant] autorelease];
}

- (instancetype)initWithContent:(id <NUCToken>)aContent
{
    if (self = [super initWithType:NUCLexicalElementConstantType])
    {
        content = [aContent retain];
    }
    
    return self;
}

- (void)dealloc
{
    [content release];
    
    [super dealloc];
}

- (BOOL)isIntegerConstant
{
    return [content isKindOfClass:[NUCIntegerConstant class]];
}

- (BOOL)isCharacterConstant
{
    return [content isKindOfClass:[NUCCharacterConstant class]];
}

- (NSString *)description
{
    return [[self content] description];
}

@end
