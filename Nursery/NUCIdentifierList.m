//
//  NUCIdentifierList.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/11.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCIdentifierList.h"

#import <Foundation/NSArray.h>

@implementation NUCIdentifierList

+ (instancetype)identifierList
{
    return [[[self alloc] initWithType:NUCLexicalElementIdentifierListType] autorelease];
}

- (void)dealloc
{
    [identifiers release];
    
    [super dealloc];
}

- (void)add:(NUCLexicalElement *)anIdentifier
{
    [[self identifiers] addObject:anIdentifier];
}

- (NSMutableArray *)identifiers
{
    return identifiers;
}

- (NSUInteger)count
{
    return [[self identifiers] count];
}

@end
