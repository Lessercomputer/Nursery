//
//  NUCConstant.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/03/05.
//

#import "NUCConstant.h"
#import "NUCIntegerConstant.h"
#import "NUCDecomposedPreprocessingToken.h"
#import "NUCPreprocessingTokenStream.h"

@implementation NUCConstant

@synthesize content;

+ (BOOL)constantFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCConstant **)aConstant
{
    if ([NUCIntegerConstant integerConstantFrom:aStream into:aConstant])
    {
        return YES;
    }
    else if ([[aStream peekNext] isCharacterConstant])
    {
        if (aConstant)
            *aConstant = [NUCConstant constantWithCharacterConstant:[aStream next]];
        
        return YES;
    }
    
    return NO;
}

+ (instancetype)constantWithIntegerConstant:(NUCIntegerConstant *)anIntegerConstant
{
    return [[[self alloc] initWithContent:anIntegerConstant] autorelease];
}

+ (instancetype)constantWithCharacterConstant:(NUCDecomposedPreprocessingToken *)aCharacterConstant
{
    return [[[self alloc] initWithContent:aCharacterConstant] autorelease];
}

- (instancetype)initWithContent:(NUCPreprocessingToken *)aContent
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

@end
