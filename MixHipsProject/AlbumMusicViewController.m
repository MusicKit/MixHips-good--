//
//  AlbumMusicViewController.m
//  MixHipsProject
//
//  Created by SDT-1 on 2014. 1. 28..
//  Copyright (c) 2014년 SDT-1. All rights reserved.
//

#import "AlbumMusicViewController.h"
#import "PlayListDB.h"
#import "PlayListViewController.h"
#import "AlbumList.h"
#import "Catalog.h"
#import "AlbumCell.h"
#import "RequestCenter.h"
#import "AFHTTPRequestOperationManager.h"
#import "PlaylistCatagory.h"
#import "UIImageView+AFNetworking.h"
#import "Player.h"
#import "PlayCatalog.h"
#import "AlbumProfileViewController.h"
#import "PlayerViewController.h"
#import "PlayListViewController.h"
#import "MyIDCatagory.h"


@interface AlbumMusicViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *allSelectButton;
@property (weak, nonatomic) IBOutlet UILabel *albumNameLable;
@property (weak, nonatomic) IBOutlet UIImageView *albumImg;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *artistName;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIView *netView;
@property (weak, nonatomic) IBOutlet UIButton *renetButton;
@property (weak, nonatomic) IBOutlet UILabel *listCount;
@end

@implementation AlbumMusicViewController{
    MyIDCatagory *myIdCatagory;
    NSString *myid;
    PlayListDB *playlist;
    NSString *is_like;
    NSString *soundName;
    NSString *soundURL;
    NSString *soundID;
    NSString *user_Id;
    NSString *albumName;
    NSString *list_count;
    NSString *albumImgURL;
    NSString *my_like;
    NSMutableArray *soundlist;
    NSArray *abc;
    NSMutableArray *soundIDArr;
    NSMutableArray *soundNameArr;
    NSMutableArray *soundURLArr;
        PlaylistCatagory *playCatagory;
    PlayerViewController *playerVC;
    NSArray *listTrack;
    UIActivityIndicatorView *indicator;
}
-(IBAction)listJoin:(id)sender{
    PlayListViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"playlist"];
    [self.navigationController pushViewController:nextVC animated:YES];
}
-(IBAction)likeButton:(id)sender{
    [self AFNetworkingADLike];
}

-(IBAction)allSelect:(id)sender{
    if(self.allSelectButton.tag == 0){
        for (NSInteger r = 0; r < [self.tableView numberOfRowsInSection:0]; r++) {
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:r inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
            self.allSelectButton.tag = 1;
        }
        [self.allSelectButton setTitle:@"전체해제" forState:UIControlStateNormal];
    }
    else if(self.allSelectButton.tag == 1){
        for (NSInteger r = 0; r < [self.tableView numberOfRowsInSection:0]; r++) {
            [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:r inSection:0] animated:NO];
            self.allSelectButton.tag =0;
            
        }
        [self.allSelectButton setTitle:@"전체선택" forState:UIControlStateNormal];
    }
}

-(IBAction)selectMusicPlay:(id)sender{
    PlayListViewController *dest = [[PlayListViewController alloc]init];
    Player *playerlist =[Player defaultCatalog];
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSArray *indexPathArr = [self.tableView indexPathsForSelectedRows];
    if(indexPathArr.count >0){
    for(indexPath in indexPathArr){
        AlbumList *albumlist = [[Catalog defaultCatalog] musicAt:indexPath.row];
        playlist = [PlayListDB sharedPlaylist];
        [playlist addMovieWithName:soundNameArr[indexPath.row] nickName:self.user_Name song_id:soundIDArr[indexPath.row] album_img:albumImgURL];
        [playlist fetchMovies];
        [playerlist setAlbumImg:albumImgURL];
        [playerlist setSoundId:soundIDArr[indexPath.row]];

        dest.albumList = albumlist;
        playerlist.indexPathRow = playlist.data.count;
    }
        PlayerViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"playerPart"];
        [self.navigationController presentViewController:nextVC animated:NO completion:nil];

    listTrack =  [playlist data];

    playerlist.indexPathRow =  playerlist.indexPathRow - indexPathArr.count;
    soundID = [NSString stringWithFormat:@"%@",listTrack[playerlist.indexPathRow]];

    [playCatagory playStart:soundID];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"MixHips" message:@"한곡이상 선택해주세요" delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
        alert.alertViewStyle = UIAlertViewStyleDefault;
        [alert show];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(IBAction)restartNet:(id)sender{
    [self AFNetworkingAD];
    self.netView.hidden = YES;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:[NSString stringWithFormat:@"joingUser"]]){
        AlbumProfileViewController *dest = (AlbumProfileViewController *)segue.destinationViewController;
        dest.user_ID = user_Id;
    }
    else if([segue.identifier isEqualToString:[NSString stringWithFormat:@"playMusic"]]){
        
    }
}

