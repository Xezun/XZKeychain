//
//  XZKeychain.m
//  Keychain
//
//  Created by iMac on 16/6/24.
//  Copyright © 2016年 人民网. All rights reserved.
//

#import "XZKeychain.h"
#import <objc/runtime.h>

// 设置钥匙串类型的键名
#define kXZKeychainTypeKey  (NSString *)kSecClass

NSInteger const kXZKeychainStatusNoError = noErr;

@interface _XZKeychainValue : NSObject

@property (nonatomic, strong) id originalValue;
@property (nonatomic, strong) id updatingValue;

@end

@implementation _XZKeychainValue

@end

@interface XZKeychain ()

@property (nonatomic, strong) NSMutableDictionary<id, _XZKeychainValue *> *attributes;

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
        case XZKeychainTypeCertificate:
            return (NSString *)kSecClassCertificate;
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

+ (id)_XZKeychain_keyObjectForAttribute:(XZKeychainAttribute)attribute {
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

#pragma mark - 一系列存取属性的方法

- (void)setValue:(id)value forAttribute:(XZKeychainAttribute)attribute {
    if (![[self valueForAttribute:attribute] isEqual:value]) {
        NSString *key = [[self class] _XZKeychain_keyObjectForAttribute:attribute];
        self.attributes[key].updatingValue = value;
    }
}

- (void)setObject:(id)anObject forAttribute:(XZKeychainAttribute)attribute {
    [self setValue:anObject forAttribute:attribute];
}

- (id)valueForAttribute:(XZKeychainAttribute)attribute {
    NSString *aKey = [[self class] _XZKeychain_keyObjectForAttribute:attribute];
    return _attributes[aKey].updatingValue;
}

- (id)objectForAttribute:(XZKeychainAttribute)attribute {
    return [self valueForAttribute:attribute];
}

- (void)setObject:(id)anObject atIndexedSubscript:(XZKeychainAttribute)attribute {
    [self setValue:anObject forAttribute:attribute];
}

- (id)objectAtIndexedSubscript:(XZKeychainAttribute)attribute {
    return [self valueForAttribute:attribute];
}

#pragma mark - 将钥匙串保存到系统

- (BOOL)writeToKeychainStore:(NSError *__autoreleasing  _Nullable *)error {
    OSStatus statusCode = errSecBadReq;
    NSInteger count = _attributes.count;
    if (count > 0) {
        __block BOOL needUpdate = NO;
        [_attributes enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, _XZKeychainValue * _Nonnull obj, BOOL * _Nonnull stop) {
            if (obj.originalValue != obj.updatingValue) {
                needUpdate = YES;
                *stop = YES;
            }
        }];
        if (needUpdate) {
            NSMutableDictionary *originalAttributes = [NSMutableDictionary dictionaryWithCapacity:count];
            NSMutableDictionary *updatingAttributes = [NSMutableDictionary dictionaryWithCapacity:count];
            [_attributes enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, _XZKeychainValue * _Nonnull obj, BOOL * _Nonnull stop) {
                originalAttributes[key] = obj.originalValue;
                updatingAttributes[key] = obj.updatingValue;
            }];
            id typeObject = [XZKeychain _XZKeychain_objectForType:self.type];
            if (originalAttributes.count > 0) {
                // 设置搜索条件、设置类型
                originalAttributes[kXZKeychainTypeKey] = typeObject;
                // 执行更新
                statusCode = SecItemUpdate((__bridge CFDictionaryRef)originalAttributes, (__bridge CFDictionaryRef)updatingAttributes);
            } else {
                // 插入新钥匙串，要指定钥匙串类型
                updatingAttributes[kXZKeychainTypeKey] = typeObject;
                statusCode = SecItemAdd((__bridge CFDictionaryRef)updatingAttributes, NULL);
            }
        }
        
    }
    
    if (statusCode == noErr) {
        [_attributes enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, _XZKeychainValue * _Nonnull obj, BOOL * _Nonnull stop) {
            obj.originalValue = obj.updatingValue;
        }];
        return YES;
    }
    if (error != NULL) {
        *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:statusCode userInfo:@{NSLocalizedFailureReasonErrorKey: [XZKeychain _XZKeyChain_descriptionForErrorStatus:statusCode]}];
    }
    return NO;
}

