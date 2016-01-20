//
//  ZBShareMenuView.m
//  MessageDisplay
//
//  Created by zhoubin@moshi on 14-5-13.
//  Copyright (c) 2014年 Crius_ZB. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "MessagePhotoView.h"
#import "ZYQAssetPickerController.h"
// 每行有4个
#define kZBMessageShareMenuPerRowItemCount 4
#define kZBMessageShareMenuPerColum 2

#define kZBShareMenuItemIconSize 60
#define KZBShareMenuItemHeight 80

#define MaxItemCount 3
#define ItemWidth 94
#define ItemHeight 94


@interface MessagePhotoView (){
    UILabel *lblNum;
}


/**
 *  这是背景滚动视图
 */
@property(nonatomic,strong) UIScrollView *photoScrollView;
@property (nonatomic, weak) UIScrollView *shareMenuScrollView;
@property (nonatomic, weak) UIPageControl *shareMenuPageControl;
@property(nonatomic,weak)UIButton *btnviewphoto;
@end

@implementation MessagePhotoView
@synthesize photoMenuItems;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{

    if (self=[super initWithCoder:aDecoder]) {
        
        [self setup];
    }

    return self;

}





- (void)photoItemButtonClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didSelecteShareMenuItem:atIndex:)]) {
        NSInteger index = sender.tag;
        NSLog(@"self.photoMenuItems.count is %d",self.photoMenuItems.count);
        if (index < self.photoMenuItems.count) {
            [self.delegate didSelectePhotoMenuItem:[self.photoMenuItems objectAtIndex:index] atIndex:index];
        }
    }
}

- (void)setup{
   
   // self.backgroundColor = [UIColor colorWithRed:248.0f/255 green:248.0f/255 blue:255.0f/255 alpha:1.0];
    
   
    _photoScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 124)];
    _photoScrollView.contentSize = CGSizeMake(1024, 0);
    _photoScrollView.backgroundColor=[UIColor whiteColor];
   
    
    
    photoMenuItems = [[NSMutableArray alloc]init];
    _itemArray = [[NSMutableArray alloc]init];
    [self addSubview:_photoScrollView];
    lblNum = [[UILabel alloc]initWithFrame:CGRectMake(50, 130, 230, 30)];
   
    [self addSubview:lblNum];
    
    [self initlizerScrollView:self.photoMenuItems];
    
    
    
    
    
    

}

-(void)reloadDataWithImage:(UIImage *)image{
    
    
   
    
    [self.photoMenuItems addObject:image];
    
    [self initlizerScrollView:self.photoMenuItems];
}

-(void)initlizerScrollView:(NSArray *)imgList{
    [self.photoScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for(int i=0;i<imgList.count;i++){
        
        ALAsset *asset=imgList[i];
        
        UIImage *tempImg;
        
        if ([asset isKindOfClass:[UIImage class]]) {
            tempImg=(UIImage *)asset;
        } else
        {
             tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
             
        }
        
        
        
      //  UIImage *image = [imgList objectAtIndex:i];
        
        MessagePhotoMenuItem *photoItem = [[MessagePhotoMenuItem alloc]initWithFrame:CGRectMake(10+ i * (ItemWidth + 5 ), 20, ItemWidth, ItemHeight)];
        photoItem.delegate = self;
        photoItem.index = i;
        photoItem.contentImage = tempImg;
        [self.photoScrollView addSubview:photoItem];
        [self.itemArray addObject:photoItem];
    }
    if(imgList.count<MaxItemCount){
        UIButton *btnphoto=[UIButton buttonWithType:UIButtonTypeCustom];
        [btnphoto setFrame:CGRectMake(20 + (ItemWidth + 5) * imgList.count, 20, 84, 84)];//
        [btnphoto setImage:[UIImage imageNamed:@"addImage.png"] forState:UIControlStateNormal];
        [btnphoto setImage:[UIImage imageNamed:@"addImage.png"] forState:UIControlStateSelected];
        //给添加按钮加点击事件
        [btnphoto addTarget:self action:@selector(openMenu) forControlEvents:UIControlEventTouchUpInside];
        [self.photoScrollView addSubview:btnphoto];
    }
    
    NSInteger count = MIN(imgList.count +1, MaxItemCount);
     lblNum.text = [NSString stringWithFormat:@"已选%d张，共可选%d张",self.photoMenuItems.count,MaxItemCount];
    lblNum.backgroundColor = [UIColor clearColor];
    [self.photoScrollView setContentSize:CGSizeMake(20 + (ItemWidth + 5)*count, 0)];
    
   // [self.photoScrollView setContentSize:CGSizeMake(1024, 0)];
}
-(void)openMenu{
    //在这里呼出下方菜单按钮项
    myActionSheet = [[UIActionSheet alloc]
                     initWithTitle:nil
                     delegate:self
                     cancelButtonTitle:@"取消"
                     destructiveButtonTitle:nil
                     otherButtonTitles:@"打开照相机",@"从手机相册获取", nil];
    //刚才少写了这一句
    [myActionSheet showInView:self.window];
    
    
}
//下拉菜单的点击响应事件
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == myActionSheet.cancelButtonIndex){
        NSLog(@"取消");
    }
    switch (buttonIndex) {
        case 0:
            [self takePhoto];
            break;
        case 1:
            [self localPhoto];
            break;
        default:
            break;
    }
}

