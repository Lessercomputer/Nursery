//
//  NUCSyntaxElement.h
//  Nursery
//
//  Created by akiha on 2025/02/19.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import <Foundation/NSObject.h>
#import <Nursery/NUTypes.h>

@class NUCTranslationOrderMap;

@interface NUCSyntaxElement : NSObject

- (void)mapTo:(NUCTranslationOrderMap *)aMap;
- (void)mapTo:(NUCTranslationOrderMap *)aMap parent:(id)aParent;
- (void)mapTo:(NUCTranslationOrderMap *)aMap parent:(id)aParent depth:(NUUInt64)aDepth;

@end

