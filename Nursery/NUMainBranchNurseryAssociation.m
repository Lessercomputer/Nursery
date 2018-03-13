//
//  NUMainBranchNurseryAssociation.m
//  Nursery
//
//  Created by Akifumi Takata on 2013/06/29.
//
//

#import "NUMainBranchNurseryAssociation.h"
#import "NUMainBranchNurseryAssociationEntry.h"
#import "NUMainBranchNursery.h"
#import "NUMainBranchSandbox.h"
#import "NUPairedMainBranchSandbox.h"
#import "NUXPCListenerEndpointServer.h"

static NSRecursiveLock *classLock;
static NUMainBranchNurseryAssociation *defaultAssociation;

NSString *NUDefaultMainBranchAssociation = @"NUDefaultMainBranchAssociation";
NSString *NUMainBranchNurseryAssociationServiceType = @"_numainbranchnurseryassociation._tcp.";

@interface NUMainBranchNurseryAssociation (Private)

- (NUMainBranchNurseryAssociationEntry *)entryForName:(NSString *)aName;

@end

@implementation NUMainBranchNurseryAssociation

+ (void)initialize
{
    classLock = [NSRecursiveLock new];
}

+ (id)defaultAssociation
{
    @try {
        [classLock lock];
        
        if (!defaultAssociation)
        {
            defaultAssociation = [[[self class] alloc] initWithName:@"NUDefaultMainBranchAssociation"];
            [defaultAssociation open];
        }
        
        return defaultAssociation;
    }
    @finally {
        [classLock unlock];
    }
}

+ (id)associationWithName:(NSString *)aName
{
    return [[[self alloc] initWithName:aName] autorelease];
}

- (id)initWithName:(NSString *)aName
{
    if (self = [super init])
    {
        lock = [NSRecursiveLock new];
        name = [aName copy];
        nurseries = [NSMutableDictionary new];
    }
    
    return self;
}

- (NSString *)name
{
    return name;
}

- (void)dealloc
{
    [name release];
    [netService setDelegate:nil];
    [netService release];
    [nurseries release];

    [super dealloc];
}

- (void)open
{
    NSThread *aThread = [[NSThread alloc] initWithTarget:self selector:@selector(startNetServiceInNewThreadWith:) object:nil];
    [aThread setName:@"NUMainBranchNurseryAssociation NetService Thread"];
    [aThread start];
}

- (void)startNetServiceInNewThreadWith:(id)anObject
{
    netService = [[NSNetService alloc] initWithDomain:@"" type:NUMainBranchNurseryAssociationServiceType name:name port:0];
    [netService setDelegate:self];
    
    [netService publishWithOptions:NSNetServiceListenForConnections];

    while (YES)
    {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
    }
}

- (void)netServiceDidPublish:(NSNetService *)sender
{
    NSLog(@"%@", sender);
    
}

- (void)netService:(NSNetService *)sender didNotPublish:(NSDictionary<NSString *,NSNumber *> *)errorDict
{
    NSLog(@"%@", errorDict);
}

- (void)netService:(NSNetService *)sender didAcceptConnectionWithInputStream:(NSInputStream *)anInputStream outputStream:(NSOutputStream *)anOutputStream
{
    NSLog(@"%@", sender);
    
}

- (void)close
{
    [nurseries enumerateKeysAndObjectsUsingBlock:^(id key, NUMainBranchNurseryAssociationEntry *anEntry, BOOL *stop) {
        [anEntry close];
    }];
    
    [netService stop];
}

- (void)setNursery:(NUMainBranchNursery *)aNursery forName:(NSString *)aName
{
    @try {
        [lock lock];
        
        [nurseries setObject:[NUMainBranchNurseryAssociationEntry entryWithName:aName nursery:aNursery] forKey:aName];
    }
    @finally {
        [lock unlock];
    }
}

- (void)removeNurseryForName:(NSString *)aName
{
    @try {
        [lock lock];
        
        [nurseries removeObjectForKey:aName];
    }
    @finally {
        [lock unlock];
    }
}

- (void)openSandboxForNurseryWithName:(NSString *)aName completionHandler:(void (^)(NUUInt64 aBranchSandboxID))aHandler
{
    NSLog(@"In openSandboxForNurseryWithName:");
    NUMainBranchNurseryAssociationEntry *anEntry = [self entryForName:aName];
    NUMainBranchNursery *aNursery = (NUMainBranchNursery *)[anEntry nursery];
    NUPairedMainBranchSandbox *aSandbox = (NUPairedMainBranchSandbox *)[aNursery createPairdSandbox];
    NUUInt64 aBranchSandboxID = [aNursery newSandboxID];
    [anEntry setSandbox:aSandbox forID:aBranchSandboxID];
    aHandler(aBranchSandboxID);
}

