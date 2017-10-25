//
//  NUNSObject.m
//  Nursery
//
//  Created by P,T,A on 2013/11/17.
//
//

#import "NUNSObject.h"
#import "NUPlayLot.h"

@implementation NSObject (NUCharacter)

+ (BOOL)automaticallyEstablishCharacter
{
	return NO;
}

+ (NUCharacter *)characterOn:(NUPlayLot *)aPlayLot
{
	NUCharacter *anEstablishedCharacter = [aPlayLot characterForClass:self];
	
	if (!anEstablishedCharacter)
		anEstablishedCharacter = [self establishCharacterOn:aPlayLot];
	
	return anEstablishedCharacter;
}

+ (NUCharacter *)establishCharacterOn:(NUPlayLot *)aPlayLot
{
	NUCharacter *aCharacter = [self createCharacterOn:aPlayLot];
	NUCharacter *anEstablishedCharacter = [aPlayLot characterForName:[aCharacter fullName]];
	
	if (anEstablishedCharacter)
	{
		[anEstablishedCharacter setCoderClass:[aCharacter coderClass]];
		[anEstablishedCharacter setTargetClass:[aCharacter targetClass]];
	}
	else
	{
		//[aPlayLot setObjectLayout:aCharacter forName:[aCharacter fullName]];
		anEstablishedCharacter = aCharacter;
	}
	
	[aPlayLot setCharacter:anEstablishedCharacter forClass:self];
    [[anEstablishedCharacter superCharacter] addSubCharacter:anEstablishedCharacter];
    
	return anEstablishedCharacter;
}

+ (NUCharacter *)createCharacterOn:(NUPlayLot *)aPlayLot
{
	NUCharacter *aSuper = self == [NSObject class] ? nil : [[[self classForNursery] superclass] characterOn:aPlayLot];
	NUCharacter *aCharacter = [NUCharacter characterWithName:[self CharacterNameOn:aPlayLot] super:aSuper];
	[aCharacter setTargetClass:self];
    [self defineCharacter:aCharacter on:aPlayLot];
    
    if (![aCharacter formatIsValid])
        @throw [NSException exceptionWithName:NUCharacterInvalidObjectFormatException reason:NUCharacterInvalidObjectFormatException userInfo:nil];
    
    [aCharacter basicSize];
    [aCharacter computeIvarOffset];
    [aCharacter indexedIvarOffset];
    
	return aCharacter;
}

+ (void)defineCharacter:(NUCharacter *)aCharacter on:(NUPlayLot *)aPlayLot
{
    if (self == [NSObject class])
        [aCharacter addOOPIvarWithName:@"isa"];
}

+ (NSString *)CharacterNameOn:(NUPlayLot *)aPlayLot
{
	Class aClass = [self classForNursery];
    
	return NSStringFromClass(aClass);
}

+ (Class)classForNursery
{
	return self;
}

- (Class)classForNursery
{
	return [self classForCoder];
}

@end
