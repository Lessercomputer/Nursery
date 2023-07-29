//
//  NUOpaqueBPlusTreeNode.h
//  Nursery
//
//  Created by Akifumi Takata on 10/09/09.
//

#import <Foundation/NSObject.h>
#import "NUTypes.h"

@class NSString;
@class NUOpaqueBPlusTree, NUOpaqueArray, NUSpaces, NUPages, NUPage, NUOpaqueBPlusTreeLeaf, NUOpaqueBPlusTreeBranch;

extern const NUUInt32 NUOpaqueBPlusTreeNodeOOPOffset;
extern const NUUInt32 NUOpaqueBPlusTreeNodeLeftNodeLocationOffset;
extern const NUUInt32 NUOpaqueBPlusTreeNodeRightNodeLocationOffset;
extern const NUUInt32 NUOpaqueBPlusTreeNodeKeyCountOffset;
extern const NUUInt32 NUOpaqueBPlusTreeNodeBodyOffset;

extern NSString *NUUnderflowNodeFoundException;
extern NSString *NUNodeKeyCountOrValueCountIsInvalidException;

@interface NUOpaqueBPlusTreeNode : NSObject
{
	NUOpaqueBPlusTree *tree;
	NUOpaqueArray *keys;
	NUOpaqueArray *values;
	NUUInt64 pageLocation;
	NUUInt64 leftNodeLocation;
	NUUInt64 rightNodeLocation;
	BOOL isChanged;
    NUUInt32 minKeyCount;
}

@end

@interface NUOpaqueBPlusTreeNode (InitializingAndRelease)

+ (id)nodeWithTree:(NUOpaqueBPlusTree *)aTree pageLocation:(NUUInt64)aPageLocation loadFromPage:(BOOL)aLoadFlag keys:(NUOpaqueArray *)aKeys values:(NUOpaqueArray *)aValues;

- (id)initWithTree:(NUOpaqueBPlusTree *)aTree pageLocation:(NUUInt64)aPageLocation loadFromPage:(BOOL)aLoadFlag keys:(NUOpaqueArray *)aKeys values:(NUOpaqueArray *)aValues;

- (void)loadKeysAndValuesFrom:(NUUInt64)aPageLocation;
- (void)readExtraValuesFromPages:(NUPages *)aPages at:(NUUInt64)aLocation count:(NUUInt32)aCount;

@end

@interface NUOpaqueBPlusTreeNode (Accessing)

- (NUOpaqueBPlusTree *)tree;
- (void)setTree:(NUOpaqueBPlusTree *)aTree;
- (NUSpaces *)spaces;
- (NUPages *)pages;

- (NUOpaqueBPlusTreeBranch *)parentNode;
- (NUOpaqueBPlusTreeBranch *)parentNodeOf:(NUOpaqueBPlusTreeNode *)aNode;

- (NUUInt64)pageLocation;
- (void)setPageLocation:(NUUInt64)aPageLocation;

- (NUUInt8 *)firstkey;
- (NUUInt8 *)lastkey;
- (NUUInt8 *)keyAt:(NUUInt32)anIndex;
- (NUUInt8 *)valueAt:(NUUInt32)anIndex;
- (NUUInt8 *)mostLeftKeyInSubTree;

- (NUUInt32)keyIndexEqualTo:(NUUInt8 *)aKey;
- (NUUInt32)keyIndexGreaterThanOrEqualToKey:(NUUInt8 *)aKey;
- (NUInt32)keyIndexLessThanOrEqualToKey:(NUUInt8 *)aKey;

- (NUOpaqueBPlusTreeLeaf *)leafNodeContainingKey:(NUUInt8 *)aKey keyIndex:(NUUInt32 *)aKeyIndex;
- (NUOpaqueBPlusTreeLeaf *)leafNodeContainingKeyGreaterThanOrEqualTo:(NUUInt8 *)aKey keyIndex:(NUUInt32 *)aKeyIndex;
- (NUOpaqueBPlusTreeLeaf *)leafNodeContainingKeyLessThanOrEqualTo:(NUUInt8 *)aKey keyIndex:(NUUInt32 *)aKeyIndex;

- (NUOpaqueArray *)keys;
- (void)setKeys:(NUOpaqueArray *)aKeys;
- (NUOpaqueArray *)values;
- (void)setValues:(NUOpaqueArray *)aValues;
- (void)newValuesAssigned:(NUOpaqueArray *)aValues;

- (NUUInt32)minKeyCount;
- (NUUInt32)minValueCount;
- (NUUInt32)keyCount;
- (NUUInt32)valueCount;

- (NUUInt8 *)firstValue;
- (NUUInt8 *)lastValue;

- (NUUInt32)shufflableKeyCount;

- (NUOpaqueBPlusTreeNode *)leftNode;
- (NUOpaqueBPlusTreeNode *)rightNode;
- (NUOpaqueBPlusTreeLeaf *)mostLeftNode;
- (NUOpaqueBPlusTreeLeaf *)mostRightNode;

- (NUUInt64)leftNodeLocation;
- (void)setLeftNodeLocation:(NUUInt64)aLocation;
- (NUUInt64)rightNodeLocation;
- (void)setRightNodeLocation:(NUUInt64)aLocation;

+ (NUUInt64)nodeOOP;

- (NUOpaqueArray *)makeKeyArray;
- (NUOpaqueArray *)makeValueArray;

- (void)setNewExtraValues;

