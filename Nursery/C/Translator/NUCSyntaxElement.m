//
//  NUCSyntaxElement.m
//  Nursery
//
//  Created by akiha on 2025/02/19.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUCSyntaxElement.h"

@implementation NUCSyntaxElement

- (void)mapTo:(NUCTranslationOrderMap *)aMap
{
    [self mapTo:aMap parent:nil];
}

- (void)mapTo:(NUCTranslationOrderMap *)aMap parent:(id)aParent
{
    [self mapTo:aMap parent:aParent depth:0];
}

- (void)mapTo:(NUCTranslationOrderMap *)aMap parent:(id)aParent depth:(NUUInt64)aDepth
{
    
}

@end
