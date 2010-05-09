// RXShadowObject.m
// Created by Rob Rix on 2010-05-07
// Copyright 2010 Monochrome Industries

#import "RXShadowObject.h"

extern void RXDeallocate(RXObjectRef _self);

@implementation RXShadowObject

-(void)dealloc {
	RXDeallocate(self);
	return;
	[super dealloc]; // under no circumstances should this be called!
}


@synthesize type;

-(NSString *)typeName {
	return [NSString stringWithUTF8String: RXObjectTypeGetName(self.type)];
}


-(BOOL)isEqual:(id)other {
	return
		[other isKindOfClass: self.class]
	&&	RXEquals(self, other);
}


-(NSString *)description {
	return [(NSString *)RXCopyDescription(self) autorelease];
}

@end
