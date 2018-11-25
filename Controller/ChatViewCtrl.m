//
//  ChatViewCtrl.m
//  WeChat
//
//  Created by Tom Xing on 8/29/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import "ChatViewCtrl.h"
#import "ChatView.h"
#import "MoreBtnView.h"
#import "MoreContainer.h"
#import "WCWebSocket.h"
#import <SocketIO/SocketIO.h>
#import "Message+addon.h"
#import "MsgBoxTableViewCell.h"
#import "User+addon.h"
#import "Friend.h"
#import <AVFoundation/AVFoundation.h>
#import "VoiceMsgPlayer.h"
#import "UIViewController+Alert.h"
#import "VoiceRecordNotice.h"
#import "RecordBtn.h"
#import "ChatInputView.h"
#import "DateCustomFormat.h"
#import "TimeLabel.h"
#import "NoticeSound.h"
#import "DrawViewCtrl.h"

static const CGFloat maxHeight = 100;
static NSString * const REUSEID = @"msg_cell_id";


@interface ChatViewCtrl () <UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate>
@property(nonatomic, weak) UITextView * textInput;
@property(nonatomic, weak) NSLayoutConstraint * bottomForInputView;
@property(nonatomic, weak) NSLayoutConstraint * heightForTextInput;
@property(nonatomic, strong) NSArray<NSString *> * moreItems;
@property(nonatomic, weak) UIPageControl * pageCtrl;
@property(nonatomic,weak) UICollectionView * moreContainer;
@property(nonatomic, weak) NSLayoutConstraint * topForDynamicView;
@property(nonatomic, weak) SocketIOClient * socket;
@property(nonatomic, weak) UITableView * tableView;
@property(nonatomic) NSInteger currentUserId;
@property(nonatomic, weak) RecordBtn * recordBtn;
@property(nonatomic, strong) AVAudioRecorder * recorder;
@property(nonatomic, weak) VoiceRecordNotice * recordNotice;
@property(nonatomic, assign) NSTimeInterval recordDuration;
@property(nonatomic, strong) NSTimer * recordTimer;
@property(nonatomic, getter=isShowDynamicView) BOOL showDynamicView;
@property(nonatomic, weak) ChatInputView * inputView;
@property(nonatomic, getter=isSoundMode) BOOL soundMode;
@property(nonatomic, strong) UIImage * mineAvator;
@property(nonatomic, strong) UIImage * otherAvator;
@property(nonatomic) BOOL isDraging;
@property(nonatomic) BOOL isScrolling;
@property(nonatomic, strong) NSUUID * sockId;
@end

@implementation ChatViewCtrl

@dynamic tableView;

-(UIImage *) mineAvator
{
    if (!_mineAvator) {
        User * currentUser = [User getCurrentUserWithUserId:self.currentUserId inContext:self.contacter.managedObjectContext];
        if (currentUser.avatorUrl) {
            _mineAvator = [UIImage imageWithData:currentUser.avator];
        } else {
            _mineAvator = [UIImage imageNamed:@"girl.jpg"];
        }
    }
    return _mineAvator;
}

-(UIImage *) otherAvator
{
    if (!_otherAvator) {
        if (self.contacter.avator) {
            _otherAvator = [UIImage imageWithData:self.contacter.avator];
        } else {
            _otherAvator = [UIImage imageNamed:@"girl.jpg"];
        }
    }
    
    return _otherAvator;
}

-(ChatInputView *)inputView
{
    if (!_inputView) {
        ChatView * rootView = (ChatView *) self.view;
        self.inputView = rootView.inputView;
    }
    return _inputView;
}

