//
//  NUCharacterDictionary.m
//  Nursery
//
//  Created by Akifumi Takata on 2013/10/05.
//
//

#import "NUCharacterDictionary.h"
#import "NUMutableDictionary.h"
#import "NUCharacter.h"
#import "NUIvar.h"
#import "NUAliaser.h"
#import "NUBell.h"
#import "NUSandbox.h"

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
    [[[self bell] sandbox] markChangedObject:self];
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

+ (void)defineCharacter:(NUCharacter *)aCharacter on:(NUSandbox *)aSandbox
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
    
    [[[[self bell] sandbox] aliaser] moveUp:self ignoreGradeAtCallFor:NO];
    [[self dictionary] moveUp];
    
    if ([[self bell] grade] != aGradeBeforeMoveUp)
        [self mergeWithSandboxCharacters];
}

- (void)mergeWithSandboxCharacters
{
    NUMutableDictionary *aCharactersInSandbox = [[[self bell] sandbox] characters];
    NSDictionary *aNewCharactersInSandbox = [aCharactersInSandbox dictionaryWithValuesForKeys:[[aCharactersInSandbox setKeys] allObjects]];
    
    [aNewCharactersInSandbox enumerateKeysAndObjectsUsingBlock:^(Class aCharacterClass, NUCharacter *aCharacterInSandbox, BOOL *aStop) {
        NUCharacter *aCharacterInSelf = [[self dictionary] objectForKey:[aCharacterInSandbox fullName]];
        
        if (aCharacterInSelf && aCharacterInSelf != aCharacterInSandbox)
        {
            [aCharacterInSelf setCoderClass:[aCharacterInSandbox coderClass]];
            [aCharacterInSelf setTargetClass:[aCharacterInSandbox targetClass]];
            
            [[[self bell] sandbox] setCharacter:aCharacterInSelf forClass:aCharacterClass];
        }
    }];
    
    [aCharactersInSandbox removeAllModificationInfo];
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
