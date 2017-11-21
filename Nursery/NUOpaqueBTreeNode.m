//
//  NUOpaqueBTreeNode.m
//  Nursery
//
//  Created by Akifumi Takata on 10/09/09.
//  Copyright 2010 Nursery-Framework. All rights reserved.
//

#import "NUOpaqueBTreeNode.h"
#import "NUOpaqueBTree.h"
#import "NUSpaces.h"
#import "NUPages.h"
#import "NUPage.h"
#import "NUObjectTable.h"
#import "NUIndexArray.h"
#import "NUOpaqueBTreeBranch.h"

const NUUInt32 NUOpaqueBTreeNodeOOPOffset = 0;
const NUUInt32 NUOpaqueBTreeNodeLeftNodeLocationOffset = 8;
const NUUInt32 NUOpaqueBTreeNodeRightNodeLocationOffset = 16;
const NUUInt32 NUOpaqueBTreeNodeKeyCountOffset = 24;
const NUUInt32 NUOpaqueBTreeNodeBodyOffset = 28;

NSString *NUUnderflowNodeFoundException = @"NUUnderflowNodeFoundException";
NSString *NUNodeKeyCountOrValueCountIsInvalidException = @"NUNodeKeyCountOrValueCountIsInvalidException";

@implementation NUOpaqueBTreeNode

- (oneway void)release
{
    [super release];
}

- (id)autorelease
{
    return [super autorelease];
}

- (void)dealloc
{
    [super dealloc];
}

@end

@implementation NUOpaqueBTreeNode (InitializingAndRelease)

+ (id)nodeWithTree:(NUOpaqueBTree *)aTree pageLocation:(NUUInt64)aPageLocation
{
	return [[[self alloc] initWithTree:aTree pageLocation:aPageLocation] autorelease];
}

+ (id)nodeWithTree:(NUOpaqueBTree *)aTree pageLocation:(NUUInt64)aPageLocation keys:(NUOpaqueArray *)aKeys values:(NUOpaqueArray *)aValues
{
	return [[[self alloc] initWithTree:aTree pageLocation:aPageLocation keys:aKeys values:aValues] autorelease];
}

- (id)initWithTree:(NUOpaqueBTree *)aTree pageLocation:(NUUInt64)aPageLocation
{
	return [self initWithTree:aTree pageLocation:aPageLocation keys:nil values:nil];
}

- (id)initWithTree:(NUOpaqueBTree *)aTree pageLocation:(NUUInt64)aPageLocation keys:(NUOpaqueArray *)aKeys values:(NUOpaqueArray *)aValues
{
	[super init];
	
	[self setTree:aTree];
	[self setPageLocation:aPageLocation];
	
	if (aKeys)
	{
		[self setKeys:aKeys];
		[self setValues:aValues];
        [self setNewExtraValues];
        [self nodeDidInsertKeys:[aKeys at:0] at:0 count:[aKeys count]];
        [self nodeDidInsertValues:[aValues at:0] at:0 count:[aValues count]];
		[self markChanged];
	}
	else if ([[self pages] pageIsCreatedFor:aPageLocation])
	{
		[self loadKeysAndValuesFrom:aPageLocation];
	}
	else
	{
		[self setKeys:[self makeKeyArray]];
		[self setValues:[self makeValueArray]];
		[self setNewExtraValues];
		[self markChanged];
	}
	
	return self;
}

- (void)loadKeysAndValuesFrom:(NUUInt64)aPageLocation
{
	NUOpaqueArray *aKeys = [self makeKeyArray];
	NUOpaqueArray *aValues = [self makeValueArray];
	
	[self setLeftNodeLocation:[[self pages] readUInt64At:NUOpaqueBTreeNodeLeftNodeLocationOffset of:aPageLocation]];
	[self setRightNodeLocation:[[self pages] readUInt64At:NUOpaqueBTreeNodeRightNodeLocationOffset of:aPageLocation]];
	[aKeys readFrom:[self pages] at:aPageLocation + [[self tree] nodeHeaderLength]
		capacity:[self keyCapacity] count:[[self pages] readUInt32At:NUOpaqueBTreeNodeKeyCountOffset of:aPageLocation]];
	[aValues readFrom:[self pages] at:aPageLocation + [[self tree] nodeHeaderLength] + [aKeys size]
		capacity:[self valueCapacity] count:[self valueCountForKeyCount:[aKeys count]]];
	[self setKeys:aKeys];
	[self setValues:aValues];
	[self readExtraValuesFromPages:[self pages]
		at:aPageLocation + [[self tree] nodeHeaderLength] + [aKeys size] + [aValues size]
		count:[self valueCountForKeyCount:[aKeys count]]];
	[self clearChanged];
}

