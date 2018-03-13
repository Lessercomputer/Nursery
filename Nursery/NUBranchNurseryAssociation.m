//
//  NUBranchChildminder.m
//  Nursery
//
//  Created by Akifumi Takata on 2013/06/29.
//
//

#import "NUBranchNurseryAssociation.h"
#import "NUBranchNursery.h"
#import "NUBranchSandbox.h"
#import "NUBranchNurseryAssociationEntry.h"
#import "NUMainBranchNurseryAssociationProtocol.h"
#import "NUXPCListenerEndpointServer.h"

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

- (NUMainBranchNurseryAssociation *)mainBranchAssociationForSandbox:(NUBranchSandbox *)aSandbox
{
    @try {
        [lock lock];
        
        NSURL *aNurseryURL = [(NUBranchNursery *)[aSandbox nursery] URL];
        NSURL *anAssociationURL = [[self class] associationURLFromNurseryURL:aNurseryURL];
        NUBranchNurseryAssociationEntry *anEntry = [self entryForURL:anAssociationURL];
        NSNumber *aThreadID = [self ensureBranchNurseryAssociationThreadID];
        NUMainBranchNurseryAssociation *anAssociation = nil;
        //NSConnection *aConnection = [[anEntry connections] objectForKey:aThreadID];
        NSXPCConnection *aConnection = [[anEntry connections] objectForKey:aThreadID];
        
        if (!aConnection)
        {
            NSString *anAssociationName = [[self class] associationNameFromURL:anAssociationURL];
            id aRootProxy = nil;

//            aConnection = [NSConnection connectionWithRegisteredName:anAssociationName host:[aNurseryURL host]];
//            aConnection = [NSConnection connectionWithRegisteredName:anAssociationName host:[aNurseryURL host] usingNameServer:[NSSocketPortNameServer sharedInstance]];
            //NSSocketPort *aPort = (NSSocketPort *)[[NSSocketPortNameServer sharedInstance] portForName:anAssociationName host:[aNurseryURL host]];
//            aConnection = [NSConnection connectionWithReceivePort:nil sendPort:aPort];
//            aRootProxy = [aConnection rootProxy];
//            [aRootProxy setProtocolForProxy:@protocol(NUMainBranchNurseryAssociation)];
            //aConnection = [[[NSXPCConnection alloc] initWithMachServiceName:anAssociationName options:NSXPCConnectionPrivileged] autorelease];
            NSXPCListenerEndpoint *anEndpoint = [[NUXPCListenerEndpointServer sharedInstance] endpointForName:anAssociationName];
            aConnection = [[[NSXPCConnection alloc] initWithListenerEndpoint:anEndpoint] autorelease];
            [aConnection setRemoteObjectInterface:[NSXPCInterface interfaceWithProtocol:@protocol(NUMainBranchNurseryAssociation)]];
            [aConnection resume];
            aRootProxy = [aConnection remoteObjectProxy];
            [[anEntry connections] setObject:aConnection forKey:aThreadID];
            anAssociation = (NUMainBranchNurseryAssociation *)aRootProxy;
        }
        else
            anAssociation = (NUMainBranchNurseryAssociation *)[aConnection remoteObjectProxy];
        
        if ([aSandbox ID] == NUNilSandboxID)
        {
//            [aSandbox setID:[anAssociation openSandboxForNurseryWithName:[[self class] nurseryNameFromURL:aNurseryURL]]];
            __block BOOL aCompletion = NO;
            NSCondition *aCondition = [[NSCondition new] autorelease];
            [aCondition lock];
            
            [anAssociation openSandboxForNurseryWithName:[[self class] nurseryNameFromURL:aNurseryURL] completionHandler:^(NUUInt64 anID){
                [aCondition lock];
                
                NSLog(@"in remove");
                [aSandbox setID:anID];
                aCompletion = YES;
                
                [aCondition signal];
                [aCondition unlock];
            }];
            
            while (!aCompletion)
                [aCondition wait];
            
            [aCondition unlock];
        }

        return anAssociation;
    }
    @finally {
        [lock unlock];
    }
}


@end
