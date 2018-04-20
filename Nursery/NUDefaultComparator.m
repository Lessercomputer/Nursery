//
//  NUDefaultComparator.m
//  Nursery
//
//  Created by Akifumi Takata on 2013/01/26.
//
//

#import "NUDefaultComparator.h"
#import "NUCharacter.h"

@implementation NUDefaultComparator

- (NSComparisonResult)compareObject:(id)anObject1 toObject:(id)anObject2
{
    return [anObject1 compare:anObject2];
}

@end

@implementation NUDefaultComparator (Coding)

+ (BOOL)automaticallyEstablishCharacter
{
	return YES;
}

+ (void)defineCharacter:(NUCharacter *)aCharacter on:(NUGarden *)aGarden
{
}

- (void)encodeWithAliaser:(NUAliaser *)anAliaser
{
}

- (id)initWithAliaser:(NUAliaser *)anAliaser
{
    [super init];
        
    return self;
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