- (void)readExtraValuesFromPages:(NUPages *)aPages at:(NUUInt64)aLocation count:(NUUInt32)aCount
{
}

@end

@implementation NUOpaqueBTreeNode (Accessing)

- (NUOpaqueBTree *)tree { return tree; }

- (void)setTree:(NUOpaqueBTree *)aTree
{
	tree = aTree;
}

- (NUSpaces *)spaces { return [[self tree] spaces]; }

- (NUPages *)pages { return [[self tree] pages]; }

- (NUOpaqueBTreeBranch *)parentNode
{
    return [[self tree] parentNodeOf:self];
}

- (NUOpaqueBTreeBranch *)parentNodeOf:(NUOpaqueBTreeNode *)aNode
{
    return nil;
}

- (NUUInt64)pageLocation
{
	return pageLocation;
}

- (void)setPageLocation:(NUUInt64)aPageLocation
{    
	pageLocation = aPageLocation;
}

- (NUUInt8 *)firstkey
{
	return [[self keys] first];
}

- (NUUInt8 *)keyAt:(NUUInt32)anIndex
{
	return [[self keys] at:anIndex];
}

- (NUUInt8 *)valueAt:(NUUInt32)anIndex
{
	return [[self values] at:anIndex];
}

- (NUUInt8 *)mostLeftKey
{
	return [self firstkey];
}

- (NUUInt32)keyIndexEqualTo:(NUUInt8 *)aKey
{
	return [[self keys] indexEqualTo:aKey];
}

- (NUUInt32)keyIndexGreaterThanOrEqualToKey:(NUUInt8 *)aKey
{
	return [[self keys] indexGreaterThanOrEqualTo:aKey];
}

- (NUInt32)keyIndexLessThanOrEqualToKey:(NUUInt8 *)aKey
{
	return [[self keys] indexLessThanOrEqualTo:aKey];
}

- (NUOpaqueBTreeLeaf *)leafNodeContainingKey:(NUUInt8 *)aKey keyIndex:(NUUInt32 *)aKeyIndex
{
	return nil;
}

- (NUOpaqueBTreeLeaf *)leafNodeContainingKeyGreaterThanOrEqualTo:(NUUInt8 *)aKey keyIndex:(NUUInt32 *)aKeyIndex
{
	return nil;
}

- (NUOpaqueBTreeLeaf *)leafNodeContainingKeyLessThanOrEqualTo:(NUUInt8 *)aKey keyIndex:(NUUInt32 *)aKeyIndex
{
	return nil;
}

- (NUOpaqueArray *)keys
{
	return keys;
}

- (void)setKeys:(NUOpaqueArray *)aKeys
{
	if (keys == aKeys) return;
	
	[keys release];
	keys = [aKeys retain];
}

- (NUOpaqueArray *)values
{
	return values;
}

- (void)setValues:(NUOpaqueArray *)aValues
{
	if (values == aValues) return;
	
	[values release];
	values = [aValues retain];
	[self newValuesAssigned:values];
}

- (void)newValuesAssigned:(NUOpaqueArray *)aValues
{
	if ([aValues count])
		[self nodeDidInsertValues:[aValues at:0] at:0 count:[aValues count]];
}

- (NUUInt32)minKeyCount
{
	return floor([self keyCapacity] / 2.0);
}

- (NUUInt32)minValueCount
{
	return floor([self valueCapacity] / 2.0);
}

- (NUUInt32)keyCount
{
	return [[self keys] count];
}

