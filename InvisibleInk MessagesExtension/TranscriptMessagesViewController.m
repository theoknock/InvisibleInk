//
//  TranscriptMessagesViewController.m
//  InvisibleInk MessagesExtension
//
//  Created by Xcode Developer on 5/22/21.
//

#import "TranscriptMessagesViewController.h"

@interface TranscriptMessagesViewController ()

@end

@implementation TranscriptMessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [(RootMessagesViewController *)self.parentViewController setDelegate:(id<RootMessagesViewControllerDelegate>)self];
    [self.delegate sendCipherStickerToView:self.cipherStickerView];
}

- (CGSize)contentSizeThatFits:(CGSize)size
{
    CGSize liveLayoutTemplateSize = CGSizeMake(300.0, 300.0);
    
    return liveLayoutTemplateSize;
}

@end
