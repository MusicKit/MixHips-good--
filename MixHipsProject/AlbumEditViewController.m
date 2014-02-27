
//
//  AlbumEditViewController.m
//  MixHipsProject
//
//  Created by SDT-1 on 2014. 2. 5..
//  Copyright (c) 2014년 SDT-1. All rights reserved.
//

#import "AlbumEditViewController.h"
#import "AlbumList.h"
#import "MyAlbumCell.h"
#import "Catalog.h"
#import "AFHTTPRequestOperationManager.h"
#import "EdicCell.h"
#import "EditCatagory.h"
#import "MyPageViewController.h"
#import "EditDelegate.h"
#import "PlayListViewController.h"
#import "alphaViewController.h"
#import "MyIDCatagory.h"

@interface AlbumEditViewController ()<UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate,UINavigationControllerDelegate, EditDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *alertV;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *albumImg;
@property (weak, nonatomic) IBOutlet UIControl *hideView;
@property (weak, nonatomic) IBOutlet UIButton *albumNameEdit;
@property (weak, nonatomic) IBOutlet UILabel *albumNameLable;
@property (strong, nonatomic)UIProgressView *progressBar;

@property (weak, nonatomic) IBOutlet UIView *netView;
@property (weak, nonatomic) IBOutlet UIButton *renetButton;
@property (weak, nonatomic) IBOutlet UILabel *progressValue;



@end

@implementation AlbumEditViewController{
    MyIDCatagory *myIdCatagory;
    NSString *myid;
    NSMutableArray *listdata;
    EdicCell *editCell;
    NSInteger numCell;
    EditCatagory *editCatagory;
    NSMutableArray *soundNameArr;
    NSMutableArray *fileNameArr;
    NSString *soundName;
    NSString *fileName;
    UITextField *searchField;
    NSString *albumName;
    UIAlertView *alert3;
    UIAlertView *alert1;
    NSMutableArray *mpArr;
    NSData *data11;
    UIAlertView *alert4;
}

-(IBAction)listJoin:(id)sender{
    PlayListViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"playlist"];
    [self.navigationController pushViewController:nextVC animated:YES];
}

-(IBAction)albumNameEdit:(id)sender{
    alert3 = [[UIAlertView alloc]initWithTitle:@"앨범명" message:@"두 글자이상 입력하세요" delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"입력", nil];
    alert3.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert3 show];
}

-(IBAction)restartNet:(id)sender{
    [self AFNetworkingUploadAlbum];
    self.netView.hidden = YES;
}

-(BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView{
    if(alertView == alert3){
        searchField = [alert3 textFieldAtIndex:0];
        return ([searchField.text length] > 1);
    }
    return YES;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(alertView == alert3){
        if(alert3.cancelButtonIndex == buttonIndex){
            self.hideView.hidden = YES;

        }
        else if(alert3.firstOtherButtonIndex == buttonIndex){
            searchField = [alert3 textFieldAtIndex:0];
                       searchField.placeholder = [NSString stringWithFormat:@"2글자 이상입력해주세요."];
                self.albumNameLable.text = searchField.text;
            self.hideView.hidden = YES;
                albumName = [NSString stringWithFormat:@"%@",searchField.text];

        }
    }
    else if(alertView == alert4){
        if(alert4.cancelButtonIndex == buttonIndex)
        {
            
        }
        else if(alert4.firstOtherButtonIndex == buttonIndex){
           

            [self AFNetworkingUploadAlbum];
        }
    }
    else if(alertView == alert1){
        
    }
}

-(void)dismissVC{
    [self.navigationController popViewControllerAnimated:YES];
}


//사진편집 버튼
-(IBAction)getProfileImage:(id)sender{
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"취소" destructiveButtonTitle:nil otherButtonTitles:@"사진촬영",@"앨범에서 사진 선택", nil];
    [sheet showInView:[self.view window]];
}

-(void)dismissView{
    
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFade;
    animation.duration = 0.5;
    self.alertV.hidden = YES;
    [self.alertV.layer addAnimation:animation forKey:Nil];
    [UIView beginAnimations:nil context:NULL];
    [UIView commitAnimations];
}