- (NUUInt32)valueCount
{
	return [[self values] count];
}

- (NUUInt8 *)firstValue
{
	return [[self values] first];
}

- (NUOpaqueBTreeNode *)leftNode
{
	return [[self tree] nodeFor:[self leftNodeLocation]];
}

- (NUOpaqueBTreeNode *)rightNode
{
	return [[self tree] nodeFor:[self rightNodeLocation]];
}

- (NUOpaqueBTreeLeaf *)mostLeftNode
{
	return nil;
}

- (NUOpaqueBTreeLeaf *)mostRightNode
{
	return nil;
}

- (NUUInt64)leftNodeLocation
{
	return leftNodeLocation;
}

- (void)setLeftNodeLocation:(NUUInt64)aLocation
{
	if (leftNodeLocation == aLocation) return;
	
	leftNodeLocation = aLocation;
	[self markChanged];
}

- (NUUInt64)rightNodeLocation
{
	return rightNodeLocation;
}

- (void)setRightNodeLocation:(NUUInt64)aLocation
{
	if (rightNodeLocation == aLocation) return;
	
	rightNodeLocation = aLocation;
	[self markChanged];
}

- (NUUInt32)shufflableKeyCount
{
    return ceil(([self keyCount] - [self minKeyCount]) / 2.0);
}

+ (NUUInt64)nodeOOP
{
	return NUNilOOP;
}

- (NUOpaqueArray *)makeKeyArray
{
	return [[[NUIndexArray alloc] initWithCapacity:[self keyCapacity] comparator:[[self tree] comparator]] autorelease];
}

- (NUOpaqueArray *)makeValueArray
{
	return nil;
}

- (void)setNewExtraValues
{
}

- (NUUInt32)nodeHeaderLength
{
	return [[self tree] nodeHeaderLength];
}

- (NUUInt32)keyLength
{
	return [[self tree] keyLength];
}

- (NUUInt32)valueLength
{
	return [self isLeaf] ? [[self tree] leafValueLength] : [[self tree] branchValueLength];
}

- (NUUInt32)extraValueLength
{
	return 0;
}

- (NUUInt32)valueLengthIncludingExtra
{
	return [self valueLength] + [self extraValueLength];
}

- (NUUInt32)keyCapacity
{
	NUUInt32 aKeyCapacity;
    [self computeKeyCapacityInto:&aKeyCapacity valueCapacityInto:NULL];
    
    return aKeyCapacity;
}

- (NUUInt32)valueCapacity
{
    NUUInt32 aValueCapacity;
    [self computeKeyCapacityInto:NULL valueCapacityInto:&aValueCapacity];
    return aValueCapacity;
}

- (void)computeKeyCapacityInto:(NUUInt32 *)aKeyCapacity valueCapacityInto:(NUUInt32 *)aValueCapacity
{
    NUUInt32 aPageSizeWithoutHeader = [[self pages] pageSize] - [self nodeHeaderLength];
    NUUInt32 aCapacity = aPageSizeWithoutHeader / ([self keyLength] + [self valueLengthIncludingExtra]);
    NUUInt32 aRemainingLength = aPageSizeWithoutHeader - ([self keyLength] + [self valueLengthIncludingExtra]) * aCapacity;
    
    if ([self isLeaf])
    {
        if (aKeyCapacity) *aKeyCapacity = aCapacity;
        if (aValueCapacity) *aValueCapacity = aCapacity;
    }
    else if (aRemainingLength >= [self valueLengthIncludingExtra])
    {
        if (aKeyCapacity) *aKeyCapacity = aCapacity;
        if (aValueCapacity) *aValueCapacity = aCapacity + 1;
    }
    else
    {
        if (aKeyCapacity) *aKeyCapacity = aCapacity - 1;
        if (aValueCapacity) *aValueCapacity = aCapacity;
    }
}

- (NUUInt32)valueCountForKeyCount:(NUUInt32)aKeyCount
{
	return [self isLeaf] ? aKeyCount : aKeyCount + 1;
}

- (NUOpaqueBTreeNode *)setOpaqueValue:(NUUInt8 *)aValue forKey:(NUUInt8 *)aKey
{
	return nil;
}

