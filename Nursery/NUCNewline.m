//
//  NUCNewline.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/01.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCNewline.h"

@implementation NUCNewline

+ (instancetype)newlineWithCr:(NUCLexicalElement *)aCr lf:(NUCLexicalElement *)anLf
{
    return [[[self alloc] initWithCr:aCr lf:anLf] autorelease];
}

- (instancetype)initWithCr:(NUCLexicalElement *)aCr lf:(NUCLexicalElement *)anLf
{
    if (self = [super initWithType:NUCLexicalElementNewlineType])
    {
        cr = [aCr retain];
        lf = [anLf retain];
    }
    
    return self;
}

- (void)dealloc
{
    [cr release];
    [lf release];
    
    [super dealloc];
}

- (BOOL)isCr
{
    return [self cr] && ![self lf];
}

- (BOOL)isLf
{
    return ![self cr] && [self lf];
}

- (BOOL)isCrLf
{
    return [self cr] && [self lf];
}

- (NUCLexicalElement *)cr
{
    return cr;
}

- (NUCLexicalElement *)lf
{
    return lf;
}

@end
