//
//  NUDefaultComparator.m
//  Nursery
//
//  Created by Akifumi Takata on 2013/01/26.
//
//

#import <Foundation/NSDate.h>
#import <Foundation/NSValue.h>
#import <Foundation/NSString.h>

#import "NUDefaultComparator.h"
#import "NUCharacter.h"

@implementation NUDefaultComparator

- (NSComparisonResult)compareObject:(id)anObject1 toObject:(id)anObject2
{
    return (NSComparisonResult)[anObject1 compare:anObject2];
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
