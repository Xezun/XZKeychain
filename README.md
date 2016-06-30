#   XZKeychain
##  对“钥匙串”接口的封装
*   只有一个 XZKeychain 类，目的是简化“钥匙串”接口的访问，支持创建、修改、更新和删除操作。
*   对具体的钥匙串类型，建议使用类目来拓展。
*   简单易用且不失灵活性。

##### 通用钥匙串的使用示例代码：

```objective-c
    {
        NSLog(@"\n\n获取所有钥匙串");
        NSArray<XZKeychain *> *keychains = [XZKeychain allKeychains];
        [keychains enumerateObjectsUsingBlock:^(XZKeychain * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSLog(@"%02lu, %lu, %@, %@, %@", idx, obj.type, obj, obj.identifier, [obj valueForAttribute:(XZKeychainAttributeLabel)]);
        }];
        printf("\n\n");
    }
    
    {
        NSLog(@"\n\n获取分类 XZKeychainTypeGenericPassword 的钥匙串");
        NSArray<XZKeychain *> *keychains = [XZKeychain allKeychainsWithType:(XZKeychainTypeGenericPassword)];
        [keychains enumerateObjectsUsingBlock:^(XZKeychain * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSLog(@"%02lu, %lu, %@, %@, %@", idx, obj.type, obj, obj.identifier, [obj valueForAttribute:(XZKeychainAttributeLabel)]);
        }];
        printf("\n\n");
    }
    
    {
        NSLog(@"\n\n创建钥匙串: kIdentifierForKeychain");
        XZKeychain *keychain = [XZKeychain keychainWithType:(XZKeychainTypeGenericPassword)];
        keychain.identifier = @"kIdentifierForKeychain";
        keychain.account = @"newKeychain";
        keychain.password = @"newPassword";
        NSError *error = nil;
        if ([keychain insert:&error]) {
            NSLog(@"%lu, %@, %@, %@", keychain.type, keychain, keychain.account, keychain.password);
            NSLog(@"%@", keychain.attributes);
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        printf("\n\n");
    }
    
    {
        NSLog(@"\n\n获取钥匙串: kIdentifierForKeychain");
        XZKeychain *keychain = [XZKeychain keychainWithType:(XZKeychainTypeGenericPassword)];
        keychain.identifier = @"kIdentifierForKeychain";
        NSError *error = nil;
        if ([keychain search:&error]) {  
            NSLog(@"%lu, %@, %@, %@", keychain.type, keychain, keychain.account, keychain.password);
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        printf("\n\n");
    }
    
    {
        NSLog(@"\n\n修改钥匙串: kIdentifierForKeychain");
        XZKeychain *keychain = [XZKeychain keychainWithType:(XZKeychainTypeGenericPassword)];
        keychain.identifier = @"kIdentifierForKeychain";
        NSError *error = nil;
        if ([keychain search:&error]) {
            NSLog(@"修改前：%lu, %@, %@, %@", keychain.type, keychain, keychain.account, keychain.password);
            keychain.account = @"accoutModify";
            keychain.password = @"accountModify";
            if ([keychain update:&error]) {
                NSLog(@"修改后：%lu, %@, %@, %@", keychain.type, keychain, keychain.account, keychain.password);
            } else {
                NSLog(@"修改出错：%@", error.localizedDescription);
            }
        } else {
            NSLog(@"没有找到要修改的钥匙串：%@", error.localizedDescription);
        }
        printf("\n\n");
    }
    
    {
        NSLog(@"\n\n删除钥匙串: kIdentifierForKeychain");
        XZKeychain *keychain = [XZKeychain keychainWithType:(XZKeychainTypeGenericPassword)];
        keychain.identifier = @"kIdentifierForKeychain";
        NSError *error = nil;
        if ([keychain remove:&error]) {
            NSLog(@"删除成功");
        } else {
            NSLog(@"删除失败：%@", error.localizedDescription);
        }
        printf("\n\n");
    }
    
    {
        NSLog(@"\n\n获取与已知条件匹配的钥匙串");
        XZKeychain *keychain = [XZKeychain keychainWithType:(XZKeychainTypeGenericPassword)];
        NSError *error = nil;
        NSArray<XZKeychain *> *keychains = [keychain match:&error];
        if (error.code != XZKeychainErrorSuccess) {
            NSLog(@"%@", error.localizedDescription);
        } else {
            [keychains enumerateObjectsUsingBlock:^(XZKeychain * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSLog(@"%02lu, %lu, %@, %@, %@", idx, obj.type, obj, obj.identifier, [obj valueForAttribute:(XZKeychainAttributeLabel)]);
            }];
        }
        printf("\n\n");
    }
    
    {
        NSLog(@"\n\n获取匹配指定条件下所有钥匙串");
        NSError *error = nil;
        NSArray<XZKeychain *> *matches = @[
                                           [XZKeychain keychainWithType:(XZKeychainTypeGenericPassword)],
                                           [XZKeychain keychainWithType:(XZKeychainTypeInternetPassword)],
                                           [XZKeychain keychainWithType:(XZKeychainTypeCertificate)]];
        NSArray<XZKeychain *> *keychains = [XZKeychain match:matches error:&error];
        if (error.code != XZKeychainErrorSuccess) {
            NSLog(@"%@", error.userInfo);
        } else {
            [keychains enumerateObjectsUsingBlock:^(XZKeychain * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSLog(@"%02lu, %lu, %@, %@, %@", idx, obj.type, obj, obj.identifier, [obj valueForAttribute:(XZKeychainAttributeLabel)]);
            }];
        }
        printf("\n\n");
    }

```
