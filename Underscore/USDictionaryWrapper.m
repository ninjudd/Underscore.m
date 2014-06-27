//
//  USDictionaryWrapper.m
//  Underscore
//
//  Created by Robert Böhnke on 5/14/12.
//  Copyright (C) 2012 Robert Böhnke
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//

#import "Underscore.h"

#import "USDictionaryWrapper.h"
#import "USDictionaryEntry.h"

@interface USDictionaryWrapper ()

- initWithDictionary:(NSDictionary *)dictionary;

@property (readwrite, retain) NSDictionary *dictionary;

@end

@implementation USDictionaryWrapper

#pragma mark Class methods

+ (USDictionaryWrapper *)wrap:(NSDictionary *)dictionary
{
    return [[USDictionaryWrapper alloc] initWithDictionary:[dictionary copy]];
}

#pragma mark Lifecycle

- (id)init
{
    return [super init];
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        self.dictionary = dictionary;
    }
    return self;
}
@synthesize dictionary = _dictionary;

- (NSDictionary *)unwrap
{
    return [self.dictionary copy];
}

#pragma mark Underscore methods

- (USArrayWrapper *)keys
{
    return [USArrayWrapper wrap:self.dictionary.allKeys];
}

- (USArrayWrapper *)values
{
    return [USArrayWrapper wrap:self.dictionary.allValues];
}

- (USArrayWrapper *)array
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:self.dictionary.count];
    for (id key in self.dictionary.allKeys) {
        id value = [self.dictionary objectForKey:key];
        [result addObject:[[USDictionaryEntry alloc] initWithKey:key value:value]];
    }
    return [USArrayWrapper wrap:result];
}

- (USDictionaryWrapper *(^)(id, id))assoc
{
    return ^USDictionaryWrapper *(id key, id value) {
        if (key && value) {
            __block NSMutableDictionary *result = [self.dictionary mutableCopy];
            [result setObject:value forKey:key];
            return [[USDictionaryWrapper alloc] initWithDictionary:result];
        } else {
            return self;
        }
    };
}

- (USDictionaryWrapper *(^)(id))dissoc
{
    return ^USDictionaryWrapper *(id key) {
        if (key) {
            __block NSMutableDictionary *result = [self.dictionary mutableCopy];
            [result removeObjectForKey:key];
            return [[USDictionaryWrapper alloc] initWithDictionary:result];
        } else {
            return self;
        }
    };
}

- (USDictionaryWrapper *(^)(UnderscoreDictionaryIteratorBlock))each
{
    return ^USDictionaryWrapper *(UnderscoreDictionaryIteratorBlock block) {
        [self.dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            block(key, obj);
        }];

        return self;
    };
}

- (USDictionaryWrapper *(^)(UnderscoreDictionaryMapBlock))map
{
    return ^USDictionaryWrapper *(UnderscoreDictionaryMapBlock block) {
        NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:self.dictionary.count];

        [self.dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            id mapped = block(key, obj);

            if (mapped) {
                [result setObject:mapped
                           forKey:key];
            }
        }];

        return [[USDictionaryWrapper alloc] initWithDictionary:result];
    };
}

- (USDictionaryWrapper *(^)(UnderscoreArrayMapBlock))mapKeys
{
    return ^USDictionaryWrapper *(UnderscoreArrayMapBlock block) {
        NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:self.dictionary.count];

        [self.dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [result setObject:obj forKey:block(key)];
        }];

        return [[USDictionaryWrapper alloc] initWithDictionary:result];
    };
}

- (USDictionaryWrapper *(^)(UnderscoreArrayMapBlock))mapValues
{
    return ^USDictionaryWrapper *(UnderscoreArrayMapBlock block) {
        NSMutableDictionary *result = [NSMutableDictionary dictionary];

        [self.dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [result setObject:block(obj) forKey:key];
        }];

        return [[USDictionaryWrapper alloc] initWithDictionary:result];
    };
}

- (USDictionaryWrapper *(^)(NSArray *))pick
{
    return ^USDictionaryWrapper *(NSArray *keys) {
        __block NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:keys.count];

        [self.dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if ([keys containsObject:key]) {
                [result setObject:obj
                           forKey:key];
            }
        }];

        return [[USDictionaryWrapper alloc] initWithDictionary:result];
    };
}

- (USDictionaryWrapper *(^)(NSDictionary *))extend
{
    return ^USDictionaryWrapper *(NSDictionary *source) {
        __block NSMutableDictionary *result = [self.dictionary mutableCopy];

        [source enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [result setObject:obj
                       forKey:key];
        }];

        return [[USDictionaryWrapper alloc] initWithDictionary:result];
    };
}

- (USDictionaryWrapper *(^)(NSDictionary *))defaults
{
    return ^USDictionaryWrapper *(NSDictionary *source) {
        __block NSMutableDictionary *result = [self.dictionary mutableCopy];

        [source enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if (![result valueForKey:key]) {
                [result setObject:obj
                           forKey:key];
            }
        }];

        return [[USDictionaryWrapper alloc] initWithDictionary:result];
    };
}

- (USDictionaryWrapper *(^)(UnderscoreTestBlock))filterKeys
{
    return ^USDictionaryWrapper *(UnderscoreTestBlock test) {
        return self.map(^id (id key, id obj) {
            return test(key) ? obj : nil;
        });
    };
}

- (USDictionaryWrapper *(^)(UnderscoreTestBlock))filterValues
{
    return ^USDictionaryWrapper *(UnderscoreTestBlock test) {
        return self.map(^id (id key, id obj) {
            return test(obj) ? obj : nil;
        });
    };
}

- (USDictionaryWrapper *(^)(UnderscoreTestBlock))rejectKeys
{
    return ^USDictionaryWrapper *(UnderscoreTestBlock test) {
        return self.filterKeys(Underscore.negate(test));
    };
}

- (USDictionaryWrapper *(^)(UnderscoreTestBlock))rejectValues
{
    return ^USDictionaryWrapper *(UnderscoreTestBlock test) {
        return self.filterValues(Underscore.negate(test));
    };
}

- (USDictionaryWrapper *(^)(NSDictionary *, UnderscoreReduceBlock))mergeWith
{
    return ^USDictionaryWrapper *(NSDictionary *other, UnderscoreReduceBlock block) {
        NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:self.dictionary];
        [other enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            id existing = [result objectForKey:key];
            if (existing) {
                id new = block(existing, obj);
                if (new) {
                    [result setObject:new forKey:key];
                } else {
                    [result removeObjectForKey:key];
                }
            } else {
                [result setObject:obj forKey:key];
            }
        }];
        return [[USDictionaryWrapper alloc] initWithDictionary:result];
    };
}

@end
