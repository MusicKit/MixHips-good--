//
//  NewsDetailViewController.m
//  MixHipsProject
//
//  Created by SDT-1 on 2014. 2. 11..
//  Copyright (c) 2014년 SDT-1. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "UIImageView+AFNetworking.h"
#import "PlaylistCatagory.h"
#import "PlayListViewController.h"
#import "Player.h"
#import "PlayListDB.h"
@interface NewsDetailViewController ()
@property (weak, nonatomic) IBOutlet UITextView *contentsTextView;
@property (weak, nonatomic) IBOutlet UIView *netView;
@property (weak, nonatomic) IBOutlet UIButton *renetButton;

@property (weak, nonatomic) IBOutlet UIImageView *urlImg;
@property (strong,nonatomic) UIProgressView *progressBar;

@end

@implementation NewsDetailViewController{
    PlaylistCatagory *playCatagory;
    Player *playerCata;
    NSArray *listTrack;
    NSMutableArray *abc;
    NSString *adMenu;
    NSString *adTitle;
    NSString *adContents;
    NSString *adURL;
    UIActivityIndicatorView *indicator;
}

-(IBAction)listJoin:(id)sender{
    PlayListViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"playlist"];
    [self.navigationController pushViewController:nextVC animated:YES];
}

-(IBAction)restartNet:(id)sender{
    [self AFNetworkingAD];
    self.netView.hidden = YES;
}

-(IBAction)urlJoin:(id)sender{
    NSString *fff = [NSString stringWithFormat:@"http://%@",adURL];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: fff]
     ];
}

- (void)test:(NSDictionary *)dic {
    NSDictionary *dd = [NSDictionary dictionaryWithDictionary:dic];
    abc = [[NSMutableArray alloc]init];
    [abc  addObject:[dd objectForKey:@"ad_detail"]];
    
    adMenu = [NSString stringWithFormat:@"%@",[abc[0] objectForKey:@"ad_menu"]];
    adContents = [NSString stringWithFormat:@"%@",[abc[0] objectForKey:@"ad_contents"]];
    adTitle = [NSString stringWithFormat:@"%@",[abc[0] objectForKey:@"ad_title"]];
    adURL = [NSString stringWithFormat:@"%@",[abc[0] objectForKey:@"ad_url"]];
}

-(void)AFNetworkingAD{
    [indicator startAnimating];
    NSString *i = [NSString stringWithFormat:@"%@",self.newsList.ad_id];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"foo":@"bar", @"ad_id":i};
    [manager POST: @"http://mixhips.nowanser.cloulu.com/request_ad_detail" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"JSON: %@", responseObject);
        [self test:responseObject];
        [indicator stopAnimating];
        [self setDetail];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [indicator stopAnimating];
        self.netView.hidden = NO;
    }];
}

-(void)setDetail{
   self.contentsTextView.text = adContents;
    
   NSString *url = @"http://mixhips.nowanser.cloulu.com/";
   url = [url stringByAppendingString:adURL];
    NSURL *ad_URL = [NSURL URLWithString:url];
   [self.urlImg setImageWithURL:ad_URL];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dismissVC{
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    //if it is a remote control event handle it correctly
    if (event.type == UIEventTypeRemoteControl)
    {
        if (event.subtype == UIEventSubtypeRemoteControlPlay)
        {
            [playCatagory.player play];
        }
        else if (event.subtype == UIEventSubtypeRemoteControlPause)
        {
            [playCatagory.player pause];
        }
        else if (event.subtype == UIEventSubtypeRemoteControlTogglePlayPause)
        {
            if(playCatagory.player.rate == 1.0){
                [playCatagory.player pause];
            }
            else{
                [playCatagory.player play];
            }
        }
        
        else if (event.subtype == UIEventSubtypeRemoteControlPreviousTrack)
        {
            playerCata = [Player defaultCatalog];
            playerCata.indexPathRow--;
            if(playerCata.indexPathRow <0){
                playerCata.indexPathRow = listTrack.count-1;
                self.soundID = [NSString stringWithFormat:@"%@",listTrack[playerCata.indexPathRow]];
                [playCatagory playStart:self.soundID];
            }else{

                self.soundID = [NSString stringWithFormat:@"%@",listTrack[playerCata.indexPathRow]];
                [playCatagory playStart:self.soundID];
            }
            
        }
        else if (event.subtype == UIEventSubtypeRemoteControlNextTrack)
        {
            playerCata = [Player defaultCatalog];
            playerCata.indexPathRow++;
            if(playerCata.indexPathRow > listTrack.count-1){
                playerCata.indexPathRow = 0;
                self.soundID= [NSString stringWithFormat:@"%@",listTrack[playerCata.indexPathRow]];
                [playCatagory playStart:self.soundID];
            }
            else{
                self.soundID = [NSString stringWithFormat:@"%@",listTrack[playerCata.indexPathRow]];
                [playCatagory playStart:self.soundID];
            }
            
        }
        
    }
}

-(void)viewWillAppear:(BOOL)animated{
    
    PlayListDB *playDB = [PlayListDB sharedPlaylist];
    [playDB fetchMovies];
    listTrack  = [playDB data];
    
    [self AFNetworkingAD];
    playCatagory = [PlaylistCatagory defaultCatalog];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //Once the view has loaded then we can register to begin recieving controls and we can become the first responder
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //End recieving events
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    self.netView.hidden = YES;
    CALayer * l = [self.netView layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:6.0];
    
    
    indicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(135, 200, 50, 50)];
    indicator.hidesWhenStopped = YES;
    [self.view addSubview:indicator];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(dismissVC)];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