- (BOOL)deleteFromKeychainStore:(NSError *__autoreleasing  _Nullable *)error {
    OSStatus statusCode = errSecItemNotFound;
    NSInteger count = _attributes.count;
    if (count > 0) {
        NSMutableDictionary *query = [NSMutableDictionary dictionaryWithCapacity:count];
        [_attributes enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, _XZKeychainValue * _Nonnull obj, BOOL * _Nonnull stop) {
            query[key] = obj.originalValue;
        }];
        id typeObject = [XZKeychain _XZKeychain_objectForType:self.type];
        query[kXZKeychainTypeKey] = typeObject;
        statusCode = SecItemDelete((__bridge CFDictionaryRef)query);
    }
    if (statusCode != noErr) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:statusCode userInfo:@{NSLocalizedFailureReasonErrorKey: [XZKeychain _XZKeyChain_descriptionForErrorStatus:statusCode]}];
        }
        return (statusCode == errSecItemNotFound);
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
//        NSMutableDictionary *keychainQuery = [self _XZKeychainQueryLazyLoad];
//        // 钥匙串分类
//        NSString *typeObject = [XZKeychain _XZKeychain_objectForType:_type];
//        [keychainQuery setObject:typeObject forKeyedSubscript:kXZKeychainTypeKey];
//#if !TARGET_IPHONE_SIMULATOR
//        // access group
//        NSString *groupKey = [XZKeychain _XZKeychain_keyObjectForAtrribute:(XZKeychainAttributeAccessGroup)];
//        [query setObject:group forKeyedSubscript:groupKey];
//#endif
//        
//        // identifier
//        NSString *identifierKey = [XZKeychain _XZKeychain_keyObjectForAttribute:(XZKeychainAttributeGeneric)];
//        [keychainQuery setObject:identifier forKeyedSubscript:identifierKey];
//        
//        // 设置只返回第一个匹配的结果
//        [keychainQuery setObject:(id)kSecMatchLimitOne forKeyedSubscript:(id)kSecMatchLimit]; // 只返回一个
//        [keychainQuery setObject:(id)kCFBooleanTrue forKeyedSubscript:(id)kSecReturnAttributes];  // 返回“非加密属性”字典
//        
//        // 设置检索条件
//        NSMutableDictionary *tempQuery = [[NSMutableDictionary alloc] initWithDictionary:keychainQuery];
//        
//        // 执行搜索
//        CFDictionaryRef resultDictRef = NULL;
//        OSStatus result = SecItemCopyMatching((__bridge CFDictionaryRef)tempQuery, (CFTypeRef *)&resultDictRef);
//        if (result != noErr) {
//            // 如果没有找到钥匙串，将这些值作为默认值写入。
//            [self _XZKeychain_attributesLazyLoad];
//            // 默认属性
//            [self setValue:identifier forAttribute:(XZKeychainAttributeGeneric)];
//#if !TARGET_IPHONE_SIMULATOR
//            // access group
//            if (group != nil) {
//                [self setValue:group forAttribute:(XZKeychainAttributeAccessGroup)];
//            }
//#endif
//            // [self setValue:@"" forAttribute:(XZKeychainAttributeAccount)];
//            // [self setValue:@"" forAttribute:(XZKeychainAttributeLabel)];
//            // [self setValue:@"" forAttribute:(XZKeychainAttributeDescription)];
//            // 默认Data：密码为空
//            // [_attributes setObject:@"" forKeyedSubscript:kXZGenericPasswordKeychainPasswordKey];
//        } else {
//            // 保存属性
//            NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:(__bridge NSDictionary * _Nonnull)(resultDictRef)];
//            
//            // 查询密码：密码并不是随属性一起返回的，需要重新在钥匙串中查询。
//            NSMutableDictionary *passwordQuery = [NSMutableDictionary dictionaryWithDictionary:attributes];
//            // 设置返回值为 CFDataRef
//            [passwordQuery setObject:(id)kCFBooleanTrue forKeyedSubscript:(id)kSecReturnData];
//            // 钥匙串类型
//            id typeObject = [[self class] _XZKeychain_objectForType:self.type];
//            [passwordQuery setObject:typeObject forKeyedSubscript:kXZKeychainTypeKey];
//            
//            CFDataRef passwordDataRef = NULL;
//            OSStatus resultStatus = SecItemCopyMatching((__bridge CFDictionaryRef)passwordQuery, (CFTypeRef *)&passwordDataRef);
//            if (resultStatus == noErr) {
//                NSData *passwordData = (__bridge NSData *)(passwordDataRef);
//                // 将密码保存
//                attributes[kXZGenericPasswordKeychainPasswordKey] = passwordData;
//                [self _XZKeychain_setAttributes:attributes];
//            } else {
//                NSAssert(NO, @"出现严重错误，在钥匙串中没有找到密码。\n");
//            }
//            if (passwordDataRef != NULL) {
//                CFRelease(passwordDataRef);
//            }
//        }
//        if (resultDictRef != NULL) {
//            CFRelease(resultDictRef);
//        }
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
//    NSData *passwordData = [[self _XZKeychain_attributesLazyLoad] objectForKey:kXZGenericPasswordKeychainPasswordKey];
//    if (passwordData != nil) {
//        password = [[NSString alloc] initWithData:passwordData encoding:(NSUTF8StringEncoding)];
//    }
    return password;
}