- (NUUInt32)nodeHeaderLength;
- (NUUInt32)keyLength;
- (NUUInt32)valueLength;
- (NUUInt32)extraValueLength;
- (NUUInt32)valueLengthIncludingExtra;

- (NUUInt32)keyCapacity;
- (NUUInt32)valueCapacity;
- (void)computeKeyCapacityInto:(NUUInt32 *)aKeyCapacity valueCapacityInto:(NUUInt32 *)aValueCapacity;

- (NUUInt32)valueCountForKeyCount:(NUUInt32)aKeyCount;

- (NUUInt8 *)valueFor:(NUUInt8 *)aKey;
- (NUOpaqueBPlusTreeNode *)setOpaqueValue:(NUUInt8 *)aValue forKey:(NUUInt8 *)aKey;
- (BOOL)removeValueFor:(NUUInt8 *)aKey;

- (void)enumerateNodesUsingBlock:(void (^)(NUOpaqueBPlusTreeNode *aNode, BOOL *aStop))aBlock stopFlag:(BOOL *)aStop;

@end

@interface NUOpaqueBPlusTreeNode (Modifying)

- (void)addKey:(NUUInt8 *)aKey;
- (void)addKeys:(NUOpaqueArray *)aKeys;
- (void)insertKey:(NUUInt8 *)aKey at:(NUUInt32)anIndex;
- (void)insertKeys:(NUUInt8 *)aKeys at:(NUUInt32)anIndex count:(NUUInt32)aCount;
- (void)insertKeys:(NUOpaqueArray *)aKeys at:(NUUInt32)anIndex;
- (void)replaceKeyAt:(NUUInt32)anIndex with:(NUUInt8 *)aNewKey;
- (void)removeFirstKey;
- (void)removeKeyAt:(NUUInt32)anIndex;
- (void)removeKeysAt:(NUUInt32)anIndex count:(NUUInt32)aCount;
- (void)removeAllKeys;

- (void)addValues:(NUOpaqueArray *)aValues;
- (void)insertValues:(NUOpaqueArray *)aValues at:(NUUInt32)anIndex;
- (void)primitiveInsertValues:(NUUInt8 *)aValues at:(NUUInt32)anIndex count:(NUUInt32)aCount;
- (void)replaceValueAt:(NUUInt32)anIndex with:(NUUInt8 *)aValue;
- (void)removeValueAt:(NUUInt32)anIndex;
- (void)removeValuesAt:(NUUInt32)anIndex count:(NUUInt32)aCount;
- (void)removeAllValues;

- (NUOpaqueArray *)insertOpaqueKey:(NUUInt8 *)aKey at:(NUUInt32)anIndex;
- (NUOpaqueArray *)insertOpaqueValue:(NUUInt8 *)aValue at:(NUUInt32)anIndex;

- (void)nodeDidInsertKeys:(NUUInt8 *)aKeys at:(NUUInt32)anIndex count:(NUUInt32)aCount;
- (void)nodeDidRemoveKeysAt:(NUUInt32)anIndex count:(NUUInt32)aCount;
- (void)nodeDidInsertValues:(NUUInt8 *)aValues at:(NUUInt32)anIndex count:(NUUInt32)aCount;
- (void)nodeDidRemoveValuesAt:(NUUInt32)anIndex count:(NUUInt32)aCount;

- (void)markChanged;
- (void)unmarkChanged;

@end

@interface NUOpaqueBPlusTreeNode (Balancing)

- (void)insertRightNode:(NUOpaqueBPlusTreeNode *)aNewNode;
- (void)shuffleLeftNode;
- (void)shuffleRightNode;
- (void)mergeRightNode;
- (void)mergeLeftNode;

@end

@interface NUOpaqueBPlusTreeNode (Testing)

- (BOOL)isRoot;
- (BOOL)isBranch;
- (BOOL)isLeaf;
- (BOOL)isChanged;

- (BOOL)isEmpty;
- (BOOL)isMin;
- (BOOL)isUnderflow;
- (BOOL)isFull;

- (BOOL)keyAt:(NUUInt32)anIndex isEqual:(NUUInt8 *)aKey;
- (BOOL)keyAt:(NUUInt32)anIndex isLessThan:(NUUInt8 *)aKey;
- (BOOL)keyAt:(NUUInt32)anIndex isGreaterThan:(NUUInt8 *)aKey;

- (BOOL)canPreventNodeReleseWhenValueRemovedOrAdded;

- (BOOL)isMostLeftNodeInCurrentDepth;
- (BOOL)nodeIsMostLeftNodeInDepthOf:(NUOpaqueBPlusTreeNode *)aNode;
- (BOOL)isMostRightNodeInCurrentDepth;
- (BOOL)nodeIsMostRightNodeInDepthOf:(NUOpaqueBPlusTreeNode *)aNode;

- (BOOL)pageIsVirtual;
- (BOOL)pageIsNotVirtual;

@end

@interface NUOpaqueBPlusTreeNode (ManagingPage)

- (void)releaseNodePageAndCache;
- (void)changeNodePageWith:(NUUInt64)aPageLocation;
- (void)changeNodePageWith:(NUUInt64)aPageLocation of:(NUOpaqueBPlusTreeNode *)aNode;

- (void)save;
- (void)writeExtraValuesToPages:(NUPages *)aPages at:(NUUInt64)aLocation;

@end

@interface NUOpaqueBPlusTreeNode (Debug)

- (void)validate;

@end