-(IBAction)albumUploadButton:(id)sender{
 
    if(mpArr.count < 2) {
        self.alertV.hidden = NO;
        CATransition *animation = [CATransition animation];
        animation.type = kCATransitionFade;
        animation.duration = 0.5;
        UILabel *alertLB = [[UILabel alloc]initWithFrame:CGRectMake(8 , 17, 212, 26)];
               alertLB.text = @"2곡 이상 등록해 주세요.";
        
        [alertLB setFont:[UIFont fontWithName:@"system - system" size:17]];
        [alertLB setBackgroundColor:[UIColor clearColor]];
        [alertLB setTextColor:[UIColor blackColor]];
        [alertLB setTextAlignment:NSTextAlignmentCenter];
        
        [self.alertV addSubview:alertLB];
        [self.alertV.layer addAnimation:animation forKey:Nil];
        [UIView beginAnimations:nil context:NULL];
        [UIView commitAnimations];
        [self performSelector:@selector(dismissView) withObject:self.alertV afterDelay:1.0];
    }
    else if(self.albumImg.image == NULL){
        self.alertV.hidden = NO;
        CATransition *animation = [CATransition animation];
        animation.type = kCATransitionFade;
        animation.duration = 0.5;
        UILabel *alertLB = [[UILabel alloc]initWithFrame:CGRectMake(8 , 17, 212, 26)];
        alertLB.text = @"앨범 이미지를 등록해 주세요.";
        
        [alertLB setFont:[UIFont fontWithName:@"system - system" size:17]];
        [alertLB setBackgroundColor:[UIColor clearColor]];
        [alertLB setTextColor:[UIColor redColor]];
        [alertLB setTextAlignment:NSTextAlignmentCenter];
        
        [self.alertV addSubview:alertLB];
        [self.alertV.layer addAnimation:animation forKey:Nil];
        [UIView beginAnimations:nil context:NULL];
        [UIView commitAnimations];
        [self performSelector:@selector(dismissView) withObject:self.alertV afterDelay:1.0];
        
    }
    else if([self.albumNameLable.text isEqualToString:@""]){
        self.alertV.hidden = NO;
        CATransition *animation = [CATransition animation];
        animation.type = kCATransitionFade;
        animation.duration = 0.5;
        UILabel *alertLB = [[UILabel alloc]initWithFrame:CGRectMake(8 , 17, 212, 26)];
        alertLB.text = @"앨범명을 입력해 주세요";
        
        [alertLB setFont:[UIFont fontWithName:@"system - system" size:17]];
        [alertLB setBackgroundColor:[UIColor clearColor]];
        [alertLB setTextColor:[UIColor redColor]];
        [alertLB setTextAlignment:NSTextAlignmentCenter];
        
        [self.alertV addSubview:alertLB];
        [self.alertV.layer addAnimation:animation forKey:Nil];
        [UIView beginAnimations:nil context:NULL];
        [UIView commitAnimations];
        [self performSelector:@selector(dismissView) withObject:self.alertV afterDelay:1.0];
    }
    else if(mpArr.count >10){
        self.alertV.hidden = NO;
        CATransition *animation = [CATransition animation];
        animation.type = kCATransitionFade;
        animation.duration = 0.5;
        UILabel *alertLB = [[UILabel alloc]initWithFrame:CGRectMake(8 , 17, 212, 26)];
        alertLB.text = @"10곡 이상은 등록할 수 없습니다.";
        
        [alertLB setFont:[UIFont fontWithName:@"system - system" size:17]];
        [alertLB setBackgroundColor:[UIColor clearColor]];
        [alertLB setTextColor:[UIColor redColor]];
        [alertLB setTextAlignment:NSTextAlignmentCenter];
        
        [self.alertV addSubview:alertLB];
        [self.alertV.layer addAnimation:animation forKey:Nil];
        [UIView beginAnimations:nil context:NULL];
        [UIView commitAnimations];
        [self performSelector:@selector(dismissView) withObject:self.alertV afterDelay:1.0];
    }
    else{
        
        soundName = [[EditCatagory defaultCatalog] returnSoundName];
        
               soundNameArr = [[EditCatagory defaultCatalog]getArrTest];
                mpArr = [[EditCatagory defaultCatalog] getMpArr];
        alert4 = [[UIAlertView alloc]initWithTitle:@"MixHips" message:@"Wifi를 이용하지 않으면 별도의 데이터 통화료가 발생할 수 있습니다. 업로드 하시겠습니까?" delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
        alert4.alertViewStyle = UIAlertViewStyleDefault;
        
        [alert4 show];
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
            UIAlertView *alert2 = [[UIAlertView alloc]initWithTitle:@"오류" message:@"카메라가 지원되지 않는 기종입니다." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles: nil];
            [alert2 show];
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



//바뀐 사진을 선택했을시 프로필 사진이 바뀐다.
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    //편집된 이미지가 있으면 사용, 없으면 원본으로 사용
    UIImage *usingImage = (nil == editedImage)? originalImage : editedImage;
    self.albumImg.image = usingImage;
    //피커 감추기
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)deleteMusic:(NSInteger)indexPathRow{
    [soundNameArr removeObjectAtIndex:indexPathRow];
     [mpArr removeObjectAtIndex:indexPathRow];
    [fileNameArr removeObjectAtIndex:indexPathRow];
    [self.tableView reloadData];
}


//uploadAlbum
-(void)AFNetworkingUploadAlbum{
    

    alphaViewController *alphaVC = [[alphaViewController alloc]init];
    [self.navigationController presentViewController:alphaVC animated:YES completion:nil];
    [alphaVC startIndicator];

    NSString *ff = [NSString stringWithFormat:@"%d",arc4random()];
    NSString *d = [NSString stringWithFormat:@"%@",albumName];
    NSString *i = [NSString stringWithFormat:@"%@",myid]; ///   본인 아이디
    NSString *x = [NSString stringWithFormat:@"%d",soundNameArr.count];
    
    
    NSData *imageData = UIImageJPEGRepresentation(self.albumImg.image, 0.5);
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
   
    
    NSDictionary *parameters = @{@"foo":@"bar", @"user_id":i, @"album_name":d, @"sounds_name":soundNameArr, @"sound_count":x };
    AFHTTPRequestOperation *operation =
   [manager POST: @"http://mixhips.nowanser.cloulu.com/upload_album" parameters:parameters
constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    [formData appendPartWithFileData:imageData name:@"album_img" fileName:ff mimeType:@"image/jpeg"];
    for (int i=0; i<[mpArr count]; i++) {
        [formData appendPartWithFileData:mpArr[i] name:[NSString stringWithFormat:@"sounds_file[%d]",i] fileName:[NSString stringWithFormat:@"mixhips_%d.mp3",arc4random()] mimeType:@"audio/mp3"];
    }
    
}
success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    [alphaVC stopIndicator];
     [[EditCatagory defaultCatalog]initialize];
    [alphaVC dismissViewControllerAnimated:NO completion:nil];

    [self.navigationController popViewControllerAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);

        [alphaVC stopIndicator];
        [alphaVC dismissViewControllerAnimated:NO completion:nil];
        self.netView.hidden = NO;
        
    }];
    [operation setUploadProgressBlock:^(NSUInteger __unused bytesWritten,
                                        long long totalBytesWritten,
                                        long long totalBytesExpectedToWrite) {
        [alphaVC statusLabel:[NSString stringWithFormat:@"%.f 퍼센트",(float)totalBytesWritten/(float)totalBytesExpectedToWrite*100]];

    }];
    
    [operation start];

    
}

