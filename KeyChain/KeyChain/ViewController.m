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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)read:(id)sender {
    XZKeychain *keychain = [[XZKeychain alloc] initWithIdentifier:self.identifierLabel.text];
    NSString *account = keychain.account;
    if (account.length == 0) {
        self.messageLabel.text = @"没有找到";
        self.accountTextField.text = nil;
        self.passwordTextField.text = nil;
    } else {
        self.messageLabel.text = @"读取成功";
        NSString *password = keychain.password;
        self.accountTextField.text = account;
        self.passwordTextField.text = password;
    }
}

- (IBAction)write:(id)sender {
    XZKeychain *keychain = [[XZKeychain alloc] initWithIdentifier:self.identifierLabel.text];
    if (self.accountTextField.text.length == 0 || self.passwordTextField.text.length == 0) {
        self.messageLabel.text = @"帐号或密码为空";
        return;
    }
    keychain.account = self.accountTextField.text;
    keychain.password = self.passwordTextField.text;
    NSError *error = nil;
    if (![keychain writeToKeychainStore:&error]) {
        self.messageLabel.text = error.localizedDescription;
    } else {
        self.messageLabel.text = @"写入成功";
    }
}

- (IBAction)remove:(id)sender {
    XZKeychain *keychain = [[XZKeychain alloc] initWithIdentifier:self.identifierLabel.text];
    NSError *error = nil;
    if (![keychain deleteFromKeychainStore:&error]) {
        self.messageLabel.text = error.localizedDescription;
    } else {
        if (error != nil) {
            self.messageLabel.text = error.localizedDescription;
        } else {
            self.messageLabel.text = @"删除成功";
        }
    }
}

@end


