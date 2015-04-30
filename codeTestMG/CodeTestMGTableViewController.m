//
//  CodeTestMGTableViewController.m
//  codeTestMG
//
//  Created by Marcos Garcia on 4/30/15.
//  Copyright (c) 2015 marcos. All rights reserved.
//

#import "CodeTestMGTableViewController.h"
#import "CodeTestMGTableViewCell.h"
#import "LoadingViewController.h"


@interface CodeTestMGTableViewController (){
    NSMutableArray *arrElements;
}

@end

@implementation CodeTestMGTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIColor *topBarColor = [UIColor colorWithRed:169.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
    self.navigationController.navigationBar.barTintColor = topBarColor;
    
    CGRect frame = CGRectMake(0, 0, 70, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = @"Music";
    self.navigationItem.titleView = label;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CodeTestMGTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cellVideo"];
    
    
    //STEP 01: Connect to webService
    [self connectToService];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [arrElements count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 118.0;
}

//STEP 04: Use the information to load the customized cells
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Configure the cell...
    UITableViewCell *cell;
    CodeTestMGTableViewCell *theCell = (CodeTestMGTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"cellVideo" forIndexPath:indexPath];

    NSMutableDictionary *dictionaryInfo = [NSMutableDictionary dictionary];
    
    dictionaryInfo = [arrElements objectAtIndex:indexPath.row];
    
    if ([[dictionaryInfo valueForKey:@"title"] isEqualToString:@""]) {
        theCell.lblTitleVideo.text = @"No title Available";
    }
    else{
        theCell.lblTitleVideo.text = [dictionaryInfo valueForKey:@"title"];
    }
    
    if ([[dictionaryInfo valueForKey:@"description"] isEqualToString:@""]) {
        theCell.lblDescriptionVideo.text = @"No description Available";
    }
    else{
        theCell.lblDescriptionVideo.text = [dictionaryInfo valueForKey:@"description"];
    }
    
    //STEP 05: Create an async operation to load in different threads the images for the thumbnails in order to have a better performance
    if ([[dictionaryInfo valueForKey:@"image"] length] > 0) {
        //Consume webservice with image...
        [theCell.activityVideo startAnimating];
        
        //Creation of the queue...
        dispatch_queue_t imageQueue = dispatch_queue_create("Image Queue", NULL);
        
        dispatch_async(imageQueue, ^{
            
            NSURL *url = [NSURL URLWithString:[dictionaryInfo valueForKey:@"image"]];
            NSData *imageData = [NSData dataWithContentsOfURL:url];
            UIImage *image = [UIImage imageWithData:imageData];
            
            //Update the view with the main queue
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [theCell.imgThumbnailVideo setImage:image];
                [theCell.imgThumbnailVideo setAlpha:1.0];
                
                [theCell.activityVideo stopAnimating];
                [theCell.activityVideo setHidden:YES];
                
            });
        });
    }
    else{
        //no action required...
        theCell.imgThumbnailVideo.image = [UIImage imageNamed:@"noImage.png"];
        theCell.imgThumbnailVideo.layer.borderWidth = 0;
        
        [theCell.activityVideo setHidden:YES];
        [theCell.activityVideo setAlpha:1.0];
    }

    cell = theCell;
    return cell;
}


-(void)connectToService{
    LoadingViewController *connection = [[LoadingViewController alloc]init];
    [connection setDelegate:self];
    [self.view insertSubview:connection.view atIndex:[[self.view subviews]count]];
    [connection start];
    NSURL *url = [NSURL URLWithString:@"https://gdata.youtube.com/feeds/api/videos?q=vevo&max-re%E2%80%8C%20%E2%80%8Bsults=5&v=2&alt=jsonc&orderby=published"];
    NSURLRequest *req = [[NSURLRequest alloc]initWithURL:url];
    [connection connect:[req mutableCopy]];
}


#pragma mark - Connection Delegates
-(void)connectionFinish:(NSDictionary *)JSONObject succes:(BOOL)success serviceName:(NSString *)name{
    
    if ([JSONObject count] == 0 || success == NO) {
        [self someTroubles];
    }
    else{
        
        //STEP 02: If the connection is OK, let's continue parsing the information...
        arrElements = [[NSMutableArray alloc]initWithCapacity:[[[JSONObject objectForKey:@"data"] valueForKey:@"items"] count]];
        
        for (id element in [[JSONObject objectForKey:@"data"] valueForKey:@"items"]) {
            
            NSMutableDictionary *tmpDictionary = [NSMutableDictionary dictionary];
            
            [tmpDictionary setObject:[element valueForKey:@"title"] forKey:@"title"];
            [tmpDictionary setObject:[element valueForKey:@"description"] forKey:@"description"];
            [tmpDictionary setObject:[[element valueForKey:@"thumbnail"]valueForKey:@"sqDefault"] forKey:@"image"];
            
            //STEP 03: Store all the relevant information in the array to reload the tableView
            [arrElements addObject:[tmpDictionary copy]];
            
            [tmpDictionary removeAllObjects];

            [self.tableView reloadData];
            
        }
    }
}

-(void)someTroubles{
    UIView *backView = [[UIView alloc]initWithFrame:self.tableView.frame];
    [backView setBackgroundColor:[UIColor whiteColor]];
    UIImageView *imageBlank = [[UIImageView alloc]initWithFrame:CGRectMake(142, 212, 76, 76)];
    [imageBlank setImage:[UIImage imageNamed:@"failImage.png"]];
    [imageBlank setAlpha:0.8];
    [backView addSubview:imageBlank];
    UILabel *lblMessage = [[UILabel alloc]initWithFrame:CGRectMake(41, 300, 291, 69)];
    lblMessage.text = @"Unable to load. Please try again.";
    lblMessage.numberOfLines = 3;
    lblMessage.textAlignment = NSTextAlignmentCenter;
    lblMessage.textColor = [UIColor colorWithRed:139.0/256.0 green:139.0/256.0 blue:139.0/256.0 alpha:1.0];
    lblMessage.font = [UIFont fontWithName:@"Helvetica Neue" size:17.0];
    [backView addSubview:lblMessage];
    [self.tableView setUserInteractionEnabled:NO];
    [self.tableView setBackgroundView:backView];
}

@end