//network like{
-(void)AFNetworkingADLike{
    NSString *d = [NSString stringWithFormat:@"%@",self.album_ID];
    NSString *i = [NSString stringWithFormat:@"%@",myid]; ///   본인 아이디
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"user_id":i , @"album_id":d};
    [manager POST: @"http://mixhips.nowanser.cloulu.com/action_like" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [self AFNetworkingAD];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


//Network

- (void)test:(NSDictionary *)dic {
    NSDictionary *dd = [NSDictionary dictionaryWithDictionary:dic];
    user_Id = [NSString stringWithFormat:@"%@",[dd objectForKey:@"user_id"]];
    albumName = [NSString stringWithFormat:@"%@",[dd objectForKey:@"album_name"]];
    albumImgURL = [NSString stringWithFormat:@"%@",[dd objectForKey:@"album_img_url"]];
    list_count = [NSString stringWithFormat:@"%@",[dd objectForKey:@"like_count"]];
    my_like = [NSString stringWithFormat:@"%@",[dd objectForKey:@"is_like:"]];

    NSArray *sound = [dd objectForKey:@"sounds"];
    soundIDArr = [[NSMutableArray alloc]init];
    soundNameArr = [[NSMutableArray alloc]init];
    soundURLArr = [[NSMutableArray alloc]init];
    soundlist = [[NSMutableArray alloc]init];
    
    
    for(int i=0;i<sound.count;i++)
    {
        [soundIDArr addObject:[sound[i] objectForKey:@"sound_id"]];
        [soundURLArr addObject:[sound[i] objectForKey:@"sound_url"]];
        [soundNameArr addObject:[sound[i] objectForKey:@"sound_name"]];
        
        [soundlist addObject:[AlbumList soundlist:soundNameArr[i] sound_id:soundIDArr[i] sound_url:soundURLArr[i]]];
    }
    [self.tableView reloadData];
    
}
-(void)AFNetworkingAD{
    [indicator startAnimating];
    NSString *d = [NSString stringWithFormat:@"%@",self.album_ID];
    NSString *i = [NSString stringWithFormat:@"%@",myid]; ///   본인 아이디
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"foo":@"bar", @"my_id":i , @"album_id":d};
    [manager POST: @"http://mixhips.nowanser.cloulu.com/request_album" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSLog(@"JSON: %@", responseObject);
        [self test:responseObject];
        [indicator stopAnimating];
        [self.tableView reloadData];
        [self setProfile];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        self.netView.hidden = NO;
        [indicator stopAnimating];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    
    return soundlist.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"music_CELL" forIndexPath:indexPath];
    self.albumList = [soundlist objectAtIndex:indexPath.row];
    
    [cell setProductInfo:self.albumList indexPath:indexPath.row];
    
    return cell;
}




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)setProfile{
    self.artistName.text = self.user_Name;
    self.albumNameLable.text = [NSString stringWithFormat:@"%@",albumName];
    self.listCount.text = [NSString stringWithFormat:@"%@",list_count];
    NSString *url = @"http://mixhips.nowanser.cloulu.com";
    url = [url stringByAppendingString:albumImgURL];
    NSURL *imgURL = [NSURL URLWithString:url];
    [self.albumImg setImageWithURL:imgURL];
    self.title = [NSString stringWithFormat:@"%@",albumName];
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
            Player *playerlist =[Player defaultCatalog];
            playerlist.indexPathRow--;
            if(playerlist.indexPathRow <0){
                playerlist.indexPathRow = listTrack.count-1;
                self.soundIDff = [NSString stringWithFormat:@"%@",listTrack[playerlist.indexPathRow]];
                [playCatagory playStart:self.soundIDff];
            }else{

                self.soundIDff = [NSString stringWithFormat:@"%@",listTrack[playerlist.indexPathRow]];
                [playCatagory playStart:self.soundIDff];
            }
            
        }
        else if (event.subtype == UIEventSubtypeRemoteControlNextTrack)
        {
            Player *playerlist =[Player defaultCatalog];

            playerlist.indexPathRow++;
            if(playerlist.indexPathRow > listTrack.count-1){
                playerlist.indexPathRow = 0;
                self.soundIDff= [NSString stringWithFormat:@"%@",listTrack[playerlist.indexPathRow]];
                [playCatagory playStart:self.soundIDff];
            }
            else{
                self.soundIDff = [NSString stringWithFormat:@"%@",listTrack[playerlist.indexPathRow]];
                [playCatagory playStart:self.soundIDff];
            }
            
        }
        
    }
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


-(void)viewWillAppear:(BOOL)animated{
    
    myIdCatagory = [MyIDCatagory defaultCatalog];
    myid = [myIdCatagory getMyid];
    
    PlayListDB *playDB = [PlayListDB sharedPlaylist];
    [playDB fetchMovies];
    listTrack  = [playDB data];
        [self AFNetworkingAD];
    [self.navigationController setNavigationBarHidden:NO];
    self.allSelectButton.tag =0;

}


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.netView.hidden = YES;
    CALayer * l = [self.netView layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:6.0];

    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(dismissVC)];
    
    indicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(135, 200, 50, 50)];
    indicator.hidesWhenStopped = YES;
    [self.view addSubview:indicator];
    
    playCatagory = [PlaylistCatagory defaultCatalog];
    

    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