//开始拍照
-(void)takePhoto{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self.delegate addUIImagePicker:picker];
    
        
    }else{
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}
/*
    新加的另外的方法
 */
////////////////////////////////////////////////////////////
//打开相册，可以多选
-(void)localPhoto{
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc]init];
    
    picker.maximumNumberOfSelection = 3;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups = NO;
    picker.delegate = self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject,NSDictionary *bindings){
        if ([[(ALAsset *)evaluatedObject valueForProperty:ALAssetPropertyType]isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset *)evaluatedObject valueForProperty:ALAssetPropertyDuration]doubleValue];
            return duration >= 5;
        }else{
            return  YES;
        }
    }];
    
    [self.delegate addPicker:picker];
}

#pragma  mark   -ZYQAssetPickerController Delegate

/*
 得到选中的图片
 */
#pragma mark - ZYQAssetPickerController Delegate

-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    
    [self.scrollview.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
   
    NSLog(@"self.itemArray is %d",self.photoMenuItems.count);
        NSLog(@"assets is %d",assets.count);
        //跳转到显示大图的页面
        ShowBigViewController *big = [[ShowBigViewController alloc]init];
      
        big.arrayOK = [NSMutableArray arrayWithArray:assets];
    
    if (self.photoMenuItems==nil) {
        self.photoMenuItems = [NSMutableArray arrayWithArray:assets];
    }else
    {
    
        
        
        for (int i=0; i<assets.count; i++) {
            
            
            
            if (self.photoMenuItems.count>=MaxItemCount) {
                
                
                break;
                
            }else
            {
            
                
                ALAsset *asset=[assets objectAtIndex:i];
                
                
                [self.photoMenuItems addObject:asset];

            
            
            }
            
            
           
            
        }
        
           }
    
    
    
    
    
    [self initlizerScrollView:self.photoMenuItems];
        NSLog(@"arraryOk is %d",big.arrayOK.count);
        [picker pushViewController:big animated:YES];
  
}
/////////////////////////////////////////////////////////





//选择某张照片之后
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    //关闭相册界面
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if([type isEqualToString:@"public.image"]){
        //先把图片转成NSData
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        [self reloadDataWithImage:image];
        
//        NSData *datas;
//        if(UIImagePNGRepresentation(image)==nil){
//            datas = UIImageJPEGRepresentation(image, 1.0);
//        }else{
//            datas = UIImagePNGRepresentation(image);
//        }
//        
//        //图片保存的路径
//        //这里将图片放在沙盒的documents文件夹中
//        NSString *DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
//        //文件管理器
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//        //把刚才图片转换的data对象拷贝至沙盒中,并保存为image.png
//        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
//        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:datas attributes:nil];
//        //得到选择后沙盒中图片的完整路径
//        filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,@"/image.png"];
//        
//        //创建一个选择后图片的图片放在scrollview中
//        
//        //加载scrollview中
        
    }
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    NSLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)reloadData {
    
}
- (void)dealloc {
    //self.shareMenuItems = nil;
    self.photoScrollView.delegate = self;
    self.shareMenuScrollView.delegate = self;
    self.shareMenuScrollView = nil;
    self.shareMenuPageControl = nil;
}

#pragma mark - MessagePhotoItemDelegate

-(void)messagePhotoItemView:(MessagePhotoMenuItem *)messagePhotoItemView didSelectDeleteButtonAtIndex:(NSInteger)index{
    [self.photoMenuItems removeObjectAtIndex:index];
    [self initlizerScrollView:self.photoMenuItems];
}

#pragma mark - UIScrollView delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //每页宽度
    CGFloat pageWidth = scrollView.frame.size.width;
    //根据当前的坐标与页宽计算当前页码
    NSInteger currentPage = floor((scrollView.contentOffset.x - pageWidth/2)/pageWidth)+1;
    [self.shareMenuPageControl setCurrentPage:currentPage];
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
