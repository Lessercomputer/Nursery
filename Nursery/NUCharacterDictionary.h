//
//  NUCharacterDictionary.h
//  Nursery
//
//  Created by P,T,A on 2013/10/05.
//
//

#import <Nursery/NUCoding.h>
#import <Nursery/NUMovingUp.h>

@class NUMutableDictionary;

@interface NUCharacterDictionary : NSObject <NUCoding, NUMovingUp>
{
    NUMutableDictionary *dictionary;
    NUBell *bell;
}

+ (id)dictionary;

- (NSUInteger)count;
- (id)objectForKey:(id)aKey;
- (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey;
- (NSEnumerator *)keyEnumerator;

- (void)moveUp;
- (void)mergeWithSandboxCharacters;

@end

@interface NUCharacterDictionary (Private)

- (NUMutableDictionary *)dictionary;
- (void)setDictionary:(NUMutableDictionary *)aDictionary;

@end
