//
//  NUCConstant.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/03/05.
//  Copyright © 2021 Nursery-Framework. All rights reserved.
//

#import "NUCConstant.h"
#import "NUCIntegerConstant.h"
#import "NUCDecomposedPreprocessingToken.h"

@implementation NUCConstant

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
