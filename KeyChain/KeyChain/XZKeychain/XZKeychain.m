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

NSString *const kXZKeychainErrorDomain = @"com.mlibai.keychain";

static NSString *NSStringFromKeychainItemType(XZKeychainType type) {
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
        case XZKeychainTypeNotSupported:
            return nil;
        default:
            break;
    }
}

static NSString *NSStringFromKeychainAttribute(XZKeychainAttribute attribute) {
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
            //XZKeychainInternetPassword 支持的属性：
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
            
            // XZKeychainCertificate 支持的属性：
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
            
            // XZKeychainKey 支持的属性：
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
            return nil;
            break;
    }
}

static NSString *NSStringFromOSStaus(OSStatus status) {
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
            return @"未知错误";
            break;
    }
}

#pragma mark - _XZKeychainValue

@interface _XZKeychainItemAttributeValue : NSObject

@property (nonatomic, strong) id originalValue;
@property (nonatomic, strong) id updatingValue;

@end

@implementation _XZKeychainItemAttributeValue

- (NSString *)description {
    return [NSString stringWithFormat:@"{originalValue: %@, updatingValue: %@}", self.originalValue, self.updatingValue];
}

@end

#pragma mark - XZKeychainItem

@interface XZKeychain () {
    NSMutableDictionary<NSString *, _XZKeychainItemAttributeValue *> *_attributes;
}

- (NSMutableDictionary<NSString *, _XZKeychainItemAttributeValue *> *)_XZKeychain_attributesIfLoaded;
- (NSMutableDictionary<NSString *, _XZKeychainItemAttributeValue *> *)_XZKeychain_attributesLazyLoad;

@end


@implementation XZKeychain

- (NSDictionary *)attributes {
    NSMutableDictionary *tmp = nil;
    if ([self _XZKeychain_attributesIfLoaded].count > 0) {
        tmp = [[NSMutableDictionary alloc] init];
        [[self _XZKeychain_attributesIfLoaded] enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, _XZKeychainItemAttributeValue * _Nonnull obj, BOOL * _Nonnull stop) {
            tmp[key] = obj.updatingValue;
        }];
    }
    return tmp;
}

+ (instancetype)keychainWithType:(XZKeychainType)type {
    return [[self alloc] initWithType:type];
}

- (instancetype)init {
    return [self initWithType:(XZKeychainTypeGenericPassword)];
}

- (instancetype)initWithType:(XZKeychainType)type {
    self = [super init];
    if (self != nil) {
        _type = type;
    }
    return self;
}

#pragma mark - 私有方法

- (NSString *)_XZKeychain_typeString {
    NSString *typeString = NSStringFromKeychainItemType(self.type);
    return typeString;
}

- (NSMutableDictionary<NSString *,_XZKeychainItemAttributeValue *> *)_XZKeychain_attributesIfLoaded {
    return _attributes;
}

- (NSMutableDictionary<NSString *, _XZKeychainItemAttributeValue *> *)_XZKeychain_attributesLazyLoad {
    if (_attributes != nil) {
        return _attributes;
    }
    _attributes = [[NSMutableDictionary alloc] init];
    return _attributes;
}

#pragma mark - 公开方法

- (BOOL)isModified {
    BOOL isModified = NO;
    for (_XZKeychainItemAttributeValue *value in [self _XZKeychain_attributesIfLoaded].allValues) {
        if (value.originalValue != value.updatingValue) {
            isModified = YES;
            break;
        }
    }
    return isModified;
}

- (void)setValue:(id)value forAttribute:(XZKeychainAttribute)attribute {
    if ([self valueForAttribute:attribute] != value) {
        NSString *aKey = NSStringFromKeychainAttribute(attribute);
        [self _XZKeychain_setValue:value forAttributeKey:aKey];
    }
}

- (void)_XZKeychain_setValue:(id)aValue forAttributeKey:(NSString *)attributeKey {
    NSMutableDictionary *attributes = [self _XZKeychain_attributesLazyLoad];
    _XZKeychainItemAttributeValue *keychainValue = attributes[attributeKey];
    if (keychainValue == nil) {
        keychainValue = [[_XZKeychainItemAttributeValue alloc] init];
        attributes[attributeKey] = keychainValue;
    }
    keychainValue.updatingValue = aValue;
}

- (void)setObject:(id)anObject forAttribute:(XZKeychainAttribute)attribute {
    [self setValue:anObject forAttribute:attribute];
}

- (id)_XZKeychain_valueForAttributeKey:(NSString *)aKey {
    return [self _XZKeychain_attributesIfLoaded][aKey].updatingValue;
}

