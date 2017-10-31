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


static NSRecursiveLock *classLock;
static NUMainBranchNurseryAssociation *defaultAssociation;

NSString *NUDefaultMainBranchAssociation = @"NUDefaultMainBranchAssociation";

@interface NUMainBranchNurseryAssociation (Private)

- (void)prepareConnection;

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
    [connection invalidate];
    [connection setDelegate:nil];
    [connection release];
    [nurseries release];

    [super dealloc];
}

- (void)open
{
    [self prepareConnection];
}

- (void)close
{
    [nurseries enumerateKeysAndObjectsUsingBlock:^(id key, NUMainBranchNurseryAssociationEntry *anEntry, BOOL *stop) {
        [anEntry close];
    }];
    [[NSSocketPortNameServer sharedInstance] removePortForName:name];
    [connection invalidate];
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

- (BOOL)makeNewConnection:(NSConnection *)conn sender:(NSConnection *)ancestor
{
    [conn removeRunLoop:[NSRunLoop currentRunLoop]];
    [conn runInNewThread];
    return YES;
}

- (NUUInt64)openSandboxForNurseryWithName:(bycopy NSString *)aName
{
    NUMainBranchNurseryAssociationEntry *anEntry = [self entryForName:aName];
    NUMainBranchNursery *aNursery = (NUMainBranchNursery *)[anEntry nursery];
    NUPairedMainBranchSandbox *aSandbox = (NUPairedMainBranchSandbox *)[aNursery createPairdSandbox];
    NUUInt64 aBranchSandboxID = [aNursery newSandboxID];
    [anEntry setSandbox:aSandbox forID:aBranchSandboxID];
    return aBranchSandboxID;
}

- (void)closeSandboxWithID:(NUUInt64)anID inNurseryWithName:(bycopy NSString *)aName
{
    NUMainBranchNurseryAssociationEntry *anEntry = [self entryForName:aName];
    NUPairedMainBranchSandbox *aSandbox = [anEntry sandboxForID:anID];
    [aSandbox close];
    [anEntry removeSandboxForID:anID];
}

- (NUUInt64)rootOOPForNurseryWithName:(bycopy NSString *)aName sandboxWithID:(NUUInt64)anID
{
    NUMainBranchNurseryAssociationEntry *anEntry = [self entryForName:aName];
    return [[[anEntry sandboxForID:anID] aliaser] rootOOP];
}

- (NUUInt64)latestGradeForNurseryWithName:(bycopy NSString *)aName
{
    return [[[self entryForName:aName] nursery] latestGrade:nil];
}

- (NUUInt64)olderRetainedGradeForNurseryWithName:(bycopy NSString *)aName
{
    NUMainBranchNurseryAssociationEntry *anEntry = [self entryForName:aName];
    return [[anEntry nursery] olderRetainedGrade:nil];
}

- (NUUInt64)retainLatestGradeBySandboxWithID:(NUUInt64)anID inNurseryWithName:(bycopy NSString *)aName
{
    NUMainBranchNurseryAssociationEntry *anEntry = [self entryForName:aName];
    return [[anEntry nursery] retainLatestGradeBySandbox:(NUMainBranchSandbox *)[anEntry sandboxForID:anID]];
}

- (NUUInt64)retainGradeIfValid:(NUUInt64)aGrade bySandboxWithID:(NUUInt64)anID inNurseryWithName:(bycopy NSString *)aName
{
    NUMainBranchNurseryAssociationEntry *anEntry = [self entryForName:aName];
    return [[anEntry nursery] retainGradeIfValid:aGrade bySandbox:(NUMainBranchSandbox *)[anEntry sandboxForID:anID]];
}

- (void)retainGrade:(NUUInt64)aGrade bySandboxWithID:(NUUInt64)anID inNurseryWithName:(bycopy NSString *)aName
{
    NUMainBranchNurseryAssociationEntry *anEntry = [self entryForName:aName];
    [[anEntry nursery] retainGrade:aGrade bySandbox:(NUMainBranchSandbox *)[anEntry sandboxForID:anID]];
}

- (void)releaseGradeLessThan:(NUUInt64)aGrade bySandboxWithID:(NUUInt64)anID inNurseryWithName:(bycopy NSString *)aName
{
    NUMainBranchNurseryAssociationEntry *anEntry = [self entryForName:aName];
    [[anEntry nursery] releaseGradeLessThan:aGrade bySandbox:(NUMainBranchSandbox *)[anEntry sandboxForID:anID]];
}

- (bycopy NSData *)callForPupilWithOOP:(NUUInt64)anOOP gradeLessThanOrEqualTo:(NUUInt64)aGrade sandboxWithID:(NUUInt64)anID containsFellowPupils:(BOOL)aContainsFellowPupils inNurseryWithName:(bycopy NSString *)aName
{
    NUMainBranchNurseryAssociationEntry *anEntry = [self entryForName:aName];
    return [[anEntry sandboxForID:anID] callForPupilWithOOP:anOOP gradeLessThanOrEqualTo:aGrade containsFellowPupils:aContainsFellowPupils];
}

- (NUFarmOutStatus)farmOutPupils:(bycopy NSData *)aPupilData rootOOP:(NUUInt64)aRootOOP sandboxWithID:(NUUInt64)anID inNurseryWithName:(bycopy NSString *)aName fixedOOPs:(bycopy NSData **)aFixedOOPs latestGrade:(NUUInt64 *)aLatestGrade
{
    NUMainBranchNurseryAssociationEntry *anEntry = [self entryForName:aName];
    return [[anEntry sandboxForID:anID] farmOutPupils:aPupilData rootOOP:aRootOOP fixedOOPs:aFixedOOPs latestGrade:aLatestGrade];
}

@end

@implementation NUMainBranchNurseryAssociation (Private)

- (void)prepareConnection
{
//    connection = [[NSConnection serviceConnectionWithName:name rootObject:self] retain];
    
    NSSocketPort *aPort = [[[NSSocketPort alloc] init] autorelease];
    connection = [[NSConnection connectionWithReceivePort:aPort sendPort:nil] retain];
    if (![[NSSocketPortNameServer sharedInstance] registerPort:aPort name:name])
        @throw [NSException exceptionWithName:NSGenericException reason:NSGenericException userInfo:nil];
    
//    [connection setIndependentConversationQueueing:YES];
    [connection setRootObject:self];
    [connection setDelegate:self];
}

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
