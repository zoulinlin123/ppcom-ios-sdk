//
//  FeedbackMessagesViewController.m
//  PPComDemo
//
//  Created by Kun Zhao on 10/10/15.
//  Copyright (c) 2015 Yvertical. All rights reserved.
//

#import "FeedbackMessagesViewController.h"

#define APP_UUID @"604f3438-39d1-11e6-b48e-c82a1426f133";
#define USER_EMAIL @"55118222@qq.com"

@interface FeedbackMessagesViewController ()

- (void)onClosePressed:(UIBarButtonItem *)sender;

@end

@implementation FeedbackMessagesViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (self.delegateModal) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                                                              target:self
                                                                                              action:@selector(onClosePressed:)];
    }

    // set title
    self.title = @"会话列表";
    
    // set appUUID
    self.appUUID = APP_UUID;
    
    // initialize with anonymous user or call `[self initializeWithUserEmail:USER_EMAIL]` to initialize with user_email.
    [self initialize];
}

//NOTE: you must call `releaseResources` manaually when dismiss this controller with `Modal` segue
- (void)onClosePressed:(UIBarButtonItem *)sender {
    [super releaseResources];
    [self.delegateModal didDismissFeedbackViewController:self];
}

@end
