// RXObject.m
// Created by Rob Rix on 2010-04-19
// Copyright 2010 Monochrome Industries

#include "RXAllocation.h"
#include "RXObject.h"
#include <stdlib.h>

RXObjectRef RXCreate(RXIndex size, void *type) {
	RXObjectRef object = RXAllocate(size);
	((struct RXObject*)object)->type = type;
	return RXRetain(object);
}

void RXDeallocate(RXObjectRef _self) {
	struct RXObject *self = _self;
	if(self->type->deallocate != NULL) {
		self->type->deallocate(self);
	}
	if(!RXCollectionEnabled()) {
		free(self);
	}
}


RXObjectRef RXRetain(RXObjectRef self) {
	if(self) {
		if(!RXCollectionEnabled()) {
			((struct RXObject*)self)->referenceCount++;
		}
	}
	return self;
}

void RXRelease(RXObjectRef self) {
	if(self) {
		if(!RXCollectionEnabled()) {
			((struct RXObject*)self)->referenceCount--;
			if(RXGetReferenceCount(self) == 0) {
				RXDeallocate(self);
			}
		}
	}
}

RXIndex RXGetReferenceCount(RXObjectRef self) {
	return RXCollectionEnabled() ? 0 : ((struct RXObject*)self)->referenceCount;
}


__strong RXObjectTypeRef RXGetType(RXObjectRef self) {
	return ((struct RXObject *)self)->type;
}


RXBool RXEquals(RXObjectRef self, RXObjectRef other) {
	return ((struct RXObject *)self)->type->isEqual(self, other);
}