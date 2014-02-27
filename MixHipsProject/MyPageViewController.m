//
//  MyPageViewController.m
//  MixHipsProject
//
//  Created by SDT-1 on 2014. 1. 16..
//  Copyright (c) 2014년 SDT-1. All rights reserved.
//

#import "MyPageViewController.h"
#import "AlbumCatalog.h"
#import "AlbumList.h"
#import "MyPageCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "AFHTTPRequestOperationManager.h"
#import "MyAlbumViewController.h"
#import "FollowViewController.h"
#import "PlaylistCatagory.h"
#import "MypageCatagory.h"
#import "PlayListViewController.h"
#import "Player.h"
#import "PlayListDB.h"
#import "MyIDCatagory.h"


@interface MyPageViewController ()<UIImagePickerControllerDelegate, UIActionSheetDelegate ,UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, playDelegate4>
@property (weak, nonatomic) IBOutlet UIImageView *profileImg;
@property (strong, nonatomic) UIButton *testButton;
@property (weak, nonatomic) IBOutlet UILabel *Message;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *FollowingCount;
@property (weak, nonatomic) IBOutlet UILabel *FollowerCount;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic ) UIProgressView *progressBar;
@property (strong, nonatomic) UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UILabel *Name;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIView *netView;
@property (weak, nonatomic) IBOutlet UIButton *renetButton;
@property (weak, nonatomic) IBOutlet UIView *editView;
@property (weak, nonatomic) IBOutlet UILabel *eidtLable;


@end

@implementation MyPageViewController{
    MyIDCatagory *myIdCatagory;
    NSString *myid;
    Player *playerCata;
    MypageCatagory *myCatagory;
    PlaylistCatagory *playCatagory;
    NSMutableArray *albumlist;
    NSString *follwer;
    NSString *following;
    NSString *userImg;
    NSString *userSay1;
    NSString *userID;
    NSString *userName;
    NSString *userName1;
    NSString *soundName1;
    NSMutableArray *albumID;
    UITextField *searchField;
    UIAlertView *alert;
    UIAlertView *alert1;
    NSString *album_id;
    NSArray *listTrack;
    NSString *soundid11;
    MyAlbumViewController *dest;
    BOOL editChange;
    BOOL ch;
}
-(IBAction)listJoin:(id)sender{
    PlayListViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"playlist"];
    [self.navigationController pushViewController:nextVC animated:YES];
}

-(IBAction)restartNet:(id)sender{
    [self AFNetworkingAD];
    self.netView.hidden = YES;
}

