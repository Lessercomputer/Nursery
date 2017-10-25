//
//  NUCharacterDictionary.m
//  Nursery
//
//  Created by P,T,A on 2013/10/05.
//
//

#import "NUCharacterDictionary.h"
#import "NUMutableDictionary.h"
#import "NUCharacter.h"
#import "NUIvar.h"
#import "NUAliaser.h"
#import "NUBell.h"
#import "NUPlayLot.h"

@implementation NUCharacterDictionary

+ (id)dictionary
{
    return [[[self alloc] init] autorelease];
}

- (id)init
{
    if (self = [super init])
    {
        dictionary = [NUMutableDictionary new];
    }
    
    return self;
}

- (void)dealloc
{
    [dictionary release];
    
    [super dealloc];
}

- (NSUInteger)count
{
    return [[self dictionary] count];
}

- (id)objectForKey:(id)aKey
{
    return [[self dictionary] objectForKey:aKey];
}

- (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey
{
    NUCharacter *aCharacter = anObject;
    
    [[self dictionary] setObject:anObject forKey:aKey];
    [[aCharacter superCharacter] addSubCharacter:aCharacter];
    [[[self bell] playLot] markChangedObject:self];
}

- (NSEnumerator *)keyEnumerator
{
    return [[self dictionary] keyEnumerator];
}

- (NUBell *)bell
{
	return bell;
}

- (void)setBell:(NUBell *)aBell
{
	bell = aBell;
}

+ (void)defineCharacter:(NUCharacter *)aCharacter on:(NUPlayLot *)aPlayLot
{
    [aCharacter addOOPIvarWithName:@"dictionary"];
}

- (void)encodeWithAliaser:(NUAliaser *)anAliaser
{
	[anAliaser encodeObject:dictionary];
}

- (id)initWithAliaser:(NUAliaser *)anAliaser
{
    NUSetIvar(&dictionary, [anAliaser decodeObjectReally]);
	
	return self;
}

- (void)moveUpWithAliaser:(NUAliaser *)anAliaser
{
    
}

- (void)moveUp
{
    NUUInt64 aGradeBeforeMoveUp = [[self bell] grade];
    
    [[[[self bell] playLot] aliaser] moveUp:self];
    [[self dictionary] moveUp];
    
    if ([[self bell] grade] != aGradeBeforeMoveUp)
        [self mergeWithPlayLotCharacters];
}

- (void)mergeWithPlayLotCharacters
{
    NUMutableDictionary *aCharactersInPlayLot = [[[self bell] playLot] characters];
    NSDictionary *aNewCharactersInPlayLot = [aCharactersInPlayLot dictionaryWithValuesForKeys:[[aCharactersInPlayLot setKeys] allObjects]];
    
    [aNewCharactersInPlayLot enumerateKeysAndObjectsUsingBlock:^(Class aCharacterClass, NUCharacter *aCharacterInPlayLot, BOOL *aStop) {
        NUCharacter *aCharacterInSelf = [[self dictionary] objectForKey:[aCharacterInPlayLot fullName]];
        
        if (aCharacterInSelf && aCharacterInSelf != aCharacterInPlayLot)
        {
            [aCharacterInSelf setCoderClass:[aCharacterInPlayLot coderClass]];
            [aCharacterInSelf setTargetClass:[aCharacterInPlayLot targetClass]];
            
            [[[self bell] playLot] setCharacter:aCharacterInSelf forClass:aCharacterClass];
        }
    }];
    
    [aCharactersInPlayLot removeAllModificationInfo];
}

@end

@implementation NUCharacterDictionary (Private)

- (NUMutableDictionary *)dictionary
{
    return dictionary;
}

- (void)setDictionary:(NUMutableDictionary *)aDictionary
{
    [dictionary autorelease];
    dictionary = [aDictionary retain];
}

@end