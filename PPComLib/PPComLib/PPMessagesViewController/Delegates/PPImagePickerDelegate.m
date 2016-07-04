//
//  PPImagePickerDelegate.m
//  PPComDemo
//
//  Created by Kun Zhao on 9/29/15.
//  Copyright (c) 2015 Yvertical. All rights reserved.
//
#import "PPMessagesViewController.h"
#import "PPImagePickerDelegate.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import <Photos/PHImageManager.h>

@implementation PPImagePickerDelegate

- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    if (self.imageSender != nil && image != nil) {
        [self.imageSender sendImage:image];
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{
        NSLog(@"UIImagePickerController dismiss.");
    }];
}

@end
