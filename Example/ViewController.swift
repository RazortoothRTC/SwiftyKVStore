//
//  ViewController.swift
//  Example
//
//  Created by xuyecan on 24/10/2017.
//  Copyright © 2017 xuyecan. All rights reserved.
//

import UIKit

import SwiftyKVStore

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

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

        kvStore.deleteAll(name: "test1")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

