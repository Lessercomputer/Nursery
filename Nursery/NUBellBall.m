//
//  NUBellBall.m
//  Nursery
//
//  Created by P,T,A on 2013/08/17.
//
//

#import "NUBellBall.h"

const NUUInt64 NUNilGrade           = 0;
const NUUInt64 NUFirstGrade         = 1;
const NUUInt64 NUBellBallFixedGrade = 1;
const NUUInt64 NUTemporaryGrade     = UINT64_MAX;
const NUUInt64 NUNotFoundGrade      = UINT64_MAX;

NUComparisonResult NUBellBallCompare(NUUInt8 *aBellBall1Pointer, NUUInt8 *aBellBall2Pointer)
{
    NUBellBall *aBellBall1 = (NUBellBall *)aBellBall1Pointer;
    NUBellBall *aBellBall2 = (NUBellBall *)aBellBall2Pointer;
    
    if (aBellBall1->oop < aBellBall2->oop) return NUOrderedAscending;
    else if (aBellBall1->oop > aBellBall2->oop) return NUOrderedDescending;
    else
    {
        if (aBellBall1->grade < aBellBall2->grade) return NUOrderedAscending;
        else if (aBellBall1->grade > aBellBall2->grade) return NUOrderedDescending;
        else return NUOrderedSame;
    }
}

NUBellBall NUMakeBellBall(NUUInt64 anOOP, NUUInt64 aGrade)
{
    NUBellBall aBellBall;
    aBellBall.oop = anOOP;
    aBellBall.grade = aGrade;
    return aBellBall;
}

NSString *NUStringFromBellBall(NUBellBall aBellBall)
{
	return [NSString stringWithFormat:@"{%llu, %llu}", aBellBall.oop, aBellBall.grade];
}

BOOL NUBellBallEquals(NUBellBall aBellBall1, NUBellBall aBellBall2)
{
    return aBellBall1.oop == aBellBall2.oop && aBellBall1.grade == aBellBall2.grade;
}