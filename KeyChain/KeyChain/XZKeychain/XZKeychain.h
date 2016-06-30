//
//  XZKeychain.h
//  Keychain
//
//  Created by iMac on 16/6/24.
//  Copyright © 2016年 mlibai. All rights reserved.
//

#import <Foundation/Foundation.h>
@import Security;

FOUNDATION_EXTERN NSString * _Nonnull const kXZKeychainErrorDomain;

enum {
    XZKeychainErrorSuccess = noErr
};

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
    XZKeychainAttributeGeneric,  // 通用属性，可以用作钥匙串唯一标识。
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

@interface XZKeychain : NSObject <NSCopying>

/**
 *  标识钥匙串所属的类型。
 */
@property (nonatomic, readonly) XZKeychainType type;

/**
 *  钥匙串所有属性的集合
 */
@property (nonatomic, copy, readonly) NSDictionary * _Nullable attributes;

/**
 *  初始化创建一个 XZKeychain 对象：
 *  新建的 XZKeychain 对象，没有与真正的钥匙串建立关联；
 *  在设置了一系列指定的属性后（一般是具有唯一标识作用的属性或属性组），通过调用 -search: 方法获取所有属性，并建立关联；
 *  否则，钥匙串的某些操作可能无法进行或者返回错误。
 *
 *  @param type 钥匙串的类型
 *
 *  @return XZKeychain 对象
 */
+ (nullable instancetype)keychainWithType:(XZKeychainType)type;
- (nullable instancetype)initWithType:(XZKeychainType)type NS_DESIGNATED_INITIALIZER;

/**
 *  获取和设置“钥匙串”属性的方法。
 *
 *  setter: [keychain setValue:@"anAccount" forAttribute:XZKeychainAttributeAccount]; keychain[XZKeychainAttributeAccount] = @"anAccount";
 *  getter: [keychain valueForAttribute:XZKeychainAttributeAccount]; keychain[XZKeychainAttributeAccount];
 *
 */
- (void)setValue:(nullable id)value forAttribute:(XZKeychainAttribute)attribute;
- (void)setObject:(nullable id)anObject forAttribute:(XZKeychainAttribute)attribute;
- (nullable id)valueForAttribute:(XZKeychainAttribute)attribute;
- (nullable id)objectForAttribute:(XZKeychainAttribute)attribute;
- (void)setObject:(nullable id)obj atIndexedSubscript:(XZKeychainAttribute)attribute;
- (nullable id)objectAtIndexedSubscript:(XZKeychainAttribute)attribute;

/**
 *  根据当前已设置的属性，匹配第一个符合条件的钥匙串，复制钥匙串属性值到当前对象默认属性中。
 *  不改变当前已设置的属性的值，但是如果当前的没有给属性设置值，则会填充值。
 *  这个方法总是按照目前已设置的值查找匹配的钥匙串，所以当属性发生改变时，调用这个方法后可能会得到不同的钥匙串。
 *
 *  @param error 如果查询钥匙串发生错误，将通过此参数传回。
 *
 *  @return YES 表示匹配到钥匙串，NO 表示没有匹配到钥匙串。
 */
- (BOOL)search:(NSError * _Nullable * _Nullable)error;

/**
 *  放弃所有已设置的属性，恢复到默认值或nil。
 */
- (void)reset;

/**
 *  根据当前已设置的属性，创建一个钥匙串。如果创建钥匙串成功，当前对象的属性会被设置为钥匙串真实的属性。钥匙串如果调用 -search: 方法成功，将返回错误。
 *
 *  @param error 如果发生错误，可用此参数输出。
 *
 *  @return YES 表示成功创建；NO 创建失败。
 */
- (BOOL)insert:(NSError * _Nullable * _Nullable)error;

/**
 *  根据当前的属性，匹配删除第一个符合条件的钥匙串。如果钥匙串本身不存在，则也返回删除成功。
 *
 *  @param error 如果发生错误，可用此参数输出。
 *
 *  @return YES 删除成功；NO 删除失败。
 */
- (BOOL)remove:(NSError * _Nullable * _Nullable)error;

/**
 *  本方法调用前，必须调用了 -search: 方法，否则无法更新。
 *
 *  @param error 如果发生错误，可用此参数输出。
 *
 *  @return YES 更新成功；NO 更新失败。
 */
- (BOOL)update:(NSError * _Nullable * _Nullable)error; //

/**
 *  根据当前的属性，匹配返回所有符合条件的钥匙串。
 *
 *  @param error 如果发生错误，可用此参数输出。
 *
 *  @return 包含所有匹配结果的集合。
 */
- (NSArray<XZKeychain *> * _Nullable)match:(NSError * _Nullable * _Nullable)error; //

/**
 *  通过搜索方式获取钥匙串。它都是类方法，或到的钥匙串都是已经关联好的。
 */
+ (NSArray<XZKeychain *> * _Nullable)allKeychains; // 所有钥匙串
+ (NSArray<XZKeychain *> * _Nullable)allKeychainsWithType:(XZKeychainType)type;

/**
 *  返回与指定条件相匹配的钥匙串。
 *
 *  @param matches 与数组中的 XZKeychain 对象相匹配的钥匙串。
 *  @param errors  匹配过程中会发生多个错误，错误信息按照待匹配的对象为键值。
 *
 *  @return 所有匹配的钥匙串。
 */
+ (NSArray<XZKeychain *> * _Nullable)match:(NSArray<XZKeychain *> * _Nullable)matches errors:(NSDictionary<XZKeychain *, NSError *> * _Nullable * _Nullable)errors;

// 不可复制，返回对象自身。主要是为了用作字典键值而提供的。
- (nonnull id)copyWithZone:(NSZone * _Nullable)zone;

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
@interface XZKeychain (XZGenericPasswordKeychain)

/**
 *  建议用 XZKeychainAttributeGeneric 属性作为 XZGenericPasswordKeychain 的唯一标识。
 */
@property (nonatomic, strong) NSString * _Nullable identifier;  // XZKeychainAttributeGeneric

/**
 *  返回的是 XZKeychainAttributeAccount 属性的值。
 */
@property (nonatomic, strong) NSString * _Nullable account;     // XZKeychainAttributeAccount

/**
 *  密码并非钥匙串的属性，在第一次调用该方法时，从钥匙串中获取。
 */
@property (nonatomic, strong) NSString * _Nullable password;

/**
 *  构造一个 XZGenericPasswordKeychain 并自动尝试关联。
 *
 *  @param identifier XZKeychainAttributeGeneric 属性被用作唯一标识符。
 *
 *  @return XZKeychain 对象，type = XZKeychainTypeGenericPassword。
 */
+ (nullable instancetype)keychainWithIdentifier:(NSString * _Nullable)identifier;

@end







