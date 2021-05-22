//
//  ImagesViewController.m
//  InvisibleInk MessagesExtension
//
//  Created by Xcode Developer on 5/20/21.
//

#import "ExpandedMessagesViewController.h"
#import "RootMessagesViewController.h"

// TO-DO:   Add a callback shimmer to the layer of the UITextView that
//          creates a shimmering mirage effect on the text to be encrypted
//          (the code for this can be found in ViewController.m -- search for
//          'reference to view controller in block' with Spotlight to find it)
//

@interface ExpandedMessagesViewController () {
    CGFloat _storedMessageTextViewContentHeight;
}

@end

@implementation ExpandedMessagesViewController

static void (^resizeTextViewFrameToUsedRectForTextContainer)(UITextView * _Nullable, UIButton * _Nullable) = ^ (UITextView * _Nullable textView, UIButton * _Nullable button) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [textView setFrame:[textView.textContainer.layoutManager usedRectForTextContainer:textView.textContainer]];
        UIBezierPath * exclusionPath = [UIBezierPath bezierPathWithRect:button.frame];
        textView.textContainer.exclusionPaths = @[exclusionPath];
    });
};

- (void)viewDidLoad {
//    [self delegate:(id<ExpandedMessagesViewControllerDelegate> _Nullable)((RootMessagesViewController *)self.parentViewController)];
    resizeTextViewFrameToUsedRectForTextContainer(self.messageTextView, self.renderCipherImageButton);
    UIBezierPath * exclusionPath = [UIBezierPath bezierPathWithRect:self.renderCipherImageButton.frame];
    self.messageTextView.textContainer.exclusionPaths = @[exclusionPath];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
//    __weak __block RootMessagesViewController * w_rootMessagesViewController = (RootMessagesViewController *)self.parentViewController;
//    [self.delegate presentationStyleForRootMessagesViewController](MSMessagesAppPresentationStyleCompact, self.storyboard);
    [self. delegate swapChildViewControllers];
}

- (void)textViewDidChange:(UITextView *)textView {
    CGFloat messageTextViewFrameHeight = self.messageTextView.frame.size.height;
    CGFloat messageTextViewContentHeight = [self.messageTextView.textContainer.layoutManager usedRectForTextContainer:self.messageTextView.textContainer].size.height;
    if (messageTextViewContentHeight != messageTextViewFrameHeight) {
        resizeTextViewFrameToUsedRectForTextContainer(textView, self.renderCipherImageButton);
    }
}

- (IBAction)renderCipherImage:(UIButton *)sender {
    [self.delegate renderCipherImageWithBlock:^UIImage * _Nonnull (void) {
        UIGraphicsBeginImageContextWithOptions(self.messageTextView.layer.frame.size, self.messageTextView.isOpaque, 0.0f);
        [self.view drawViewHierarchyInRect:self.messageTextView.layer.frame afterScreenUpdates:TRUE];
        [self.messageTextView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *cipherImageFile = UIGraphicsGetImageFromCurrentImageContext();
        
        return cipherImageFile;
    }];
    
    [self.messageTextView endEditing:TRUE];
}

@end
