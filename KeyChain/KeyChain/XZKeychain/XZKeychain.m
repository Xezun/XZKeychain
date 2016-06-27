//
//  XZKeychain.m
//  Keychain
//
//  Created by iMac on 16/6/24.
//  Copyright © 2016年 人民网. All rights reserved.
//

#import "XZKeychain.h"
#import <objc/runtime.h>

#define kXZKeychainTypeKey  (NSString *)kSecClass

@interface XZKeychain () {
    /**
     *  attributes 属性对应的实例变量；该实例变量并不随对象一起初始化；该变量应该始终只存储与“钥匙串”属性相关的内容。
     *  一般情况下，该字典存储的就是从钥匙串中获取到的属性和用户新设置的属性。
     */
    NSMutableDictionary *_attributes;
    /**
     *  在系统中查询“钥匙串”用到的字典
     */
    NSMutableDictionary *_XZKeychainQuery;
}

@end

@implementation XZKeychain

#pragma mark - alloc & init

/**
 *  默认创建的是通用钥匙串
 */
- (instancetype)init {
    return [self initWithType:(XZKeychainTypeGenericPassword)];
}

+ (instancetype)keychainWithType:(XZKeychainType)type {
    return [[self alloc] initWithType:type];
}

- (instancetype)initWithType:(XZKeychainType)type {
    self = [super init];
    if (self != nil) {
        _type = type;
    }
    return self;
}

#pragma mark - Private Methods

/**
 *  “钥匙串”类型枚举值对应的实际值。
 */
+ (NSString *)_XZKeychain_objectForType:(XZKeychainType)type {
    switch (type) {
        case XZKeychainTypeGenericPassword:
            return (NSString *)kSecClassGenericPassword;
            break;
        case XZKeychainTypeInternetPassword:
            return (NSString *)kSecClassInternetPassword;
            break;
        case XZKeychainTypeKey:
            return (NSString *)kSecClassKey;
            break;
        case XZKeychainTypeIdentity:
            return (NSString *)kSecClassIdentity;
            break;
        default:
            @throw [NSException exceptionWithName:@"不支持的钥匙串类型" reason:@"指定的钥匙串类型不支持或不存在" userInfo:@{@"XZKeychainType": @(type)}];
            return nil;
            break;
    }
}

