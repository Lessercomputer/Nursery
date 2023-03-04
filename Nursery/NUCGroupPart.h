//
//  NUCGroupPart.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2023/03/05.
//  Copyright © 2023 Nursery-Framework. All rights reserved.
//

#import "NUCPreprocessingDirective.h"


@interface NUCGroupPart : NUCPreprocessingDirective
{
    NUCPreprocessingDirective *content;
}

+ (instancetype)groupPartWithContent:(NUCPreprocessingDirective *)aContent;

- (instancetype)initWithContent:(NUCPreprocessingDirective *)aContent;

- (NUCPreprocessingDirective *)content;

@end

