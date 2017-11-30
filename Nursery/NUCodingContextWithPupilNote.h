//
//  NUBranchCodingContext.h
//  Nursery
//
//  Created by Akifumi Takata on 2014/02/27.
//
//

#import "NUCodingContext.h"

@class NUPupilNote;

@interface NUCodingContextWithPupilNote : NUCodingContext
{
    NUPupilNote *pupilNote;
}

+ (id)contextWithPupilNote:(NUPupilNote *)aPupilNote;

- (id)initWithPupilNote:(NUPupilNote *)aPupilNote;

- (NUPupilNote *)pupilNote;

@end
