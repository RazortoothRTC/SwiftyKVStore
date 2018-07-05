//
//  Store.h
//  SwiftyKVStore
//
//  Created by xuyecan on 24/10/2017.
//  Copyright © 2017 xuyecan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Store : NSObject

- (instancetype)initWithDBName:(NSString *)dbName;

- (bool)put:(NSString *)key value:(NSString *)value;

- (NSString *)get:(NSString *)key;

- (bool)delete:(NSString *)key;

- (bool)deleteAll:(NSString *)dbName;

- (void)close;

@end