+ (id)_XZKeychain_keyObjectForAtrribute:(XZKeychainAttribute)attribute {
    switch (attribute) {
        case XZKeychainAttributeAccessible:
            return (id)kSecAttrAccessible;
            break;
        case XZKeychainAttributeAccessControl:
            return (id)kSecAttrAccessControl;
            break;
        case XZKeychainAttributeAccessGroup:
            return (id)kSecAttrAccessGroup;
            break;
        case XZKeychainAttributeCreationDate:
            return (id)kSecAttrCreationDate;
            break;
        case XZKeychainAttributeModificationDate:
            return (id)kSecAttrModificationDate;
            break;
        case XZKeychainAttributeDescription:
            return (id)kSecAttrDescription;
            break;
        case XZKeychainAttributeComment:
            return (id)kSecAttrComment;
            break;
        case XZKeychainAttributeCreator:
            return (id)kSecAttrCreator;
            break;
        case XZKeychainAttributeType:
            return (id)kSecAttrType;
            break;
        case XZKeychainAttributeLabel:
            return (id)kSecAttrLabel;
            break;
        case XZKeychainAttributeIsInvisible:
            return (id)kSecAttrIsInvisible;
            break;
        case XZKeychainAttributeIsNegative:
            return (id)kSecAttrIsNegative;
            break;
        case XZKeychainAttributeAccount:
            return (id)kSecAttrAccount;
            break;
        case XZKeychainAttributeService:
            return (id)kSecAttrService;
            break;
        case XZKeychainAttributeGeneric:
            return (id)kSecAttrGeneric;
            break;
        case XZKeychainAttributeSynchronizable:
            return (id)kSecAttrSynchronizable;
            break;
            //XZKeychainTypeInternetPassword 支持的属性：
            // XZKeychainAttributeAccessible,
            // XZKeychainAttributeAccessControl,
            // XZKeychainAttributeAccessGroup,
            // XZKeychainAttributeCreationDate,
            // XZKeychainAttributeModificationDate,
            // XZKeychainAttributeDescription,
            // XZKeychainAttributeComment,
            // XZKeychainAttributeCreator,
            // XZKeychainAttributeType,
            // XZKeychainAttributeLabel,
            // XZKeychainAttributeIsInvisible,
            // XZKeychainAttributeIsNegative,
            // XZKeychainAttributeAccount:

        case XZKeychainAttributeSecurityDomain:
            return (id)kSecAttrSecurityDomain;
            break;
        case XZKeychainAttributeServer:
            return (id)kSecAttrServer;
            break;
        case XZKeychainAttributeProtocol:
            return (id)kSecAttrProtocol;
            break;
        case XZKeychainAttributeAuthenticationType:
            return (id)kSecAttrAuthenticationType;
            break;
        case XZKeychainAttributePort:
            return (id)kSecAttrPort;
            break;
        case XZKeychainAttributePath:
            return (id)kSecAttrPath;
            break;
            // XZKeychainAttributeSynchronizable
            
            // XZKeychainTypeCertificate 支持的属性：
            // XZKeychainAttributeAccessible,
            // XZKeychainAttributeAccessControl,
            // XZKeychainAttributeAccessGroup:

        case XZKeychainAttributeCertificateType:
            return (id)kSecAttrCertificateType;
            break;
        case XZKeychainAttributeCertificateEncoding:
            // XZKeychainAttributeLabel:
            return (id)kSecAttrCertificateEncoding;
            break;
        case XZKeychainAttributeSubject:
            return (id)kSecAttrSubject;
            break;
        case XZKeychainAttributeIssuer:
            return (id)kSecAttrIssuer;
            break;
        case XZKeychainAttributeSerialNumber:
            return (id)kSecAttrSerialNumber;
            break;
        case XZKeychainAttributeSubjectKeyID:
            return (id)kSecAttrSubjectKeyID;
            break;
        case XZKeychainAttributePublicKeyHash:
            return (id)kSecAttrPublicKeyHash;
            break;
            // XZKeychainAttributeSynchronizable
            
            // XZKeychainTypeKey 支持的属性：
            // XZKeychainAttributeAccessible,
            // XZKeychainAttributeAccessControl,
            // XZKeychainAttributeAccessGroup:
            // XZKeychainAttributeLabel:
        case XZKeychainAttributeKeyClass:
            return (id)kSecAttrKeyClass;
            break;
        case XZKeychainAttributeApplicationLabel:
            return (id)kSecAttrApplicationLabel;
            break;
        case XZKeychainAttributeIsPermanent:
            return (id)kSecAttrIsPermanent;
            break;
        case XZKeychainAttributeApplicationTag:
            return (id)kSecAttrApplicationTag;
            break;
        case XZKeychainAttributeKeyType:
            return (id)kSecAttrKeyType;
            break;
        case XZKeychainAttributeKeySizeInBits:
            return (id)kSecAttrKeySizeInBits;
            break;
        case XZKeychainAttributeEffectiveKeySize:
            return (id)kSecAttrEffectiveKeySize;
            break;
        case XZKeychainAttributeCanEncrypt:
            return (id)kSecAttrCanEncrypt;
            break;
        case XZKeychainAttributeCanDecrypt:
            return (id)kSecAttrCanDecrypt;
            break;
        case XZKeychainAttributeCanDerive:
            return (id)kSecAttrCanDerive;
            break;
        case XZKeychainAttributeCanSign:
            return (id)kSecAttrCanSign;
            break;
        case XZKeychainAttributeCanVerify:
            return (id)kSecAttrCanVerify;
            break;
        case XZKeychainAttributeCanWrap:
            return (id)kSecAttrCanWrap;
            break;
        case XZKeychainAttributeCanUnwrap:
            return (id)kSecAttrCanUnwrap;
            break;
        default:
            return [NSException exceptionWithName:@"不支持的属性" reason:@"查找的属性不存在或不支持" userInfo:@{@"XZKeychainAttribute": @(attribute)}];
            break;
    }
}

