//
//  CodeTestMGTableViewCell.h
//  codeTestMG
//
//  Created by Marcos Garcia on 4/30/15.
//  Copyright (c) 2015 marcos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CodeTestMGTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblTitleVideo;
@property (weak, nonatomic) IBOutlet UILabel *lblDescriptionVideo;
@property (weak, nonatomic) IBOutlet UIImageView *imgThumbnailVideo;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityVideo;

@end