- (void)setPassword:(NSString *)password {
    if (password != nil) {
//        NSData *passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
//        [[self _XZKeychain_attributesLazyLoad] setObject:passwordData forKeyedSubscript:kXZGenericPasswordKeychainPasswordKey];
    }
}

@end




@interface XZKeychainManager () {
    NSMutableDictionary *_XZKeychainManager_Query;
}

@end

@implementation XZKeychainManager

+ (NSArray<XZKeychain *> *)allKeychains:(NSError *__autoreleasing  _Nullable *)error {
    return [[[self alloc] init] search:error];
}

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        _XZKeychainManager_Query = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)addQueryObject:(id)anObject forAttribute:(XZKeychainAttribute)attribute {
    NSString *key = [XZKeychain _XZKeychain_keyObjectForAttribute:attribute];
    [_XZKeychainManager_Query setObject:anObject forKey:key];
}

- (NSArray<XZKeychain *> *)search:(NSError *__autoreleasing  _Nullable *)error {
    return [self searchWithKeychainType:(XZKeychainTypeNotAType) error:error];
}

- (NSArray<XZKeychain *> *)searchWithKeychainType:(XZKeychainType)keychainType error:(NSError *__autoreleasing  _Nullable * _Nullable)error {
    NSMutableArray<XZKeychain *> *keychains = nil;
    NSMutableDictionary *keychainQuery = [NSMutableDictionary dictionaryWithDictionary:_XZKeychainManager_Query];
    // 设置检索条件
    if (keychainType < XZKeychainTypeNotAType) {
        // 钥匙串分类
        NSString *typeObject = [XZKeychain _XZKeychain_objectForType:keychainType];
        [keychainQuery setObject:typeObject forKeyedSubscript:kXZKeychainTypeKey];
    } else {
        for (XZKeychainType type = 0; type < XZKeychainTypeNotAType; type++) {
            NSMutableArray *tmp = (NSMutableArray *)[self searchWithKeychainType:type error:error];
            if (error != NULL && *error != nil) {
                keychains = nil;
                break;
            } else {
                if (keychains == nil) {
                    keychains = tmp;
                } else {
                    [keychains addObjectsFromArray:tmp];
                }
            }
        }
        return keychains;
    }
    
    // 设置只返回所有匹配的结果
    [keychainQuery setObject:(id)kSecMatchLimitAll forKeyedSubscript:(id)kSecMatchLimit]; // 只返回一个
    [keychainQuery setObject:(id)kCFBooleanTrue forKeyedSubscript:(id)kSecReturnAttributes];  // 返回“非加密属性”字典
    
    // 执行搜索
    CFArrayRef resultArrayRef = NULL;
    OSStatus statusCode = SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&resultArrayRef);
    if (statusCode == noErr) {
        if (resultArrayRef != NULL) {
            NSInteger count = CFArrayGetCount(resultArrayRef);
            if (count > 0) {
                keychains = [[NSMutableArray alloc] initWithCapacity:count];
                NSArray<NSDictionary *> *attributesArray = (__bridge NSArray * _Nonnull)(resultArrayRef);
                for (NSDictionary *attributesDict in attributesArray) {
                    XZKeychain *keychain = [[XZKeychain alloc] initWithType:keychainType];
                    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] initWithCapacity:attributesDict.count];
                    [attributesDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                        _XZKeychainValue *value = [[_XZKeychainValue alloc] init];
                        value.originalValue = obj;
                        value.updatingValue = obj;
                        attributes[key] = value;
                    }];
                    keychain.attributes = attributes;
                    [keychains addObject:keychain];
                }
            }
            CFRelease(resultArrayRef);
        }
    } else if (statusCode != errSecItemNotFound && error != NULL) {
        NSString *description = [XZKeychain _XZKeyChain_descriptionForErrorStatus:statusCode];
        *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:statusCode userInfo:@{NSLocalizedDescriptionKey: description}];
    }
    return keychains;
}

@end



