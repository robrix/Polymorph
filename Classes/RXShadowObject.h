// RXShadowObject.h
// Created by Rob Rix on 2010-05-07
// Copyright 2010 Monochrome Industries

#import <Foundation/Foundation.h>

#import "RXObject.h"

// exists only to provide -retain, -release, -isEqual:, etc support for shoving RX objects in CF and NS collections alongside CF and NS objects
// oh, and -dealloc

@interface RXShadowObject : NSObject {
	__strong RXObjectTypeRef type;
}

@property (nonatomic, readonly) RXObjectTypeRef type;

@property (nonatomic, readonly) NSString *typeName;

@end
