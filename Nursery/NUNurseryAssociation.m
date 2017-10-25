//
//  NUChildminder.m
//  Nursery
//
//  Created by P,T,A on 2013/06/29.
//
//

#import "NUNurseryAssociation.h"


@implementation NUNurseryAssociation

+ (NSString *)associationNameFromURL:(NSURL *)aURL
{
    return [[[[aURL pathComponents] mutableCopy] autorelease] objectAtIndex:1];
}

+ (NSString *)nurseryNameFromURL:(NSURL *)aURL
{
    NSMutableArray *aPath = [[[aURL pathComponents] mutableCopy] autorelease];
    [aPath removeObjectsInRange:NSMakeRange(0, 2)];
    return [NSString pathWithComponents:aPath];
}

+ (NSURL *)associationURLFromNurseryURL:(NSURL *)aURL
{
    NSMutableArray *aPath = [[[aURL pathComponents] mutableCopy] autorelease];
    [aPath removeObjectsInRange:NSMakeRange(2, [aPath count] - 2)];
    return [[[NSURL alloc] initWithScheme:[aURL scheme] host:[aURL host] path:[NSString pathWithComponents:aPath]] autorelease];
}

+ (NSURL *)URLWithHostName:(NSString *)aHostName associationName:(NSString *)anAssociationName nurseryName:(NSString *)aNurseryName
{
    return [[[NSURL alloc] initWithScheme:@"nursery" host:aHostName path:[NSString stringWithFormat:@"/%@/%@", anAssociationName, aNurseryName]] autorelease];
}

- (NSString *)nurseryNameFromURL:(NSURL *)aURL
{
    return [[self class] nurseryNameFromURL:aURL];
}

- (void)dealloc
{
    [lock release];
    
    [super dealloc];
}

@end
