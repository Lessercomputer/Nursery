/*
 *  NUTypes.h
 *  Nursery
 *
 *  Created by P,T,A on 10/09/09.
 *  Copyright 2010 Nursery-Framework. All rights reserved.
 *
 */

typedef unsigned char		NUUInt8;
typedef unsigned short		NUUInt16;
typedef unsigned int		NUUInt32;
typedef unsigned long long  NUUInt64;

typedef char	  NUInt8;
typedef short	  NUInt16;
typedef int		  NUInt32;
typedef long long NUInt64;
typedef float	  NUFloat;
typedef double	  NUDouble;

typedef NUInt32 NUInt;

typedef NUUInt8 NUObjectFormat;
typedef NUUInt8 NUIvarType;

extern const NUUInt64 NUUInt64Max;
extern const NUUInt32 NUUInt32Max;

extern const NUUInt32 NUNotFound32;
extern const NUUInt64 NUNotFound64;

typedef struct _NURegion {
	NUUInt64 location;
	NUUInt64 length;
} NURegion;

typedef struct _NUBellBall {
    NUUInt64 oop;
    NUUInt64 grade;
} NUBellBall;

extern const NUBellBall NUNotFoundBellBall;

typedef enum _NUComparisonResult {
    NUOrderedAscending = -1L,
    NUOrderedSame,
    NUOrderedDescending
} NUComparisonResult;
