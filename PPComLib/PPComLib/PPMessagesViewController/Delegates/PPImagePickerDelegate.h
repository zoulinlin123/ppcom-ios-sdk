//
//  PPImagePickerDelegate.h
//  PPComDemo
//
//  Created by Kun Zhao on 9/29/15.
//  Copyright (c) 2015 Yvertical. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol PPImageImageSenderInterface <NSObject>
-(void)sendImage:(UIImage*)image;
@end

@interface PPImagePickerDelegate : NSObject <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property(nonatomic, weak) id<PPImageImageSenderInterface> imageSender;
@end