- (NUUInt8 *)valueFor:(NUUInt8 *)aKey
{
	return NULL;
}

- (void)removeValueFor:(NUUInt8 *)aKey
{
}

@end

@implementation NUOpaqueBTreeNode (Modifying)

- (void)addKey:(NUUInt8 *)aKey
{
	[self insertKey:aKey at:0];
}

- (void)addKeys:(NUOpaqueArray *)aKeys
{
	[self insertKeys:[aKeys at:0] at:[self keyCount] count:[aKeys count]];
}

- (void)insertKey:(NUUInt8 *)aKey at:(NUUInt32)anIndex
{
	[self insertKeys:aKey at:anIndex count:1];
}

- (void)insertKeys:(NUUInt8 *)aKeys at:(NUUInt32)anIndex count:(NUUInt32)aCount
{
	[[self keys] insert:aKeys to:anIndex count:aCount];
	[self nodeDidInsertKeys:aKeys at:anIndex count:aCount];
}

- (void)insertKeys:(NUOpaqueArray *)aKeys at:(NUUInt32)anIndex
{
    [self insertKeys:[aKeys at:0] at:anIndex count:[aKeys count]];
}

- (void)removeFirstKey
{
	[self removeKeyAt:0];
}

- (void)removeKeyAt:(NUUInt32)anIndex
{
	[self removeKeysAt:anIndex count:1];
}

- (void)removeKeysAt:(NUUInt32)anIndex count:(NUUInt32)aCount
{
	[[self keys] removeAt:anIndex count:aCount];
	[self nodeDidRemoveKeysAt:anIndex count:aCount];
}

- (void)removeAllKeys
{
	[self removeKeysAt:0 count:[self keyCount]];
}

- (void)replaceKeyAt:(NUUInt32)anIndex with:(NUUInt8 *)aNewKey
{
	[[self keys] replaceAt:anIndex with:aNewKey];
	[self markChanged];
}

- (void)addValues:(NUOpaqueArray *)aValues
{
	[[self values] insert:[aValues at:0] to:[self valueCount] count:[aValues count]];
}

- (void)insertValues:(NUOpaqueArray *)aValues at:(NUUInt32)anIndex
{
    [[self values] insert:[aValues at:0] to:0 count:[aValues count]];
}

- (void)primitiveInsertValues:(NUUInt8 *)aValues at:(NUUInt32)anIndex count:(NUUInt32)aCount
{
	[[self values] insert:aValues to:anIndex count:aCount];
}

- (void)replaceValueAt:(NUUInt32)anIndex with:(NUUInt8 *)aValue
{
	[[self values] replaceAt:anIndex with:aValue];
	[self markChanged];
}

- (void)removeValueAt:(NUUInt32)anIndex
{
	[self removeValuesAt:anIndex count:1];
}

- (void)removeValuesAt:(NUUInt32)anIndex count:(NUUInt32)aCount
{
	[[self values] removeAt:anIndex count:aCount];
	[self nodeDidRemoveValuesAt:anIndex count:aCount];
}

- (void)removeAllValues
{
	[self removeValuesAt:0 count:[self valueCount]];
}

- (NUOpaqueArray *)insertOpaqueKey:(NUUInt8 *)aKey at:(NUUInt32)anIndex
{
    return nil;
}

- (NUOpaqueArray *)insertOpaqueValue:(NUUInt8 *)aValue at:(NUUInt32)anIndex
{
    if ([self isFull])
    {
        NUOpaqueArray *aTemporaryValues = [[[self values] copyWithCapacity:[self valueCapacity] + 1] autorelease];
        [aTemporaryValues insert:aValue to:anIndex];
        [[self values] setOpaqueValues:[aTemporaryValues at:0] count:[self minValueCount]];
        [self nodeDidInsertValues:[aTemporaryValues at:0] at:0 count:[self minValueCount]];
        NUOpaqueArray *aNewValues = [[[self values] copyWithoutValues] autorelease];
        [aNewValues setOpaqueValues:[aTemporaryValues at:[self minValueCount]] count:[aTemporaryValues count] - [self minValueCount]];
        return aNewValues;
    }
    else
    {
        [[self values] insert:aValue to:anIndex];
        [self nodeDidInsertValues:aValue at:anIndex count:1];
        return nil;
    }
}

