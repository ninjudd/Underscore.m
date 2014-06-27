//
//  USDictionaryEntry.h
//  Underscore
//
//  Created by Justin Balthrop on 6/27/14.
//  Copyright (c) 2014 Robert Böhnke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface USDictionaryEntry : NSObject <NSCopying>

@property (readonly) id key;
@property (readonly) id value;

- (instancetype)initWithKey:(id)key value:(id)value;

@end
