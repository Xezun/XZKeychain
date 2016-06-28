#   XZKeychain
##  对“钥匙串”接口的封装
*   1，XZKeychain 提供了一系列基本的方法，但是本身并不直接读取钥匙串；如果要获取已有的钥匙串，需要使用它的分类提供的方法；
*   2，目前（2016年06月28日）只提供了通用钥匙串的接口，对其它类型钥匙串访问的接口，以后的版本可能会提供；
*   3，XZKeychain 初始化（具体分类的方法）一个对象时，会自动从钥匙串中读取数据，并缓存起来；
*   4，对 XZKeychain 对象的属性操作，只是对缓存的更改；要将钥匙串保存起来，要调用通用接口 -(void)writeToKeychainStore: 方法；
*   5，没有显式提供创建钥匙串的接口，但其实创建 XZKeychain 对象就表示创建钥匙串，保存的时候，会自动根据当前的属性设置创建新的钥匙串。


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