-(AVAudioRecorder *) recorder
{
    if (!_recorder) {
        NSError *categoryError = nil;
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&categoryError];
        
        [audioSession setActive:YES error:&categoryError];
        [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
        
        NSURL * url = [self getAudioSavePath];
        NSDictionary * setting = [self getAudioSetting];
        
        NSError * err;
        
        _recorder = [[AVAudioRecorder alloc] initWithURL:url settings:setting error:&err];
        _recorder.meteringEnabled = YES;
        
        if (err) {
            [self alertWithTitle:@"Error" Message:err.localizedDescription];
            return nil;
        }
    }
    
    return _recorder;
}

-(NSInteger) currentUserId
{
    if (!_currentUserId) {
        _currentUserId = [[NSUserDefaults standardUserDefaults] integerForKey:WC_CURRENT_USER];
    }
    
    return _currentUserId;
}

-(UITableView *) tableView {
    ChatView * rootView = (ChatView *) self.view;
    return rootView.tableView;
}

-(void) setSocket:(SocketIOClient *)socket
{
    if (socket) {
        _socket = socket;
        self.sockId = [_socket on:@"news" callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nonnull ack) {
            NSLog(@"data: %@", data[0]);
            NSString * lx = (NSString *) data[0][@"lx"];
            if ([lx isKindOfClass:[NSString class]]) {
                if ([lx isEqualToString:@"tocvs"]) {
                    [[NoticeSound sharedInstance] play];
                    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Do you agree" message:@"Do you want to begin the draw game" preferredStyle:(UIAlertControllerStyleAlert)];
                    
                    UIAlertAction * sure = [UIAlertAction actionWithTitle:@"Ok" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                        [self toDraw];
                    }];
                    
                    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"Cancel" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
                        //
                    }];
                    
                    [alert addAction:sure];
                    [alert addAction:cancel];
                    [self presentViewController:alert animated:YES completion:nil];
                    return;
                } else if ([lx isEqualToString:@"draw"]) {
                    return;
                }
            }
            [[NoticeSound sharedInstance] play];
            Message * lastMsg = [Message addMsg:data[0] inContext:self.contacter.managedObjectContext];
            NSIndexPath * indexPath = [self.dataCtrl indexPathForObject:lastMsg];
            NSLog(@"indexpath.row: %ld", indexPath.row);
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:(UITableViewScrollPositionBottom) animated:YES];
        }];
    }
}

-(void) loadView
{
    self.view = [[ChatView alloc] init];
}

-(void) viewDidLoad
{
    self.showDynamicView = NO;
    ChatView * rootView = (ChatView *) self.view;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.textInput = rootView.inputView.textField;
    self.textInput.delegate = self;
    self.bottomForInputView = rootView.bottomForInputView;
    self.heightForTextInput = rootView.inputView.heightForTextField;
    self.moreContainer = rootView.moreContainer.itemContiner;
    _moreContainer.delegate = self;
    _moreContainer.dataSource = self;
    [_moreContainer registerClass: [MoreBtnView class] forCellWithReuseIdentifier:@"moreBtn"];
    _moreItems = @[@"Album", @"Draw", @"Video Call", @"Location", @"Red Packet", @"Transfer", @"Voice Input", @"Concat Card", @"Favourite", @"File", @"Coupons"];
    self.pageCtrl = rootView.moreContainer.pageControl;
    [self.pageCtrl addTarget:self action:@selector(optionPage:) forControlEvents:(UIControlEventValueChanged)];
    self.topForDynamicView = rootView.topForDynamicView;
    self.socket = [WCWebSocket sharedSocket].defaultSocket;
    self.recordNotice = rootView.recordNotice;
    
    self.recordBtn = rootView.inputView.recordBtn;
    
    [self.recordBtn addTarget:self action:@selector(recordStart) forControlEvents:(UIControlEventTouchDown)];
    [self.recordBtn addTarget:self action:@selector(recordStop) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.inputView.moreBtn addTarget:self action:@selector(toggleView) forControlEvents:(UIControlEventTouchDown)];
    [self.inputView.inputModeBtn addTarget:self action:@selector(changeInputMode:) forControlEvents:UIControlEventTouchDown];
    
    [self.tableView registerClass: [MsgBoxTableViewCell class] forCellReuseIdentifier:REUSEID];
    
    
    
    // initialize dataCtx
    if (self.contacter) {
        NSFetchRequest * messageReq = [NSFetchRequest fetchRequestWithEntityName:@"Message"];
        
        NSSortDescriptor * sort = [NSSortDescriptor sortDescriptorWithKey:@"createAt" ascending:YES];
        messageReq.sortDescriptors = @[sort];
        
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"(((from = %ld) AND (to = %ld)) OR ((from = %ld) AND (to = %ld))) AND (belongTo = %ld)", self.contacter.unique.intValue, self.currentUserId, self.currentUserId, self.contacter.unique.integerValue, self.currentUserId];
        
        
        messageReq.predicate = predicate;
//        messageReq.fetchLimit = 10;
        
        self.dataCtrl = [[NSFetchedResultsController alloc] initWithFetchRequest:messageReq managedObjectContext:self.contacter.managedObjectContext sectionNameKeyPath:@"groupTime" cacheName:nil];
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyBoard:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyBoard:) name: UIKeyboardWillHideNotification object:nil];
}







