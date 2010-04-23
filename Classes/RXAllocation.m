// RXAllocation.m
// Created by Rob Rix on 2010-04-22
// Copyright 2010 Monochrome Industries

#include "RXAllocation.h"
#include <objc/objc-auto.h>
#include <Foundation/Foundation.h>

__strong void *RXAllocate(RXIndex size) { // fixme: actually allocate something
	return RXCollectionEnabled() ? NSAllocateCollectable(size, NSScannedOption) : calloc(1, size);
}

RXBool RXCollectionEnabled(void) {
	return objc_collectingEnabled();
}