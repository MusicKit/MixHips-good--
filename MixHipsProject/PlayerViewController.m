//
//  PlayerViewController.m
//  MixHipsProject
//
//  Created by SDT-1 on 2014. 1. 27..
//  Copyright (c) 2014년 SDT-1. All rights reserved.
//

#import "PlayerViewController.h"
#import "PlayListViewController.h"
#import "Player.h"
#import "AppDelegate.h"
#import "PlaylistCatagory.h"
#import "RequestCenter.h"
#import "PlayListDB.h"
#import "UIImageView+AFNetworking.h"
#import "CommentViewController.h"
#import "SoundIDCatagory.h"
#import "AFHTTPRequestOperationManager.h"
#import "playerDelegate.h"

@interface PlayerViewController ()<AVAudioPlayerDelegate, AVAudioRecorderDelegate , playerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *play;
@property (weak, nonatomic) IBOutlet UIButton *fastButton;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *albumView;
@property (weak, nonatomic) IBOutlet UIProgressView *progresss;
@property (weak, nonatomic) IBOutlet UINavigationItem *titleNavi;
@property (weak, nonatomic) IBOutlet UIButton *loopButton;
@property (weak, nonatomic) IBOutlet UIButton *shuffleButton;





@end

@implementation PlayerViewController{
    UIActivityIndicatorView *indicator;
    SoundIDCatagory *soundCata;
    PlayListDB *playDB;
    Player *playerCata;
    PlaylistCatagory *playCatagory;
    PlayListViewController *list;
    NSInteger indexPath;
    NSTimer *timer;
    NSArray *listTrack;
    NSArray *albumlistTrack;
    NSString *albumImgURL;
    BOOL isPlaying;
}
@synthesize player;


-(IBAction)dismissView:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(IBAction)toggleButton:(id)sender{
    if(playCatagory.player.rate ==1.0){
        self.play.selected = NO;
        [playCatagory.player pause];
    }
    else{
        self.play.selected = YES;
        [playCatagory.player play];
    }
}

-(IBAction)fastButton:(id)sender{
    playerCata = [Player defaultCatalog];
    playerCata.indexPathRow++;
    if(playerCata.indexPathRow > listTrack.count-1){
        playerCata.indexPathRow = 0;
        self.soundID= [NSString stringWithFormat:@"%@",listTrack[playerCata.indexPathRow]];
        [self setImg:playerCata.indexPathRow];
        [playCatagory playStart:self.soundID];
    }
    else{
    self.soundID = [NSString stringWithFormat:@"%@",listTrack[playerCata.indexPathRow]];
        [self setImg:playerCata.indexPathRow];
    [playCatagory playStart:self.soundID];
    }
}

-(IBAction)rewindButton:(id)sender{
    playerCata = [Player defaultCatalog];
    playerCata.indexPathRow--;
    if(playerCata.indexPathRow <0){
        playerCata.indexPathRow = listTrack.count-1;
        self.soundID = [NSString stringWithFormat:@"%@",listTrack[playerCata.indexPathRow]];
        [self setImg:playerCata.indexPathRow];
        [playCatagory playStart:self.soundID];
    }else{
 
    [self setImg:playerCata.indexPathRow];
//    [self setProfile];

    self.soundID = [NSString stringWithFormat:@"%@",listTrack[playerCata.indexPathRow]];
    [playCatagory playStart:self.soundID];
    }
}

-(IBAction)loopButton:(id)sender{
    if ([playCatagory returnLoop] == NO) {
        [playCatagory loopPlay];
        self.loopButton.selected = YES;
    }
    else{
        [playCatagory notloopPlay];
        self.loopButton.selected = NO;
    }
}

-(IBAction)shuffleButton:(id)sender{
    if(self.shuffleButton.tag == 100){
        self.shuffleButton.selected = YES;
        self.shuffleButton.tag =101;
    }
    else if(self.shuffleButton.tag == 101){
        self.shuffleButton.selected = NO;
        self.shuffleButton.tag =100;
    }
}

-(void)updateProgressViewWithPlayer:(NSString *)string time:(float)time{
    self.progresss.progress = time;
    self.progressLabel.text = string;
}

-(void)setUser:(NSString *)userNamef setSound:(NSString *)soundNamef{
    self.titleNavi.title = [NSString stringWithFormat:@"%@ - %@",soundNamef, userNamef];
    if(playCatagory.player.rate ==1){
        self.play.selected = NO;
    }
    else{
        self.play.selected = YES;
    }
}

-(void)setImg:(NSInteger)indexPathff{
    playDB = [PlayListDB sharedPlaylist];
    NSString *url = @"http://mixhips.nowanser.cloulu.com";
    self.albumImg = albumlistTrack[indexPathff];
    url = [url stringByAppendingString:self.albumImg];
    NSURL *imgURL = [NSURL URLWithString:url];
    [self.albumView setImageWithURL:imgURL];
    
}

-(void)setProfile{
    playerCata = [Player defaultCatalog];
    NSString *url = @"http://mixhips.nowanser.cloulu.com";
    self.albumImg = [playerCata getAlbumImg];
    url = [url stringByAppendingString:self.albumImg];
    NSURL *imgURL = [NSURL URLWithString:url];
    [self.albumView setImageWithURL:imgURL];
    if(playCatagory.player.rate ==1){
        self.play.selected = NO;
    }
    else{
        self.play.selected = YES;
    }
}

-(void)indicator{
    [indicator startAnimating];
}

-(void)stopindicator{
    [indicator stopAnimating];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
                [self setImg:playerCata.indexPathRow];
                [playCatagory playStart:self.soundID];
            }else{
                
                [self setImg:playerCata.indexPathRow];
                
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
                [self setImg:playerCata.indexPathRow];
                [playCatagory playStart:self.soundID];
            }
            else{
                self.soundID = [NSString stringWithFormat:@"%@",listTrack[playerCata.indexPathRow]];
                [self setImg:playerCata.indexPathRow];
                [playCatagory playStart:self.soundID];
            }

        }
        
    }
}

-(void)viewWillAppear:(BOOL)animated{
    playDB = [PlayListDB sharedPlaylist];
    listTrack =  [playDB data];
    albumlistTrack = [playDB albumimg];
    
    [self setProfile];
    
    if([playCatagory returnLoop] == YES){
        self.loopButton.selected = YES;
    }
    else{
        self.loopButton.selected = NO;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    self.tabBarController.tabBar.hidden=YES;
    playCatagory = [PlaylistCatagory defaultCatalog];
    playCatagory.delegate = self;
    player = nil;
    
    //indicator
    indicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(135, 200, 50, 50)];
    indicator.hidesWhenStopped = YES;
    [self.view addSubview:indicator];

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