-(void) textViewDidChange:(UITextView *)textView
{
    NSLog(@"did change");
    CGRect frame = textView.frame;
    CGSize contentSize = textView.contentSize;
    NSLog(@"textview frame: %@", [NSValue valueWithCGRect:frame]);
    
    if (contentSize.height < maxHeight) {
        if (frame.size.height < contentSize.height) {
            self.heightForTextInput.constant = contentSize.height;
        }
    }
    
    if (frame.size.height > 36) {
        if (frame.size.height > contentSize.height) {
            self.heightForTextInput.constant = contentSize.height;
        }
    }
}

-(BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
//        [textView resignFirstResponder];
        if (textView.text) {
            [self sendMsg: textView.text type:@"0"];
            textView.text = @"";
            self.heightForTextInput.constant = 36;
        }
        return NO;
    }
    return YES;
}

#pragma mark handlekeyboard
-(void) handleKeyBoard: (NSNotification *) notification
{
    NSDictionary * userinfo = notification.userInfo;
    NSNumber * aniStyle =userinfo[UIKeyboardAnimationCurveUserInfoKey];
    NSNumber * timer = userinfo[UIKeyboardAnimationDurationUserInfoKey];
    NSValue * size = userinfo[UIKeyboardFrameEndUserInfoKey];
    [UIView setAnimationCurve:aniStyle.integerValue];
    
    if ([notification.name isEqualToString:UIKeyboardWillShowNotification]) {
        NSLog(@"keyboard show");
        if (self.isScrolling) {
            [self stopScrolling];
        }
        CGFloat offset;
        self.bottomForInputView.constant = -(size.CGRectValue.size.height);
        if (self.isShowDynamicView) {
            self.topForDynamicView.constant = 0;
            offset = [self scrollToBottomWithHeight:size.CGRectValue.size.height - 230];
        } else {
           offset = [self scrollToBottomWithHeight:size.CGRectValue.size.height];
        }
        [UIView animateWithDuration:timer.doubleValue animations:^{
            [self.view layoutIfNeeded];
            if (offset) {
                [self.tableView setContentOffset:CGPointMake(0, offset)];
            }
        }];
    } else if([notification.name isEqualToString:UIKeyboardWillHideNotification]) {
        NSLog(@"keyboard dismiss");
        CGFloat offset;
        if (self.isShowDynamicView) {
            self.topForDynamicView.constant = -230;
            offset = [self scrollToBottomWithHeight:230 - size.CGRectValue.size.height];
        } else {
            offset = [self scrollToBottomWithHeight:-size.CGRectValue.size.height];
        }
        self.bottomForInputView.constant = 0;
        [UIView animateWithDuration:timer.doubleValue animations:^{
            [self.view layoutIfNeeded];
            if (offset && !self.isDraging) {
                [self.tableView setContentOffset:CGPointMake(0, offset)];
            }
        }];
        
    }
}


