//
//  NUCoder.m
//  Nursery
//
//  Created by Akifumi Takata on 11/03/20.
//

#import "NUCoder.h"
#import "NUAliaser.h"
#import "NURegion.h"
#import "NUCharacter.h"

@implementation NUCoder

+ (id)coder
{
	return [[self new] autorelease];
}

- (id)new
{
	return nil;
}

- (void)encode:(id)anObject withAliaser:(NUAliaser *)anAliaser
{
}

- (void)encodeIndexedIvarsOf:(id)anObject withAliaser:(NUAliaser *)anAliaser
{
}

- (void)decode:(id)anObject withAliaser:(NUAliaser *)anAliaser
{
}

- (void)decodeIndexedIvarsOf:(id)anObject withAliaser:(NUAliaser *)anAliaser
{
}

- (id)decodeObjectWithAliaser:(NUAliaser *)anAliaser
{
	return nil;
}

- (BOOL)canMoveUpObject:(id)anObject withAliaser:(NUAliaser *)anAliaser
{
    return NO;
}

- (void)moveUpObject:(id)anObject withAliaser:(NUAliaser *)anAliaser
{
    
}

@end














