//
//  ImagesViewController.m
//  InvisibleInk MessagesExtension
//
//  Created by Xcode Developer on 5/20/21.
//

#import <MetalKit/MetalKit.h>

#import "ExpandedMessagesViewController.h"
#import "RootMessagesViewController.h"

#import "MetalFilter.h"
#import "MetalKernel.h"

// TO-DO:   Add a callback shimmer to the layer of the UITextView that
//          creates a shimmering mirage effect on the text to be encrypted
//          (the code for this can be found in ViewController.m -- search for
//          'reference to view controller in block' with Spotlight to find it)
//

@interface ExpandedMessagesViewController ()

@end

@implementation ExpandedMessagesViewController

static void (^resizeTextViewFrameToUsedRectForTextContainer)(UITextView * _Nullable, UIButton * _Nullable) = ^ (UITextView * _Nullable textView, UIButton * _Nullable button) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [textView setFrame:[textView.textContainer.layoutManager usedRectForTextContainer:textView.textContainer]];
    });
};

- (void)viewDidLoad {
    self.messageTextView.textContainer.heightTracksTextView = TRUE;
    [self.messageTextView selectAll:nil];
}

- (IBAction)renderCipherImage:(UIButton *)sender {
    [self.messageTextView endEditing:TRUE];
    if (self.messageTextView.hasText)
    {
        CGRect contentsRect = self.messageTextView.bounds; //[self.messageTextView.textContainer.layoutManager usedRectForTextContainer:self.messageTextView.textContainer];
        UIGraphicsBeginImageContextWithOptions(contentsRect.size, YES, [[UIScreen mainScreen] scale]);
        [self.messageTextView drawViewHierarchyInRect:contentsRect afterScreenUpdates:YES];
        //            [self.messageTextView.textInputView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage * cipherImageFile = UIGraphicsGetImageFromCurrentImageContext();
        
        // ------
        // METAL - CORE IMAGE FILTER
        // ------
        
        
        //        CIFilter *filter = [[MetalFilter alloc] init];
        //
        //        CIImage *inCIImage = [[CIImage alloc] initWithImage:cipherImageFile];
        //
        //        {
        //            CGRect imageExtent = inCIImage.extent;
        //            NSLog(@"inCIImage extent %d x %d", (int) imageExtent.size.width, (int) imageExtent.size.height);
        //        }
        //
        //        [filter setValue:inCIImage forKeyPath:kCIInputImageKey];
        //
        //        // Calculate scale size so that large input image is scaled down to a size that
        //        // is the same size as the image view frame
        //
        //        {
        //            CGFloat scale = [UIScreen mainScreen].scale;
        //            CGSize imageViewSize = self.messageTextView.frame.size;
        //            imageViewSize = CGSizeMake(imageViewSize.width * scale, imageViewSize.height * scale);
        //
        //            {
        //                NSLog(@"expected resize to %d x %d", (int) imageViewSize.width, (int) imageViewSize.height);
        //            }
        //
        //            CGFloat ratio = imageViewSize.width / imageViewSize.height;
        //
        //            [filter setValue:@(imageViewSize.width) forKeyPath:kCIInputWidthKey];
        //            [filter setValue:@(ratio) forKeyPath:kCIInputAspectRatioKey];
        //        }
        //
        //        CIImage *outCIImage = filter.outputImage;
        //        UIImage *uiImgFromCIImage = [UIImage imageWithCIImage:outCIImage];
        //
        
        //        CIFilter *filter = [CIFilter filterWithName:@"CIPhotoEffectNoir"];
        //
        //        CIImage *inCIImage = [[CIImage alloc] initWithImage:cipherImageFile];
        //
        //        [filter setValue:inCIImage forKeyPath:kCIInputImageKey];
        //
        //        CIImage *outCIImage = filter.outputImage;
        //        UIImage *uiImgFromCIImage = [UIImage imageWithCIImage:outCIImage];
        
        CGFloat ratio = self.messageTextView.bounds.size.width / self.messageTextView.bounds.size.height;
        
        CIImage *inputImage = [CIImage imageWithCGImage:cipherImageFile.CGImage];
        inputImage = [inputImage imageByApplyingCGOrientation:kCGImagePropertyOrientationUp];
        CIFilter *filter = [[MetalFilter alloc] init];
        [filter setDefaults];
        [filter setValue:inputImage forKey:kCIInputImageKey];
        [filter setValue:@(self.messageTextView.bounds.size.width) forKeyPath:kCIInputWidthKey];
        [filter setValue:@(ratio) forKeyPath:kCIInputAspectRatioKey];
        CIImage *outputImage = [filter outputImage];
        UIImage * cipherImageFileBlur = [UIImage imageWithCIImage:outputImage];
        //------
        // METAL - CORE IMAGE FILTER
        // ------
        
        [self.delegate renderCipherImageWithBlock:^UIImage * _Nonnull (void) {
            return cipherImageFileBlur; //cipherImageFile;
        }];
        UIGraphicsEndImageContext();
        
        [(typeof (MSMessagesAppViewController *))self.parentViewController requestPresentationStyle:MSMessagesAppPresentationStyleCompact];
    }
}

@end
