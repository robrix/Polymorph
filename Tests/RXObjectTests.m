// RXObjectTests.m
// Created by Rob Rix on 2010-04-22
// Copyright 2010 Monochrome Industries

#import "RXObject.h"

typedef struct RXTestObject *RXTestObjectRef;


@protocol RXTestObjectDelegate <NSObject>

-(void)deallocateWasCalled;

@end

// the type, which includes the methods from the type it inherits from (in this case, RXObjectType), and its own methods.
typedef struct RXTestObjectType {
	// the RX_METHODS_FROM macro copies in the methods from the supertype. It’s pretty easy to make this work so you or others can make subtypes of your types.
	RX_METHODS_FROM(RXObjectType);
	
	RXTestObjectRef (*self)(RXTestObjectRef self);
} *RXTestObjectTypeRef;


// the instance, which includes a reference to the type, the data from the instance type it inherits from (in this case, RXObject), and its own data.
typedef struct RXTestObject {
	// the RX_FIELDS_FROM macro copies in the data fields from the supertype, and conveniently also declares which type this instance type takes methods from.
	RX_FIELDS_FROM(RXObject, RXTestObjectType);
	
	struct RXTestObject *self;
	id delegate;
} RXTestObject;


// these are the functions which implement the methods on the type
void RXTestObjectDeallocate(RXTestObjectRef self) {
	[self->delegate deallocateWasCalled];
}

bool RXTestObjectIsEqual(RXTestObjectRef self, RXObjectRef other) {
	return
		(RXGetType(self) == RXGetType(other)) // pointer equality is fine for types
	&&	self->delegate == ((RXTestObjectRef)other)->delegate;
}

RXTestObjectRef RXTestObjectSelf(RXTestObjectRef self) {
	return self;
}


// the type, in memory.
static struct RXTestObjectType RXTestObjectType = {
	.deallocate = (RXDeallocateMethod)RXTestObjectDeallocate,
	.isEqual = (RXIsEqualMethod)RXTestObjectIsEqual,
	.self = RXTestObjectSelf,
};


// a function which creates instances
RXTestObjectRef RXTestObjectCreateWithDelegate(id delegate) {
	RXTestObjectRef result = RXCreate(sizeof(struct RXTestObject), &RXTestObjectType);
	result->self = result;
	result->delegate = delegate;
	return result;
}


@interface RXObjectTests : SenTestCase <RXTestObjectDelegate> {
	RXObjectRef object;
	BOOL deallocateWasCalled;
	NSAutoreleasePool *pool;
}
@end

@implementation RXObjectTests

-(void)setUp {
	pool = [[NSAutoreleasePool alloc] init];
	deallocateWasCalled = false;
	object = (RXObjectRef)[(id)RXTestObjectCreateWithDelegate(self) retain];
}

-(void)tearDown {
	[(id)object release];
	[pool release];
}


// test can be a member in a CF collection

-(void)testRetainIncrementsReferenceCount {
	if(!RXCollectionEnabled()) {
		[pool drain]; pool = nil;
		RXAssertEquals(CFGetRetainCount(object), 1);
		RXAssertEquals(CFGetRetainCount(CFRetain(object)), 2);
		RXAssertEquals(CFGetRetainCount(CFRetain(object)), 3);
		RXAssertEquals(CFGetRetainCount(CFRetain(object)), 4);
	}
}

-(void)testReleaseDecrementsReferenceCount {
	if(!RXCollectionEnabled()) {
		[pool drain]; pool = nil;
		RXAssertEquals(CFGetRetainCount(object), 1);
		RXAssertEquals(CFGetRetainCount(CFRetain(object)), 2);
		CFRelease(object);
		RXAssertEquals(CFGetRetainCount(object), 1);
	}
}

-(void)testLastReleaseTriggersDeallocateUnderRetainRelease {
	if(RXCollectionEnabled()) {
		RXAssertFalse(deallocateWasCalled);
		CFRelease(object); // no op
		RXAssertFalse(deallocateWasCalled);
	}
}

-(void)testLastReleaseDoesNotTriggerDeallocateUnderGarbageCollection {
	if(!RXCollectionEnabled()) {
		[pool drain]; pool = nil;
		
		RXAssertFalse(deallocateWasCalled);
		CFRelease(object);
		RXAssert(deallocateWasCalled);
	}
}

-(void)testNewObjectsHaveBeenRetained {
	if(!RXCollectionEnabled()) {
		[pool drain]; pool = nil;
		RXAssertEquals(CFGetRetainCount(object), 1);
	}
}

-(void)testEqualityTestsArePolymorphic {
	RXObjectRef other = RXTestObjectCreateWithDelegate(NULL);
	RXAssertFalse(RXEquals(object, other));
	
	RXTestObjectRef same = RXTestObjectCreateWithDelegate(self);
	RXAssert(RXEquals(object, same));
}


-(void)deallocateWasCalled {
	deallocateWasCalled = true;
}

@end
