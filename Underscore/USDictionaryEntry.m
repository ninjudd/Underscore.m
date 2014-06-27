//
//  USDictionaryEntry.m
//  Underscore
//
//  Created by Justin Balthrop on 6/27/14.
//  Copyright (c) 2014 Robert Böhnke. All rights reserved.
//

#import "USDictionaryEntry.h"

@implementation USDictionaryEntry

- (instancetype)initWithKey:(id)key value:(id)value {
    self = [super init];
    if (self) {
        _key = key;
        _value = value;
    }
    return self;
}

- (instancetype)copyWithZone:(NSZone *)zone
{
    return [[[self class] alloc] initWithKey:[self.key copyWithZone:zone] value:[self.value copyWithZone:zone]];
}

@end