-(void) toggleView
{
    if (self.isSoundMode) [self changeInputMode: self.inputView.inputModeBtn];
    if (self.isShowDynamicView) {
        if ([self.inputView.textField isFirstResponder]) {
            [self.inputView.textField resignFirstResponder];
        } else {
            [self.inputView.textField becomeFirstResponder];
        }
    } else {
        self.showDynamicView = YES;
        if ([self.inputView.textField isFirstResponder]) {
            [self.inputView.textField resignFirstResponder];
        } else {
            if (self.isScrolling) {
                [self stopScrolling];
            }
            self.topForDynamicView.constant = -230;
            CGFloat offset = [self scrollToBottomWithHeight:230];
            [UIView setAnimationCurve:7];
            [UIView animateWithDuration:0.25 animations:^{
                [self.view layoutIfNeeded];
                if (offset) {
                    [self.tableView setContentOffset:CGPointMake(0, offset)];
                }
            }];
        }
    }
}

-(void) changeInputMode: (UIButton *) btn
{
    if (self.isSoundMode) {
        self.inputView.textField.hidden = NO;
        self.inputView.recordBtn.hidden = YES;
        [btn setBackgroundImage:[UIImage imageNamed:@"voice.png"] forState:(UIControlStateNormal)];
        CGSize size = self.inputView.textField.contentSize;
        self.inputView.heightForTextField.constant = size.height;
        [self.inputView.textField becomeFirstResponder];
    } else {
        self.inputView.recordBtn.hidden = NO;
        self.inputView.textField.hidden = YES;
        self.inputView.heightForTextField.constant = 36;
        [btn setBackgroundImage:[UIImage imageNamed:@"keyboard.png"] forState:(UIControlStateNormal)];
        [self hiddenMore];
    }
    self.soundMode = !self.soundMode;
}


-(void) hiddenMore
{
    if (self.isShowDynamicView) {
        self.showDynamicView = NO;
        if ([self.inputView.textField isFirstResponder]) {
            [self.inputView.textField resignFirstResponder];
        } else {
            self.topForDynamicView.constant = 0;
            [UIView setAnimationCurve:7];
            CGFloat offset = [self scrollToBottomWithHeight:-230];
            [UIView animateWithDuration:0.25 animations:^{
                [self.view layoutIfNeeded];
                if (offset && !self.isScrolling) {
                    [self.tableView setContentOffset:CGPointMake(0, offset)];
                }
            }];
        }
    }
    
    if ([self.inputView.textField isFirstResponder]) {
        [self.inputView.textField resignFirstResponder];
    }
}


#pragma collectionView