-(void)toggleButton:(id)sender{
    if(ch == YES){
        [playCatagory playStart:soundid11];
        [self.testButton setImage:[UIImage imageNamed:@"stop.png"] forState:UIControlStateNormal];
    }
    else{
        if(playCatagory.player.rate == 1.0){
            [playCatagory.player pause];
            [self.testButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        }
        else{
            [playCatagory.player play];
            [self.testButton setImage:[UIImage imageNamed:@"stop.png"] forState:UIControlStateNormal];
        }
        
    }
}


-(IBAction)getprofileMessage:(id)sender{
    alert = [[UIAlertView alloc]initWithTitle:@"MixHips" message:@"한마디" delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"등록", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

-(IBAction)editBOOL:(id)sender{
    if(editChange == YES){
        editChange =NO;
        self.editView.hidden = NO;
        CATransition *animation = [CATransition animation];
        animation.type = kCATransitionFade;
        animation.duration = 0.5;
        [self.editView.layer addAnimation:animation forKey:Nil];
        [UIView beginAnimations:nil context:NULL];
        [UIView commitAnimations];

        
        self.eidtLable.text = [NSString stringWithFormat:@"편집모드"];
        self.deleteButton.selected = YES;
        [self performSelector:@selector(dismissView) withObject:self.editView afterDelay:1.0];
    }
    else if(editChange == NO){
        editChange =YES
        ;
        self.editView.hidden = NO;
        CATransition *animation = [CATransition animation];
        animation.type = kCATransitionFade;
        animation.duration = 0.5;
        [self.editView.layer addAnimation:animation forKey:Nil];
        [UIView beginAnimations:nil context:NULL];
        [UIView commitAnimations];
        

        self.eidtLable.text = [NSString stringWithFormat:@"편집모드 해제"];
        self.deleteButton.selected = NO;
        [self performSelector:@selector(dismissView) withObject:self.editView afterDelay:1.0];
    }
}

-(void)dismissView{
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFade;
    animation.duration = 0.5;
    self.editView.hidden = YES;
    [self.editView.layer addAnimation:animation forKey:Nil];
    [UIView beginAnimations:nil context:NULL];
    [UIView commitAnimations];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView == alert){
    if(alertView.cancelButtonIndex == buttonIndex){
    }
    else if(alertView.firstOtherButtonIndex == buttonIndex){
        searchField = [alertView textFieldAtIndex:0];
        self.Message.text = searchField.text;
        [self AFNetworkingADSay];
    }
    }
    else if(alertView == alert1)
    {
        if(alertView.cancelButtonIndex == buttonIndex){
        }
        else if(alertView.firstOtherButtonIndex == buttonIndex){
            [self AFNetworkingDeleteAlbum:album_id];
        }
    }
}

//액션버튼에서 사용자가 특정 버튼을 눌렀을 때 처리
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;

    if(buttonIndex == 0){
        if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            //에러 처리
            alert = [[UIAlertView alloc]initWithTitle:@"오류" message:@"카메라가 지원되지 않는 기종입니다." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles: nil];
            [alert show];
            return;
        }
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    else if(buttonIndex == 1){
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    else if(buttonIndex == actionSheet.cancelButtonIndex)
    {
       
    }
}


//사진편집 버튼
-(IBAction)getProfileImage:(id)sender{
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"취소" destructiveButtonTitle:nil otherButtonTitles:@"사진촬영",@"앨범에서 사진 선택", nil];
    [sheet showInView:[self.view window]];
}


//바뀐 사진을 선택했을시 프로필 사진이 바뀐다.
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *originalImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    //편집된 이미지가 있으면 사용, 없으면 원본으로 사용
    UIImage *usingImage = (nil == editedImage)? originalImage : editedImage;
    [self AFNetworkingUploadImg:usingImage];
    
    //피커 감추기
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)notiPlay{
    ch = NO;
}

//uploadImg
-(void)AFNetworkingUploadImg:(UIImage *)img{
    NSString *ff = [NSString stringWithFormat:@"%d.jpeg",arc4random()];
    NSString *i = [NSString stringWithFormat:@"%@",myid]; ///   본인 아이디
    NSData *imageData = UIImageJPEGRepresentation(img, 0.5);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"foo":@"bar", @"user_id":i};
    [manager POST: @"http://mixhips.nowanser.cloulu.com/upload_user_img" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
        [formData appendPartWithFileData:imageData name:@"user_img" fileName:ff mimeType:@"image/jpeg"];
    }success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [self AFNetworkingAD];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

