//
//  LoadingViewController.h
//  codeTestMG
//
//  Created by Marcos Garcia on 4/30/15.
//  Copyright (c) 2015 marcos. All rights reserved.
//

#import <UIKit/UIKit.h>

//Protocol for connection
@protocol ConnectionDelegate <NSObject>

-(void)connectionFinish:(NSDictionary *)JSONObject succes:(BOOL)success serviceName:(NSString *)name;

@end

@interface LoadingViewController : UIViewController <NSURLConnectionDataDelegate>{
    NSMutableData *webData;
    NSURLConnection *connection;
    NSString *webServiceName;
    id<ConnectionDelegate> delegate;
}

@property (nonatomic, retain) id <ConnectionDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (nonatomic, retain) NSString *webServiceName;
@property (weak, nonatomic) IBOutlet UIView *containerLoad;

-(void)connect:(NSMutableURLRequest *)req;
-(void)start;
-(void)finish;
-(void)setPositionFromFrame:(CGRect)frame;
-(void)errorAlert:(NSString *)title :(NSString *)message;

@end
