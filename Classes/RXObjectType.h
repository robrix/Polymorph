// RXObjectType.h
// Created by Rob Rix on 2010-04-19
// Copyright 2010 Monochrome Industries

#ifndef RXObjectType_H
#define RXObjectType_H

#import <stdint.h>

typedef void * RXObjectRef;

typedef uint8_t RXBool;

#ifndef NO
#define NO (RXBool)0
#endif

#ifndef YES
#define YES (RXBool)1
#endif

#ifdef __LP64__
typedef uint64_t RXIndex;
#else
typedef uint32_t RXIndex;
#endif

typedef void (*RXDeallocateMethod)(RXObjectRef);
typedef RXBool (*RXIsEqualMethod)(RXObjectRef, RXObjectRef);

#define RX_METHODS_FROM(typename) RX_METHODS_FROM_##typename()
#define RX_METHODS_FROM_RXObjectType() \
	RXDeallocateMethod deallocate;\
	RXIsEqualMethod isEqual;

typedef struct RXObjectType {
	RX_METHODS_FROM(RXObjectType);
} RXObjectType, *RXObjectTypeRef;

#endif // RXObjectType_H
