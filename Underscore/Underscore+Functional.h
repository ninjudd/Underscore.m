//
//  Underscore+Functional.h
//  Underscore
//
//  Created by Robert Böhnke on 7/15/12.
//  Copyright (c) 2012 Robert Böhnke. All rights reserved.
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

@interface Underscore (FunctionalStyle)

#pragma mark NSArray functional style methods

+ (USArrayWrapper *(^)(NSArray *))array;

+ (USArrayWrapper *(^)(NSRange))arrayRange;
+ (NSArray *(^)(NSRange, UnderscoreMapIndexBlock))mapRange;

+ (id (^)(NSArray *))first;
+ (id (^)(NSArray *))last;
+ (NSArray *(^)(NSArray *))rest;
+ (NSArray *(^)(NSArray *))butLast;

+ (NSArray *(^)(NSArray *array, NSUInteger n))head;
+ (NSArray *(^)(NSArray *array, NSUInteger n))tail;
+ (NSArray *(^)(NSArray *array, NSUInteger n))drop;
+ (NSArray *(^)(NSArray *array, NSUInteger n))dropLast;

+ (NSArray *(^)(NSArray *, UnderscoreTestBlock))takeWhile;
+ (NSArray *(^)(NSArray *, UnderscoreTestBlock))dropWhile;

+ (NSArray *(^)(NSArray *array, NSArray *more))into;
+ (NSArray *(^)(NSArray *array, id obj))conj;

+ (NSUInteger (^)(NSArray *array, id obj))indexOf;

+ (NSArray *(^)(NSArray *array))cat;
+ (NSArray *(^)(NSArray *array))flatten;
+ (NSArray *(^)(NSArray *array, NSArray *values))without;

+ (NSArray *(^)(NSArray *array))shuffle;
+ (NSArray *(^)(NSArray *array))reverse;

+ (id (^)(NSArray *array, id memo, UnderscoreReduceBlock block))reduce;
+ (id (^)(NSArray *array, id memo, UnderscoreReduceBlock block))reduceRight;
+ (NSInteger (^)(NSArray *array, UnderscoreIntegerMapBlock block))sumIntegers;

+ (void (^)(NSArray *array, UnderscoreArrayIteratorBlock block))arrayEach;
+ (NSArray *(^)(NSArray *array, UnderscoreArrayMapBlock block))arrayMap;
+ (NSArray *(^)(NSArray *array, UnderscoreArrayMapBlock block))mapCat;
+ (NSArray *(^)(NSArray *firstArray, NSArray *secondArray, UnderscoreArrayZipWithBlock block))arrayZipWith;

+ (NSArray *(^)(NSArray *firstArray, NSArray *secondArray))interpose;
+ (NSArray *(^)(NSArray *firstArray, NSArray *secondArray))interleave;
+ (NSArray *(^)(NSArray *array, NSUInteger num))partition;

+ (NSDictionary *(^)(NSArray *array, UnderscoreArrayMapBlock block))mapTo;
+ (NSDictionary *(^)(NSArray *array, UnderscoreArrayMapBlock block))mapFrom;
+ (NSDictionary *(^)(NSArray *array, UnderscoreArrayMapBlock block))indexBy;
+ (NSDictionary *(^)(NSArray *))arrayDict;

+ (NSDictionary *(^)(NSArray *))frequencies;
+ (NSDictionary *(^)(NSArray *))positions;

+ (NSArray *(^)(NSArray *array, NSString *keyPath))pluck;

+ (NSArray *(^)(NSArray *array))uniq;
+ (NSArray *(^)(NSArray *array, UnderscoreArrayMapBlock block))uniqOn;

+ (id (^)(NSArray *array, UnderscoreTestBlock block))find;

+ (NSArray *(^)(NSArray *array, UnderscoreTestBlock block))filter;
+ (NSArray *(^)(NSArray *array, UnderscoreTestBlock block))reject;

+ (BOOL (^)(NSArray *array, UnderscoreTestBlock block))all;
+ (BOOL (^)(NSArray *array, UnderscoreTestBlock block))any;

+ (NSArray *(^)(NSArray *array, UnderscoreSortBlock block))sort;
+ (NSArray *(^)(NSArray *array, UnderscoreArrayMapBlock block))sortBy;
+ (NSArray *(^)(NSArray *array, UnderscoreArrayMapBlock block))reverseSortBy;

+ (id(^)(NSArray *))min;
+ (id(^)(NSArray *))max;

#pragma mark NSDictionary style methods

+ (USDictionaryWrapper *(^)(NSDictionary *dictionary))dict;

+ (NSArray *(^)(NSDictionary *dictionary))keys;
+ (NSArray *(^)(NSDictionary *dictionary))values;
+ (NSArray *(^)(NSDictionary *dictionary))sortedKeys;
+ (NSArray *(^)(NSDictionary *dictionary))dictArray;

+ (NSDictionary *(^)(NSDictionary *dictionary, id key, id value))assoc;
+ (NSDictionary *(^)(NSDictionary *dictionary, id key))dissoc;

+ (void (^)(NSDictionary *dictionary, UnderscoreDictionaryIteratorBlock block))dictEach;
+ (NSDictionary *(^)(NSDictionary *dictionary, UnderscoreDictionaryMapBlock block))dictMap;

+ (NSDictionary *(^)(NSDictionary *dictionary, UnderscoreArrayMapBlock block))mapKeys;
+ (NSDictionary *(^)(NSDictionary *dictionary, UnderscoreArrayMapBlock block))mapValues;

+ (NSDictionary *(^)(NSDictionary *dictionary, NSArray *keys))pick;

+ (NSDictionary *(^)(NSDictionary *dictionary, NSDictionary *source))extend;
+ (NSDictionary *(^)(NSDictionary *dictionary, NSDictionary *defaults))defaults;

+ (NSDictionary *(^)(NSDictionary *dictionary, UnderscoreTestBlock block))filterKeys;
+ (NSDictionary *(^)(NSDictionary *dictionary, UnderscoreTestBlock block))filterValues;

+ (NSDictionary *(^)(NSDictionary *dictionary, UnderscoreTestBlock block))rejectKeys;
+ (NSDictionary *(^)(NSDictionary *dictionary, UnderscoreTestBlock block))rejectValues;

+ (NSDictionary *(^)(NSDictionary *dictionary, NSDictionary *other, UnderscoreReduceBlock block))mergeWith;

@end
