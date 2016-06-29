//
//  XZKeychain.h
//  Keychain
//
//  Created by iMac on 16/6/24.
//  Copyright © 2016年 人民网. All rights reserved.
//

#import <Foundation/Foundation.h>
@import Security;

FOUNDATION_EXTERN NSString * _Nonnull const kXZKeychainErrorDomain;

/**
 *  几种钥匙串类型
 */
typedef NS_ENUM(NSUInteger, XZKeychainType) {
    XZKeychainTypeGenericPassword = 0,  // 通用钥匙串
    XZKeychainTypeInternetPassword,     // 网络密码
    XZKeychainTypeCertificate,          // 证书
    XZKeychainTypeKey,                  // 密钥
    XZKeychainTypeIdentity,             // 验证
    XZKeychainTypeNotSupported          // 不支持的属性，请勿使用，主要是提供给 for 循环用的。
};

// 钥匙串所拥有的属性
typedef NS_ENUM(NSUInteger, XZKeychainAttribute) {
    // 钥匙串 XZKeychainGenericPassword 支持的属性：
    XZKeychainAttributeAccessible,
    XZKeychainAttributeAccessControl,
    // 模拟器（TARGET_IPHONE_SIMULATOR）没有代码签名，不存在分组。
    // 如果设置分组，添加或更新就会返回 -25243 (errSecNoAccessForItem) 错误。
    XZKeychainAttributeAccessGroup,
    XZKeychainAttributeCreationDate,
    XZKeychainAttributeModificationDate,
    XZKeychainAttributeDescription,
    XZKeychainAttributeComment,
    XZKeychainAttributeCreator,
    XZKeychainAttributeType,
    XZKeychainAttributeLabel,
    XZKeychainAttributeIsInvisible,
    XZKeychainAttributeIsNegative,
    XZKeychainAttributeAccount,  // 帐号
    XZKeychainAttributeService,
    XZKeychainAttributeGeneric,  // 通用属性，标识钥匙串的
    XZKeychainAttributeSynchronizable,
    
    /* 钥匙串 XZKeychainInternetPassword 支持的属性：
     // 注释掉的属性不表示没有，而是已经在列表中了，下同
     XZKeychainAttributeAccessible,
     XZKeychainAttributeAccessControl,
     XZKeychainAttributeAccessGroup,
     XZKeychainAttributeCreationDate,
     XZKeychainAttributeModificationDate,
     XZKeychainAttributeDescription,
     XZKeychainAttributeComment,
     XZKeychainAttributeCreator,
     XZKeychainAttributeType,
     XZKeychainAttributeLabel,
     XZKeychainAttributeIsInvisible,
     XZKeychainAttributeIsNegative,
     XZKeychainAttributeAccount, */
    XZKeychainAttributeSecurityDomain,
    XZKeychainAttributeServer,
    XZKeychainAttributeProtocol,
    XZKeychainAttributeAuthenticationType,
    XZKeychainAttributePort,
    XZKeychainAttributePath,
    // XZKeychainAttributeSynchronizable
    
    // 钥匙串 XZKeychainCertificate 支持的属性：
    // XZKeychainAttributeAccessible,
    // XZKeychainAttributeAccessControl,
    // XZKeychainAttributeAccessGroup,
    XZKeychainAttributeCertificateType,
    XZKeychainAttributeCertificateEncoding,
    // XZKeychainAttributeLabel,
    XZKeychainAttributeSubject,
    XZKeychainAttributeIssuer,
    XZKeychainAttributeSerialNumber,
    XZKeychainAttributeSubjectKeyID,
    XZKeychainAttributePublicKeyHash,
    // XZKeychainAttributeSynchronizable
    
    // 钥匙串 XZKeychainKey 支持的属性：
    // XZKeychainAttributeAccessible,
    // XZKeychainAttributeAccessControl,
    // XZKeychainAttributeAccessGroup,
    XZKeychainAttributeKeyClass,
    // XZKeychainAttributeLabel,
    XZKeychainAttributeApplicationLabel,
    XZKeychainAttributeIsPermanent,
    XZKeychainAttributeApplicationTag,
    XZKeychainAttributeKeyType,
    XZKeychainAttributeKeySizeInBits,
    XZKeychainAttributeEffectiveKeySize,
    XZKeychainAttributeCanEncrypt,
    XZKeychainAttributeCanDecrypt,
    XZKeychainAttributeCanDerive,
    XZKeychainAttributeCanSign,
    XZKeychainAttributeCanVerify,
    XZKeychainAttributeCanWrap,
    XZKeychainAttributeCanUnwrap
    // XZKeychainAttributeSynchronizable
    
    // 钥匙串 XZKeychainIdentity 支持的属性:
    // 由于 XZKeychainIdentity 钥匙串同时包含“私钥”和“证书”，
    // 所以它同时具有 XZKeychainKey 和 XZKeychainCertificate 两种钥匙串的属性。
};

