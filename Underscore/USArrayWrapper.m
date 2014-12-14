//
//  USArrayWrapper.m
//  Underscore
//
//  Created by Robert Böhnke on 5/13/12.
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

#import "USArrayWrapper.h"

@interface USArrayWrapper ()

- initWithArray:(NSArray *)array;

@property (readwrite, retain) NSArray *array;

@end

@implementation USArrayWrapper

#pragma mark Class methods

+ (USArrayWrapper *)wrap:(NSArray *)array
{
    return [[USArrayWrapper alloc] initWithArray:[array copy]];
}

#pragma mark Lifecycle

- (id)init
{
    return [super init];
}

- (id)initWithArray:(NSArray *)array
{
    if (self = [super init]) {
        self.array = array;
    }
    return self;
}

@synthesize array = _array;

- (NSArray *)unwrap
{
    return [self.array copy];
}

#pragma mark Underscore methods

- (id)first
{
    return self.array.count ? [self.array objectAtIndex:0] : nil;
}

- (id)last
{
    return self.array.lastObject;
}

- (USArrayWrapper*)rest
{
    return self.drop(1);
}

- (USArrayWrapper*)butLast
{
    return self.head(self.array.count - 1);
}

- (USArrayWrapper *(^)(NSUInteger))head
{
    return ^USArrayWrapper *(NSUInteger count) {
        NSRange    range     = NSMakeRange(0, MIN(self.array.count, count));
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
        NSArray    *result   = [self.array objectsAtIndexes:indexSet];

        return [[USArrayWrapper alloc] initWithArray:result];
    };
}

- (USArrayWrapper *(^)(NSUInteger))tail
{
    return ^USArrayWrapper *(NSUInteger count) {
        NSRange range;
        if (count > self.array.count) {
            range = NSMakeRange(0, self.array.count);
        } else {
            range = NSMakeRange(self.array.count - count, count);
        }

        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
        NSArray    *result   = [self.array objectsAtIndexes:indexSet];

        return [[USArrayWrapper alloc] initWithArray:result];
    };
}

- (USArrayWrapper *(^)(NSUInteger))drop
{
    return ^USArrayWrapper *(NSUInteger count) {
        NSUInteger start     = MIN(count, self.array.count);
        NSRange    range     = NSMakeRange(start, self.array.count - start);
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
        NSArray *result      = [self.array objectsAtIndexes:indexSet];
        return [[USArrayWrapper alloc] initWithArray:result];
    };
}

- (USArrayWrapper *(^)(NSUInteger))dropLast
{
    return ^USArrayWrapper *(NSUInteger count) {
        NSUInteger length    = count < self.array.count ? self.array.count - count : 0;
        NSRange    range     = NSMakeRange(0, length);
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
        NSArray *result      = [self.array objectsAtIndexes:indexSet];
        return [[USArrayWrapper alloc] initWithArray:result];
    };
}

- (USArrayWrapper *(^)(UnderscoreTestBlock))takeWhile
{
    return ^USArrayWrapper *(UnderscoreTestBlock test) {
        NSInteger index = 0;
        for (id object in self.array) {
            if (!test(object)) break;
            index++;
        }
        return self.head(index);
    };
}

- (USArrayWrapper *(^)(UnderscoreTestBlock))dropWhile
{
    return ^USArrayWrapper *(UnderscoreTestBlock test) {
        NSInteger count = 0;
        for (id object in self.array) {
            if (!test(object)) break;
            count++;
        }
        return self.drop(count);
    };
}

- (USArrayWrapper *(^)(NSArray*))into
{
    return ^USArrayWrapper *(NSArray *more) {
        if (more) {
            NSArray *result = [self.array arrayByAddingObjectsFromArray:more];
            return [[USArrayWrapper alloc] initWithArray:result];
        } else {
            return self;
        }
    };
}

- (USArrayWrapper *(^)(id))conj
{
    return ^USArrayWrapper *(id item) {
        NSArray *result = [self.array arrayByAddingObject:item];
        return [[USArrayWrapper alloc] initWithArray:result];
    };
}

- (NSUInteger (^)(id))indexOf
{
    return ^NSUInteger (id obj) {
        return [self.array indexOfObject:obj];
    };
}

