//
//  XZKeychain.h
//  Keychain
//
//  Created by iMac on 16/6/24.
//  Copyright © 2016年 人民网. All rights reserved.
//

#import <Foundation/Foundation.h>
@import Security;

/**
 *  几种钥匙串类型
 */
typedef NS_ENUM(NSUInteger, XZKeychainType) {
    /**
     *  通用钥匙串
     */
    XZKeychainTypeGenericPassword = 0,
    /**
     *  网络密码
     */
    XZKeychainTypeInternetPassword,
    /**
     *  证书
     */
    XZKeychainTypeCertificate,
    /**
     *  密钥
     */
    XZKeychainTypeKey,
    /**
     *  验证
     */
    XZKeychainTypeIdentity,
    /**
     *  只是标记钥匙串类型数量的
     */
    XZKeychainTypeNotAType
};

// 钥匙串所拥有的属性
typedef NS_ENUM(NSUInteger, XZKeychainAttribute) {
    // 钥匙串 XZKeychainTypeGenericPassword 支持的属性：
    XZKeychainAttributeAccessible,
    XZKeychainAttributeAccessControl,
    // 模拟器没有代码签名，不存在分组。
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
    
    /* 钥匙串 XZKeychainTypeInternetPassword 支持的属性：
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
    
    // 钥匙串 XZKeychainTypeCertificate 支持的属性：
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
    
    // 钥匙串 XZKeychainTypeKey 支持的属性：
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
    
    // 钥匙串 XZKeychainTypeIdentity 支持的属性:
    // 由于 XZKeychainTypeIdentity 钥匙串同时包含“私钥”和“证书”，
    // 所以它同时具有 XZKeychainTypeKey 和 XZKeychainTypeCertificate 两种钥匙串的属性。
};

/**
 *  对系统“钥匙串”接口的封装。XZKeychain 对象提供了获取、设置、创建“钥匙串”的方法。
 */
@interface XZKeychain : NSObject

/**
 *  钥匙串类型
 */
@property (nonatomic, readonly) XZKeychainType type;

/**
 *  存放钥匙串属性的字典。
 */
//@property (nonatomic, strong, readonly) NSDictionary * _Nullable attributes;

/**
 *  便利构造器与指定的初始化方法。
 */
+ (nullable instancetype)keychainWithType:(XZKeychainType)type;
- (nullable instancetype)initWithType:(XZKeychainType)type NS_DESIGNATED_INITIALIZER;

// 获取与设置“钥匙串”属性的方法
- (void)setValue:(nullable id)value forAttribute:(XZKeychainAttribute)attribute;
- (void)setObject:(nullable id)anObject forAttribute:(XZKeychainAttribute)attribute;
- (nullable id)valueForAttribute:(XZKeychainAttribute)attribute;
- (nullable id)objectForAttribute:(XZKeychainAttribute)attribute;
- (void)setObject:(nullable id)obj atIndexedSubscript:(XZKeychainAttribute)attribute;
- (nullable id)objectAtIndexedSubscript:(XZKeychainAttribute)attribute;

/**
 *  写入保存，只有调用了此方法，钥匙串才会真正的保存。
 */
- (BOOL)writeToKeychainStore:(NSError * _Nullable * _Nullable)error;

/**
 *  删除，注意，此方法是直接从钥匙串中删除。另外，如果钥匙串不存在，返回值为 YES，但是会同时返回 error。
 */
- (BOOL)deleteFromKeychainStore:(NSError * _Nullable * _Nullable)error;

@end


/**
 *  通用密码钥匙串：XZKeychain.type = XZKeychainTypeGenericPassword。
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
@interface XZKeychain (XZGenericPasswordKeychain)

/**
 *  以下两个属性，不支持 KVC 。
 */
@property (nonatomic, strong) NSString * _Nullable account;
@property (nonatomic, strong) NSString * _Nullable password;

- (NSString * _Nullable)account;
- (void)setAccount:(NSString * _Nullable)account;

- (NSString * _Nullable)password;
- (void)setPassword:(NSString * _Nullable)password;

// 以下方法创建的对象 .type = XZKeychainTypeGenericPassword
+ (nullable instancetype)keychainWithIdentifier:(NSString * _Nonnull)identifier;
+ (nullable instancetype)keychainWithAccessGroup:(NSString * _Nullable)group identifier:(NSString * _Nonnull)identifier;
- (nullable instancetype)initWithIdentifier:(NSString * _Nonnull)identifier;
- (nullable instancetype)initWithAccessGroup:(NSString * _Nullable)group identifier:(NSString * _Nonnull)identifier;

@end

FOUNDATION_EXTERN NSInteger const kXZKeychainStatusNoError;

/**
 *  管理 XZKeychain。 提供一系列的搜索方法。
 */
@interface XZKeychainManager : NSObject

+ (NSArray<XZKeychain *> * _Nullable)allKeychains:(NSError * _Nonnull * _Nullable)error;

- (void)addQueryObject:(nullable id)anObject forAttribute:(XZKeychainAttribute)attribute;

- (NSArray<XZKeychain *> * _Nullable)matchingKeychains;

- (NSArray<XZKeychain *> * _Nullable)search:(NSError * _Nonnull * _Nullable)error;
- (NSArray<XZKeychain *> * _Nullable)searchWithKeychainType:(XZKeychainType)keychainType error:(NSError * _Nonnull *_Nullable)error;

@end



