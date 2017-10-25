//
//  NUMainBranchNurseryAssociation.m
//  Nursery
//
//  Created by P,T,A on 2013/06/29.
//
//

#import "NUMainBranchNurseryAssociation.h"
#import "NUMainBranchNurseryAssociationEntry.h"
#import "NUMainBranchNursery.h"
#import "NUMainBranchPlayLot.h"
#import "NUPairedMainBranchPlayLot.h"


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

- (NUUInt64)openPlayLotForNurseryWithName:(bycopy NSString *)aName
{
    NUMainBranchNurseryAssociationEntry *anEntry = [self entryForName:aName];
    NUMainBranchNursery *aNursery = (NUMainBranchNursery *)[anEntry nursery];
    NUPairedMainBranchPlayLot *aPlayLot = (NUPairedMainBranchPlayLot *)[aNursery createPairdPlayLot];
    NUUInt64 aBranchPlayLotID = [aNursery newPlayLotID];
    [anEntry setPlayLot:aPlayLot forID:aBranchPlayLotID];
    return aBranchPlayLotID;
}

- (void)closePlayLotWithID:(NUUInt64)anID inNurseryWithName:(bycopy NSString *)aName
{
    NUMainBranchNurseryAssociationEntry *anEntry = [self entryForName:aName];
    NUPairedMainBranchPlayLot *aPlayLot = [anEntry playLotForID:anID];
    [aPlayLot close];
    [anEntry removePlayLotForID:anID];
}

- (NUUInt64)rootOOPForNurseryWithName:(bycopy NSString *)aName playLotWithID:(NUUInt64)anID
{
    NUMainBranchNurseryAssociationEntry *anEntry = [self entryForName:aName];
    return [[[anEntry playLotForID:anID] aliaser] rootOOP];
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

- (NUUInt64)retainLatestGradeByPlayLotWithID:(NUUInt64)anID inNurseryWithName:(bycopy NSString *)aName
{
    NUMainBranchNurseryAssociationEntry *anEntry = [self entryForName:aName];
    return [[anEntry nursery] retainLatestGradeByPlayLot:(NUMainBranchPlayLot *)[anEntry playLotForID:anID]];
}

- (NUUInt64)retainGradeIfValid:(NUUInt64)aGrade byPlayLotWithID:(NUUInt64)anID inNurseryWithName:(bycopy NSString *)aName
{
    NUMainBranchNurseryAssociationEntry *anEntry = [self entryForName:aName];
    return [[anEntry nursery] retainGradeIfValid:aGrade byPlayLot:(NUMainBranchPlayLot *)[anEntry playLotForID:anID]];
}

- (void)retainGrade:(NUUInt64)aGrade byPlayLotWithID:(NUUInt64)anID inNurseryWithName:(bycopy NSString *)aName
{
    NUMainBranchNurseryAssociationEntry *anEntry = [self entryForName:aName];
    [[anEntry nursery] retainGrade:aGrade byPlayLot:(NUMainBranchPlayLot *)[anEntry playLotForID:anID]];
}

- (void)releaseGradeLessThan:(NUUInt64)aGrade byPlayLotWithID:(NUUInt64)anID inNurseryWithName:(bycopy NSString *)aName
{
    NUMainBranchNurseryAssociationEntry *anEntry = [self entryForName:aName];
    [[anEntry nursery] releaseGradeLessThan:aGrade byPlayLot:(NUMainBranchPlayLot *)[anEntry playLotForID:anID]];
}

- (bycopy NSData *)callForPupilWithOOP:(NUUInt64)anOOP gradeLessThanOrEqualTo:(NUUInt64)aGrade playLotWithID:(NUUInt64)anID containsFellowPupils:(BOOL)aContainsFellowPupils inNurseryWithName:(bycopy NSString *)aName
{
    NUMainBranchNurseryAssociationEntry *anEntry = [self entryForName:aName];
    return [[anEntry playLotForID:anID] callForPupilWithOOP:anOOP gradeLessThanOrEqualTo:aGrade containsFellowPupils:aContainsFellowPupils];
}

- (NUFarmOutStatus)farmOutPupils:(bycopy NSData *)aPupilData rootOOP:(NUUInt64)aRootOOP playLotWithID:(NUUInt64)anID inNurseryWithName:(bycopy NSString *)aName fixedOOPs:(bycopy NSData **)aFixedOOPs latestGrade:(NUUInt64 *)aLatestGrade
{
    NUMainBranchNurseryAssociationEntry *anEntry = [self entryForName:aName];
    return [[anEntry playLotForID:anID] farmOutPupils:aPupilData rootOOP:aRootOOP fixedOOPs:aFixedOOPs latestGrade:aLatestGrade];
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
