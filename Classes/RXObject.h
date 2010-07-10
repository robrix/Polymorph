// RXObject.h
// Created by Rob Rix on 2010-04-19
// Copyright 2010 Monochrome Industries

#ifndef RX_OBJECT
#define RX_OBJECT

#import "RXObjectType.h"
#include <objc/runtime.h>

// make your own RX_FIELDS_FROM_<typename> macro to let people “subclass” your type via this macro
#define RX_FIELDS_FROM(instanceType, type) RX_FIELDS_FROM_##instanceType(type)
#define RX_FIELDS_FROM_RXObject(_type) \
	__strong Class isa;\
	__strong _type##Ref type;

struct RXObject {
	RX_FIELDS_FROM(RXObject, RXObjectType);
};

__strong RXObjectRef RXCreate(RXIndex size, void *type);

__strong RXObjectTypeRef RXGetType(RXObjectRef self);

__strong CFStringRef RXCopyDescription(RXObjectRef self);

__strong RXObjectRef RXRetain(RXObjectRef self);
void RXRelease(RXObjectRef self);
__strong RXObjectRef RXAutorelease(RXObjectRef self);

bool RXEquals(RXObjectRef self, RXObjectRef other);

#endif // RX_OBJECT
