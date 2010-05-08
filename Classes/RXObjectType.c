// RXObjectType.m
// Created by Rob Rix on 2010-04-19
// Copyright 2010 Monochrome Industries

#include "RXObjectType.h"

__strong const char *RXObjectTypeGetName(RXObjectTypeRef self) {
	return self->name;
}