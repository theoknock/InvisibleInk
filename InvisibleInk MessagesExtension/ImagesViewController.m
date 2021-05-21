//
//  ImagesViewController.m
//  InvisibleInk MessagesExtension
//
//  Created by Xcode Developer on 5/20/21.
//

#import "ImagesViewController.h"

@interface ImagesViewController () {
    CGFloat _storedMessageTextViewContentHeight;
}

@end

@implementation ImagesViewController

static void (^resizeTextViewToUsedRectForTextContainer)(UITextView * _Nullable) = ^ (UITextView * _Nullable textView) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [textView setFrame:[textView.textContainer.layoutManager usedRectForTextContainer:textView.textContainer]];
    });
};

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    _storedMessageTextViewContentHeight = [self.messageTextView.textContainer.layoutManager usedRectForTextContainer:self.messageTextView.textContainer].size.height;
    resizeTextViewToUsedRectForTextContainer(self.messageTextView);
}

- (void)textViewDidChange:(UITextView *)textView {
    CGFloat messageTextViewFrameHeight = self.messageTextView.frame.size.height;
    CGFloat messageTextViewContentHeight = [self.messageTextView.textContainer.layoutManager usedRectForTextContainer:self.messageTextView.textContainer].size.height;
    if (messageTextViewContentHeight > messageTextViewFrameHeight || messageTextViewContentHeight < messageTextViewFrameHeight) {
       resizeTextViewToUsedRectForTextContainer(textView);
    }
}

- (IBAction)renderCipherImage:(UIButton *)sender {
    [self.messageTextView endEditing:TRUE];
    [self.delegate renderCipherImageWithBlock:^UIImage * _Nonnull (void) {
        UIGraphicsBeginImageContextWithOptions(self.messageTextView.layer.frame.size, self.messageTextView.isOpaque, 0.0f);
        [self.view drawViewHierarchyInRect:self.messageTextView.layer.frame afterScreenUpdates:TRUE];
        [self.messageTextView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *cipherImageFile = UIGraphicsGetImageFromCurrentImageContext();
        
        return cipherImageFile;
    }];
}
//    NSString *cipherImageFileName = [NSString stringWithFormat:@"%@-%f", @"CipherImage", NSTimeIntervalSince1970];
////    NSString *cipherImageFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"/CipherImages/%@", [cipherImageFileName stringByAppendingPathExtension:@"png"]]];
//    NSString *cipherImageFilePath = [NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), cipherImageFileName];
//    NSURL * cipherImageFileURL = [NSURL fileURLWithPath:cipherImageFilePath];
////
////    CALayer *textViewLayer = (CALayer *)[self.messageTextView layer];
////    UIGraphicsBeginImageContextWithOptions([self.messageTextView.textContainer.layoutManager usedRectForTextContainer:self.messageTextView.textContainer].size, TRUE, 0);
//////    CGRect contextRect = CGRectMake(0.0, 0.0,
//////                                    self.messageTextView.textInputView.bounds.size.width,
//////                                    self.messageTextView.textInputView.bounds.size.height);
////    [textViewLayer renderInContext:UIGraphicsGetCurrentContext()];
////    UIImage *cipherImage = UIGraphicsGetImageFromCurrentImageContext();
////    UIGraphicsEndImageContext();
//    __autoreleasing NSError * error;
//    if (![UIImagePNGRepresentation(cipherImageFile) writeToURL:cipherImageFileURL options:NSDataWritingAtomic error:&error]) {
//           NSLog(@"Failed to write image to file: %@", error.description);
//       } else {
//           [self.delegate insertCipherImageAtFileURL:cipherImageFileURL];
//       }
//


@end
