//
//  NUCharacterDictionary.h
//  Nursery
//
//  Created by Akifumi Takata on 2013/10/05.
//
//

#import <Foundation/NSObject.h>

#import "NUCoding.h"
#import "NUMovingUp.h"

@class NSString;

@class NUMutableDictionary, NUCharacter;

@interface NUCharacterDictionary : NSObject <NUCoding, NUMovingUp>
{
    NUMutableDictionary *dictionary;
    NUBell *bell;
}

+ (id)dictionary;

- (NSUInteger)count;
- (id)objectForKey:(id)aKey;
- (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey;
- (void)enumerateUsingBlock:(void (^)(NSString *anInheritanceNameWithVersion, NUCharacter *aCharacter, BOOL *aStop))aBlock;
- (NSEnumerator *)keyEnumerator;

@end

@interface NUCharacterDictionary (Private)

- (NUMutableDictionary *)dictionary;
- (void)setDictionary:(NUMutableDictionary *)aDictionary;

@end
