# SwiftyKVStore

Another simple Key/Value store for Swift backed by [Unqlite](https://unqlite.org/).

By extracting the minimum feature set of `Unqlite`, `SwiftyKVStore` is really simple from top to bottom.

# Install

```bash
pod 'SwiftyKVStore', '~> 0.1.0.alpha'
```

# Usage

```swift
let kvStore = SwiftyKVStore(name: "test1")

kvStore.put(key: "key1", value: "value1")

if let value = kvStore.get(key: "key1") {
    print("value: \(value)")
}

kvStore.delete(key: "key1")

if let value = kvStore.get(key: "key1") {
    print("value: \(value)")
} else {
    print("nothing")
}
```

# License

Apache License Version 2.0.
