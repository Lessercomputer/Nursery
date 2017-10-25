//
//  NUNurseryRoot.m
//  Nursery
//
//  Created by P,T,A on 11/07/14.
//  Copyright 2011 Nursery-Framework. All rights reserved.
//

#import "NUNurseryRoot.h"
#import "NUCoding.h"
#import "NUBell.h"
#import "NUCharacter.h"
#import "NUAliaser.h"
#import "NUTypes.h"
#import "NUIvar.h"
#import "NUPlayLot.h"
#import "NUCharacterDictionary.h"

@implementation NUNurseryRoot

+ (id)root
{
	return [[[self alloc] init] autorelease];
}

- (id)init
{
	if (self = [super init])
    {
        [self setCharacters:[NUCharacterDictionary dictionary]];
	}
    
	return self;
}

- (void)dealloc
{
    [userRoot release];
    userRoot = nil;
    [characters release];
    characters = nil;
    
	[super dealloc];
}

+ (void)defineCharacter:(NUCharacter *)aCharacter on:(NUPlayLot *)aPlayLot
{
    [aCharacter addOOPIvarWithName:@"characters"];
    [aCharacter addOOPIvarWithName:@"userRoot"];
}

- (void)encodeWithAliaser:(NUAliaser *)anAliaser
{
	[anAliaser encodeObject:characters];
	[anAliaser encodeObject:userRoot];
}

- (id)initWithAliaser:(NUAliaser *)anAliaser
{
    [self decodeIvarsWithAliaser:anAliaser];
    
	return self;
}

- (void)moveUpWithAliaser:(NUAliaser *)anAliaser
{
    [self decodeIvarsWithAliaser:anAliaser];
}

- (void)decodeIvarsWithAliaser:(NUAliaser *)anAliaser
{
    NUSetIvar(&characters, [anAliaser decodeObjectReally]);
    NUSetIvar(&userRoot, [anAliaser decodeObject]);
}

- (NUBell *)bell
{
	return bell;
}

- (void)setBell:(NUBell *)aBell
{
	bell = aBell;
}

@end

@implementation NUNurseryRoot (Accessing)

- (id)userRoot
{
	return NUGetIvar(&userRoot);
}

- (void)setUserRoot:(id)aRoot
{
    NUSetIvar(&userRoot, aRoot);
    [[[self bell] playLot] markChangedObject:self];
}

- (NUCharacterDictionary *)characters
{
	return NUGetIvar(&characters);
}

- (void)setCharacters:(NUCharacterDictionary *)aCharacters
{
    NUSetIvar(&characters, aCharacters);
}

@end

@implementation NUNurseryRoot (MoveUp)

- (void)moveUp
{
    [[[[self bell] playLot] aliaser] moveUp:self];
    [self moveUpCharacters];
}

- (void)moveUpCharacters
{
    [[self characters] moveUp];
}

@end
