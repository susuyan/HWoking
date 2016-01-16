//
//  EZScanPhotoVC.m
//  KECallsAttribution
//
//  Created by 赵 进喜 on 15/7/6.
//  Copyright (c) 2015年 K.BLOCK. All rights reserved.
//

#import "EZScanPhotoVC.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import "EZPhotoObject.h"

#import "checkImage.h"
#import "MBProgressHUD.h"
#import "EZSimilarViewController.h"
#import <Photos/Photos.h>


#import "EZAppHelper.h"

#import "UIView+FastAnimation.h"
@interface EZScanPhotoVC ()
{
    
    
    MBProgressHUD *mLoading;
    
}
@property(strong,nonatomic)PHCachingImageManager *imageManager;
@end

@implementation EZScanPhotoVC
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //   float  similar=  AIImageMeanAbsoluteError([UIImage imageNamed:@"test1"], [UIImage imageNamed:@"test2"]);
    
    //  [self getImgs];
    
    
    
    //[self compareAllImages:nil];
    
    
    allPhotos=[NSMutableArray arrayWithCapacity:10];
    
    
    allSreenShots=[NSMutableArray arrayWithCapacity:10];
    
    
    
    allImages =[NSMutableArray arrayWithCapacity:10];
    
    
    self.imageManager = [[PHCachingImageManager alloc]init];
    
    

    
    
    
    
    
    [self getImgs];
    
    
    
    
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)compare:(UIButton *)sender {
    
    //
    //    AIImage *image1=[AIImage imageNamed:@"test1.jpg"];
    //    AIImage *image2=[AIImage imageNamed:@"test5.jpg"];
    //
    //    float  similar= AIImageMeanAbsoluteError(image1, image2);
    //
    //
    //    NSLog(@"%f",similar);
    
    
    
    
    
    
    
    
    
}

- (IBAction)skipToCleanPage:(UIButton *)sender {
    
    
    EZSimilarViewController *similar=[self.storyboard instantiateViewControllerWithIdentifier:@"similar"];
    
    // similar.allSimilarImages=[EZAppHelper shareAppHelper].allSimilarPhotos;
    
    [self.navigationController pushViewController:similar animated:YES];
    
    
}

- (IBAction)backToLast:(UIButton *)sender {
    
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}



