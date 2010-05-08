// RXObject.m
// Created by Rob Rix on 2010-04-19
// Copyright 2010 Monochrome Industries

#include "RXAllocation.h"
#include "RXObject.h"
#import "RXShadowObject.h"
#include <stdlib.h>
#include <CoreFoundation/CoreFoundation.h>

RXObjectRef RXCreate(RXIndex size, void *type) {
	RXObjectRef object = RXAllocate(size);
	((struct RXObject*)object)->isa = [RXShadowObject class];
	((struct RXObject*)object)->type = type;
	return RXAutorelease(object);
}

void RXDeallocate(RXObjectRef _self) {
	if(!RXCollectionEnabled()) {
		struct RXObject *self = _self;
		if(self->type->deallocate != NULL) {
			self->type->deallocate(self);
		}
		free(self);
	}
}


__strong RXObjectTypeRef RXGetType(RXObjectRef self) {
	return ((struct RXObject *)self)->type;
}


__strong CFStringRef RXCopyDescription(RXObjectRef self) {
	RXCopyDescriptionMethod copyDescription = ((struct RXObject *)self)->type->copyDescription;
	return copyDescription ? copyDescription(self) : CFStringCreateWithFormat(NULL, NULL, CFSTR("<%s: %x>"), RXObjectTypeGetName(RXGetType(self)), self);
}


__strong RXObjectRef RXAutorelease(RXObjectRef self) {
	return (RXObjectRef)[(id)self autorelease];
}


bool RXEquals(RXObjectRef self, RXObjectRef other) {
	return ((struct RXObject *)self)->type->isEqual(self, other);
}