- (void)nodeDidInsertKeys:(NUUInt8 *)aKeys at:(NUUInt32)anIndex count:(NUUInt32)aCount
{
	[self markChanged];
}

- (void)nodeDidRemoveKeysAt:(NUUInt32)anIndex count:(NUUInt32)aCount
{
	[self markChanged];
}

- (void)nodeDidInsertValues:(NUUInt8 *)aValues at:(NUUInt32)anIndex count:(NUUInt32)aCount
{
	[self markChanged];
}

- (void)nodeDidRemoveValuesAt:(NUUInt32)anIndex count:(NUUInt32)aCount
{
	[self markChanged];
}

- (void)markChanged
{
	isChanged = YES;
}

- (void)clearChanged
{
	isChanged = NO;
}

@end

@implementation NUOpaqueBTreeNode (Balancing)

- (void)insertRightNode:(NUOpaqueBTreeNode *)aNewNode
{
	[aNewNode setRightNodeLocation:[self rightNodeLocation]];
	[self setRightNodeLocation:[aNewNode pageLocation]];
	[aNewNode setLeftNodeLocation:[self pageLocation]];
	if ([aNewNode rightNodeLocation])
		[[[self tree] nodeFor:[aNewNode rightNodeLocation]] setLeftNodeLocation:[aNewNode pageLocation]];
}

- (void)shuffleLeftNode
{
}

- (void)shuffleRightNode
{
}

- (void)mergeRightNode
{
    NUOpaqueBTreeNode *aRightNode = [self rightNode];
    [self setRightNodeLocation:[[self rightNode] rightNodeLocation]];
    [[self rightNode] setLeftNodeLocation:[self pageLocation]];
    [aRightNode releaseNodePageAndCache];
}

- (void)mergeLeftNode
{
    NUOpaqueBTreeNode *aLeftNode = [self leftNode];
    [[[self leftNode] leftNode] setRightNodeLocation:[self pageLocation]];
    [self setLeftNodeLocation:[[self leftNode] leftNodeLocation]];
    [aLeftNode releaseNodePageAndCache];
}

@end

@implementation NUOpaqueBTreeNode (Testing)

- (BOOL)isBranch { return NO; }

- (BOOL)isLeaf { return NO; }

- (BOOL)isChanged { return isChanged; }

- (BOOL)isEmpty
{
	return [[self keys] isEmpty];
}

- (BOOL)isMin
{
	return [self minKeyCount] == [self keyCount];
}

- (BOOL)isUnderflow
{
	return [self keyCount] < [self minKeyCount];
}

- (BOOL)isFull
{
	return [[self keys] isFull];
}

- (BOOL)keyAt:(NUUInt32)anIndex isEqual:(NUUInt8 *)aKey
{
	return [[self keys] at:anIndex isEqual:aKey];
}

- (BOOL)keyAt:(NUUInt32)anIndex isLessThan:(NUUInt8 *)aKey
{
    return [[self keys] at:anIndex isLessThan:aKey];
}

- (BOOL)keyAt:(NUUInt32)anIndex isGreaterThan:(NUUInt8 *)aKey;
{
    return [[self keys] at:anIndex isGreaterThan:aKey];
}

- (BOOL)canPreventNodeReleseWhenValueRemoved
{
//	return ![self isMin] || ![[self leftNode] isMin] || ![[self rightNode] isMin];
    return ![self isMin];
}

@end

@implementation NUOpaqueBTreeNode (ManagingPage)

- (void)releaseNodePageAndCache
{
	[[self tree] releaseNodePage:[self pageLocation]];
    [[self tree] removeNodeAt:[self pageLocation]];
}

