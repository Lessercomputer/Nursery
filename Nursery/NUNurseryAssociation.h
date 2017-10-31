//
//  NUNurseryAssociation.h
//  Nursery
//
//  Created by Akifumi Takata on 2013/06/29.
//
//

@interface NUNurseryAssociation : NSObject
{
    NSRecursiveLock *lock;
}

+ (NSString *)associationNameFromURL:(NSURL *)aURL;
+ (NSString *)nurseryNameFromURL:(NSURL *)aURL;

+ (NSURL *)associationURLFromNurseryURL:(NSURL *)aURL;

+ (NSURL *)URLWithHostName:(NSString *)aHostName associationName:(NSString *)anAssociationName nurseryName:(NSString *)aNurseryName;

- (NSString *)nurseryNameFromURL:(NSURL *)aURL;


@end
