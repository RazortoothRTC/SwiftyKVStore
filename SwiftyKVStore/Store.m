//
//  Store.m
//  SwiftyKVStore
//
//  Created by xuyecan on 24/10/2017.
//  Copyright © 2017 xuyecan. All rights reserved.
//

#import "Store.h"

#import "unqlite.h"

@implementation Store {
    unqlite *pDb;

    // since we compile unqlite without multi-thread support(default behaviour),
    // we associate the db operations to a serial queue
    dispatch_queue_t serialWorker;
}

- (instancetype)initWithDBName:(NSString *)dbName {
    self = [super init];
    if (self != nil) {
        serialWorker = dispatch_queue_create("com.xyc.swiftykvstore.serialqueue", DISPATCH_QUEUE_SERIAL);
        [self openDB:dbName];
    }
    return self;
}

- (void)openDB:(NSString *)dbName {
    dispatch_sync(serialWorker, ^{
        NSError *error = nil;
        int rc;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *dbDefaultFolder = [paths[0] stringByAppendingPathComponent:@"/swiftykvstore/"];
        NSFileManager *mgr = [NSFileManager defaultManager];

        if (![mgr fileExistsAtPath:dbDefaultFolder]) {
            [mgr createDirectoryAtPath:dbDefaultFolder withIntermediateDirectories:YES attributes:nil error:&error];
            if (error != nil) {
                NSLog(@"build db direcotry failed, error msg: %@", error);
            }
        }
        NSString *dbFilePath = [dbDefaultFolder stringByAppendingPathComponent:dbName];
        NSLog(@"db %@ store at path: %@", dbName, dbFilePath);
        rc = unqlite_open(&self->pDb, dbFilePath.UTF8String, UNQLITE_OPEN_CREATE);
        if (rc != UNQLITE_OK) {
            NSLog(@"open db failed, error code: %d", rc);
        }
    });
}

- (bool)put:(NSString *)key value:(NSString *)value {
    __block BOOL success;
    dispatch_sync(serialWorker, ^{
        int rc;
        const char *pKey = key.UTF8String;
        const char *pValue = value.UTF8String;

        rc = unqlite_kv_store(self->pDb, pKey, -1, pValue, strlen(pValue) + 1);
        if (rc != UNQLITE_OK) {
            // NSLog(@"store kv failed, error code: %d", rc);
            success = false;
            return;
        }
        rc = unqlite_commit(self->pDb);
        if (rc != UNQLITE_OK) {
            // NSLog(@"commit putting kv failed, error code: %d", rc);
            success = false;
            return;
        }
        success = true;
    });
    return success;
}

- (NSString *)get:(NSString *)key {
    __block NSString *value = nil;
    dispatch_sync(serialWorker, ^{
        int rc;
        unqlite_int64 len;
        const char *pKey = key.UTF8String;

        rc = unqlite_kv_fetch(self->pDb, pKey, -1, NULL, &len);
        if (rc != UNQLITE_OK) {
            // NSLog(@"fetch kv failed, error code: %d", rc);
            return;
        }

        char *valueBuff = (char *)malloc((size_t)len);
        rc = unqlite_kv_fetch(self->pDb, pKey, -1, valueBuff, &len);
        if (rc != UNQLITE_OK) {
            // NSLog(@"fetch kv failed, error code: %d", rc);
            return;
        }
        value = [NSString stringWithUTF8String:valueBuff];
        free(valueBuff);
    });
    return value;
}

- (bool)delete:(NSString *)key {
    __block BOOL success;
    dispatch_sync(serialWorker, ^{
        int rc;
        const char *pKey = key.UTF8String;

        rc = unqlite_kv_delete(self->pDb, pKey, -1);
        if (rc != UNQLITE_OK) {
            success = false;
            // NSLog(@"delete kv failed, error code: %d", rc);
            return;
        }
        rc = unqlite_commit(self->pDb);
        if (rc != UNQLITE_OK) {
            success = false;
            // NSLog(@"commit deleting kv failed, error code: %d", rc);
            return;
        }
        success = true;
    });
    return success;
}

- (bool)deleteAll:(NSString *)dbName {
    __block BOOL success;
    dispatch_sync(serialWorker, ^{

        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *dbDefaultFolder = [paths[0] stringByAppendingPathComponent:@"/swiftykvstore/"];
        NSString *dbFilePath = [dbDefaultFolder stringByAppendingPathComponent:dbName];

        NSFileManager *mgr = [NSFileManager defaultManager];
        NSError *error = nil;
        [mgr removeItemAtPath:dbFilePath error:&error];
        if (error != nil) {
            NSLog(@"delete db %@ failed, error msg: %@", dbName, error);
        }
        NSLog(@"delete db %@ success.", dbName);
        success = true;
    });
    return success;
}

- (void)close {
    dispatch_sync(serialWorker, ^{
        int rc;
        rc = unqlite_close(self->pDb);
        if (rc != UNQLITE_OK) {
            // NSLog(@"close db failed, error code: %d", rc);
        }
    });
}

@end