-(void)getImgs{
    
    
    
    
    
    
    
    //    mLoading.detailsLabelText=[NSString stringWithFormat:@"%d张",0];
    
    
    
    
    
    
    
    [allSreenShots removeAllObjects];
    
    
    [allPhotos removeAllObjects];
    
    [allImages removeAllObjects];
    
    
    
    
    
    
    
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    PHFetchResult *result=[PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:options];
    
    
    
    
    CGSize thumSize =CGSizeMake(90, 90);
    
    
    
    PHImageRequestOptions *requestoptions = [[PHImageRequestOptions alloc] init];
    requestoptions.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
    requestoptions.synchronous = YES;
    //        requestoptions.networkAccessAllowed = YES;
    requestoptions.resizeMode=PHImageRequestOptionsResizeModeExact;
    
    
    //    [self.imageManager startCachingImagesForAssets:(NSArray *)result
    //                                        targetSize:thumSize
    //                                       contentMode:PHImageContentModeAspectFill
    //                                           options:requestoptions];
    //
    
    
    mLoading=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    mLoading.labelText=@"正在扫描相册照片";
    
    
    
    
    
    
    
    
    
    
    
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
    
    
        [result enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL *stop) {
            
            
            
            EZPhotoObject *photo=[[EZPhotoObject alloc]init];
            
            
            
            //        options.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
            //            NSLog(@"%f", progress);
            //        };
            
            
            [[PHImageManager defaultManager] requestImageForAsset:asset
                                                       targetSize:thumSize
                                                      contentMode:PHImageContentModeAspectFill
                                                          options:requestoptions
                                                    resultHandler:^(UIImage *result, NSDictionary *info) {
                                                        
                                                        // Only update the thumbnail if the cell tag hasn't changed. Otherwise, the cell has been re-used.
                                                        
                                                        photo.thumbImage=result;
                                                        
                                                        
                                                        
                                                        
                                                        
                                                        
                                                    }];
            
            
            
            
            
            
            
            
            
            //   NSLog(@"%@",photo.identify);
            
            
            //添加指纹
            
            
            
            UIImage *i=[checkImage imageToSize:photo.thumbImage toSize:CGSizeMake(8.0, 8.0)];
            uint8_t *imageData=[checkImage convertTo64GreyImage:i];
            uint8_t avg=[checkImage avgGreyPixel:imageData];
            NSMutableArray *s=[checkImage compareGreyPixelToAvgPixel:imageData avg:avg];
            NSMutableString *hash=[checkImage compareWithGroup:s];
            
            
            
            photo.identify=hash;
            
            
            
            
            
            photo.asset=asset;
            
            
            [allPhotos addObject:photo];
            
            
            
            
//            if (idx==result.count-1) {
//                
//                
//                
//                [self compareAllImages:allPhotos];
//                
//                
//                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                
//                
//            }
            
            
            
            
            
            [self updateProgress];
            
            
            
        }];
        
        

    
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
        
        
            mLoading.labelText=@"正在匹配相似照片";

        
        
            
            
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            
            
            
             [self compareAllImages:allPhotos];
            
            
                dispatch_async(dispatch_get_main_queue(), ^{
                
                
                
                
                
                  [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    
                    
                    
                    
                    [self ScanDidFinish];
                
                
                
                });
            
            
            
            });
            
            
        
           
            
            
          

        
        
        
        
        
        
        });
    
    
    
    
    });
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //    ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *myerror){
    //        NSLog(@"相册访问失败 =%@", [myerror localizedDescription]);
    //        if ([myerror.localizedDescription rangeOfString:@"Global denied access"].location!=NSNotFound) {
    //            NSLog(@"无法访问相册.请在'设置->定位服务'设置为打开状态.");
    //        }else{
    //            NSLog(@"相册访问失败.");
    //        }
    //    };
    //
    //
    //
    //
    //
    //   // ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc]init];//生成整个photolibrary句柄的实例
    //
    //    ALAssetsLibrary *assetsLibrary =[ViewController  defaultAssetsLibrary];
    //   // NSMutableArray *mediaArray = [[NSMutableArray alloc]init];//存放media的数组
    //    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {//获取所有group
    //        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {//从group里面
    //
    //
    //
    //
    //            NSString* assetType = [result valueForProperty:ALAssetPropertyType];
    //            if ([assetType isEqualToString:ALAssetTypePhoto]) {
    //
    //               // NSLog(@"photo");
    //
    //
    //
    //                EZPhotoObject *photo=[[EZPhotoObject alloc]init];
    //
    //
    //
    //                photo.url=[result.defaultRepresentation.url absoluteString];
    //
    //
    //                photo.thumbImage=[UIImage imageWithCGImage:result.thumbnail];
    //
    //
    //               // photo.bigImage=[UIImage imageWithCGImage:result.defaultRepresentation.fullScreenImage];
    //
    //
    //                NSString *fileExt=[result.defaultRepresentation.filename componentsSeparatedByString:@"."][1];
    //
    //
    //
    //                photo.asset=result;
    //
    //
    //#warning 截图格式为png，照片格式为jpg
    //
    //
    //              //  NSLog(@"%@",fileExt);
    //
    //                if ([fileExt isEqualToString:@"JPG"]) {
    //
    //
    //                    //添加指纹
    //
    //
    //                    UIImage *i=[checkImage imageToSize:photo.thumbImage toSize:CGSizeMake(8.0, 8.0)];
    //                    uint8_t *imageData=[checkImage convertTo64GreyImage:i];
    //                    uint8_t avg=[checkImage avgGreyPixel:imageData];
    //                    NSMutableArray *s=[checkImage compareGreyPixelToAvgPixel:imageData avg:avg];
    //                    NSMutableString *hash=[checkImage compareWithGroup:s];
    //
    //
    //
    //                    photo.identify=hash;
    //
    //
    //               //     NSLog(@"%@",photo.identify);
    //
    //
    //
    //                    [allPhotos addObject:photo];
    //
    //
    //
    //
    //                }else
    //                {
    //
    //
    //
    //
    //
    //                    [allSreenShots addObject:photo];
    //
    //
    //
    //
    //                }
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //                [allImages addObject:photo];
    //
    //
    //
    //
    //
    //
    //
    ////
    ////                [self performSelectorOnMainThread:@selector(updateProgress) withObject:nil waitUntilDone:YES];
    ////
    //
    //
    //
    //
    //
    //
    //
    //            }
    //
    //
    //
    //
    //
    //
    //
    //
    //           }];
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //        if (group==nil) {
    //
    //
    //          //  NSLog(@"%@",allImages);
    //
    //
    //            //开始比较
    //
    //            [self compareAllImages:allPhotos];
    //
    //
    //            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    //
    //        }
    //
    //
    //
    //
    //    } failureBlock:failureblock];
    //
    //
    //
    
    
    
    
    
    
}




