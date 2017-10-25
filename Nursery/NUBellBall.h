//
//  NUBellBall.h
//  Nursery
//
//  Created by P,T,A on 2013/08/17.
//
//

#import <Nursery/NUTypes.h>

extern const NUUInt64 NUNilGrade;
extern const NUUInt64 NUFirstGrade;
extern const NUUInt64 NUBellBallFixedGrade;
extern const NUUInt64 NUTemporaryGrade;
extern const NUUInt64 NUNotFoundGrade;

NUComparisonResult NUBellBallCompare(NUUInt8 *aBellBall1Pointer, NUUInt8 *aBellBall2Pointer);

NUBellBall NUMakeBellBall(NUUInt64 anOOP, NUUInt64 aGrade);

NSString *NUStringFromBellBall(NUBellBall aBellBall);

BOOL NUBellBallEquals(NUBellBall aBellBall1, NUBellBall aBellBall2);