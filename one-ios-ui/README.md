# WalletCore  

## 结构   

- 账号管理
- 聊天管理
- 群组管理
- 联系人管理
- 红包管理
- 社区管理   

## 初始化SDK   

### 初始化环境

APP启动需要调用`registerSDK`来初始化SDK环境，在`Appdelegate`的`- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions `方法中调用。

```object-c
[[ONEChatClient sharedClient] registerSDK];
```

### 判断本地是否存在账号

如果本地没有账号则需要去注册或者恢复,建议在进行注册或者恢复之前先进行节点检测以选择性能最优的节点。如果本地有账号信息则验证密码即可。

```object-c
BOOL exist = [ONEChatClient isHomeAccountExist];
```   

## 注册恢复   

### 助记词   

助记词由15个单词组成   

- 生成助记词   

	```object-c
	NSString *seed = [ONEChatClient buildSeed];
	```
- 获取本地存储的助记词   

	```object-c
	NSString *seed = [ONEChatClient seedWithPassword:password];
	```
	
- 验证助记词是否合法

	```object-c
	// invalidSeeds会返回错误的助记单词列表
	NSMutableArray *invalidSeeds = [NSMutableArray array];
    
    ONEError *error = [ONEChatClient seedIsValid:seed invalidWords:&invalidSeeds];
	```   
	
- 获取加密助记词   

	加密助记词是通过助记词和用户密码通过一系列加密生成的加密字符串

	```object-c
	NSString *encryptedSeed = [ONEChatClient getEncryptedSeed];
	```   
	
- 用密码解密加密后的助记词   

	```object-c
	NSString *seed = [ONEChatClient aesCommonDecryptWithPass:password string:encryptedSeed];
	```
	
### 注册   

- 生成账号信息

	```object-c
	WSAccountInfo* info = [[WSAccountInfo alloc] init];
	info.name = name;	// 用户名
	info.nickname = nickname;	// 昵称
	info.referrer = invitecode;	// 邀请码
	info.sex = AccountMan;	// 性别
	```   
	
- 注册账号   

	注册账号需要传`WSAccountInfo`对象、助记词以及密码   


	```object-c
	[[ONEChatClient sharedClient] createAccount:info seed:seed password:password completion:^(ONEError *error){
	
		dispatch_async(dispatch_get_main_queue(), ^{

   			if (!error) {
		
					// 注册成功
    			} else {
					// 注册失败
   			}
		});
	}];

	```
	> 注册成功之后会回调`- (void)accountVerificationFinish:(AccountVerifyType)type;`在此方法中需要去做获取token等一系列操作。`delegate`使用方法使用见。   
	
### 恢复   

- 恢复账号   

	恢复账号需要传入助记词以及密码

	```object-c
	[[ONEChatClient sharedClient] recoverAccount:seed password:self.miMatextFiled.text completion:^(ONEError *error) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
           
            if (!error) {
                // 恢复成功
            } else {
                // 恢复失败
            }
        });
    }];
	```
	> 恢复成功之后也会回调`- (void)accountVerificationFinish:(AccountVerifyType)type;`。在此方法中需要去做获取token等一系列操作。`delegate`使用方法使用见。    
	
### 验证密码   

- 验证密码   

	APP每次启动,如果本地存在账号，则不需要进行注册或者恢复操作，通过验证密码可以激活账号。   
	
	```object-c
	BOOL state = [ONEChatClient verifyAccountWithPassword:password];
	```
	> 验证密码成功之后也会回调`- (void)accountVerificationFinish:(AccountVerifyType)type;`。在此方法中需要去做获取token等一系列操作。`delegate`使用方法使用见。   
	

## 账号管理   

### 当前账号信息   

- AccountName

	`AccountName`为注册时传入的用户名   
	获取自己的`AccountName`:
	
	```object-c
	NSString *accountName = [ONEChatClient homeAccountName];
	```

- AccountId

	`AccountId`是服务器生成的唯一ID，格式为`1.2.xxx`。   
	获取自己的`AccountId`:
	
	```object-c
	NSString *accountId = [ONEChatClient homeAccountId];
	```   
	
- AccountInfo   

	`AccountInfo`为自己的账号信息，包括用户名、昵称、性别、头像URL等信息。   
	获取自己的`AccountInfo`:   
	
	```object-c
	WSAccountInfo *info = [ONEChatClient homeAccountInfo];
	```
	
- 本地是否有账号信息   

	```object-c
	BOOL isExist = [ONEChatClient isHomeAccountExist];
	```   
	
- 本地账号是否已经激活   

	```object-c
	BOOL isActive = [ONEChatClient isHomeAccountActive];   
	```
	
- 更新本地账号信息   

	```object-c
	BOOL isSuccess = [ONEChatClient saveAccountInfo:accountInfo];
	```
	
