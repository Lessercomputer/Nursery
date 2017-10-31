//
//  NUNSObject.m
//  Nursery
//
//  Created by Akifumi Takata on 2013/11/17.
//
//

#import "NUNSObject.h"
#import "NUSandbox.h"

@implementation NSObject (NUCharacter)

+ (BOOL)automaticallyEstablishCharacter
{
	return NO;
}

+ (NUCharacter *)characterOn:(NUSandbox *)aSandbox
{
	NUCharacter *anEstablishedCharacter = [aSandbox characterForClass:self];
	
	if (!anEstablishedCharacter)
		anEstablishedCharacter = [self establishCharacterOn:aSandbox];
	
	return anEstablishedCharacter;
}

+ (NUCharacter *)establishCharacterOn:(NUSandbox *)aSandbox
{
	NUCharacter *aCharacter = [self createCharacterOn:aSandbox];
	NUCharacter *anEstablishedCharacter = [aSandbox characterForName:[aCharacter fullName]];
	
	if (anEstablishedCharacter)
	{
		[anEstablishedCharacter setCoderClass:[aCharacter coderClass]];
		[anEstablishedCharacter setTargetClass:[aCharacter targetClass]];
	}
	else
	{
		//[aSandbox setObjectLayout:aCharacter forName:[aCharacter fullName]];
		anEstablishedCharacter = aCharacter;
	}
	
	[aSandbox setCharacter:anEstablishedCharacter forClass:self];
    [[anEstablishedCharacter superCharacter] addSubCharacter:anEstablishedCharacter];
    
	return anEstablishedCharacter;
}

+ (NUCharacter *)createCharacterOn:(NUSandbox *)aSandbox
{
	NUCharacter *aSuper = self == [NSObject class] ? nil : [[[self classForNursery] superclass] characterOn:aSandbox];
	NUCharacter *aCharacter = [NUCharacter characterWithName:[self CharacterNameOn:aSandbox] super:aSuper];
	[aCharacter setTargetClass:self];
    [self defineCharacter:aCharacter on:aSandbox];
    
    if (![aCharacter formatIsValid])
        @throw [NSException exceptionWithName:NUCharacterInvalidObjectFormatException reason:NUCharacterInvalidObjectFormatException userInfo:nil];
    
    [aCharacter basicSize];
    [aCharacter computeIvarOffset];
    [aCharacter indexedIvarOffset];
    
	return aCharacter;
}

+ (void)defineCharacter:(NUCharacter *)aCharacter on:(NUSandbox *)aSandbox
{
    if (self == [NSObject class])
        [aCharacter addOOPIvarWithName:@"isa"];
}

+ (NSString *)CharacterNameOn:(NUSandbox *)aSandbox
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
