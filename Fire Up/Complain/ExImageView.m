//
//  ExImageView.m
//  Complain
//
//  Created by sunkai on 1/15/15.
//  Copyright (c) 2015 sunkai. All rights reserved.
//

#import "ExImageView.h"

@interface ExImageView ()

@property (nonatomic, strong) PFFile *currentFile;
@property (nonatomic, strong) NSString *url;

@end

@implementation ExImageView

@synthesize currentFile,url;
@synthesize placeholderImage;

#pragma mark - PAPImageView

- (void) setFile:(PFFile *)file {
    UIImageView *border = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ShadowsProfilePicture-43.png"]];
    [self addSubview:border];
    
    NSString *requestURL = file.url; // Save copy of url locally (will not change in block)
    [self setUrl:file.url]; // Save copy of url on the instance
    
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            if ([requestURL isEqualToString:self.url]) {
                [self setImage:image];
                [self setNeedsDisplay];
            }
        } else {
            NSLog(@"Error on fetching file");
        }
    }];
}

@end