- 更新用户信息到Server   

	只能更新用户性别、昵称、简介

	```object-c
    [[ONEChatClient sharedClient] pushAccountInfo:accInfo completion:^(ONEError *error) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
            		// 更新成功
            } else {
            		// 更新失败
            }
        });
    }];
	
	```   
	
- 上传用户头像   

	传入UIImage对象

	```object-c
	[[ONEChatClient sharedClient] uploadAvatar:image completion:^(ONEError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
            		// 上传成功
           } else {
           		// 上传失败
           }
        });
    }];
	```   
	
- 从服务器获取用户头像URL   


	```
	[[ONEChatClient sharedClient] fetchUserAvatarUrl:account_id completion:^(ONEError *error, NSString *newAvatarUrl) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
           
            if (!error) {
                WSAccountInfo *info = [ONEChatClient accountInfoWithName:accountName];
                info.avatar_url = newAvatarUrl;
                [ONEChatClient saveAccountInfo:info];
            }
        });
    }];
	```
	
	获取到的头像URL在界面展示时需要拼接Host   
	
	```object-c
	NSString *urlString = [NSString stringWithFormat:@"%@%@",[ONEUrlHelper userAvatarPrefix], accountInfo.avatar_url];
	```


### 他人账号信息

- 获取账号信息   

	```object-c
	// 根据accountId获取账号信息
	WSAccountInfo *info = [ONEChatClient accountInfoWithId:accountId];
	// 根据accountName获取账号信息
	WSAccountInfo *info = [ONEChatClient accountInfoWithName:accountName];
	// 根据accountName获取accountId
	NSString *accountId = [ONEChatClient accountIdWithName:accountName];
	```

- 通过`accountName`获取账号信息，如果本地有，取本地，本地没有从Server拉取   

	```object-c
	[[ONEChatClient sharedClient] pullAccountInfoWithAccountName:accountName completion:^(ONEError *error, WSAccountInfo *accountInfo) {
	    // 获取成功之后会自动更新本地存储的账号信息                    
	}];
	```   
	
- 通过`accountName`获取账号信息，直接从Server拉取更新本地   

	```object-c
    [[ONEChatClient sharedClient] updateFriendAccountInfoWithCompletion:^(ONEError *error) {
       	if (!error) {
       		// 成功
       	}
    }];
	```
	
- 批量获取账号信息   
	
	通过`accountId`列表获取,自动更新本地   
	
	```object-c
	[[ONEChatClient sharedClient] pullAccountInfosWithAccountIdList:needFetchList completion:^(ONEError *error) {
   }];
	```   
	
## 消息管理   

### 消息构造   


- 消息Body		

	|消息类型|ONEMessageBodyType|支持类型|   
	|:--:|:--:|:--:|   
	|文本|ONEMessageBodyTypeText|全部|
	|图片|ONEMessageBodyTypeImage|全部|
	|位置|ONEMessageBodyTypeLocation|全部|
	|语音|ONEMessageBodyTypeVoice|全部|
	|红包|ONEMessageBodyTypeRedpacket|群聊|

- 文本消息   

	```object-c
	NSString *willSendText = @"message";
	ONETextMessageBody *body = [[ONETextMessageBody alloc] initWithText:willSendText];
	```   
	
- 图片消息   

	```object-c
	NSData *imageData = UIImageJPEGRepresentation(image, 1);
	ONEImageMessageBody *body = [[ONEImageMessageBody alloc] initWithData:imageData];
	```   
	
- 位置消息   

	```object-c
	double latitude = 1.0;
	double longitude = 1.0;
	NSString *address = @"北京市";
	ONELocationMessageBody *body = [[ONELocationMessageBody alloc] initWithLatitude:latitude longitude:longitude address:address];
	```   

- 语音消息

	```object-c
	NSString *voiceLocalPath = @"语音文件本地路径";
	int duration = 语音时长;
	ONEVoiceMessageBody *body = [[ONEVoiceMessageBody alloc] initWithLocalPath:localPath];
	body.duration = duration;
	```   
	
- 红包消息   

	```object-c
	NSDictionary *dic = @{
	                      @"red_packet_id":红包ID,
	                      @"red_packet_msg":红包留言
	                      };
   NSString *params = [dic yy_modelToJSONString];
   ONERedPacketMessageBody *body = [[ONERedPacketMessageBody alloc] initWithPacket:params];
	```   
	