+ (nonnull NSString *)_XZKeyChain_descriptionForErrorStatus:(OSStatus)status {
    switch (status) {
        case errSecSuccess:
            return @"没有错误"; // No error
            break;
        case errSecUnimplemented:
            return @"程序没有执行"; // Function or operation not implemented.
            break;
        case errSecIO:
            return @"IO错误"; // I/O error (bummers)
            break;
        case errSecOpWr:
            return @"文件正在被使用"; // file already open with with write permission
            break;
        case errSecParam:
            return @"一个或多个参数错误"; // One or more parameters passed to a function where not valid.
            break;
        case errSecAllocate:
            return @"无法分配内存"; // Failed to allocate memory.
            break;
        case errSecUserCanceled:
            return @"用户取消了进程"; // User canceled the operation.
            break;
        case errSecBadReq:
            return @"参数错误或状态错误"; // Bad parameter or invalid state for operation.
            break;
        case errSecInternalComponent:
            return @"Internal Component.";
            break;
        case errSecNotAvailable:
            return @"无可用钥匙串，请重启设备"; // No keychain is available. You may need to restart your computer.
            break;
        case errSecDuplicateItem:
            return @"钥匙串已存在"; // The specified item already exists in the keychain.
            break;
        case errSecItemNotFound:
            return @"找不到指定的钥匙串"; // The specified item could not be found in the keychain.
            break;
        case errSecInteractionNotAllowed:
            return @"不允许的用户操作"; // User interaction is not allowed.
            break;
        case errSecDecode:
            return @"无法解码数据"; // Unable to decode the provided data.
            break;
        case errSecAuthFailed:
            return @"权限验证失败，用户名或密码不对"; // The user name or passphrase you entered is not correct.

        default:
            break;
    }
    return @"未知错误";
}

- (NSMutableDictionary *)_XZKeychainQueryLazyLoad {
    if (_XZKeychainQuery != nil) {
        return _XZKeychainQuery;
    }
    _XZKeychainQuery = [[NSMutableDictionary alloc] init];
    return _XZKeychainQuery;
}

#pragma mark - Public Methods

- (NSDictionary *)attributes {
    return _attributes;
}

/**
 *  存放属性的字典的懒加载方法。
 */
- (NSMutableDictionary *)_XZKeychain_attributesLazyLoad {
    if (_attributes != nil) {
        return _attributes;
    }
    _attributes = [[NSMutableDictionary alloc] init];
    return _attributes;
}

- (void)_XZKeychain_setAttributes:(NSMutableDictionary *)attributes {
    _attributes = attributes;
}

#pragma mark - 一系列存取属性的方法

- (void)setValue:(id)value forAttribute:(XZKeychainAttribute)attribute {
    if (![[self valueForAttribute:attribute] isEqual:value]) {
        NSString *key = [[self class] _XZKeychain_keyObjectForAtrribute:attribute];
        [[self _XZKeychain_attributesLazyLoad] setObject:value forKey:key];
    }
}

- (void)setObject:(id)anObject forAttribute:(XZKeychainAttribute)attribute {
    [self setValue:anObject forAttribute:attribute];
}

- (id)valueForAttribute:(XZKeychainAttribute)attribute {
    NSString *key = [[self class] _XZKeychain_keyObjectForAtrribute:attribute];
    return [_attributes objectForKey:key];
}

- (id)objectForAttribute:(XZKeychainAttribute)attribute {
    return [self valueForAttribute:attribute];
}

- (void)setObject:(id)obj atIndexedSubscript:(XZKeychainAttribute)attribute {
    [self setValue:obj forAttribute:attribute];
}

- (id)objectAtIndexedSubscript:(XZKeychainAttribute)attribute {
    return [self valueForAttribute:attribute];
}

#pragma mark - 将钥匙串保存到系统