- (id)valueForAttribute:(XZKeychainAttribute)attribute {
    NSString *aKey = NSStringFromKeychainAttribute(attribute);
    return [self _XZKeychain_valueForAttributeKey:aKey];
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

- (void)reset {
    [[self _XZKeychain_attributesIfLoaded] enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, _XZKeychainItemAttributeValue * _Nonnull obj, BOOL * _Nonnull stop) {
        obj.updatingValue = obj.originalValue;
    }];
}

#pragma mark - 增删改查

- (BOOL)_XZKeychain_handleStatus:(OSStatus)statusCode operation:(BOOL)isDeleting error:(NSError *__autoreleasing  _Nullable *)error {
    if (statusCode == noErr) {
        if (isDeleting) {
            [[self _XZKeychain_attributesIfLoaded] enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, _XZKeychainItemAttributeValue * _Nonnull obj, BOOL * _Nonnull stop) {
                obj.originalValue = nil;
                obj.updatingValue = nil;
            }];
        } else {
            [[self _XZKeychain_attributesIfLoaded] enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, _XZKeychainItemAttributeValue * _Nonnull obj, BOOL * _Nonnull stop) {
                obj.originalValue = obj.updatingValue;
            }];
        }
        return YES;
    }
    if (error != NULL) {
        NSString *localizedDescription = NSStringFromOSStaus(statusCode);
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: localizedDescription};
        *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:statusCode userInfo:userInfo];
    }
    return NO;
}

- (BOOL)insert:(NSError * _Nullable * _Nullable)error {
    OSStatus statusCode = errSecBadReq;
    if ([self isModified]) {
        if (![self search:NULL]) {
            NSInteger count = self._XZKeychain_attributesIfLoaded.count;
            NSMutableDictionary *updatingAttributes = [NSMutableDictionary dictionaryWithCapacity:count];
            [[self _XZKeychain_attributesIfLoaded] enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, _XZKeychainItemAttributeValue * _Nonnull obj, BOOL * _Nonnull stop) {
                updatingAttributes[key] = obj.updatingValue;
            }];
            // 插入新钥匙串，要指定钥匙串类型
            updatingAttributes[kXZKeychainTypeKey] = [self _XZKeychain_typeString];
            statusCode = SecItemAdd((__bridge CFDictionaryRef)updatingAttributes, NULL);
        } else {
            statusCode = errSecDuplicateItem;
        }
    }
    return [self _XZKeychain_handleStatus:statusCode operation:NO error:error];
}

- (BOOL)remove:(NSError * _Nullable * _Nullable)error {
    OSStatus statusCode = errSecBadReq;
    NSMutableDictionary *attributes = [self _XZKeychain_attributesIfLoaded];
    if (attributes != nil && attributes.count > 0) { // 当参数不为 0 的时候。
        if ([self search:NULL]) {
            NSMutableDictionary *query = [NSMutableDictionary dictionaryWithDictionary:attributes];
            [attributes enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, _XZKeychainItemAttributeValue * _Nonnull obj, BOOL * _Nonnull stop) {
                query[key] = obj.originalValue;
            }];
            if (query.count > 0) {
                query[kXZKeychainTypeKey] = [self _XZKeychain_typeString];
                statusCode = SecItemDelete((__bridge CFDictionaryRef)query);
            }
        } else {
            statusCode = errSecItemNotFound;
        }
    }
    return [self _XZKeychain_handleStatus:statusCode operation:YES error:error];
}

- (BOOL)update:(NSError * _Nullable * _Nullable)error {
    OSStatus statusCode = errSecBadReq;
    if ([self isModified]) {
        if ([self search:NULL]) {
            NSInteger count = self._XZKeychain_attributesIfLoaded.count;
            NSMutableDictionary *originalAttributes = [NSMutableDictionary dictionaryWithCapacity:count];
            NSMutableDictionary *updatingAttributes = [NSMutableDictionary dictionaryWithCapacity:count];
            [[self _XZKeychain_attributesIfLoaded] enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, _XZKeychainItemAttributeValue * _Nonnull obj, BOOL * _Nonnull stop) {
                originalAttributes[key] = obj.originalValue;
                updatingAttributes[key] = obj.updatingValue;
            }];
            originalAttributes[kXZKeychainTypeKey] = [self _XZKeychain_typeString];
            statusCode = SecItemUpdate((__bridge CFDictionaryRef)originalAttributes, (__bridge CFDictionaryRef)updatingAttributes);
        } else {
            statusCode = errSecItemNotFound;
        }
    }
    return [self _XZKeychain_handleStatus:statusCode operation:NO error:error];
}