- ONEMessage构造   

	- 消息类型			

		|消息类型|ONEChatType|
		|:--:|:--:|
		|单聊|ONEChatTypeChat|
		|群聊|ONEChatTypeGroupChat|
		
	- 消息状态   

		|消息状态|ONEMessageStatus|
		|:--:|:--:|
		|正在发送|ONEMessageStatusDelivering|
		|发送成功|ONEMessageStatusSuccessed|
		|发送失败|ONEMessageStatusFailed|

	构造`ONEMessage`时，`from`是自己的`accountName`,单聊时，`to`为聊天对方的`accountName`。群聊时，`to`为群组ID。需要指定消息类型。
	
	```object-c
	NSString *toUser = @"username";	// 对方的accountName，如果是群的话为群组ID
	ONETextMessageBody *body = [[ONETextMessageBody alloc] initWithText:@"msg"];
   NSString *from = [ONEChatClient homeAccountName];
   ONEMessage *message = [[ONEMessage alloc] initWithConversationID:toUser from:from to:toUser body:body ext:nil];
    message.chatType = ONEChatTypeChat;	// 消息类型
    message.timestamp = [[ONEChatClient date] timeIntervalSince1970]*1000;
	```   
	
### 发送消息   

构造完成`ONEMessage`对象完成后，调用SDK提供的api进行消息的发送操作。   
发送失败会回调相应的```error```。

```object-c
[[ONEChatClient sharedClient] sendMessage:message progress:nil completion:^(ONEMessage *message, ONEError *error) {
        
    if (!error) {
			// 发送成功
    } else {
			// 发送失败
    }
 }];
```   

### 接收消息   

首先要在需要接收的页面注册回调,需要在哪个页面接收消息的通知，就在哪个界面注册回调。   

```object-c
[[ONEChatClient sharedClient] addDelegate:self delegateQueue:nil];
```   

实现代理方法：   

```object-c
/**
 收到新消息

 @param aMessages 消息数组List<ONEMessage>
 */
- (void)didReceiveMessages:(NSArray *)aMessages;
```   

### 解析消息   

```object-c
- (void)didReceiveMessages:(NSArray *)aMessages
{
	for (ONEMessage *msg in aMessages) {
		
		ONEMessageBody *body = msg.body;
		switch(body.type) {
			// 文本消息
			case ONEMessageBodyTypeText: 
			{
				ONETextMessageBody *textBody = (ONETextMessageBody *)body;
				NSString *receiveText = textBody.text;
			}
			break;
			// 图片消息,收到图片消息SDK会自动下载，下载缓存本地之后会将本地路径和远程路径做映射。
			// 通过消息附件的远程路径获取本地路径进行展示。
			case ONEMessageBodyTypeImage:
			{
				ONEImageMessageBody *imgMessageBody = (ONEImageMessageBody *)body;
                
	            NSString *localPath = imgMessageBody.localPath;
	            NSString *remotePath = imgMessageBody.remotePath;
	            if (localPath == nil) {
	                
	                localPath = [ONEChatClient localPathFromRemotePath:remotePath];
	            }
			}
			break;
			// 语音消息，处理等同图片消息
			case ONEMessageBodyTypeVoice:
			{
				ONEVoiceMessageBody *voiceBody = (ONEVoiceMessageBody *)body;
				NSString *localPath = voiceBody.localPath;
                NSString *remotePath = voiceBody.remotePath;
                if (localPath == nil) {
                    
                    localPath = [ONEChatClient localPathFromRemotePath:remotePath];
                }
			}
			break;
			// 位置消息
			case ONEMessageBodyTypeLocation:
			{
				ONELocationMessageBody *locationBody = (ONELocationMessageBody *)body;
                NSString *address = locationBody.address;
                long latitude = locationBody.latitude;
                long longitude = locationBody.longitude;
			}
			break;
			// 红包消息
			case ONEMessageBodyTypeRedpacket:
			{
				ONERedPacketMessageBody *msgBody = (ONERedPacketMessageBody *)body;
                NSString *params = msgBody.redpacketParam;
                if (params.length > 0) {
                    
                    NSData *jsonData = [params dataUsingEncoding:NSUTF8StringEncoding];
                    if (jsonData) {
                        
                        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
                        NSString *red_id = dic[@"red_packet_id"];
                        NSString *red_msg = dic[@"red_packet_msg"];
                    }
                }
			}
			break;
			default:
                break;
		}
	}
} 
```   

### 会话管理   

会话在本地DB进行管理   


- 获取会话列表   

	```object-c
	NSArray *list = [[ONEChatClient sharedClient] getAllConversations];
	```

- 获取单个会话实例   


	```object-c
	// 如果本地没有这个会话会创建新的实例
	ONEConversation *conversation = [[ONEChatClient sharedClient] getConversation:conversationChatter type:conversationType createIfNotExist:YES];
	```
	
- 删除某个人的会话

	```object-c
	[[ONEChatClient sharedClient] deleteConversationFromUser:accountName];
	```   
	
- 删除某个会话实例

	```object-c
	[[ONEChatClient sharedClient] deleteConversation:conversation];
	```
    