//network deleteAlbum
-(void)AFNetworkingDeleteAlbum:(NSString *)albumid{
    NSString *i = [NSString stringWithFormat:@"%@",myid]; ///   본인 아이디
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"foo":@"bar", @"user_id":i , @"album_id":albumid};
    [manager POST: @"http://mixhips.nowanser.cloulu.com/delete_album" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [self AFNetworkingAD];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

//network say
-(void)AFNetworkingADSay{
    NSString *i = [NSString stringWithFormat:@"%@",myid]; ///   본인 아이디
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"foo":@"bar", @"user_id":i , @"user_say":searchField.text};
    [manager POST: @"http://mixhips.nowanser.cloulu.com/update_user_say" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"JSON: %@", responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)test:(NSDictionary *)dic {
    NSDictionary *dd = [NSDictionary dictionaryWithDictionary:dic];
    
    userID = [NSString stringWithFormat:@"%@",[dd objectForKey:@"user_id"]];
    userName = [NSString stringWithFormat:@"%@",[dd objectForKey:@"user_name"]];
    follwer = [NSString stringWithFormat:@"%@",[dd objectForKey:@"follower"]];
    following = [NSString stringWithFormat:@"%@", [dd objectForKey:@"following"]];
    userImg = [NSString stringWithFormat:@"%@", [dd objectForKey:@"user_img_url"]];
    userSay1 = [NSString stringWithFormat:@"%@",[dd objectForKey:@"user_say"]];

    NSArray *album = [[NSArray alloc]init];
    album = [dd objectForKey:@"albums"];
    NSString *string =  [NSString stringWithFormat:@"%@",[dd objectForKey:@"albums"]];
    if([string isEqualToString:@"<null>"])
    {
        if(albumlist.count == 1){
        [albumlist removeObjectAtIndex:0];
        }
    }
    else{
    albumID = [[NSMutableArray alloc]init];
    NSMutableArray *albumImg = [[NSMutableArray alloc]init];
    NSMutableArray *albumName = [[NSMutableArray alloc]init];
    NSMutableArray *like = [[NSMutableArray alloc]init];
    albumlist = [[NSMutableArray alloc]init];
    for(int i=0;i<album.count;i++)
    {
        [albumID addObject:[album[i] objectForKey:@"album_id"]];
        [albumImg addObject:[album[i] objectForKey:@"album_img_url"]];
        [albumName addObject:[album[i] objectForKey:@"album_name"]];
        [like addObject:[album[i] objectForKey:@"like_count"]];
        
        [albumlist addObject:[AlbumList hotArtistAlbumlist:albumID[i] album_img:albumImg[i] album_name:albumName[i] like:like[i]]];
    }
    
        
    
    }
    [self.collectionView reloadData];
}

-(void)AFNetworkingAD{
    [self.indicator startAnimating];
    
    NSString *d = [NSString stringWithFormat:@"%@",myid];
    NSString *i = [NSString stringWithFormat:@"%@",myid]; ///   본인 아이디
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"foo":@"bar", @"my_id":i , @"user_id":d};
    [manager POST: @"http://mixhips.nowanser.cloulu.com/request_user" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"JSON: %@", responseObject);
        [self test:responseObject];
        [self.indicator stopAnimating];
        [self setProfile];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.netView.hidden = NO;
        [self.indicator stopAnimating];
        NSLog(@"Error: %@", error);
    }];
}

-(void)setProfile{
    self.Message.text = userSay1;
    self.FollowerCount.text = [NSString stringWithFormat:@"%@",follwer];
    self.FollowingCount.text = [NSString stringWithFormat:@"%@",following];
    self.Name.text = userName;

    NSString *url = @"http://mixhips.nowanser.cloulu.com";
     url = [url stringByAppendingString:userImg];
    NSURL *userURL = [NSURL URLWithString:url];
    [self.profileImg setImageWithURL:userURL];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"following"]){
        FollowViewController *dest1 = (FollowViewController *)segue.destinationViewController;
        dest1.user_ID = userID;
    }
    if([segue.identifier isEqualToString:@"follower"]){
        
    }
}

// -------------- 콜렉션 뷰-----------------

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(editChange == NO){
        if(indexPath.row < albumlist.count){
            album_id = [NSString stringWithFormat:@"%@", albumID[indexPath.row]];
            alert1 = [[UIAlertView alloc]initWithTitle:@"MixHips" message:@"삭제하시겠습니까?" delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"삭제", nil];
            alert.alertViewStyle = UIAlertViewStyleDefault;
            [alert1 show];
        }
        else{
        }
    }
    else if(editChange == YES){
        if(indexPath.row < albumlist.count){
            
            [[MypageCatagory defaultCatalog] setAlbuId:albumID[indexPath.row]];
            MyAlbumViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MyAlbum"];
            [self.navigationController pushViewController:nextVC animated:YES];
        }
        else{
            
        }
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return albumlist.count+1;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	MyPageCollectionViewCell* cell;
    if (indexPath.row == albumlist.count) {
        cell= [collectionView dequeueReusableCellWithReuseIdentifier:@"add_cell" forIndexPath:indexPath];
    }
    else {
        
        cell= [collectionView dequeueReusableCellWithReuseIdentifier:@"albumlist_cell" forIndexPath:indexPath];
        self.list = [albumlist objectAtIndex:indexPath.row];
        
        [cell setAlbumInfo:self.list];
    }
	return cell;
}

