//
//  ExImageView.h
//  Complain
//
//  Created by sunkai on 1/15/15.
//  Copyright (c) 2015 sunkai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ExImageView : UIImageView

@property (nonatomic, strong) UIImage *placeholderImage;

- (void) setFile:(PFFile *)file;

@end
