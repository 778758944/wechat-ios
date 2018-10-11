//
//  WCImageViewCtrl.m
//  WeChat
//
//  Created by Tom Xing on 9/27/18.
//  Copyright © 2018 Tom Xing. All rights reserved.
//

#import "WCImageViewCtrl.h"
#import "UIViewController+alert.h"
#import "NetWork.h"
#import "WCToast.h"
#import "User+addon.h"
#import "WCLoading.h"

@interface WCImageViewCtrl () <UIImagePickerControllerDelegate, NetWorkDelegate, UIScrollViewDelegate>
@property(nonatomic, strong) UIImageView * imageView;
@property(nonatomic, weak) NetWork * net;
@end

@implementation WCImageViewCtrl

-(NetWork *) net
{
    if (!_net) {
        self.net = [NetWork sharedNetWork];
        self.net.delegate = self;
    }
    
    return _net;
}

-(void) loadView
{
    self.view = [[UIScrollView alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView = [[UIImageView alloc] initWithImage:self.image];
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationItem.title = @"Photo";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemAction) target:self action:@selector(doAction)];
    UIScrollView * scrollView = (UIScrollView *) self.view;
    scrollView.delegate = self;
    scrollView.maximumZoomScale = 3;
}

-(void) initSizeForImage
{
    CGSize size = self.view.frame.size;
    CGFloat ratio = size.width/_image.size.width;
    
    CGFloat h_pos;
    
    if(_image.size.height * ratio > size.height) {
        h_pos = 0;
    } else {
        h_pos = (size.height - _image.size.height * ratio)/2;
    }
    
    h_pos = h_pos - (self.view.safeAreaInsets.top);
    
    CGRect rect = CGRectMake(0, h_pos, size.width, _image.size.height * ratio);
    
    _imageView.frame = rect;
    
    
    
    [self.view addSubview:_imageView];
    
    UIScrollView * scrollView = (UIScrollView *) self.view;
    scrollView.contentSize = _imageView.frame.size;
//    scrollView.contentOffset = CGPointMake(0, 0);
//    scrollView.contentOffset = CGPointMake(0, -h_pos);
    scrollView.minimumZoomScale = 1;
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self initSizeForImage];
}


-(void) setImage:(UIImage *)image
{
    if (image) {
        _image = image;
        if (!_imageView) {
            self.imageView = [[UIImageView alloc] initWithImage:self.image];
        } else {
            self.imageView.image = image;
        }
        [self initSizeForImage];
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

-(void) doAction
{
    NSLog(@"do action");
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    UIAlertAction * takePhoto = [UIAlertAction actionWithTitle:@"Take Photo" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [self changeAvator: UIImagePickerControllerSourceTypeCamera];
    }];
    
    
    
    UIAlertAction * chooseFormAlbum = [UIAlertAction actionWithTitle:@"Choose from Album" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [self changeAvator: UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    
    UIAlertAction * savePhoto = [UIAlertAction actionWithTitle:@"Save Photo" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        UIImageWriteToSavedPhotosAlbum(self.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }];
    
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"Cancel" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        //
    }];
    
    [alert addAction:takePhoto];
    [alert addAction:chooseFormAlbum];
    [alert addAction:savePhoto];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void) changeAvator: (UIImagePickerControllerSourceType) type
{
    UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = type;
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info
{
    [WCLoading show];
    UIImage * image = info[UIImagePickerControllerEditedImage];
    NSDictionary * data = @{
                            @"data": image,
                            };
    [self.net postImageWithUrl:@"/uploadImg" Data: data completion:^(NSError *err, NSDictionary *response) {
        UIImage * avatorImage;
        if (err) {
            
        } else {
            if (response[@"path"]) {
                if (self.delegate) {
                    [self.delegate saveWithData:response[@"path"] Key:@"avatorUrl"];
                    NSString * avatorStr = [SOURCELOC stringByAppendingString:response[@"path"]];
                    NSData * avarotData = [NSData dataWithContentsOfURL:[NSURL URLWithString:avatorStr]];
                    avatorImage = [UIImage imageWithData:avarotData];
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [WCLoading hide];
            [self dismissViewControllerAnimated:YES completion:nil];
            self.image = avatorImage;
        });
    }];
}

- (void)image:(UIImage *)image
didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo
{
    [WCToast showWithTitle:@"Saved" timeout:2];
}

#pragma mark scrollview delegate
-(UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

-(void) scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGSize containerSize = scrollView.frame.size;
    CGSize size = scrollView.contentSize;
    CGFloat h_top = 0;
    CGRect rect = self.imageView.frame;
    if (size.height < containerSize.height) {
        h_top = (containerSize.height-size.height)/2 - scrollView.safeAreaInsets.top;
        rect.origin.y = h_top;
        self.imageView.frame = rect;
    } else {
        if (rect.origin.y != -scrollView.safeAreaInsets.top) {
            rect.origin.y = -scrollView.safeAreaInsets.top;
            self.imageView.frame = rect;
        }
    }
}






@end
