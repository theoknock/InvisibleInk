//
//  CompactMessagesViewController.m
//  InvisibleInk MessagesExtension
//
//  Created by Xcode Developer on 5/21/21.
//

#import "CompactMessagesViewController.h"

@interface CompactMessagesViewController ()

@end

@implementation CompactMessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (IBAction)presentExpandedMessagesViewController:(UIButton *)sender {
    [(typeof (MSMessagesAppViewController *))self.parentViewController requestPresentationStyle:MSMessagesAppPresentationStyleExpanded];
}

@end
