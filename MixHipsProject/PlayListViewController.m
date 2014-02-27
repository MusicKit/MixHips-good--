//
//  PlayListViewController.m
//  MixHipsProject
//
//  Created by SDT-1 on 2014. 1. 27..
//  Copyright (c) 2014년 SDT-1. All rights reserved.
//

#import "PlayListViewController.h"
#import "PlayListDB.h"
#import "PlaylistCell.h"
#import "Playlist.h"
#import "PlayerViewController.h"
#import "Catalog.h"
#import "PlaylistCatagory.h"
#import "Player.h"
#import "cacheList.h"


@interface PlayListViewController () <UITableViewDataSource, UITableViewDelegate, AVAudioPlayerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIProgressView *progressBar;
@end



@implementation PlayListViewController{
    PlaylistCell *cell;
    PlayerViewController *player;
    PlayListDB *_playlist;
    PlaylistCatagory *play;
    Player *playerCata;
    cacheList *data;
    NSInteger indexRow;
    NSString *img;
    NSArray *listTrack;
    NSInteger indexff;
}


//
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    player = (PlayerViewController *)segue.destinationViewController;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [_playlist fetchMovies];

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(play.player.rate ==1 ){
        if(indexPath.row == playerCata.indexPathRow){
            PlayerViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"playerPart"];
             [playerCata setAlbumImg:[_playlist getalbumImgAtIndex:indexPath.row]];
            [self.navigationController presentViewController:nextVC animated:YES completion:nil];
        }
        else{
            [playerCata setAlbumImg:[_playlist getalbumImgAtIndex:indexPath.row]];
            playerCata.indexPathRow = indexPath.row;
            indexRow = indexPath.row;
            NSString *soundID = [_playlist getSoundIdAtIndex:indexPath.row];
            PlayerViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"playerPart"];
            [self.navigationController presentViewController:nextVC animated:YES completion:nil];
            [play playStart:soundID];
        }
    }
    else{
        if(play.playStatus == YES){
           
            if(indexPath.row == playerCata.indexPathRow){
                [play.player play];
                PlayerViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"playerPart"];
                [playerCata setAlbumImg:[_playlist getalbumImgAtIndex:indexPath.row]];
                [self.navigationController presentViewController:nextVC animated:YES completion:nil];
            }
            else{
                [playerCata setAlbumImg:[_playlist getalbumImgAtIndex:indexPath.row]];
                playerCata.indexPathRow = indexPath.row;
                indexRow = indexPath.row;
                NSString *soundID = [_playlist getSoundIdAtIndex:indexPath.row];
                PlayerViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"playerPart"];
                [self.navigationController presentViewController:nextVC animated:YES completion:nil];
                [play playStart:soundID];

            }
            
        }else{
       
        [playerCata setAlbumImg:[_playlist getalbumImgAtIndex:indexPath.row]];
        playerCata.indexPathRow = indexPath.row;
        indexRow = indexPath.row;
        NSString *soundID = [_playlist getSoundIdAtIndex:indexPath.row];
        PlayerViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"playerPart"];
        [self.navigationController presentViewController:nextVC animated:YES completion:nil];
        [play playStart:soundID];
            
        }
    }
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(UITableViewCellEditingStyleDelete == editingStyle){
        [_playlist deleteMusic:indexPath.row];
        indexff = indexPath.row;
    }
    if(playerCata.indexPathRow > indexff){
        playerCata.indexPathRow--;
    }
    [_playlist fetchMovies];
    listTrack = [_playlist data];
    [self.tableView reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_playlist getNumberOfMovies];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        cell = [tableView dequeueReusableCellWithIdentifier:@"PLAYLIST_CELL" forIndexPath:indexPath];
        NSString *name = [_playlist getNameOfMovieAtIndex:indexPath.row];
        NSString *nickName = [_playlist getNickNameOfMusicAtIndex:indexPath.row];

 
           if(indexPath.row == playerCata.indexPathRow){
            img = [NSString stringWithFormat:@"gold.png"];
            [cell setPlaylistInfo:name nickName:nickName img:img];
        }
        else{
            NSString *ff = [NSString stringWithFormat:@"gray.png"];
            [cell setPlaylistInfo:name nickName:nickName img:ff];
        }
    return cell;
}


- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    //if it is a remote control event handle it correctly
    if (event.type == UIEventTypeRemoteControl)
    {
        if (event.subtype == UIEventSubtypeRemoteControlPlay)
        {
            [play.player play];
        }
        else if (event.subtype == UIEventSubtypeRemoteControlPause)
        {
            [play.player pause];
        }
        else if (event.subtype == UIEventSubtypeRemoteControlTogglePlayPause)
        {
            if(play.player.rate == 1.0){
                [play.player pause];
            }
            else{
                [play.player play];
            }
        }
        
        else if (event.subtype == UIEventSubtypeRemoteControlPreviousTrack)
        {
            playerCata = [Player defaultCatalog];
            playerCata.indexPathRow--;
            if(playerCata.indexPathRow <0){
                playerCata.indexPathRow = listTrack.count-1;
                self.soundID = [NSString stringWithFormat:@"%@",listTrack[playerCata.indexPathRow]];
                [play playStart:self.soundID];
            }else{
                
                self.soundID = [NSString stringWithFormat:@"%@",listTrack[playerCata.indexPathRow]];
                [play playStart:self.soundID];
            }
            
        }
        else if (event.subtype == UIEventSubtypeRemoteControlNextTrack)
        {
            playerCata = [Player defaultCatalog];
            playerCata.indexPathRow++;
            if(playerCata.indexPathRow > listTrack.count-1){
                playerCata.indexPathRow = 0;
                self.soundID= [NSString stringWithFormat:@"%@",listTrack[playerCata.indexPathRow]];
                [play playStart:self.soundID];
            }
            else{
                self.soundID = [NSString stringWithFormat:@"%@",listTrack[playerCata.indexPathRow]];
                [play playStart:self.soundID];
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

-(void)viewDidDisappear:(BOOL)animated{

}

-(void)viewWillAppear:(BOOL)animated
{
    _playlist = [PlayListDB sharedPlaylist];
    [_playlist fetchMovies];
    listTrack = [_playlist data];

    [self.tableView reloadData];
    
    
    play = [PlaylistCatagory defaultCatalog];
    self.tabBarController.tabBar.hidden=NO;
    self.navigationController.toolbar.hidden = NO;
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(dismissVC)];
	// Do any additional setup after loading the view.

    play = [PlaylistCatagory defaultCatalog];
    playerCata = [Player defaultCatalog];
    
    
    
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