@interface XZKeychain : NSObject

@property (nonatomic, readonly) XZKeychainType type;

@property (nonatomic, copy, readonly) NSDictionary * _Nullable attributes;

@property (nonatomic, readonly, getter=isModified) BOOL modified;

+ (nullable instancetype)keychainWithType:(XZKeychainType)type;
- (nullable instancetype)initWithType:(XZKeychainType)type NS_DESIGNATED_INITIALIZER;

// 获取与设置“钥匙串”属性的方法
- (void)setValue:(nullable id)value forAttribute:(XZKeychainAttribute)attribute;
- (void)setObject:(nullable id)anObject forAttribute:(XZKeychainAttribute)attribute;
- (nullable id)valueForAttribute:(XZKeychainAttribute)attribute;
- (nullable id)objectForAttribute:(XZKeychainAttribute)attribute;
- (void)setObject:(nullable id)obj atIndexedSubscript:(XZKeychainAttribute)attribute;
- (nullable id)objectAtIndexedSubscript:(XZKeychainAttribute)attribute;

// 放弃所有已设置的属性，恢复到默认值或nil。
- (void)reset;

// 增删改
- (BOOL)insert:(NSError * _Nullable * _Nullable)error; // 根据当前的属性，创建一个钥匙串。
- (BOOL)remove:(NSError * _Nullable * _Nullable)error; // 根据当前的属性，匹配删除第一个符合条件的钥匙串。
- (BOOL)update:(NSError * _Nullable * _Nullable)error; // 根据当前的属性，匹配更新第一个符合条件的钥匙串。
- (BOOL)search:(NSError * _Nullable * _Nullable)error; // 根据当前的属性，匹配第一个符合条件的钥匙串，不改变当前已设置的属性的值，但是如果当前的没有给属性设置值，则会填充值。


- (NSArray<XZKeychain *> * _Nullable)match:(NSError * _Nullable * _Nullable)error; // 根据当前的属性，匹配返回所有符合条件的钥匙串。

+ (NSArray<XZKeychain *> * _Nullable)allKeychains; // 所有钥匙串
+ (NSArray<XZKeychain *> * _Nullable)match:(NSArray<XZKeychain *> * _Nullable)matches error:(NSError * _Nullable * _Nullable)error; // 返回与指定条件相匹配的钥匙串。

@end

/**
 *  通用密码钥匙串：XZKeychain.type = XZKeychainGenericPassword。
 *  关于 AccessGroup 钥匙串共享的两种设置方法：
 *  1, 首先，需要在项目中创建一个如下结构的 plist 文件，将文件名作为 group 参数传入；
 *     然后，在 Target -> Build settings -> Code Sign Entitlements 设置签名授权为该 plist 文件。
 *     ┌────────────────────────────────────────────────────────────────────────────────────┐
 *     │<dict>                                                                              │
 *     │    <key>keychain-access-groups</key>                                               │
 *     │    <array>                                                                         │
 *     │        <string>YOUR_APP_ID_HERE.com.yourcompany.keychain</string>                  │
 *     │        <string>YOUR_APP_ID_HERE.com.yourcompany.keychainSuite</string>             │
 *     │    </array>                                                                        │
 *     │</dict>                                                                             │
 *     └────────────────────────────────────────────────────────────────────────────────────┘
 *  2, 在 Target -> Capabilities -> Keychain Sharing 中设置。
 */
@interface XZKeychain (XZGenericPasswordKeychainItem)

@property (nonatomic, strong) NSString * _Nullable identifier;  // XZKeychainAttributeGeneric
@property (nonatomic, strong) NSString * _Nullable account;     // XZKeychainAttributeAccount
@property (nonatomic, strong) NSString * _Nullable password;

@end







