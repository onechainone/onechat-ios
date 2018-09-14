/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import "EaseConversationListViewController.h"

#import "EaseEmotionEscape.h"
#import "EaseConversationCell.h"
#import "EaseConvertToCommonEmoticonsHelper.h"
#import "EaseMessageViewController.h"
#import "NSDate+Category.h"
#import "EaseLocalDefine.h"
#import "ONEGroupManager.h"
@interface EaseConversationListViewController ()
{
    dispatch_queue_t _loadConversationQueue;
}
@end

@implementation EaseConversationListViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self registerNotifications];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self unregisterNotifications];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _loadConversationQueue = dispatch_queue_create("com.loadconversation.one", DISPATCH_QUEUE_SERIAL);
    dispatch_set_target_queue(_loadConversationQueue, dispatch_get_global_queue(DISPATCH_TARGET_QUEUE_DEFAULT, 0));
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [EaseConversationCell cellIdentifierWithModel:nil];
    EaseConversationCell *cell = (EaseConversationCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[EaseConversationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    if ([self.dataArray count] <= indexPath.row) {
        return cell;
    }

    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![cell isKindOfClass:[EaseConversationCell class]]) {
        return;
    }
    id<IConversationModel> model = [self.dataArray objectAtIndex:indexPath.row];
    EaseConversationCell *eCell = (EaseConversationCell *)cell;
    eCell.model = model;
    
    if (_dataSource && [_dataSource respondsToSelector:@selector(conversationListViewController:latestMessageTitleForConversationModel:)]) {
        NSMutableAttributedString *attributedText = [[_dataSource conversationListViewController:self latestMessageTitleForConversationModel:model] mutableCopy];
        eCell.detailLabel.attributedText =  attributedText;
    } else {
        eCell.detailLabel.attributedText =  [[EaseEmotionEscape sharedInstance] attStringFromTextForChatting:[self _latestMessageTitleForConversationModel:model]textFont:eCell.detailLabel.font textColor:nil];
    }
    
    if (_dataSource && [_dataSource respondsToSelector:@selector(conversationListViewController:latestMessageTimeForConversationModel:)]) {
        eCell.timeLabel.text = [_dataSource conversationListViewController:self latestMessageTimeForConversationModel:model];
    } else {
        eCell.timeLabel.text = [self _latestMessageTimeForConversationModel:model];
    }
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [EaseConversationCell cellHeightWithModel:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_delegate && [_delegate respondsToSelector:@selector(conversationListViewController:didSelectConversationModel:)]) {
        EaseConversationModel *model = [self.dataArray objectAtIndex:indexPath.row];
        [_delegate conversationListViewController:self didSelectConversationModel:model];
    } else {
        EaseConversationModel *model = [self.dataArray objectAtIndex:indexPath.row];
        EaseMessageViewController *viewController = [[EaseMessageViewController alloc] initWithConversationChatter:model.conversation.conversationId conversationType:model.conversation.type];
        viewController.title = model.title;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{

    
    return YES;

}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        EaseConversationModel *model = [self.dataArray objectAtIndex:indexPath.row];
        [[ONEChatClient sharedClient] deleteConversation:model.conversation];
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - data

-(void)refreshAndSortView
{
    if ([self.dataArray count] > 1) {
        if ([[self.dataArray objectAtIndex:0] isKindOfClass:[EaseConversationModel class]]) {

            NSArray* sorted = [self.dataArray sortedArrayUsingComparator:
                               ^(EaseConversationModel *obj1, EaseConversationModel* obj2){
                                   ONEMessage *message1 = [obj1.conversation latestMessage];
                                   ONEMessage *message2 = [obj2.conversation latestMessage];
                                   if(message1.timestamp > message2.timestamp) {
                                       return(NSComparisonResult)NSOrderedAscending;
                                   }else {
                                       return(NSComparisonResult)NSOrderedDescending;
                                   }
                               }];

            
                [self.dataArray removeAllObjects];
                [self.dataArray addObjectsFromArray:sorted];
                [self.tableView reloadData];

        }
    }
}

- (void)asyncTableViewDidTriggerHeaderRefresh
{
    dispatch_async(/**dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)*/_loadConversationQueue, ^{

        
        NSArray *conversations = [[ONEChatClient sharedClient] getAllConversations];
        NSArray* sorted = [conversations sortedArrayUsingComparator:
                           ^(ONEConversation *obj1, ONEConversation* obj2){
                               if(obj1.timestamp > obj2.timestamp) {
                                   return(NSComparisonResult)NSOrderedAscending;
                               }else {
                                   return(NSComparisonResult)NSOrderedDescending;
                               }
                           }];
        
        dispatch_async(dispatch_get_main_queue(), ^{

            [self.dataArray removeAllObjects];
            for (ONEConversation *converstion in sorted) {
                EaseConversationModel *model = nil;
                if (self.dataSource && [self.dataSource respondsToSelector:@selector(conversationListViewController:modelForConversation:)]) {
                    model = [self.dataSource conversationListViewController:self
                                                       modelForConversation:converstion];
                }
                else{
                    model = [[EaseConversationModel alloc] initWithConversation:converstion];
                }
                
                if (model) {
                    [self.dataArray addObject:model];
                }
            }
            
            [self.tableView reloadData];
            [self tableViewDidFinishTriggerHeader:YES reload:NO];
        });
    });

}

- (void)tableViewDidTriggerHeaderRefresh
{
    [self asyncTableViewDidTriggerHeaderRefresh];
}

- (void)conversationListDidUpdate
{
    [self tableViewDidTriggerHeaderRefresh];
}

- (void)didReceiveAtMessage:(ONEMessage *)message
{
    if (!message) {
        return;
    }
    [ONEGroupManager markConversationAsHasAt:message.conversationId hasAt:YES];
    [self.tableView reloadData];
}


#pragma mark - registerNotifications
-(void)registerNotifications{
    [self unregisterNotifications];

    [[ONEChatClient sharedClient] addDelegate:self delegateQueue:nil];
}

-(void)unregisterNotifications{
    [[ONEChatClient sharedClient] removeDelegate:self];
}

- (void)dealloc{
    [self unregisterNotifications];
}

#pragma mark - private
- (NSString *)_latestMessageTitleForConversationModel:(id<IConversationModel>)conversationModel
{
    NSString *latestMessageTitle = @"";
    ONEMessage *lastMessage = [conversationModel.conversation latestMessage];
    if (lastMessage) {
        ONEMessageBody *messageBody = lastMessage.body;
        switch (messageBody.type) {
            case ONEMessageBodyTypeImage:{
                latestMessageTitle = NSEaseLocalizedString(@"message.image1", @"[image]");
            } break;
            case ONEMessageBodyTypeText:{
                NSString *didReceiveText = [EaseConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((ONETextMessageBody *)messageBody).text];
                latestMessageTitle = didReceiveText;
            } break;
            case ONEMessageBodyTypeVoice:{
                latestMessageTitle = NSEaseLocalizedString(@"message.voice1", @"[voice]");
            } break;
            case ONEMessageBodyTypeLocation: {
                latestMessageTitle = NSEaseLocalizedString(@"message.location1", @"[location]");
            } break;
            case ONEMessageBodyTypeVideo: {
                latestMessageTitle = NSEaseLocalizedString(@"message.video1", @"[video]");
            } break;
            case ONEMessageBodyTypeFile: {
                latestMessageTitle = NSEaseLocalizedString(@"message.file1", @"[file]");
            } break;
            case ONEMessageBodyTypeTransfer: {
                
                latestMessageTitle = [NSString stringWithFormat:@"[%@]",NSLocalizedString(@"fast_transfer", @"")];
            }break;
            case ONEMessageBodyTypeRedpacket:{
                latestMessageTitle = [NSString stringWithFormat:@"[%@]",NSLocalizedString(@"msg_red_packet", @"[Red Packet]")];
            }break;
            default:
            break;
        }
    }
    return latestMessageTitle;
}

- (NSString *)_latestMessageTimeForConversationModel:(id<IConversationModel>)conversationModel
{
    NSString *latestMessageTime = @"";
    ONEMessage *lastMessage = [conversationModel.conversation latestMessage];
    if (lastMessage) {
        double timeInterval = lastMessage.timestamp;
        if(timeInterval > 140000000000) {
            timeInterval = timeInterval / 1000;
        }
        NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"YYYY-MM-dd"];
        latestMessageTime = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
    }
    return latestMessageTime;
}

@end