- (BOOL)search:(NSError *__autoreleasing  _Nullable *)error {
    OSStatus statusCode             = errSecBadReq;                     // 状态码
    // 创建查询条件
    NSMutableDictionary *query = [[NSMutableDictionary alloc] init];
    query[kXZKeychainTypeKey]       = NSStringFromKeychainItemType(self.type);
    query[(id)kSecMatchLimit]       = (id)kSecMatchLimitOne;    // 返回一个
    query[(id)kSecReturnAttributes] = (id)kCFBooleanTrue;       // 返回“非加密属性”字典
    [self._XZKeychain_attributesIfLoaded enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, _XZKeychainItemAttributeValue * _Nonnull obj, BOOL * _Nonnull stop) {
        query[key] = obj.updatingValue;
    }];
    
    // 执行搜索
    CFDictionaryRef resultRef = NULL;
    statusCode = SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef *)&resultRef);
    if (statusCode == noErr) { // 无错误
        if (resultRef != NULL) {
            [(__bridge NSDictionary *)resultRef enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                _XZKeychainItemAttributeValue *value = [self _XZKeychain_attributesLazyLoad][key];
                if (value == nil) {
                    value = [[_XZKeychainItemAttributeValue alloc] init];
                    [self _XZKeychain_attributesLazyLoad][key] = value;
                }
                value.originalValue = obj; // 只改变了原始值。
                if (value.updatingValue == nil) {
                    value.updatingValue = obj;
                }
            }];
            CFRelease(resultRef);
        }
        return YES;
    }
    if (error != NULL) {  // 有错误且参数 error 不为 NULL
        NSString *localizedDescription = NSStringFromOSStaus(statusCode);
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: localizedDescription};
        *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:noErr userInfo:userInfo];
    }
    return NO;
}

- (NSMutableDictionary *)_XZKeychain_attributeValuedDictionaryFromDictionary:(NSDictionary *)fromDictionary {
    NSMutableDictionary *resultDictionary = [[NSMutableDictionary alloc] initWithCapacity:fromDictionary.count];
    [fromDictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        _XZKeychainItemAttributeValue *value = [[_XZKeychainItemAttributeValue alloc] init];
        value.originalValue = obj;
        value.updatingValue = obj;
        resultDictionary[key] = value;
    }];
    return resultDictionary;
}

- (NSArray<XZKeychain *> *)match:(NSError *__autoreleasing  _Nullable *)error {
    OSStatus statusCode             = errSecBadReq;                     // 状态码
    NSMutableArray *keychainItems   = nil;                              // 返回值
    
    NSMutableDictionary *query = [[NSMutableDictionary alloc] init];
    query[kXZKeychainTypeKey]       = NSStringFromKeychainItemType(self.type);
    query[(id)kSecMatchLimit]       = (id)kSecMatchLimitAll;// 返回所有
    query[(id)kSecReturnAttributes] = (id)kCFBooleanTrue;// 返回“非加密属性”字典
    [self._XZKeychain_attributesIfLoaded enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, _XZKeychainItemAttributeValue * _Nonnull obj, BOOL * _Nonnull stop) {
        query[key] = obj.updatingValue;
    }];
    
    // 执行搜索
    CFArrayRef resultRef = NULL;
    statusCode = SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef *)&resultRef);
    if (statusCode == noErr) { // 无错误
        if (resultRef != NULL) {
            if (CFArrayGetCount(resultRef) > 0) {
                keychainItems = [[NSMutableArray alloc] init];
                [(__bridge NSArray *)resultRef enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull itemDict, NSUInteger idx, BOOL * _Nonnull stop) {
                    XZKeychain *item = [[XZKeychain alloc] initWithType:self.type];
                    [itemDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                        _XZKeychainItemAttributeValue *value = [[_XZKeychainItemAttributeValue alloc] init];
                        value.originalValue = obj;
                        value.updatingValue = obj;
                        [item _XZKeychain_attributesLazyLoad][key] = value;
                    }];
                    [keychainItems addObject:item];
                }];
            }
            CFRelease(resultRef);
        }
    } else if (error != NULL) {  // 有错误且参数 error 不为 NULL
        NSString *localizedDescription = NSStringFromOSStaus(statusCode);
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: localizedDescription};
        *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:noErr userInfo:userInfo];
    }
    return keychainItems;
}