- (USArrayWrapper *)cat
{
    NSMutableArray *result = [NSMutableArray new];
    for (NSArray *subarray in self.array) {
        for (id obj in subarray) {
            [result addObject:obj];
        }
    }
    return [[USArrayWrapper alloc] initWithArray:result];
}

- (USArrayWrapper *)flatten
{
    __weak NSArray *array = self.array;
    __block NSArray *(^flatten)(NSArray *) = ^NSArray *(NSArray *input) {
        NSMutableArray *result = [NSMutableArray array];

        for (id obj in input) {
            if ([obj isKindOfClass:[NSArray class]]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-retain-cycles"
                [result addObjectsFromArray:flatten(obj)];
#pragma clang diagnostic pop
            } else {
                [result addObject:obj];
            }
        }

        // If the outmost call terminates, nil the reference to flatten to break
        // the retain cycle
        if (input == array) {
            flatten = nil;
        }

        return result;
    };

    return [USArrayWrapper wrap:flatten(self.array)];
}

- (USArrayWrapper *(^)(NSArray *))without
{
    return ^USArrayWrapper *(NSArray *value) {
        return self.reject(^(id obj){
            return [value containsObject:obj];
        });
    };
}

- (USArrayWrapper *)shuffle
{
    NSMutableArray *result = [self.array mutableCopy];

    for (NSInteger i = result.count - 1; i > 0; i--) {
        [result exchangeObjectAtIndex:arc4random() % (i + 1)
                    withObjectAtIndex:i];
    }

    return [[USArrayWrapper alloc] initWithArray:result];
}

- (USArrayWrapper *)reverse
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:self.array.count];
    NSEnumerator *enumerator = [self.array reverseObjectEnumerator];

    for (id object in enumerator) {
        [result addObject:object];
    }

    return [[USArrayWrapper alloc] initWithArray:result];
}


- (id (^)(id, UnderscoreReduceBlock))reduce
{
    return ^USArrayWrapper *(id memo, UnderscoreReduceBlock function) {
        for (id obj in self.array) {
            memo = function(memo, obj);
        }

        return memo;
    };
}

- (id (^)(id, UnderscoreReduceBlock))reduceRight
{
    return ^USArrayWrapper *(id memo, UnderscoreReduceBlock function) {
        for (id obj in self.array.reverseObjectEnumerator) {
            memo = function(memo, obj);
        }

        return memo;
    };
}

- (NSInteger (^)(UnderscoreIntegerMapBlock))sumIntegers
{
    return ^NSInteger(UnderscoreIntegerMapBlock block) {
        NSInteger sum = 0;
        for (id obj in self.array) {
            sum += block(obj);
        }
        return sum;
    };
}

- (USArrayWrapper *(^)(UnderscoreArrayIteratorBlock))each
{
    return ^USArrayWrapper *(UnderscoreArrayIteratorBlock block) {
        for (id obj in self.array) {
            block(obj);
        }

        return self;
    };
}

- (USArrayWrapper *(^)(UnderscoreArrayMapBlock))map
{
    return ^USArrayWrapper *(UnderscoreArrayMapBlock block) {
        NSMutableArray *result = [NSMutableArray arrayWithCapacity:self.array.count];

        for (id obj in self.array) {
            id mapped = block(obj);

            if (mapped) {
                [result addObject:mapped];
            }
        }

        return [[USArrayWrapper alloc] initWithArray:result];
    };
}

- (USArrayWrapper *(^)(UnderscoreArrayMapBlock))mapCat
{
    return ^USArrayWrapper *(UnderscoreArrayMapBlock block) {
        NSMutableArray *result = [NSMutableArray arrayWithCapacity:self.array.count];

        for (id obj in self.array) {
            for (id item in block(obj)) {
                [result addObject:item];
            }
        }

        return [[USArrayWrapper alloc] initWithArray:result];
    };
}

- (USArrayWrapper *(^)(NSArray *array, UnderscoreArrayZipWithBlock block))zipWith
{
    return ^USArrayWrapper *(NSArray *array, UnderscoreArrayZipWithBlock block) {
        NSMutableArray *result = [NSMutableArray arrayWithCapacity:self.array.count];
        if(self.array.count <= array.count) {
            [self.array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [result addObject:block(obj, array[idx])];
            }];
        } else {
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [result addObject:block(self.array[idx], obj)];
            }];
        }
        return [[USArrayWrapper alloc] initWithArray:result];
    };
}

