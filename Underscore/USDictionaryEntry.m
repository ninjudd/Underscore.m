//
//  USDictionaryEntry.m
//  Underscore
//
//  Created by Justin Balthrop on 6/27/14.
//  Copyright (c) 2014 Robert Böhnke. All rights reserved.
//

#import "USDictionaryEntry.h"

@implementation USDictionaryEntry

+ (instancetype)entryWithKey:(id)key value:(id)value {
    return [[self alloc] initWithKey:key value:value];
}

- (instancetype)initWithKey:(id)key value:(id)value {
    self = [super init];
    if (self) {
        _key = key;
        _value = value;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"(%@: %@)", self.key, self.value];
}

- (instancetype)copyWithZone:(NSZone *)zone
{
    return [[[self class] alloc] initWithKey:[self.key copyWithZone:zone] value:[self.value copyWithZone:zone]];
}

- (BOOL)isEqualToUSDictionaryEntry:(USDictionaryEntry *)other {
    if (!other) return NO;

    return ((!self.key   && !other.key)   || [self.key   isEqual:other.key]) &&
           ((!self.value && !other.value) || [self.value isEqual:other.value]);
}

#pragma mark - NSObject

- (BOOL)isEqual:(id)object {
    if (self == object) return YES;
    if (![object isKindOfClass:[USDictionaryEntry class]]) return NO;

    return [self isEqualToUSDictionaryEntry:(USDictionaryEntry *)object];
}

- (NSUInteger)hash {
    return [self.key hash] ^ [self.value hash];
}

@end