- (BOOL)writeToKeychainStore:(NSError *__autoreleasing  _Nullable *)error {
    OSStatus result = errSecBadReq;
    if (_XZKeychainQuery != nil) {
        // 复制要更新的值
        NSMutableDictionary *newAttributes = [NSMutableDictionary dictionaryWithDictionary:_attributes];
#if TARGET_IPHONE_SIMULATOR
        NSString *groupKey = [[self class] _XZKeychain_keyObjectForAtrribute:(XZKeychainAttributeAccessGroup)];
        [newAttributes removeObjectForKey:groupKey];
#endif
        
        // 获取钥匙
        CFDictionaryRef tempQueryRef = NULL;
        OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)(_XZKeychainQuery), (CFTypeRef *)&tempQueryRef);
        if (status == noErr) {
            // 复制当前的属性
            NSMutableDictionary *queryRef = [NSMutableDictionary dictionaryWithDictionary:(__bridge NSDictionary * _Nonnull)(tempQueryRef)];
            
            // 设置搜索的键值
            id typeObject = [XZKeychain _XZKeychain_objectForType:self.type];
            [queryRef setObject:typeObject forKey:kXZKeychainTypeKey];
            
            // 更新需要移除 kSecClass 对应的键值
            // [newAttributes removeObjectForKey:kXZKeychainTypeKey];
            
            // 更新
            result = SecItemUpdate((__bridge CFDictionaryRef)queryRef, (__bridge CFDictionaryRef)newAttributes);
        } else {
            // 设置钥匙串类型
            id typeObject = [XZKeychain _XZKeychain_objectForType:self.type];
            [newAttributes setObject:typeObject forKey:kXZKeychainTypeKey];
            // 添加
            result = SecItemAdd((__bridge CFDictionaryRef)newAttributes, NULL);
        }
    }
    if (result == noErr) {
        return YES;
    } else if (error != NULL) {
        *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:result userInfo:@{NSLocalizedFailureReasonErrorKey: [XZKeychain _XZKeyChain_descriptionForErrorStatus:result]}];
    }
    return NO;
}

- (BOOL)deleteFromKeychainStore:(NSError *__autoreleasing  _Nullable *)error {
    OSStatus result = errSecItemNotFound;
    if (_attributes != nil) {
        NSMutableDictionary *query = [NSMutableDictionary dictionaryWithDictionary:_attributes];
        id typeObject = [XZKeychain _XZKeychain_objectForType:self.type];
        [query setObject:typeObject forKey:kXZKeychainTypeKey];
        result = SecItemDelete((__bridge CFDictionaryRef)query);
        // NSAssert(NO, [XZKeychain _XZKeyChain_descriptionForErrorStatus:status]);
    }
    if (result != noErr) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:result userInfo:@{NSLocalizedFailureReasonErrorKey: [XZKeychain _XZKeyChain_descriptionForErrorStatus:result]}];
        }
        return (result == errSecItemNotFound);
    }
    return YES;
}

#pragma mark - Methods

@end

/**
 *  从钥匙串中获取密码的键名
 */
#define kXZGenericPasswordKeychainPasswordKey (id)kSecValueData

@implementation XZKeychain (XZGenericPasswordKeychain)

+ (instancetype)keychainWithIdentifier:(NSString *)identifier {
    return [self keychainWithAccessGroup:nil identifier:identifier];
}

+ (instancetype)keychainWithAccessGroup:(NSString *)group identifier:(NSString *)identifier {
    return [[self alloc] initWithAccessGroup:group identifier:identifier];
}

- (instancetype)initWithIdentifier:(NSString *)identifier {
    return [self initWithAccessGroup:nil identifier:identifier];
}

