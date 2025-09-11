//
//  NUCSyntaxElement.h
//  Nursery
//
//  Created by akiha on 2025/02/19.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import <Foundation/NSObject.h>
#import <Nursery/NUTypes.h>

@class NUCTranslator;

@interface NUCSyntaxElement : NSObject

- (void)translateWith:(NUCTranslator *)aTranslator;

@end

