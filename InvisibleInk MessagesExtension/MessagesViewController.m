//
//  MessagesViewController.m
//  InvisibleInk MessagesExtension
//
//  Created by Xcode Developer on 5/20/21.
//

#import "MessagesViewController.h"

@interface MessagesViewController ()

@end

@implementation MessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ImagesViewController *imagesChildViewController = (ImagesViewController *)[[self childViewControllers] firstObject];
    [imagesChildViewController setDelegate:(id<ImagesViewControllerMessagingDelegate> _Nullable)self];
}

#pragma mark - Image Processing

static void (^CGContextRectFillColor)(CGContextRef, CGRect, CGSize, CGColorRef) = ^(CGContextRef context, CGRect rect, CGSize size, CGColorRef color) {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextSetFillColorWithColor(context, color);
    CGRect contextRect = CGRectMake(0.0, 0.0, size.width, size.height);
    CGContextFillRect(context, contextRect);
    CGColorSpaceRelease(colorSpace);
};

static UIImage * _Nonnull (^imageFromText)(NSString * _Nonnull, UIColor * _Nullable, UIColor * _Nullable, CGFloat, UIFontWeight, BOOL) = ^(NSString *text, UIColor * _Nullable color, UIColor * _Nullable fillColor, CGFloat fontsize, UIFontWeight weight, BOOL opaque)
{
    NSMutableParagraphStyle *leftAlignedParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    leftAlignedParagraphStyle.alignment                = NSTextAlignmentCenter;
    NSDictionary *leftAlignedTextAttributes            = @{NSForegroundColorAttributeName : color,
                                                             NSParagraphStyleAttributeName  : leftAlignedParagraphStyle,
                                                             NSFontAttributeName            : [UIFont systemFontOfSize:fontsize weight:weight],
                                                             NSStrokeColorAttributeName     : [UIColor blackColor],
                                                             NSStrokeWidthAttributeName     : [NSNumber numberWithFloat:0.0]
    };

    CGSize textSize = [text sizeWithAttributes:leftAlignedTextAttributes];
    UIGraphicsBeginImageContextWithOptions(textSize, opaque, 0);
    CGRect contextRect = CGRectMake(0.0, 0.0, textSize.width, textSize.height);
    [[UIBezierPath bezierPathWithRoundedRect:contextRect
                            cornerRadius:4.5] addClip];
    
    CGContextSetShouldAntialias(UIGraphicsGetCurrentContext(), YES);
    CGContextSetShadow(UIGraphicsGetCurrentContext(), CGSizeZero, fontsize);
    if (opaque) {
        CGContextRectFillColor(UIGraphicsGetCurrentContext(), contextRect, textSize, fillColor.CGColor);
    }
    [text drawAtPoint:CGPointZero withAttributes:leftAlignedTextAttributes];
    CGPathCreateWithRoundedRect(contextRect, 1.0/textSize.width, 1.0/textSize.height, NULL);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
};


#pragma mark - Conversation Handling

-(void)didBecomeActiveWithConversation:(MSConversation *)conversation {
    // Called when the extension is about to move from the inactive to active state.
    // This will happen when the extension is about to present UI.
    
    // Use this method to configure the extension and restore previously stored state.
}

-(void)willResignActiveWithConversation:(MSConversation *)conversation {
    // Called when the extension is about to move from the active to inactive state.
    // This will happen when the user dismisses the extension, changes to a different
    // conversation or quits Messages.
    
    // Use this method to release shared resources, save user data, invalidate timers,
    // and store enough state information to restore your extension to its current state
    // in case it is terminated later.
}

-(void)didReceiveMessage:(MSMessage *)message conversation:(MSConversation *)conversation {
    // Called when a message arrives that was generated by another instance of this
    // extension on a remote device.
    
    // Use this method to trigger UI updates in response to the message.
    
    // TO-DO:
    //      1. Get image from message
    //      2. Process using contrast stretch Metal CIFilter
}

-(void)didStartSendingMessage:(MSMessage *)message conversation:(MSConversation *)conversation {
    // Called when the user taps the send button.
}

-(void)didCancelSendingMessage:(MSMessage *)message conversation:(MSConversation *)conversation {
    // Called when the user deletes the message without sending it.
    
    // Use this to clean up state related to the deleted message.
}

-(void)willTransitionToPresentationStyle:(MSMessagesAppPresentationStyle)presentationStyle {
    // Called before the extension transitions to a new presentation style.
    
    // Use this method to prepare for the change in presentation style.
}

-(void)didTransitionToPresentationStyle:(MSMessagesAppPresentationStyle)presentationStyle {
    // Called after the extension transitions to a new presentation style.
    
    // Use this method to finalize any behaviors associated with the change in presentation style.
}

- (void)composeTestMessage:(NSString *)messageText {
    MSConversation * conversation = self.activeConversation;
    UIImage * cipherImage = imageFromText(messageText, [UIColor blackColor], [UIColor colorWithRed:255.0 green:251.0 blue:0.0 alpha:0.25], 14.0, UIFontWeightMedium, TRUE);
    NSString *outputPath = [NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), @"output.png"];
       if (![UIImagePNGRepresentation(cipherImage) writeToFile:outputPath atomically:YES]) {
           NSLog(@"Failed to write image to file");
       } else {
           __autoreleasing NSError * error = nil;
           NSURL * fileURL = [NSURL fileURLWithPath:outputPath];
           MSSticker * cipherMessage = [[MSSticker alloc] initWithContentsOfFileURL:fileURL localizedDescription:nil error:&error];
           if (!error) {
               [conversation insertSticker:cipherMessage completionHandler:^(NSError * _Nullable error) {
                   if (error) {
                       NSLog(@"Failed to insert cipher message (sticker) into the current conversation");
                   }
               }];
           }
       }
}

- (void)insertCipherImageAtPath:(NSString *)cipherImagePath {
    MSConversation * conversation = self.activeConversation;
    __autoreleasing NSError * error = nil;
    NSURL * fileURL = [NSURL fileURLWithPath:cipherImagePath];
    MSSticker * cipherMessage = [[MSSticker alloc] initWithContentsOfFileURL:fileURL localizedDescription:nil error:&error];
    if (!error) {
        [conversation insertSticker:cipherMessage completionHandler:^(NSError * _Nullable error) {
            if (error) {
                NSLog(@"Failed to insert cipher message (sticker) into the current conversation");
            }
        }];
    }
}

@end
