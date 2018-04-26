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

@end

@interface NUCharacterDictionary (Private)

- (NUMutableDictionary *)dictionary;
- (void)setDictionary:(NUMutableDictionary *)aDictionary;

@end
