//
//  SYSContactManager.m
//  XMLDecoder
//
//  Created by lifei on 2018/2/5.
//  Copyright © 2018年 lifei. All rights reserved.
//

#import "SYSContactManager.h"
#import <Contacts/Contacts.h>
#import "RedPacketMngr.h"
#import "ONENetworkTool.h"
static SYSContactManager *manager = nil;

@interface SYSContactManager()

@property (nonatomic, strong) CNContactStore *cnStore;

@property (nonatomic, strong) NSArray *addressbookList;

@end

@implementation SYSContactManager
static dispatch_once_t onceToken;
+ (instancetype)manager
{
    dispatch_once(&onceToken, ^{
        manager = [[SYSContactManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _cnStore = [[CNContactStore alloc] init];
        _addressbookList = [NSArray array];
    }
    return self;
}

- (void)uploadSystemAddressBookListWithCompletion:(void(^)(NSError *))completion {
    
    [self getSystemAddressBookListWithCompletetion:^(NSError *error, NSArray *list) {
        
        if (!error)
        {
            NSString *jsonString = [list yy_modelToJSONString];
            if (!jsonString || jsonString.length == 0) {
                
                completion([NSError new]);
                return;
            }
            NSString *account_id = [ONEChatClient homeAccountId];
            if (account_id == nil || account_id.length == 0) {
                
                completion([NSError new]);
                return;
            }
            NSDictionary *dic = @{
                                  @"account_id":account_id,
                                  @"param": jsonString
                                  };
            [ONENetworkTool postUrlString:[ONEUrlHelper syncAddressbookHttpUrl] withParam:dic withSuccessBlock:^(id data) {

                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([data[@"code"] isEqualToString:@"100200"]) {

                        completion(nil);
                    } else {

                        completion([NSError new]);
                    }
                });
            } withFailedBlock:^(NSError *error) {

                dispatch_async(dispatch_get_main_queue(), ^{
                    completion([NSError new]);
                });
            } withErrorBlock:^(NSString *message) {

            }];
        } else {

            dispatch_async(dispatch_get_main_queue(), ^{

                if (error.code == 1005) {

                    completion(error);
                } else {

                    completion([NSError new]);
                }
            });
        }
    }];
    
}


- (void)getSystemAddressBookListWithCompletetion:(void (^)(NSError *, NSArray *))completion
{
    if (_addressbookList.count > 0) {
        
        completion(nil, _addressbookList);
        return;
    }
    CNContactStore *_cnStore = [[CNContactStore alloc] init];
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    __block NSArray *contacts = [NSArray array];
    
    if (status == CNAuthorizationStatusNotDetermined) {
        
        [_cnStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            
            if (granted && !error) {
                
                contacts = [self getContactList];
                self.addressbookList = [contacts copy];
                completion(nil, contacts);
            } else {
                
                completion([NSError new], nil);
            }
        }];
    } else if (status == CNAuthorizationStatusAuthorized) {
        
        contacts = [self getContactList];
        self.addressbookList = [contacts copy];
        completion(nil, contacts);
    } else {
        completion([NSError errorWithDomain:@"" code:1005 userInfo:nil], nil);
    }
}

- (NSArray *)getContactList
{
    __block NSMutableArray *list = [NSMutableArray array];
    CNContactFetchRequest * request = [[CNContactFetchRequest alloc] initWithKeysToFetch:@[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactOrganizationNameKey, CNContactJobTitleKey,CNContactEmailAddressesKey]];
    [_cnStore enumerateContactsWithFetchRequest:request error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        
        NSDictionary *dic = [self contactDicFromContact:contact];
        [list addObject:dic];
    }];
    return list;
}


- (NSDictionary *)contactDicFromContact:(CNContact *)contact
{
    if (contact == nil) {
        return nil;
    }
    
    NSString *name = [self nameFromContact:contact];
    
    NSArray *phoneNumberList = [self phoneNumberListFromContact:contact];
    
    NSArray *emailList = [self emailListFromContact:contact];
    
    NSString *company = contact.organizationName ? contact.organizationName : @"";
    NSString *title = contact.jobTitle ? contact.jobTitle : @"";
    
    NSDictionary *dic = @{
                          @"company": company,
                          @"email":emailList,
                          @"phone":phoneNumberList,
                          @"name":name,
                          @"title":title
                          };
    return dic;
}


- (NSString *)nameFromContact:(CNContact *)contact
{
    NSString *givenName = contact.givenName ? contact.givenName : @"";
    NSString *familyName = contact.familyName ? contact.familyName : @"";
    NSString *name = [givenName stringByAppendingString:familyName];
    
    return name;
}

- (NSArray *)phoneNumberListFromContact:(CNContact *)contact
{
    NSArray *phoneNumbers = contact.phoneNumbers;
    NSMutableArray *phones = [NSMutableArray array];
    for (CNLabeledValue *labeledValue in phoneNumbers) {
        CNPhoneNumber *phoneNumer = labeledValue.value;
        NSString *phoneValue = phoneNumer.stringValue;
        if (phoneValue) {
            [phones addObject:phoneValue];
        }
    }
    return [NSArray arrayWithArray:phones];
}

- (NSArray *)emailListFromContact:(CNContact *)contact
{
    NSArray *emails = contact.emailAddresses;
    NSMutableArray *contactEmails = [NSMutableArray array];
    for (CNLabeledValue *value in emails) {
        if (value) {
            NSString *emailAddtess = value.value;
            if (emailAddtess) {
                [contactEmails addObject:emailAddtess];
            }
        }
    }
    return [NSArray arrayWithArray:contactEmails];
}



+ (void)clearManager
{
    onceToken = 0;
    manager = nil;
}



@end
