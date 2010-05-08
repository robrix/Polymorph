// RXCoreFoundationIntegration.m
// Created by Rob Rix on 2010-05-06
// Copyright 2010 Monochrome Industries

#include "RXCoreFoundationIntegration.h"
#include "RXObject.h"
#include <stdarg.h>
#import <Foundation/Foundation.h>

CFArrayRef RXArray(RXObjectRef object, ...) {
	NSCParameterAssert(object != NULL);
	NSMutableArray *objects = [[NSMutableArray alloc] init];
	va_list args;
	va_start(args, object);
	do {
		[objects addObject: (id)object];
	} while((object = va_arg(args, RXObjectRef)) != NULL);
	va_end(args);
	CFArrayRef result = (CFArrayRef)[[objects copy] autorelease];
	[objects release];
	return result;
}

CFDictionaryRef RXDictionary(RXObjectRef object, ...) {
	NSMutableDictionary *objects = [[NSMutableDictionary alloc] init];
	va_list args;
	va_start(args, object);
	do {
		id key = va_arg(args, id);
		[objects setObject: (id)object forKey: key];
	} while((object = va_arg(args, RXObjectRef)) != NULL);
	va_end(args);
	
	CFDictionaryRef result = (CFDictionaryRef)[[objects copy] autorelease];
	[objects release];
	return result;
}
