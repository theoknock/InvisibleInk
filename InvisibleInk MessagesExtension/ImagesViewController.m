//
//  ImagesViewController.m
//  InvisibleInk MessagesExtension
//
//  Created by Xcode Developer on 5/20/21.
//

#import "ImagesViewController.h"
#import "MessagesViewController.h"

// TO-DO:   Add a callback shimmer to the layer of the UITextView that
//          creates a shimmering mirage effect on the text to be encrypted
//          (the code for this can be found in ViewController.m -- search for
//          'reference to view controller in block' with Spotlight to find it)
//

@interface ImagesViewController () {
    CGFloat _storedMessageTextViewContentHeight;
}

@end

@implementation ImagesViewController

static void (^resizeTextViewFrameToUsedRectForTextContainer)(UITextView * _Nullable, UIButton * _Nullable) = ^ (UITextView * _Nullable textView, UIButton * _Nullable button) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [textView setFrame:[textView.textContainer.layoutManager usedRectForTextContainer:textView.textContainer]];
        UIBezierPath * exclusionPath = [UIBezierPath bezierPathWithRect:button.frame];
        textView.textContainer.exclusionPaths  = @[exclusionPath];
    });
};

- (void)viewDidLoad {
//    [(MSMessagesAppViewController *)[self presentationController] set
    resizeTextViewFrameToUsedRectForTextContainer(self.messageTextView, self.renderCipherImageButton);
}

//- (void)textViewDidBeginEditing:(UITextView *)textView
//{
//
//}

- (void)textViewDidChange:(UITextView *)textView {
    CGFloat messageTextViewFrameHeight = self.messageTextView.frame.size.height;
    CGFloat messageTextViewContentHeight = [self.messageTextView.textContainer.layoutManager usedRectForTextContainer:self.messageTextView.textContainer].size.height;
    if (messageTextViewContentHeight != messageTextViewFrameHeight) {
        resizeTextViewFrameToUsedRectForTextContainer(textView, self.renderCipherImageButton);
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

@end
