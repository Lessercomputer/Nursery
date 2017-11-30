//
//  NUBranchCodingContext.m
//  Nursery
//
//  Created by Akifumi Takata on 2014/02/27.
//
//

#import "NUCodingContextWithPupilNote.h"
#import "NUPupilNote.h"

@implementation NUCodingContextWithPupilNote

+ (id)contextWithPupilNote:(NUPupilNote *)aPupilNote
{
    return [[[self alloc] initWithPupilNote:aPupilNote] autorelease];
}

- (id)initWithPupilNote:(NUPupilNote *)aPupilNote
{
    if (self = [super init])
    {
        pupilNote = [aPupilNote retain];
    }
    
    return self;
}

- (void)dealloc
{
    [pupilNote release];
    
    [super dealloc];
}

- (NUPupilNote *)pupilNote
{
    return pupilNote;
}

- (id<NUCodingNote>)codingNote
{
    return pupilNote;
}

@end