-(void)keyboardWillHide:(NSNotification *)noti{
    
    self.view.center = CGPointMake(self.view.center.x, self.view.center.y +122);
    self.hideView.hidden = NO;
}


-(void)keyboardWillShow:(NSNotification *)noti{
    self.view.center = CGPointMake(self.view.center.x, self.view.center.y - 122);
    self.hideView.hidden = NO;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == soundNameArr.count){
        
    }
    else{
    }
}




-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(UITableViewCellEditingStyleDelete == editingStyle){
        [soundNameArr removeObjectAtIndex:indexPath.row];
        [mpArr removeObjectAtIndex:indexPath.row];
    }

    [self.tableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return soundNameArr.count+1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EdicCell *cell;
    
    if(indexPath.row == soundNameArr.count){
        cell = [tableView dequeueReusableCellWithIdentifier:@"add_cell" forIndexPath:indexPath];
    }
    else{
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"list_cell" forIndexPath:indexPath];
        cell.delegate = self;
        [cell setInfo:soundNameArr[indexPath.row] indexPath:indexPath.row fileName:fileNameArr[indexPath.row]];

    }
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

-(void)viewDidAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:Nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    //감시자 삭제
    [[NSNotificationCenter defaultCenter] removeObserver:self];
   
}

-(void)viewWillAppear:(BOOL)animated{
    self.netView.hidden =YES;
    
    myIdCatagory = [MyIDCatagory defaultCatalog];
    myid = [myIdCatagory getMyid];

    mpArr = [[EditCatagory defaultCatalog] getMpArr];
    soundNameArr = [[EditCatagory defaultCatalog] getArrTest];
    fileNameArr = [[EditCatagory defaultCatalog] getFileName];
    [self.tableView reloadData];
     self.hideView.hidden = YES;
    
    self.soundArr = [[NSMutableArray alloc]init];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    searchField = [[UITextField alloc] init];
    
    
    numCell = 0;
    self.alertV.hidden = YES;
    CALayer * l = [self.alertV layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:6.0];
    
    self.netView.hidden = YES;
    CALayer * f = [self.netView layer];
    [f setMasksToBounds:YES];
    [f setCornerRadius:6.0];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(dismissVC)];

    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
