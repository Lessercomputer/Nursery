//
//  NUMutableDictionary.h
//  Nursery
//
//  Created by Akifumi Takata on 2013/10/05.
//
//

#import <Nursery/NUCoding.h>

@class NUBell;

@interface NUMutableDictionary : NSMutableDictionary <NUCoding>
{
    NSMutableDictionary *innerDictionary;
    NSMutableSet *setKeys;
    NSMutableSet *removedKeys;
    NUBell *bell;
}
@end

@interface NUMutableDictionary (ModificationInfo)

- (void)removeAllModificationInfo;

@end

@interface NUMutableDictionary (MoveUp)

- (void)moveUp;

@end

@interface NUMutableDictionary (Private)

- (NSMutableDictionary *)innerDictionary;
- (void)setInnerDictionary:(NSMutableDictionary *)aDictionary;

- (NSMutableSet *)setKeys;
- (void)setSetKeys:(NSMutableSet *)aKeys;

- (NSMutableSet *)removedKeys;
- (void)setRemovedKeys:(NSMutableSet *)aKeys;

@end
