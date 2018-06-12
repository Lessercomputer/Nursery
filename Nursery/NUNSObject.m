//
//  NUNSObject.m
//  Nursery
//
//  Created by Akifumi Takata on 2013/11/17.
//
//

#import <Foundation/NSException.h>

#import "NUNSObject.h"
#import "NUGarden.h"
#import "NUGarden+Project.h"

@implementation NSObject (NUCharacter)

+ (NUCharacter *)characterOn:(NUGarden *)aGarden
{
	NUCharacter *anEstablishedCharacter = [aGarden characterForClass:self];
	
	if (!anEstablishedCharacter)
		anEstablishedCharacter = [self establishCharacterOn:aGarden];
	
	return anEstablishedCharacter;
}

+ (NUCharacter *)establishCharacterOn:(NUGarden *)aGarden
{
	NUCharacter *aCharacter = [self createCharacterOn:aGarden];
	NUCharacter *anEstablishedCharacter = [aGarden characterForNameWithVersion:[aCharacter nameWithVersion]];
	
	if (anEstablishedCharacter)
	{
		[anEstablishedCharacter setCoderClass:[aCharacter coderClass]];
		[anEstablishedCharacter setTargetClass:[aCharacter targetClass]];
	}
	else
		anEstablishedCharacter = aCharacter;
	
	[aGarden setCharacter:anEstablishedCharacter forClass:self];
    [[anEstablishedCharacter superCharacter] addSubCharacter:anEstablishedCharacter];
    
	return anEstablishedCharacter;
}

+ (NUCharacter *)createCharacterOn:(NUGarden *)aGarden
{
	NUCharacter *aSuper = self == [NSObject class] ? nil : [[[self classForNursery] superclass] characterOn:aGarden];
	NUCharacter *aCharacter = [NUCharacter characterWithName:[self characterNameOn:aGarden] super:aSuper];
	[aCharacter setTargetClass:self];
    [self defineCharacter:aCharacter on:aGarden];
    
    if (![aCharacter formatIsValid])
        @throw [NSException exceptionWithName:NUCharacterInvalidObjectFormatException reason:NUCharacterInvalidObjectFormatException userInfo:nil];
    
    [aCharacter basicSize];
    [aCharacter computeIvarOffset];
    [aCharacter indexedIvarOffset];
    
	return aCharacter;
}

+ (void)defineCharacter:(NUCharacter *)aCharacter on:(NUGarden *)aGarden
{
    if (self == [NSObject class])
        [aCharacter addOOPIvarWithName:@"isa"];
}

+ (NSString *)characterNameOn:(NUGarden *)aGarden
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
