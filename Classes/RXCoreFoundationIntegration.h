// RXCoreFoundationIntegration.h
// Created by Rob Rix on 2010-05-06
// Copyright 2010 Monochrome Industries

#ifndef RX_CORE_FOUNDATION_INTEGRATION
#define RX_CORE_FOUNDATION_INTEGRATION

#include <CoreFoundation/CoreFoundation.h>
#include "RXObject.h"

#define RX_REQUIRES_NULL_TERMINATION __attribute__ ((sentinel))

CFArrayRef RXArray(RXObjectRef object, ...) RX_REQUIRES_NULL_TERMINATION;
CFDictionaryRef RXDictionary(RXObjectRef object, ...) RX_REQUIRES_NULL_TERMINATION;

#endif // RX_CORE_FOUNDATION_INTEGRATION