-(void)compareAllImages:(NSMutableArray *)allImageArray
{
    
    
    
    
    int numCount=(int)allImageArray.count;
    
    
    
    for (int i=0; i<numCount; i++) {
        
        
        mLoading.detailsLabelText=[NSString stringWithFormat:@"%d/%d",i+1,allPhotos.count];
        
        EZPhotoObject *photo1=allImageArray[i];
        
        //  UIImage *image1=photo1.thumbImage;
        
        NSString *image1=photo1.identify;
        
        
        for (int j=i+1; j<numCount; j++) {
            
            
            
            
            
            
            EZPhotoObject *photo2=allImageArray[j];
            
            //UIImage *image2=photo2.thumbImage;
            
            //NSLog(@"%d___%d____%@____%@",i,j,photo1.identify,photo2.identify);
            
            NSString *image2=photo2.identify;
            
            BOOL isSimilar;
            
            
            
            if (photo1.catid==nil) {
                
                
                isSimilar =[checkImage compareTwoImageFinger:[image1 mutableCopy] current:[image2 mutableCopy]];
                
                
                if (isSimilar) {
                    
                    //首次遇到相似
                    
                    
                    
                    if (photo2.catid==nil) {
                        
                        
                        photo1.catid=[NSString stringWithFormat:@"identify_%d",i];
                        
                        photo2.catid=[NSString stringWithFormat:@"identify_%d",i];
                        
                        
                        
                        allImageArray[i]=photo1;
                        
                        
                        allImageArray[j]=photo2;
                        
                        // continue;
                        
                    }else
                    {
                        
                        
                        photo1.catid=photo2.catid;
                        
                        
                        
                        allImageArray[i]=photo1;
                        
                        
                        
                        //   continue;
                        
                        
                    }
                    
                    
                    
                    
                    
                    
                    //                     NSLog(@"%d___%d____%@____%@",i,j,photo1.identify,photo2.identify);
                    
                    
                    
                    
                    
                    
                }else
                {
                    
                    
                    
                    //  continue;
                    
                }
                
                
                
                
                
            }else
            {
                
                
                
                
                if (photo2.catid==nil) {
                    
                    isSimilar =[checkImage compareTwoImageFinger:[image1 mutableCopy]  current:[image2 mutableCopy]];
                    
                    
                    
                    if (isSimilar) {
                        
                        
                        
                        
                        
                        
                        
                        
                        photo2.catid=photo1.identify;
                        
                        
                        allImageArray[j]=photo2;
                        
                        
                        //  continue;
                        
                        // NSLog(@"%d___%d____%@____%@",i,j,photo1.identify,photo2.identify);
                        
                        
                    }else
                    {
                        
                        
                        // continue;
                        
                        
                    }
                    
                    
                    
                    
                    
                    
                }else
                {
                    
                    
                    //什么也不用操作
                    
                    //  continue;
                    
                }
                
                
                
                
            }
            
            
            //测试，过滤catid为空的
            
            
            
            if (photo1.catid!=nil) {
                if (![allPhotos containsObject:photo1]) {
                    [allPhotos addObject:photo1];
                }
            }
            
            
            if (photo2.catid!=nil) {
                if (![allPhotos containsObject:photo2]) {
                    [allPhotos addObject:photo2];
                }
            }
            
            
            
            
            
            
            
            
            
            
        }
        
        
        
        
        
        
        
        
        
        
    }
    
    
    
    // allPhotos=allImageArray;
    [EZAppHelper shareAppHelper].allSimilarPhotos=allPhotos;
    
}

//-(BOOL)isTwoImageSimilar:(UIImage *)image1 With:(UIImage *)image2
//{
//
//    float  similar= AIImageMeanAbsoluteError(image1, image2);
//    
//    //NSLog(@"%f",similar);
//    if (similar<0.01f) {
//        
//        
//        return YES;
//
//        
//    }
//
//
//    return NO;
//}


-(void)updateProgress
{
    
    
    
    
    mLoading.detailsLabelText=[NSString stringWithFormat:@"%d张",allSreenShots.count+allPhotos.count];
    
    
    
    
}


+ (ALAssetsLibrary *)defaultAssetsLibrary {
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}





//+ (NSString *)typeForImageData:(NSData *)data {
//    
//    
//    uint8_t c;
//    
//    [data getBytes:&c length:1];
//    
//    
//    
//    switch (c) {
//            
//        case 0xFF:
//            
//            return @"image/jpeg";
//            
//        case 0x89:
//            
//            return @"image/png";
//            
//        case 0x47:
//            
//            return @"image/gif";
//            
//        case 0x49:
//            
//        case 0x4D:
//            
//            return @"image/tiff";
//            
//    }
//    
//    return nil;
//    
//}
-(void)ScanDidFinish
{


    
    
    
        _cleanTips.hidden=NO;
        
        
        
        
        _cleanButton.hidden=NO;
    
    
    
        
    
    
    _cleanTips.animationType=@"BounceRight";
    
    
    _cleanTips.animationParams[@"velocity"]=@100;
    
    _cleanTips.delay=0.5f;
    
     [_cleanTips startFAAnimation];
    
    
    _cleanButton.animationType=@"BounceLeft";
    
    
    _cleanButton.animationParams[@"velocity"]=@-100;
    
    _cleanButton.delay=1.0f;
    
    [_cleanButton startFAAnimation];


}
@end
