//
//  NUPairedMainBranchAperture.h
//  Nursery
//
//  Created by Akifumi Takata on 2018/05/19.
//

#import "NUAperture.h"

@class NUMainBranchNursery, NUPairedMainBranchGarden, NUNurseryNetResponder, NUPupilNote;

@interface NUPairedMainBranchAperture : NUAperture

@property (nonatomic, assign) NUMainBranchNursery *nursery;
@property (nonatomic, assign) NUPairedMainBranchGarden *garden;
@property (nonatomic, assign) NUNurseryNetResponder *responder;
@property (nonatomic, retain) NUPupilNote *pupilNote;

@end
