//
//  NUBranchChildminder.m
//  Nursery
//
//  Created by P,T,A on 2013/06/29.
//
//

#import "NUBranchNurseryAssociation.h"
#import "NUBranchNursery.h"
#import "NUBranchPlayLot.h"
#import "NUBranchNurseryAssociationEntry.h"

NSString *NUBranchNurseryAssociationThreadID = @"NUBranchNurseryAssociationThreadID";

static NSRecursiveLock *classLock;
static NUUInt64 nextBranchNurseryAssociationThreadID = 0;

@implementation NUBranchNurseryAssociation

+ (void)initialize
{
    classLock = [NSRecursiveLock new];
}

+ (id)association
{
    return [[[self alloc] init] autorelease];
}

- (id)init
{
    if (self = [super init])
    {
        entries = [NSMutableDictionary new];
    }
    
    return self;
}

- (void)dealloc
{
    [entries release];
    
    [super dealloc];
}

- (NUBranchNursery *)nurseryForURL:(NSURL *)aURL
{
    @try {
        [lock lock];
        
        NSURL *anAssociationURL = [[self class] associationURLFromNurseryURL:aURL];
        NUBranchNurseryAssociationEntry *anEntry = [self entryForURL:anAssociationURL];
        NUBranchNursery *aNursery = nil;
        
        if (!anEntry)
        {
            anEntry = [NUBranchNurseryAssociationEntry entryWithURL:anAssociationURL];
            [entries setObject:anEntry forKey:anAssociationURL];
        }

        aNursery = [anEntry nurseryForURL:aURL];
        
        if (!aNursery)
        {
            [self ensureBranchNurseryAssociationThreadID];
            
            aNursery = [[[NUBranchNursery alloc] initWithURL:aURL association:self] autorelease];
            [anEntry setNursery:aNursery forURL:aURL];
        }
            
        return aNursery;
    }
    @finally {
        [lock unlock];
    }
}

- (void)close
{
    [entries enumerateKeysAndObjectsUsingBlock:^(id key, NUBranchNurseryAssociationEntry *anEntry, BOOL *stop) {
        [anEntry close];
    }];
}

@end

@implementation NUBranchNurseryAssociation (Private)

- (NUBranchNurseryAssociationEntry *)entryForURL:(NSURL *)aURL
{
    @try {
        [lock lock];
        return [entries objectForKey:aURL];
    }
    @finally {
        [lock unlock];
    }
}

- (NSNumber *)ensureBranchNurseryAssociationThreadID
{
    NSThread *aCurrentThread = [NSThread currentThread];
    NSNumber *aThreadID = [[aCurrentThread threadDictionary] objectForKey:NUBranchNurseryAssociationThreadID];
    
    if (!aThreadID)
    {
        @try {
            [classLock lock];
            aThreadID = @(nextBranchNurseryAssociationThreadID++);
        }
        @finally {
            [classLock unlock];
        }
        
        [[aCurrentThread threadDictionary] setObject:aThreadID forKey:NUBranchNurseryAssociationThreadID];
    }

    return aThreadID;
}

- (id<NUMainBranchNurseryAssociation>)mainBranchAssociationForPlayLot:(NUBranchPlayLot *)aPlayLot
{
    @try {
        [lock lock];
        
        NSURL *aNurseryURL = [(NUBranchNursery *)[aPlayLot nursery] URL];
        NSURL *anAssociationURL = [[self class] associationURLFromNurseryURL:aNurseryURL];
        NUBranchNurseryAssociationEntry *anEntry = [self entryForURL:anAssociationURL];
        NSNumber *aThreadID = [self ensureBranchNurseryAssociationThreadID];
        id <NUMainBranchNurseryAssociation> anAssociation = nil;
        NSConnection *aConnection = [[anEntry connections] objectForKey:aThreadID];
        
        if (!aConnection)
        {
            NSString *anAssociationName = [[self class] associationNameFromURL:anAssociationURL];
            id aRootProxy = nil;

//            aConnection = [NSConnection connectionWithRegisteredName:anAssociationName host:[aNurseryURL host]];
//            aConnection = [NSConnection connectionWithRegisteredName:anAssociationName host:[aNurseryURL host] usingNameServer:[NSSocketPortNameServer sharedInstance]];
            NSSocketPort *aPort = (NSSocketPort *)[[NSSocketPortNameServer sharedInstance] portForName:anAssociationName host:[aNurseryURL host]];
            aConnection = [NSConnection connectionWithReceivePort:nil sendPort:aPort];
            aRootProxy = [aConnection rootProxy];
            [aRootProxy setProtocolForProxy:@protocol(NUMainBranchNurseryAssociation)];
            [[anEntry connections] setObject:aConnection forKey:aThreadID];
            anAssociation = (id <NUMainBranchNurseryAssociation>)aRootProxy;
        }
        else
            anAssociation = (id<NUMainBranchNurseryAssociation>)[aConnection rootProxy];
        
        if ([aPlayLot ID] == NUNilPlayLotID)
            [aPlayLot setID:[anAssociation openPlayLotForNurseryWithName:[[self class] nurseryNameFromURL:aNurseryURL]]];

        return anAssociation;
    }
    @finally {
        [lock unlock];
    }
}


@end