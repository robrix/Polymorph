// RXObject.h
// Created by Rob Rix on 2010-04-19
// Copyright 2010 Monochrome Industries

#ifndef RXObject_H
#define RXObject_H

#import "RXObjectType.h"

// this expects the type structure for your new instance to be in a global named <instance structure name>Type.
#define RX_CREATE(type) \
	RXCreate(sizeof(type), (void *)&type##Type);

// make your own RX_FIELDS_FROM_<typename> macro to let people “subclass” your type via this macro
#define RX_FIELDS_FROM(instanceType, type) RX_FIELDS_FROM_##instanceType(type)
#define RX_FIELDS_FROM_RXObject(_type) \
	__strong _type##Ref type;\
	RXIndex referenceCount;

struct RXObject {
	RX_FIELDS_FROM(RXObject, RXObjectType);
};

__strong RXObjectRef RXCreate(RXIndex size, void *type);

__strong RXObjectRef RXRetain(RXObjectRef self);
void RXRelease(RXObjectRef self);
RXIndex RXGetReferenceCount(RXObjectRef self);

__strong RXObjectTypeRef RXGetType(RXObjectRef self);

bool RXEquals(RXObjectRef self, RXObjectRef other);

#endif // RXObject_H
