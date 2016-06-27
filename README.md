# XZKeychain
提供了一个非常方便的方法访问“钥匙串”，示例代码：
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
