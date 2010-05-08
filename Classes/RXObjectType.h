// RXObjectType.h
// Created by Rob Rix on 2010-04-19
// Copyright 2010 Monochrome Industries

#ifndef RX_OBJECT_TYPE
#define RX_OBJECT_TYPE

#include <stdint.h>
#include <stdbool.h>
#include <CoreFoundation/CoreFoundation.h>

typedef void * RXObjectRef;

#ifdef __LP64__
typedef uint64_t RXIndex;
#else
typedef uint32_t RXIndex;
#endif

typedef void (*RXDeallocateMethod)(RXObjectRef);
typedef bool (*RXIsEqualMethod)(RXObjectRef, RXObjectRef);
typedef CFStringRef (*RXCopyDescriptionMethod)(RXObjectRef);

#define RX_METHODS_FROM(typename) RX_METHODS_FROM_##typename()
#define RX_METHODS_FROM_RXObjectType() \
	__strong const char *name;\
	RXDeallocateMethod deallocate;\
	RXIsEqualMethod isEqual;\
	RXCopyDescriptionMethod copyDescription;

typedef struct RXObjectType {
	RX_METHODS_FROM(RXObjectType);
} RXObjectType, *RXObjectTypeRef;

__strong const char *RXObjectTypeGetName(RXObjectTypeRef self);

#endif // RX_OBJECT_TYPE
