//
//  InputController.m
//  WeChat
//
//  Created by Tom Xing on 9/24/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import "InputController.h"
#import "EditInputView.h"
#import "UIColor+transform.h"

@interface InputController () <UITextFieldDelegate>
@property(nonatomic, strong) EditInputView * textField;
@end

@implementation InputController

-(instancetype) initWithContent: (NSString *) content Title: (NSString *) title
{
    self = [super init];
    
    if (self) {
        self.navigationItem.title = title;
        self.navTitle = title;
        self.content = content;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"navTitle: %@", _navTitle);
    NSLog(@"content: %@", _content);
    self.textField = [[EditInputView alloc] init];
    self.view.backgroundColor = [UIColor transformColorFormHex:@"efeff4"];
    _textField.translatesAutoresizingMaskIntoConstraints = NO;
    _textField.text = _content;
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.delegate = self;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:(UIBarButtonItemStylePlain) target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:(UIBarButtonItemStylePlain) target:self action:@selector(done)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self.view addSubview:_textField];
    [_textField.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [_textField.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    [_textField.heightAnchor constraintEqualToConstant:44].active = YES;
    [_textField.topAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.topAnchor constant:15].active = YES;
    [_textField becomeFirstResponder];
    [_textField addTarget:self action:@selector(textDidChange) forControlEvents:UIControlEventEditingChanged];
}


-(void) cancel
{
    [_textField resignFirstResponder];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void) done
{
    [_textField resignFirstResponder];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    if (self.delegate) {
        [self.delegate saveWithData:_textField.text Key:@"Name"];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

-(void) textDidChange
{
    NSString * value = _textField.text;
    if (![value isEqualToString:self.content]) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
