#   XZKeychain
##  对“钥匙串”接口的封装
*   1，XZKeychain 基类，提供了一系列基本的方法，对“钥匙串”属性熟悉的同学可以直接通过基类提供的方法创建、修改钥匙串；
*   2，XZKeychain 类目，提供了方便的接口操作具体类型的钥匙串，不过目前只提供了“通用密码”钥匙串的接口；
*   3，对其它类型钥匙串访问的接口，将会通过追加类目的方式扩充，以实现版本的无缝兼容；
*   4，XZKeychain 从设计上来讲，更像是“钥匙串”的一个缓存，在创建一个对象时，从钥匙串中读取数据并保存；
*   5，因此，对 XZKeychain 对象的属性操作，并不立即体现在钥匙串属性的更改；
*   6，通过调用接口 -(void)writeToKeychainStore: 方法，所有属性的更改才会最终保存到钥匙串；
*   7，因为获取钥匙串的操作，实际上是个查询操作，从理论上来讲，查询得到的结果往往是多个；
*   8，为了保证钥匙串的唯一性，XZKeychain 被设计为通过钥匙串属性的设置来唯一确定一个钥匙串；
*   9，XZKeychain 没有显式提供创建钥匙串的接口，开发者可以通过唯一的属性（或属性组合）来直接创建新的钥匙串。


##### 通用钥匙串的使用示例代码：

```objective-c
    NSString *identifer = @"anIdentifier";
    XZKeychain *keychain = [[XZKeychain alloc] initWithIdentifier:identifer];
    NSLog(@"account: %@", keychain.account);
    NSLog(@"password: %@", keychain.password);
    keychain.account = @"aNewAccount";
    keychain.password = @"aNewPassword";
    NSError *error = nil;
    if ([keychain writeToKeychainStore:&error]) {
        NSLog(@"保存成功");
    } else {
        NSLog(@"保存失败:%@", error.localizedDescription);
    }
    error = nil;
    if ([keychain deleteFromKeychainStore:&error]) {
        NSLog(@"删除成功");
    } else {
        NSLog(@"删除失败：%@", error.localizedDescription);
    }
```
