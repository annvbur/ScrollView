//
//  ViewController.m
//  ScrollViewAndKeyboard
//
//  Created by Mac on 04.07.15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    self.titleField.delegate = self;
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithTitle:@"Hide" style:UIBarButtonItemStylePlain target:self action:@selector(hideKeyboard)];

    toolbar.items = @[item];
    self.descriptionField.inputAccessoryView = toolbar;
}

-(void)hideKeyboard{
    [self.descriptionField resignFirstResponder];
}

- (void)keyboardWasShown:(NSNotification *)notif {
    NSDictionary *userInfo = notif.userInfo;
    CGRect keyboardRect = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    //UIKeyboardFrameBeginUserInfoKey
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, keyboardRect.size.height, 0);
    self.scrollView.contentInset = insets;
    self.scrollView.scrollIndicatorInsets = insets;

    UIView* activeField = [self detectActiveField];

    CGFloat kbHeight = keyboardRect.size.height;

    if(activeField.frame.origin.y>self.view.frame.size.height -kbHeight){
        CGFloat delta = (self.view.frame.size.height - kbHeight) - activeField.frame.origin.y;
        delta -= activeField.frame.size.height;
        self.scrollView.contentOffset = CGPointMake(0, -delta-10);
    }
}

- (UIView *)detectActiveField {
    UIView* result = nil;
    if([self.titleField isFirstResponder]){
        result = self.titleField;
    } else if ([self.descriptionField isFirstResponder]){
        result = self.descriptionField;
    }
    return result;
}

- (void)keyboardWillHide:(NSNotification *)notif {
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.scrollView.contentInset = insets;
    self.scrollView.scrollIndicatorInsets = insets;

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}


- (IBAction)selectPicture:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];

}

#pragma mark  - UIImagePickerController

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
      //"UIImagePickerControllerOriginalImage"
    self.imageView.image = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark  - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


@end