+ (NSArray<XZKeychain *> *)match:(NSArray<XZKeychain *> *)matches error:(NSError *__autoreleasing  _Nullable *)error {
    NSMutableArray *keychainItems   = nil;
    NSMutableDictionary *errors = nil;
    for (XZKeychain *item in matches) {
        NSError *tmpError = nil;
        NSArray *tmpArray = [item match:&tmpError];
        if (keychainItems == nil) {
            keychainItems = (NSMutableArray *)tmpArray;
        } else {
            [keychainItems addObjectsFromArray:tmpArray];
        }
        if (error != NULL && tmpError != nil) {
            NSString *aKey = NSStringFromKeychainItemType(item.type) ?: @"Not A Keychain";
            if (errors == nil) {
                errors = [NSMutableDictionary dictionary];
            }
            errors[aKey] = tmpError;
        }
    }
    if (errors != nil) {  // errors 不等于 nil 时，error 一定不为 NULL。
        *error = [NSError errorWithDomain:kXZKeychainErrorDomain code:-9999 userInfo:errors];
    }
    return keychainItems;
}

+ (NSArray<XZKeychain *> *)allKeychains {
    NSMutableArray *matches = [[NSMutableArray alloc] init];
    for (XZKeychainType type = 0; type < XZKeychainTypeNotSupported; type++) {
        XZKeychain *item = [[XZKeychain alloc] initWithType:type];
        [matches addObject:item];
    }
    return [self match:matches error:NULL];
}

@end

/**
 *  从钥匙串中获取密码的键名
 */
#define kXZGenericPasswordKeychainPasswordKey (id)kSecValueData

@implementation XZKeychain (XZGenericPasswordKeychainItem)

- (NSString *)identifier {
    return [self valueForAttribute:(XZKeychainAttributeGeneric)];
}

- (void)setIdentifier:(NSString *)identifier {
    [self setValue:identifier forAttribute:(XZKeychainAttributeGeneric)];
}

- (NSString *)account {
    return [self valueForAttribute:(XZKeychainAttributeAccount)];
}

- (void)setAccount:(NSString *)account {
    [self setValue:account forAttribute:(XZKeychainAttributeAccount)];
}

- (NSString *)password {
    NSString *password = nil;
    if ([self _XZKeychain_attributesIfLoaded][kXZGenericPasswordKeychainPasswordKey] == nil) {
        [self _XZKeychain_loadPasswordData];
    }
    NSData *passwordData = [self _XZKeychain_valueForAttributeKey:kXZGenericPasswordKeychainPasswordKey];
    if (passwordData != nil) {
        password = [[NSString alloc] initWithData:passwordData encoding:(NSUTF8StringEncoding)];
    }
    return password;
}

- (void)setPassword:(NSString *)password {
    if (self.password != password) {
        NSData *passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
        [self _XZKeychain_setValue:passwordData forAttributeKey:kXZGenericPasswordKeychainPasswordKey];
    }
}

- (void)_XZKeychain_loadPasswordData {
    NSMutableDictionary *attributes = [self _XZKeychain_attributesIfLoaded];
    if (attributes != NULL && attributes.count > 0) {
        // 查询密码：密码并不是随属性一起返回的，需要重新在钥匙串中查询。
        NSMutableDictionary *passwordQuery = [NSMutableDictionary dictionary];
        [attributes enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, _XZKeychainItemAttributeValue * _Nonnull obj, BOOL * _Nonnull stop) {
            passwordQuery[key] = obj.originalValue;
        }];
        _XZKeychainItemAttributeValue *passwordValue = [[_XZKeychainItemAttributeValue alloc] init];
        if (passwordQuery.count > 0) {
            // 设置返回值为 CFDataRef
            passwordQuery[(id)kSecReturnData] = (id)kCFBooleanTrue;
            // 钥匙串类型
            passwordQuery[kXZKeychainTypeKey] = [self _XZKeychain_typeString];
            
            CFDataRef passwordDataRef = NULL;
            OSStatus resultStatus = SecItemCopyMatching((__bridge CFDictionaryRef)passwordQuery, (CFTypeRef *)&passwordDataRef);
            if (resultStatus == noErr) {
                if (passwordDataRef != NULL) {
                    NSData *passwordData = (__bridge NSData *)(passwordDataRef);
                    passwordValue.originalValue = passwordData;
                    passwordValue.updatingValue = passwordData;
                    CFRelease(passwordDataRef);
                }
            } else {
                NSLog(@"Warning: 从钥匙串获取密码失败！");
            }
        }
        [self _XZKeychain_attributesLazyLoad][kXZGenericPasswordKeychainPasswordKey] = passwordValue;
    }
}

@end




