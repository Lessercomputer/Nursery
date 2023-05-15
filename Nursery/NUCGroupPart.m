//
//  NUCGroupPart.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2023/03/05.
//  Copyright © 2023 Nursery-Framework. All rights reserved.
//

#import "NUCGroupPart.h"
#import "NUCPreprocessingTokenStream.h"
#import "NUCIfSection.h"
#import "NUCControlLine.h"
#import "NUCTextLine.h"
#import "NUCNonDirective.h"

@class NUCPreprocessor;

@implementation NUCGroupPart

+ (BOOL)groupPartFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCPreprocessingDirective **)aGroupPart
{
    NUCPreprocessingDirective *aPreprocessingDirective = nil;
    
    if ([NUCIfSection ifSectionFrom:aStream into:&aPreprocessingDirective])
        ;
    else if ([NUCControlLine controlLineFrom:aStream into:&aPreprocessingDirective])
        ;
    else if ([NUCTextLine textLineFrom:aStream into:&aPreprocessingDirective])
        ;
    else if ([NUCNonDirective hashAndNonDirectiveFrom:aStream into:&aPreprocessingDirective])
        ;
    else
        return NO;
    
    if (aGroupPart)
        *aGroupPart = [NUCGroupPart groupPartWithContent:aPreprocessingDirective];
    
    return YES;
}

+ (instancetype)groupPartWithContent:(NUCPreprocessingDirective *)aContent
{
    return [[[self alloc] initWithContent:aContent] autorelease];
}

- (instancetype)initWithContent:(NUCPreprocessingDirective *)aContent
{
    if (self = [super initWithType:NUCLexicalElementGroupPartType])
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

-(NUCPreprocessingDirective *)content
{
    return content;
}

- (void)preprocessWith:(NUCPreprocessor *)aPreprocesser
{
    [[self content] preprocessWith:aPreprocesser];
}

@end