- (void)changeNodePageWith:(NUUInt64)aPageLocation
{
#ifdef DEBUG
    NSLog(@"%@ #changeNodePageWith:%llu; rootLocation:%llu", [self class], aPageLocation, pageLocation);
#endif
    
    [[self parentNode] changeNodePageWith:aPageLocation of:self];
    [self retain];
	[[self tree] removeNodeAt:pageLocation];
    if ([[self spaces] nodePageLocationIsVirtual:pageLocation])
        [[self spaces] setNodePageLocation:aPageLocation forVirtualNodePageLocation:pageLocation];
	pageLocation = aPageLocation;
	[[self tree] addNode:self];
    [self release];
	[[self leftNode] setRightNodeLocation:pageLocation];
	[[self rightNode] setLeftNodeLocation:pageLocation];
    [[self tree] updateRootLocationIfNeeded];
}

- (void)changeNodePageWith:(NUUInt64)aPageLocation of:(NUOpaqueBTreeNode *)aNode
{
}

- (void)save
{
	NUPages *aPages = [self pages];

	[aPages writeUInt64:[[self class] nodeOOP] at:NUOpaqueBTreeNodeOOPOffset of:pageLocation];
	[aPages writeUInt64:[self leftNodeLocation] at:NUOpaqueBTreeNodeLeftNodeLocationOffset of:pageLocation];
	[aPages writeUInt64:[self rightNodeLocation] at:NUOpaqueBTreeNodeRightNodeLocationOffset of:pageLocation];
	[aPages writeUInt32:[self keyCount] at:NUOpaqueBTreeNodeKeyCountOffset of:pageLocation];
	[[self keys] writeTo:aPages at:[self pageLocation] + NUOpaqueBTreeNodeBodyOffset];
	[[self values] writeTo:aPages at:[self pageLocation] + NUOpaqueBTreeNodeBodyOffset + [[self keys] size]];
	[self writeExtraValuesToPages:aPages at:[self pageLocation] + NUOpaqueBTreeNodeBodyOffset + [[self keys] size] + [[self values] size]];
	
	[self clearChanged];
}

- (void)writeExtraValuesToPages:(NUPages *)aPages at:(NUUInt64)aLocation
{
}

@end

@implementation NUOpaqueBTreeNode (Debug)

- (void)validateAllNodeLocations
{
    NUUInt32 aPageSize = [[self pages] pageSize];
    
    if ([self pageLocation] % aPageSize != 0)
        [[NSException exceptionWithName:NUInvalidPageLocationException reason:NUInvalidPageLocationException userInfo:nil] raise];
    if ([self leftNodeLocation] % aPageSize != 0)
        [[NSException exceptionWithName:NUInvalidPageLocationException reason:NUInvalidPageLocationException userInfo:nil] raise];
    if ([self rightNodeLocation] % aPageSize != 0)
        [[NSException exceptionWithName:NUInvalidPageLocationException reason:NUInvalidPageLocationException userInfo:nil] raise];
    if ([self parentNode] && [self isUnderflow])
        [[NSException exceptionWithName:NUUnderflowNodeFoundException reason:NUUnderflowNodeFoundException userInfo:nil] raise];
    
    if ([self isLeaf])
    {
        if ([self values] && [self keyCount] != [self valueCount])
            [[NSException exceptionWithName:NUNodeKeyCountOrValueCountIsInvalidException reason:NUNodeKeyCountOrValueCountIsInvalidException userInfo:nil] raise];
        return;
    }
    else
    {
        if ([self keyCount] + 1 != [self valueCount])
            [[NSException exceptionWithName:NUNodeKeyCountOrValueCountIsInvalidException reason:NUNodeKeyCountOrValueCountIsInvalidException userInfo:nil] raise];
    }
    
    NUOpaqueBTreeBranch *aBranchNode = (NUOpaqueBTreeBranch *)self;
    NUUInt32 i = 0;
    for (; i < [aBranchNode valueCount]; i++)
    {
        if ([aBranchNode nodeLocationAt:i] % aPageSize != 0)
            [[NSException exceptionWithName:NUInvalidPageLocationException reason:NUInvalidPageLocationException userInfo:nil] raise];
        [[aBranchNode nodeAt:i] validateAllNodeLocations];
    }
}

@end
