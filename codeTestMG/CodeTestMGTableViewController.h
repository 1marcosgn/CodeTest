//
//  CodeTestMGTableViewController.h
//  codeTestMG
//
//  Created by Marcos Garcia on 4/30/15.
//  Copyright (c) 2015 marcos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface CodeTestMGTableViewController : UITableViewController <ConnectionDelegate, UIAlertViewDelegate>
@property (nonatomic, retain) NSMutableData *dataResponse;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activity;

@end
