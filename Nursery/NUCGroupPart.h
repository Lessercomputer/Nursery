//
//  NUCGroupPart.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2023/03/05.
//  Copyright © 2023 Nursery-Framework. All rights reserved.
//

#import "NUCPreprocessingDirective.h"

@class NUCPreprocessingTokenStream;

@interface NUCGroupPart : NUCPreprocessingDirective
{
    NUCPreprocessingDirective *content;
}

+ (BOOL)groupPartFrom:(NUCPreprocessingTokenStream *)aStream  with:(NUCPreprocessor *)aPreprocessor isSkipped:(BOOL)aGroupIsSkipped into:(NUCPreprocessingDirective **)aGroupPart;

+ (instancetype)groupPartWithContent:(NUCPreprocessingDirective *)aContent;

- (instancetype)initWithContent:(NUCPreprocessingDirective *)aContent;

- (NUCPreprocessingDirective *)content;

@end