- (USArrayWrapper *(^)(NSArray *array))interpose
{
    return ^USArrayWrapper *(NSArray *array) {
        NSMutableArray *result = [NSMutableArray arrayWithCapacity:self.array.count * (array.count + 1)];
        for (NSUInteger idx = 0; idx < self.array.count; idx++) {
            [result addObject:self.array[idx]];
            if (idx != self.array.count - 1) {
                [result addObjectsFromArray:array];
            }
        }
        return [[USArrayWrapper alloc] initWithArray:result];
    };
}

- (USArrayWrapper *(^)(NSArray *array))interleave
{
    return ^USArrayWrapper *(NSArray *array) {
        NSMutableArray *result = [NSMutableArray arrayWithCapacity:self.array.count + array.count];
        NSUInteger max = MAX(self.array.count, array.count);
        for (NSUInteger idx = 0; idx < max; idx++) {
            if (idx < self.array.count) {
                [result addObject:self.array[idx]];
            }
            if (idx < array.count) {
                [result addObject:array[idx]];
            }
        }
        return [[USArrayWrapper alloc] initWithArray:result];
    };
}

- (USArrayWrapper *(^)(NSUInteger n))partition
{
    return ^USArrayWrapper *(NSUInteger num) {
        NSMutableArray *result = [NSMutableArray arrayWithCapacity:self.array.count/num];
        __block NSMutableArray *group = nil;
        [self.array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if (idx % num == 0) {
                if (group) [result addObject:[NSArray arrayWithArray:group]];
                group = [NSMutableArray arrayWithCapacity:num];
            }
            [group addObject:obj];
        }];
        if (group) [result addObject:[NSArray arrayWithArray:group]];

        return [[USArrayWrapper alloc] initWithArray:result];
    };
}

- (NSDictionary *(^)(UnderscoreArrayMapBlock))mapTo
{
    return ^NSDictionary *(UnderscoreArrayMapBlock block) {
        NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:self.array.count];

        for (id obj in self.array) {
            if (![result objectForKey:obj]) {
                id mapped = block(obj);
                if (mapped) {
                    [result setObject:mapped forKey:obj];
                }
            }
        }

        return [NSDictionary dictionaryWithDictionary:result];
    };
}

- (NSDictionary *(^)(UnderscoreArrayMapBlock))mapFrom
{
    return ^NSDictionary *(UnderscoreArrayMapBlock block) {
        NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:self.array.count];

        for (id obj in self.array) {
            id mapped = block(obj);
            if (mapped && ![result objectForKey:mapped]) {
                [result setObject:obj forKey:mapped];
            }
        }

        return [NSDictionary dictionaryWithDictionary:result];
    };
}

- (NSDictionary *(^)(UnderscoreArrayMapBlock))indexBy
{
    return ^NSDictionary *(UnderscoreArrayMapBlock block) {
        NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:self.array.count];

        for (id obj in self.array) {
            id index = block(obj);
            for (id key in index) {
                NSMutableArray *values = [result objectForKey:key];
                if (!values) {
                    values = [NSMutableArray new];
                    [result setObject:values forKey:key];
                }
                [values addObject:obj];
            }
        }

        for (id key in result.allKeys) { // Make all value arrays immutable.
            [result setObject:[NSArray arrayWithArray:[result objectForKey:key]] forKey:key];
        }

        return [NSDictionary dictionaryWithDictionary:result];
    };
}

- (NSDictionary *)dict
{
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:self.array.count];
    for (USDictionaryEntry *entry in self.array) {
        [result setObject:entry.value forKey:entry.key];
    }
    return [NSDictionary dictionaryWithDictionary:result];
}

- (NSDictionary *)frequencies
{
    NSMutableDictionary *counts = [NSMutableDictionary dictionaryWithCapacity:self.array.count];
    for (id object in self.array) {
        NSNumber *count = [counts objectForKey:object];
        if (!count) count = @0;
        [counts setObject:[NSNumber numberWithInt:[count intValue] + 1] forKey:object];
    }
    return [NSDictionary dictionaryWithDictionary:counts];
}

