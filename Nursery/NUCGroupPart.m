//
//  NUCGroupPart.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2023/03/05.
//  Copyright © 2023 Nursery-Framework. All rights reserved.
//

#import "NUCGroupPart.h"

@implementation NUCGroupPart

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

@end