- (void)closeSandboxWithID:(NUUInt64)anID inNurseryWithName:(NSString *)aName
{
    NUMainBranchNurseryAssociationEntry *anEntry = [self entryForName:aName];
    NUPairedMainBranchSandbox *aSandbox = [anEntry sandboxForID:anID];
    [aSandbox close];
    [anEntry removeSandboxForID:anID];
}

- (void)rootOOPForNurseryWithName:(NSString *)aName sandboxWithID:(NUUInt64)anID completionHandler:(void (^)(NUUInt64 aLatestGrade))aHandler
{
    NUMainBranchNurseryAssociationEntry *anEntry = [self entryForName:aName];
    aHandler([[[anEntry sandboxForID:anID] aliaser] rootOOP]);
}

- (void)latestGradeForNurseryWithName:(NSString *)aName completionHandler:(void (^)(NUUInt64 aLatestGrade))aHandler
{
    aHandler([[[self entryForName:aName] nursery] latestGrade:nil]);
}

- (void)olderRetainedGradeForNurseryWithName:(NSString *)aName completionHandler:(void (^)(NUUInt64 anOlderRetaindGrade))aHandler
{
    NUMainBranchNurseryAssociationEntry *anEntry = [self entryForName:aName];
    aHandler([[anEntry nursery] olderRetainedGrade:nil]);
}

- (void)retainLatestGradeBySandboxWithID:(NUUInt64)anID inNurseryWithName:(NSString *)aName completionHandler:(void (^)(NUUInt64 aLatestGrade))aHandler
{
    NUMainBranchNurseryAssociationEntry *anEntry = [self entryForName:aName];
    aHandler([[anEntry nursery] retainLatestGradeBySandbox:(NUMainBranchSandbox *)[anEntry sandboxForID:anID]]);
}

- (NUUInt64)retainGradeIfValid:(NUUInt64)aGrade bySandboxWithID:(NUUInt64)anID inNurseryWithName:(bycopy NSString *)aName
{
    NUMainBranchNurseryAssociationEntry *anEntry = [self entryForName:aName];
    return [[anEntry nursery] retainGradeIfValid:aGrade bySandbox:(NUMainBranchSandbox *)[anEntry sandboxForID:anID]];
}

- (void)retainGrade:(NUUInt64)aGrade bySandboxWithID:(NUUInt64)anID inNurseryWithName:(NSString *)aName
{
    NUMainBranchNurseryAssociationEntry *anEntry = [self entryForName:aName];
    [[anEntry nursery] retainGrade:aGrade bySandbox:(NUMainBranchSandbox *)[anEntry sandboxForID:anID]];
}

- (void)releaseGradeLessThan:(NUUInt64)aGrade bySandboxWithID:(NUUInt64)anID inNurseryWithName:(NSString *)aName
{
    NUMainBranchNurseryAssociationEntry *anEntry = [self entryForName:aName];
    [[anEntry nursery] releaseGradeLessThan:aGrade bySandbox:(NUMainBranchSandbox *)[anEntry sandboxForID:anID]];
}

- (void)callForPupilWithOOP:(NUUInt64)anOOP gradeLessThanOrEqualTo:(NUUInt64)aGrade sandboxWithID:(NUUInt64)anID containsFellowPupils:(BOOL)aContainsFellowPupils inNurseryWithName:(NSString *)aName completionHandler:(void (^)(NSData *aPupilNotesData))aHandler
{
    NUMainBranchNurseryAssociationEntry *anEntry = [self entryForName:aName];
    aHandler([[anEntry sandboxForID:anID] callForPupilWithOOP:anOOP gradeLessThanOrEqualTo:aGrade containsFellowPupils:aContainsFellowPupils]);
}

- (void)farmOutPupils:(NSData *)aPupilData rootOOP:(NUUInt64)aRootOOP sandboxWithID:(NUUInt64)anID inNurseryWithName:(NSString *)aName  completionHandler:(void (^)(NUFarmOutStatus aFarmOutStatus, NSData *aFixedOOPs, NUUInt64 aLatestGrade))aHandler
{
//    [aPupilData writeToFile:[@"~/Desktop/NUMainBranchNurseryAssociation_encodedObjects" stringByExpandingTildeInPath] atomically:YES];
    NUMainBranchNurseryAssociationEntry *anEntry = [self entryForName:aName];
    NSData *aFixedOOPs;
    NUUInt64 aLatestGrade;
    NUFarmOutStatus aFarmOutStatus = [[anEntry sandboxForID:anID] farmOutPupils:aPupilData rootOOP:aRootOOP fixedOOPs:&aFixedOOPs latestGrade:&aLatestGrade];
    aHandler(aFarmOutStatus, aFixedOOPs, aLatestGrade);
}

@end

@implementation NUMainBranchNurseryAssociation (Private)

- (NUMainBranchNurseryAssociationEntry *)entryForName:(NSString *)aName
{
    @try {
        [lock lock];
        return [nurseries objectForKey:aName];
    }
    @finally {
        [lock unlock];
    }
}

@end
