//
//  SwiftyKVStore.swift
//  SwiftyKVStore
//
//  Created by xuyecan on 24/10/2017.
//  Copyright © 2017 xuyecan. All rights reserved.
//

import Foundation
import StorePrivate

public final class SwiftyKVStore {

    var store: Store

    public init(name: String) {
        self.store = Store(dbName: name)
    }

    public func put(key: String, value: String) {
        store.put(key, value: value)
    }

    public func get(key: String) -> String? {
        return store.get(key)
    }

    public func delete(key: String) {
        store.delete(key)
    }

    deinit {
        store.close()
    }
}