-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_moreItems count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MoreBtnView * cell = (MoreBtnView *) [collectionView dequeueReusableCellWithReuseIdentifier:@"moreBtn" forIndexPath:indexPath];
    
    cell.textLabel.text = _moreItems[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", _moreItems[indexPath.row]]];
    
    
    return cell;
    
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void) optionPage: (UIPageControl *) sender
{
    NSInteger current =  sender.currentPage;
    [self.moreContainer scrollRectToVisible:CGRectMake(self.view.bounds.size.width * current, 0, self.view.bounds.size.width, 230) animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.isDraging = YES;
    self.isScrolling = YES;
    if ([scrollView isMemberOfClass: [UITableView class]]) {
        [self hiddenMore];
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    self.isDraging = NO;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.isScrolling = NO;
    if ([scrollView isKindOfClass:[UICollectionView class]]) {
        CGPoint p = scrollView.contentOffset;
        NSLog(@"%@", [NSValue valueWithCGPoint:p]);
        self.pageCtrl.currentPage = p.x/scrollView.bounds.size.width;
    }
}
/*
-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"dede");
}
 */

-(void) sendMsg: (id) msg type: (NSString *) type;
{
    if (self.socket) {
        NSInteger differSecondFormUtc = [[NSTimeZone systemTimeZone] secondsFromGMT];
        NSInteger utc_timeStamp = [[NSDate date] timeIntervalSince1970]-differSecondFormUtc;
        NSString * lx = type;
        NSDictionary * message = @{
                                   @"from": [NSNumber numberWithInteger:self.currentUserId],
                                   @"lx": lx,
                                   @"msg": msg,
                                   @"type": @1,
                                   @"to": self.contacter.unique,
                                   @"createAt": [NSNumber numberWithInteger:utc_timeStamp]
                                   };
        NSLog(@"send message: %@", message);
        if (![lx isEqualToString:@"tocvs"]) {
            Message * lastMsg = [Message addMsg:message inContext:self.contacter.managedObjectContext];
            NSIndexPath * indexPath = [self.dataCtrl indexPathForObject:lastMsg];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:(UITableViewScrollPositionBottom) animated:YES];
        }
        [self.socket emit:@"sendMsg" with:@[message]];
        
    }
}

#pragma mark -tableviewCell
-(MsgBoxTableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Message * msg = [self.dataCtrl objectAtIndexPath:indexPath];
    MsgBoxTableViewCell * cell = [[MsgBoxTableViewCell alloc] initWithMessage:msg reuseIdentifier:@"message cell" MineAvator:self.mineAvator OtherAvator:self.otherAvator];
    
    return cell;
}

-(void) scrollToBottom
{
    NSInteger lastSec = [[self.dataCtrl sections] count] - 1;
    if (lastSec >= 0) {
        NSInteger lastRow = [[[self.dataCtrl sections] objectAtIndex:lastSec] numberOfObjects] - 1;
        
        NSIndexPath * lastIndex = [NSIndexPath indexPathForRow:lastRow inSection:lastSec];
        
        [self.tableView scrollToRowAtIndexPath:lastIndex atScrollPosition:(UITableViewScrollPositionBottom) animated:NO];
    }
    
}

-(CGFloat) scrollToBottomWithHeight: (CGFloat) height
{
    CGFloat contentHeight = [self.tableView contentSize].height;
    CGFloat tableHeight = self.tableView.bounds.size.height;
    
    CGFloat diff = contentHeight - (tableHeight - height);
    return diff > 0 ? diff : 0;
}


-(void) viewWillDisappear:(BOOL)animated;
{
    [super viewWillDisappear:animated];
    NSLog(@"will disappear");
    [self.socket off:@"news"];
    [VoiceMsgPlayer stop];
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self hiddenMore];
}

#pragma mark record wav
-(void) recordStart
{
    [self.recorder record];
    [self.recordNotice setHidden: NO];
    [self startRecordLoop];
}

-(void) recordStop
{
    [self.recorder stop];
    NSData * data = [NSData dataWithContentsOfURL:[self getAudioSavePath]];
    [self sendMsg:data type:@"wav"];
    [self.recordNotice setHidden: YES];
    [self stopRecordLoop];
}

-(NSURL *) getAudioSavePath
{
    NSString * urlStr = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    urlStr = [urlStr stringByAppendingPathComponent:@"record.wav"];
    
    NSURL * url = [NSURL fileURLWithPath:urlStr];
    NSLog(@"url: %@", url);
    return url;
}

-(NSDictionary *) getAudioSetting
{
    NSMutableDictionary * dicM = [NSMutableDictionary dictionary];
    
    [dicM setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
    [dicM setObject:@(8000) forKey:AVSampleRateKey];
    [dicM setObject:@(1) forKey:AVNumberOfChannelsKey];
    [dicM setObject: @(8) forKey:AVLinearPCMBitDepthKey];
    [dicM setObject:@(12800) forKey:AVEncoderBitRateKey];
    [dicM setObject:@(AVAudioQualityHigh) forKey:AVEncoderAudioQualityKey];
    
    return dicM;
    
}

-(void) startRecordLoop
{
    self.recordTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(updateRecordState) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.recordTimer forMode:NSRunLoopCommonModes];
}

