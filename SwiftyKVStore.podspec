Pod::Spec.new do |s|
    s.author = {'xuyecan' => 'xuyecan@gmail.com'}
    s.license = 'Apache License 2.0'
    s.requires_arc = true
    s.version = '0.3.0'
    s.homepage = "https://github.com/xuyecan/SwiftyKVStore"
    s.name = "SwiftyKVStore"

    s.source_files = 'SwiftyKVStore/**/*.{h,m,mm,c,swift}'
    s.public_header_files = 'SwiftyKVStore/SwiftyKVStore.h'
    s.private_header_files = 'SwiftyKVStore/Store.h', 'SwiftyKVStore/Unqlite/*.{h}'
    s.source = { :git => 'https://github.com/xuyecan/SwiftyKVStore.git', :tag => s.version.to_s }

    s.summary = 'Simple Key/Value store for Swift backed by Unqlite.'
    s.description = 'Another Simple Key/Value store for Swift backed by Unqlite.'

    s.ios.deployment_target = '8.0'
    s.preserve_paths = 'SwiftyKVStore/StorePrivate/*'
    s.xcconfig = { 'SWIFT_INCLUDE_PATHS' => '$(PODS_ROOT)/SwiftyKVStore/SwiftyKVStore' }

    s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }
end
