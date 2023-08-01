//
//  NUCDiagnostics.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2023/06/30.
//  Copyright © 2023 Nursery-Framework. All rights reserved.
//

#import "NUCDiagnostics.h"
#import "NUNSArray.h"

@implementation NUCDiagnostics

+ (instancetype)diagnostics
{
    return [[self new] autorelease];
}

- (void)dealloc
{
    [diagnostics release];
    
    [super dealloc];
}

- (void)add:(id)aDiagnostic
{
    [[self diagnostics] addObject:aDiagnostic];
}

- (NSMutableArray *)diagnostics
{
    if (!diagnostics)
        diagnostics = [NSMutableArray new];
    
    return diagnostics;
}

@end