- (NSDictionary *)positions
{
    NSMutableDictionary *positions = [NSMutableDictionary dictionaryWithCapacity:self.array.count];
    [self.array enumerateObjectsUsingBlock:^(id object, NSUInteger i, BOOL *stop) {
        if (![positions objectForKey:object]) {
            [positions setObject:@(i) forKey:object];
        }
    }];
    return [NSDictionary dictionaryWithDictionary:positions];
}

- (USArrayWrapper *(^)(NSString *))pluck
{
    return ^USArrayWrapper *(NSString *keyPath) {
        return self.map(^id (id obj) {
            return [obj valueForKeyPath:keyPath];
        });
    };
}

- (USArrayWrapper *)uniq
{
    NSOrderedSet *set = [NSOrderedSet orderedSetWithArray:self.array];

    return [[USArrayWrapper alloc] initWithArray:[set array]];
}

- (USArrayWrapper *(^)(UnderscoreArrayMapBlock))uniqOn
{
    return ^USArrayWrapper *(UnderscoreArrayMapBlock block) {
        NSMutableArray *result = [NSMutableArray arrayWithCapacity:self.array.count];
        NSMutableSet *seen = [NSMutableSet setWithCapacity:self.array.count];

        for (id obj in self.array) {
            id key = block(obj);

            if (key && ![seen containsObject:key]) {
                [result addObject:obj];
                [seen addObject:key];
            }
        }

        return [[USArrayWrapper alloc] initWithArray:result];
    };
}

- (id (^)(UnderscoreTestBlock))find
{
    return ^id (UnderscoreTestBlock test) {
        for (id obj in self.array) {
            if (test(obj)) {
                return obj;
            }
        }

        return nil;
    };
}

- (USArrayWrapper *(^)(UnderscoreTestBlock))filter
{
    return ^USArrayWrapper *(UnderscoreTestBlock test) {
        return self.map(^id (id obj) {
            return test(obj) ? obj : nil;
        });
    };
}

- (USArrayWrapper *(^)(UnderscoreTestBlock))reject
{
    return ^USArrayWrapper *(UnderscoreTestBlock test) {
        return self.filter(Underscore.negate(test));
    };
}

- (BOOL (^)(UnderscoreTestBlock))all
{
    return ^BOOL (UnderscoreTestBlock test) {
        if (self.array.count == 0) {
            return NO;
        }

        BOOL result = YES;

        for (id obj in self.array) {
            if (!test(obj)) {
                return NO;
            }
        }

        return result;
    };
}

- (BOOL (^)(UnderscoreTestBlock))any
{
    return ^BOOL (UnderscoreTestBlock test) {
        BOOL result = NO;

        for (id obj in self.array) {
            if (test(obj)) {
                return YES;
            }
        }

        return result;
    };
}

- (USArrayWrapper *(^)(UnderscoreSortBlock))sort
{
    return ^USArrayWrapper *(UnderscoreSortBlock block) {
        NSArray *result = [self.array sortedArrayUsingComparator:block];
        return [[USArrayWrapper alloc] initWithArray:result];
    };
}

- (USArrayWrapper *(^)(UnderscoreArrayMapBlock))sortBy
{
    return ^USArrayWrapper *(UnderscoreArrayMapBlock block) {
        NSArray *result = [self.array sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            return [block(a) compare:block(b)];
        }];

        return [[USArrayWrapper alloc] initWithArray:result];
    };
}

- (USArrayWrapper *(^)(UnderscoreArrayMapBlock))reverseSortBy
{
    return ^USArrayWrapper *(UnderscoreArrayMapBlock block) {
        NSArray *result = [self.array sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            return [block(b) compare:block(a)];
        }];

        return [[USArrayWrapper alloc] initWithArray:result];
    };
}

- (id)min
{
    id min = nil;
    for (id object in self.array) {
        if (!min || [min compare:object] == NSOrderedDescending) {
            min = object;
        }
    }
    return min;
}

- (id)max
{
    id max = nil;
    for (id object in self.array) {
        if (!max || [max compare:object] == NSOrderedAscending) {
            max = object;
        }
    }
    return max;
}

@end
