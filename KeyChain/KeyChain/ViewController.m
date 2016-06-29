//
//  ViewController.m
//  KeyChain
//
//  Created by iMac on 16/6/24.
//  Copyright © 2016年 人民网. All rights reserved.
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
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    XZKeychain *keychain = [[XZKeychain alloc] initWithType:(XZKeychainTypeGenericPassword)];
    
    NSError *error = nil;
    NSArray *array = [keychain match:&error];
    if (error == nil) {
        for (XZKeychain *item in array) {
            NSLog(@"%@, %@, %@, %@", item.account, item.password, item.identifier, [item valueForAttribute:(XZKeychainAttributeCreationDate)]);
        }
    } else {
        NSLog(@"%ld, %@", error.code, error.localizedDescription);
    }
    
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

@end


