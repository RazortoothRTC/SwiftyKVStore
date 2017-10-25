//
//  ViewController.swift
//  Example
//
//  Created by xuyecan on 24/10/2017.
//  Copyright © 2017 xuyecan. All rights reserved.
//

import UIKit

import SwiftyKVStore

private let ALYUniconfLocalCacheKey = "ALYUniconfLocalCacheKey"

class ViewController: UIViewController {

    private var kvStore: SwiftyKVStore!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        kvStore = SwiftyKVStore(name: "aly_uniconf_cache_kv_store")
        // kvStore.put(key: ALYUniconfLocalCacheKey, value: "bcc")

        if let value = kvStore.get(key: ALYUniconfLocalCacheKey) {
            print("value: \(value)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