- (instancetype)initWithAccessGroup:(NSString *)group identifier:(NSString *)identifier {
    self = [self initWithType:(XZKeychainTypeGenericPassword)];
    if (self != nil) {
        NSMutableDictionary *keychainQuery = [self _XZKeychainQueryLazyLoad];
        // 钥匙串分类
        NSString *typeObject = [XZKeychain _XZKeychain_objectForType:_type];
        [keychainQuery setObject:typeObject forKey:kXZKeychainTypeKey];
#if !TARGET_IPHONE_SIMULATOR
        // access group
        NSString *groupKey = [XZKeychain _XZKeychain_keyObjectForAtrribute:(XZKeychainAttributeAccessGroup)];
        [query setObject:group forKey:groupKey];
#endif
        // identifier
        NSString *identifierKey = [XZKeychain _XZKeychain_keyObjectForAtrribute:(XZKeychainAttributeGeneric)];
        [keychainQuery setObject:identifier forKey:identifierKey];
        
        // 设置只返回第一个匹配的结果
        [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit]; // 只返回一个
        [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnAttributes];  // 返回“非加密属性”字典
        
        // 设置检索条件
        NSMutableDictionary *tempQuery = [[NSMutableDictionary alloc] initWithDictionary:keychainQuery];
        
        // 执行搜索
        CFDictionaryRef resultDictRef = NULL;
        OSStatus result = SecItemCopyMatching((__bridge CFDictionaryRef)tempQuery, (CFTypeRef *)&resultDictRef);
        if (result != noErr) {
            // 如果没有找到钥匙串，将这些值作为默认值写入。
            [self _XZKeychain_attributesLazyLoad];
            // 默认属性
            [self setValue:identifier forAttribute:(XZKeychainAttributeGeneric)];
#if !TARGET_IPHONE_SIMULATOR
            // access group
            if (group != nil) {
                [self setValue:group forAttribute:(XZKeychainAttributeAccessGroup)];
            }
#endif
            // [self setValue:@"" forAttribute:(XZKeychainAttributeAccount)];
            // [self setValue:@"" forAttribute:(XZKeychainAttributeLabel)];
            // [self setValue:@"" forAttribute:(XZKeychainAttributeDescription)];
            // 默认Data：密码为空
            // [_attributes setObject:@"" forKey:kXZGenericPasswordKeychainPasswordKey];
        } else {
            // 保存属性
            NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:(__bridge NSDictionary * _Nonnull)(resultDictRef)];
            [self _XZKeychain_setAttributes:attributes];
            
            // 查询密码：密码并不是随属性一起返回的，需要重新在钥匙串中查询。
            NSMutableDictionary *passwordQuery = [NSMutableDictionary dictionaryWithDictionary:attributes];
            // 设置返回值为 CFDataRef
            [passwordQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
            // 钥匙串类型
            id typeObject = [[self class] _XZKeychain_objectForType:self.type];
            [passwordQuery setObject:typeObject forKey:kXZKeychainTypeKey];
            
            CFDataRef passwordDataRef = NULL;
            OSStatus resultStatus = SecItemCopyMatching((__bridge CFDictionaryRef)passwordQuery, (CFTypeRef *)&passwordDataRef);
            if (resultStatus == noErr) {
                NSData *passwordData = (__bridge NSData *)(passwordDataRef);
                // 将密码保存
                [attributes setObject:passwordData forKey:kXZGenericPasswordKeychainPasswordKey];
            } else {
                NSAssert(NO, @"出现严重错误，在钥匙串中没有找到密码。\n");
            }
            if (passwordDataRef != NULL) {
                CFRelease(passwordDataRef);
            }
        }
        if (resultDictRef != NULL) {
            CFRelease(resultDictRef);
        }
    }
    return self;
}

- (NSString *)account {
    return [self valueForAttribute:(XZKeychainAttributeAccount)];
}

- (void)setAccount:(NSString *)account {
    [self setValue:account forAttribute:(XZKeychainAttributeAccount)];
}

- (NSString *)password {
    NSString *password = nil;
    NSData *passwordData = [[self _XZKeychain_attributesLazyLoad] objectForKey:kXZGenericPasswordKeychainPasswordKey];
    if (passwordData != nil) {
        password = [[NSString alloc] initWithData:passwordData encoding:(NSUTF8StringEncoding)];
    }
    return password;
}

- (void)setPassword:(NSString *)password {
    if (password != nil) {
        NSData *passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
        [[self _XZKeychain_attributesLazyLoad] setObject:passwordData forKey:kXZGenericPasswordKeychainPasswordKey];
    }
}

@end






