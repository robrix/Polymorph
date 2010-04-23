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
	RXTestObjectRef result = RX_CREATE(RXTestObject);
	result->self = result;
	result->delegate = delegate;
	return result;
}


@interface RXObjectTests : SenTestCase <RXTestObjectDelegate> {
	RXObjectRef object;
	BOOL deallocateWasCalled;
}
@end

@implementation RXObjectTests

-(void)setUp {
	deallocateWasCalled = false;
	object = RXTestObjectCreateWithDelegate(self);
}

-(void)tearDown {
	RXRelease(object);
}


// test can be a member in a CF collection

-(void)testRetainIncrementsReferenceCount {
	if(!RXCollectionEnabled()) {
		RXAssertEquals(RXGetReferenceCount(object), 1);
		RXAssertEquals(RXGetReferenceCount(RXRetain(object)), 2);
		RXAssertEquals(RXGetReferenceCount(RXRetain(object)), 3);
		RXAssertEquals(RXGetReferenceCount(RXRetain(object)), 4);
	}
}

-(void)testReleaseDecrementsReferenceCount {
	if(!RXCollectionEnabled()) {
		RXAssertEquals(RXGetReferenceCount(object), 1);
		RXAssertEquals(RXGetReferenceCount(RXRetain(object)), 2);
		RXRelease(object);
		RXAssertEquals(RXGetReferenceCount(object), 1);
	}
}

-(void)testLastReleaseTriggersDeallocateUnderRetainRelease {
	if(RXCollectionEnabled()) {
		RXAssertFalse(deallocateWasCalled);
		RXRelease(object); // no op
		RXAssertFalse(deallocateWasCalled);
	}
}

-(void)testLastReleaseDoesNotTriggerDeallocateUnderGarbageCollection {
	if(!RXCollectionEnabled()) {
		RXAssertFalse(deallocateWasCalled);
		RXRelease(object);
		RXAssert(deallocateWasCalled);
	}
}

-(void)testNewObjectsHaveBeenRetained {
	RXAssertEquals(RXGetReferenceCount(object), RXCollectionEnabled() ? 0 : 1);
}

-(void)testEqualityTestsArePolymorphic {
	RXObjectRef other = RXTestObjectCreateWithDelegate(NULL);
	RXAssertFalse(RXEquals(object, other));
	
	RXTestObjectRef same = RXTestObjectCreateWithDelegate(self);
	RXAssert(RXEquals(object, same));
}

-(void)testReleasingNullIsANoOp {
	RXObjectRef nullObject = NULL;
	RXRelease(nullObject);
	RXAssertEquals(nullObject, NULL);
}

-(void)testRetainingNullIsANoOp {
	RXAssertEquals(RXRetain(NULL), NULL);
}


-(void)deallocateWasCalled {
	deallocateWasCalled = true;
}

@end
