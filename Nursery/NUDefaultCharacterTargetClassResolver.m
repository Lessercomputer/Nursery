//
//  NUDefaultCharacterTargetClassResolver.m
//  Nursery
//
//  Created by Akifumi Takata on 2018/06/12.
//  Copyright © 2018年 Nursery-Framework. All rights reserved.
//

#import <Foundation/NSString.h>

#import "NUDefaultCharacterTargetClassResolver.h"
#import "NUBPlusTree.h"
#import "NUBPlusTreeBranch.h"
#import "NUBPlusTreeLeaf.h"

@implementation NUDefaultCharacterTargetClassResolver

- (BOOL)resolveTargetClassOrCoderForCharacter:(NUCharacter *)aCharacter onGarden:(NUGarden *)aGarden
{
    NSString *aCharacterName = [aCharacter name];
    
    if ([aCharacterName isEqualToString:@"NUBTree"])
    {
        [aCharacter setTargetClass:[NUBPlusTree class]];
        return YES;
    }
    
    if ([aCharacterName isEqualToString:@"NUBTreeBranch"])
    {
        [aCharacter setTargetClass:[NUBPlusTreeBranch class]];
        return YES;
    }
    
    if ([aCharacterName isEqualToString:@"NUBTreeLeaf"])
    {
        [aCharacter setTargetClass:[NUBPlusTreeLeaf class]];
        return YES;
    }
    
    return NO;
}

@end
