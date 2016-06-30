//
//  ViewController.m
//  KeyChain
//
//  Created by iMac on 16/6/24.
//  Copyright © 2016年 mlibai. All rights reserved.
//

#import "ViewController.h"

#import "XZKeychain.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UILabel *identifierLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
        NSDictionary *errors = nil;
        NSArray<XZKeychain *> *matches = @[
                                           [XZKeychain keychainWithType:(XZKeychainTypeGenericPassword)],
                                           [XZKeychain keychainWithType:(XZKeychainTypeInternetPassword)],
                                           [XZKeychain keychainWithType:(XZKeychainTypeCertificate)]];
        NSArray<XZKeychain *> *keychains = [XZKeychain match:matches errors:&errors];
        if (errors != nil) {
            [errors enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSError * _Nonnull obj, BOOL * _Nonnull stop) {
                NSLog(@"%@: %@", key, obj.localizedDescription);
            }];
        } else {
            [keychains enumerateObjectsUsingBlock:^(XZKeychain * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSLog(@"%02lu, %lu, %@, %@, %@", idx, obj.type, obj, obj.identifier, [obj valueForAttribute:(XZKeychainAttributeLabel)]);
            }];
        }
        printf("\n\n");
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)read:(id)sender {
    XZKeychain *keychain = [[XZKeychain alloc] initWithType:(XZKeychainTypeGenericPassword)];
    keychain.identifier = self.identifierLabel.text;
    NSError *error = nil;
    if ([keychain search:&error]) {
        self.messageLabel.text = @"读取成功";
        NSString *password = keychain.password;
        self.accountTextField.text = keychain.account;
        self.passwordTextField.text = password;
    } else {
        self.messageLabel.text = error.localizedDescription;
        self.accountTextField.text = nil;
        self.passwordTextField.text = nil;
    }
}

- (IBAction)write:(id)sender {
    if (self.accountTextField.text.length == 0 || self.passwordTextField.text.length == 0) {
        self.messageLabel.text = @"帐号或密码为空";
        return;
    }
    XZKeychain *keychain = [[XZKeychain alloc] initWithType:(XZKeychainTypeGenericPassword)];
    keychain.identifier = self.identifierLabel.text;
    keychain.account = self.accountTextField.text;
    keychain.password = self.passwordTextField.text;
    NSError *error = nil;
    if ([keychain insert:&error]) {
        self.messageLabel.text = @"写入成功";
    } else {
        self.messageLabel.text = error.localizedDescription;
    }
}

- (IBAction)remove:(id)sender {
    XZKeychain *keychain = [[XZKeychain alloc] initWithType:(XZKeychainTypeGenericPassword)];
    keychain.identifier = self.identifierLabel.text;
    NSError *error = nil;
    if ([keychain remove:&error]) {
        self.messageLabel.text = @"删除成功";
    } else {
        self.messageLabel.text = error.localizedDescription;
    }
}

- (IBAction)update:(UIButton *)sender {
    XZKeychain *keychain = [XZKeychain keychainWithIdentifier:self.identifierLabel.text];
    keychain.account = self.accountTextField.text;
    keychain.password = self.passwordTextField.text;
    NSError *error = nil;
    if ([keychain update:&error]) {
        self.messageLabel.text = @"修改成功";
    } else {
        self.messageLabel.text = error.localizedDescription;
    }
}

@end