-(void)updateProgressViewWithPlayer:(NSString *)string time:(float)time{
    self.progressBar.progress = time;
    self.progressBar.progress = [[PlaylistCatagory defaultCatalog] getTime];
    
    if(playCatagory.player.rate == 1.0){
        [self.testButton setImage:[UIImage imageNamed:@"stop.png"] forState:UIControlStateNormal];
    }
    else{
        [self.testButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    }
}

-(void)setUser:(NSString *)userNamef setSound:(NSString *)soundNamef{
    soundName1 = soundNamef;
    userName1 = userNamef;
    if(soundName1 == NULL){
        
    }
    else{
        [self.titleLabel setText:[NSString stringWithFormat:@"%@ - %@",soundName1, userName1]];
    }
}




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) loadData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *userName11 = [defaults objectForKey:@"userName"];
    NSString *soundName11 = [defaults objectForKey:@"soundName"];
    soundid11 = [defaults objectForKey:@"soundId"];

    [self.titleLabel setText:[NSString stringWithFormat:@"%@ - %@",soundName11, userName11]];
}


///////////////////////////////////////////////////////////////////////////
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
    editChange = YES;
    
    myIdCatagory = [MyIDCatagory defaultCatalog];
    myid = [myIdCatagory getMyid];
    
    PlayListDB *playDB = [PlayListDB sharedPlaylist];
    [playDB fetchMovies];
    listTrack  = [playDB data];
    
    self.deleteButton.selected = NO;
    self.editView.hidden = YES;
    CALayer * l = [self.editView layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:6.0];
    
    [self AFNetworkingAD];
    playCatagory = [PlaylistCatagory defaultCatalog];
    self.progressBar.progress = [playCatagory getTime];
    
    if(playCatagory.player.rate == 1.0){
        [self.testButton setImage:[UIImage imageNamed:@"stop.png"] forState:UIControlStateNormal];
    }
    else{
        [self.testButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    ch = YES;
    
    

    [self.collectionView reloadData];
    dest = [[MyAlbumViewController alloc]init];
    
    self.netView.hidden = YES;
    CALayer * l = [self.netView layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:6.0];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/Music"];
    playCatagory = [PlaylistCatagory defaultCatalog];
    playCatagory.delegate4 = self;
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(92 , 7, 200, 20)];
    [self.titleLabel setFont:[UIFont fontWithName:@"system - system" size:10]];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setTextColor:[UIColor blackColor]];
    [self.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [self.navigationController.toolbar addSubview:self.titleLabel];
     [self loadData];
    
	// Do any additional setup after loading the view.
    
    self.progressBar = [[UIProgressView alloc] initWithFrame:CGRectMake(93, 30, 200, 4)];
     [self.progressBar setTintColor:[UIColor blackColor]];
    [self.navigationController.toolbar addSubview:self.progressBar];
    
    self.testButton = [[UIButton alloc]initWithFrame:CGRectMake( 50,2,40 ,40)];
    [self.testButton addTarget:self action:@selector(toggleButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.testButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    
    //indicator
    self.indicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(135, 200, 50, 50)];
    self.indicator.hidesWhenStopped = YES;
    [self.view addSubview:self.indicator];

    
    
    
    [self.navigationController.toolbar addSubview:self.testButton];
    
	// Do any additional setup after loading the view.
    
    
	
	
	//[self updateData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