-(void) stopRecordLoop
{
    [self.recordTimer invalidate];
}

-(void) updateRecordState
{
    NSTimeInterval duration = self.recorder.currentTime;
    NSLog(@"recordtime: %0.2f", duration);
    
    if (duration < 60) {
        [self.recorder updateMeters];
        float peak = [_recorder peakPowerForChannel:0];
        NSLog(@"peak: %.2f", peak);
        float ratio;
        if (peak > -70) {
            ratio = (peak + 70)/70;
        } else {
            ratio = 0.2;
        }
        [_recordNotice.volume setProgress:ratio];
        
    }
}

#pragma PUSH
-(void) pushToCtrl: (UIViewController *) ctrl
{
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ctrl animated:YES];
}

#pragma mark collectioncell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:imagePicker animated:YES completion: nil];
    } else if (indexPath.row == 1) {
        NSDictionary * msg = @{
                               @"lx": @"tocvs"
                               };
        [self sendMsg:msg type:@"tocvs"];
        [self toDraw];
    }
}

#pragma make todraw
-(void) toDraw
{
    DrawViewCtrl * draw = [[DrawViewCtrl alloc] init];
    draw.contacter = self.contacter;
    [self presentViewController:draw animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
    NSLog(@"did select a image: %@", info);
    NSData * imageData;
    NSString * imageFotmat;
    NSURL * picketUrl = info[UIImagePickerControllerReferenceURL];
    
    UIImage * pickedImage = info[UIImagePickerControllerOriginalImage];
    NSLog(@"pickedImage: %@", pickedImage);
    if ([[picketUrl absoluteString] hasSuffix:@"PNG"]) {
        imageData = UIImagePNGRepresentation(pickedImage);
        imageFotmat = @"png";
    } else {
        imageData = UIImageJPEGRepresentation(pickedImage, 1);
        imageFotmat = @"jpg";
    }
    
    NSString * base64Str = [imageData base64EncodedStringWithOptions:0];
    
    base64Str = [NSString stringWithFormat:@"data:image/%@;base64,%@", imageFotmat, base64Str];
    
    [self sendMsg:base64Str type:@"img"];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma touchevent
/*
-(void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self hiddenMore];
}
*/

-(void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self hiddenMore];
}


#pragma fetchresultcontroller
-(void) fetchData
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSError * error;
        [self.dataCtrl performFetch: &error];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                NSLog(@"core data fetch error: %@", error);
            } else {
                [self.tableView reloadData];
                [self scrollToBottom];
            }
        });
    });
}

#pragma mark tabview section header

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *rawDateStr = [[[self.dataCtrl sections] objectAtIndex:section] name];
    NSNumberFormatter * numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber * time = [numberFormatter numberFromString:rawDateStr];
    NSTimeInterval zoneInterval = [[NSTimeZone systemTimeZone] secondsFromGMT];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:[time doubleValue] + zoneInterval];
    NSString * dateStr = [DateCustomFormat formatForMessageWithDate:date];
    TimeLabel * timeLabel = [[TimeLabel alloc] init];
    timeLabel.text = dateStr;
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 35)];
    [view addSubview:timeLabel];
    [timeLabel.centerXAnchor constraintEqualToAnchor:view.centerXAnchor].active = YES;
    [timeLabel.bottomAnchor constraintEqualToAnchor:view.bottomAnchor constant:-10].active = YES;
    [timeLabel.heightAnchor constraintEqualToConstant:20].active = YES;
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

-(void) stopScrolling
{
    [self.tableView setContentOffset:self.tableView.contentOffset animated:NO];
}

#pragma mark backtoforeground(todo)
























@end
