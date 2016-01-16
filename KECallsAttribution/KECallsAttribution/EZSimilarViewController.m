//
//  EZSimilarViewController.m
//  TestImageCompare
//
//  Created by 赵 进喜 on 15/5/27.
//  Copyright (c) 2015年 everzones. All rights reserved.
//

#import "EZSimilarViewController.h"
#import "EZSimilarPhotoViewCell.h"
#import "EZPhotoObject.h"
#import "EZAppHelper.h"
#import <Photos/Photos.h>
#import "MBProgressHUD.h"
@interface EZSimilarViewController ()

@end


#define AllSimialrPhotos [EZAppHelper shareAppHelper].allSimilarPhotos




@implementation EZSimilarViewController
- (void)dealloc
{
    
    
    [[EZAppHelper shareAppHelper] removeObserver:self forKeyPath:@"selectedArray"];
    
    
//    [[EZAppHelper shareAppHelper].selectedArray removeAllObjects];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"EZSimilarPhotoViewCell" bundle:nil] forCellReuseIdentifier:@"similar"];
    
    self.tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    
    
    [self compareAllImages:AllSimialrPhotos];
    
    
    
    EZAppHelper *apphelper=[EZAppHelper shareAppHelper];
    
    [apphelper  addObserver:self forKeyPath:@"selectedArray" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionNew context:nil];
    
    [self.showCountButton setTitle:[NSString stringWithFormat:@"删除已选择%d张",[EZAppHelper shareAppHelper].selectedArray.count] forState:UIControlStateNormal];

    // Do any additional setup after loading the view.
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{

     [self.showCountButton setTitle:[NSString stringWithFormat:@"删除已选择%d张",[EZAppHelper shareAppHelper].selectedArray.count] forState:UIControlStateNormal];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//-(void)compareAllImages:(NSMutableArray *)allImages
//{
//    
//    
//    
//    NSMutableDictionary *onceDic=[[NSMutableDictionary alloc]initWithCapacity:10];//只存第一次循环到的
//    
//    NSMutableDictionary *moreDic=[[NSMutableDictionary alloc]initWithCapacity:10];
//    
//    
//    
//    
//    for (int i=0; i<allImages.count; i++) {
//        
//        
//        
//        
//        
//        EZPhotoObject *photo=allImages[i];
//        
//        
//        
//        
//        
//        if (![[onceDic allKeys] containsObject:photo.identify]) {
//            
//            
//            
//            
//            
//            NSMutableArray *array=[NSMutableArray arrayWithObject:photo];
//            
//            
//            [onceDic setObject:array forKey:photo.identify];
//            
//            
//        }else
//        {
//            
//            
//            
//            
//            
//            
//            if (![[moreDic allKeys] containsObject:photo.identify]) {
//                
//                
//                
//                
//                
//                
//                NSMutableArray *array=[NSMutableArray arrayWithObjects:onceDic[photo.identify][0],photo, nil];
//                
//                
//                [moreDic setObject:array forKey:photo.identify];
//                
//                
//                
//                
//                
//                
//                
//            }else
//            {
//                
//                
//                
//                NSMutableArray *array=[NSMutableArray arrayWithArray:moreDic[photo.identify]];
//                
//                
//                [array addObject:photo];
//                
//                
//                
//                
//                [moreDic setObject:array forKey:photo.identify];
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
//        }
//        
//        
//        
//        
//        
//        
//        
//        
//    }
//    
//    
//    
//    
//    
//    
//    
//    NSLog(@"%@",moreDic);
//    
//    self.allDics=moreDic;
//    
//    
//    
//    
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{


    EZSimilarPhotoViewCell *cell=[self.tableView dequeueReusableCellWithIdentifier:@"similar"];
    
    
    NSString *identify=[_allDics allKeys][indexPath.row];
    
    
    NSArray *array=_allDics[identify];
    
    
    [cell setInfo:array];
    
    return cell;



}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.allDics.allKeys.count;


}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    NSString *identify=[_allDics allKeys][indexPath.row];
    
    
    NSArray *array=_allDics[identify];

    int height=  [EZSimilarPhotoViewCell getHeightWithCount:array.count];

    return height;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


//测试
-(void)compareAllImages:(NSMutableArray *)allImages
{
    
    
    
    NSMutableDictionary *onceDic=[[NSMutableDictionary alloc]initWithCapacity:10];//只存第一次循环到的
    
    NSMutableDictionary *moreDic=[[NSMutableDictionary alloc]initWithCapacity:10];
    
    
    
    
    for (int i=0; i<allImages.count; i++) {
        
        
        
        
        
        EZPhotoObject *photo=allImages[i];
        
        
        
        if (photo.catid==nil) {
            continue;
        }
        
        
        
        if (![[onceDic allKeys] containsObject:photo.catid]) {
            
            
            
            
            
            NSMutableArray *array=[NSMutableArray arrayWithObject:photo];
            
            
            [onceDic setObject:array forKey:photo.catid];
            
            
        }else
        {
            
            
            
            
            
            
            if (![[moreDic allKeys] containsObject:photo.catid]) {
                
                
                
                
                
                
                NSMutableArray *array=[NSMutableArray arrayWithObjects:onceDic[photo.catid][0],photo, nil];
                
                
                [moreDic setObject:array forKey:photo.catid];
                
                
                
                
                
                
                
            }else
            {
                
                
                
                NSMutableArray *array=[NSMutableArray arrayWithArray:moreDic[photo.catid]];
                
                
                [array addObject:photo];
                
                
                
                
                [moreDic setObject:array forKey:photo.catid];
                
                
                
                
                
            }
            
            
            
            
            
            
            
            
        }
        
        
        
        
        
        
        
        
    }
    
    
    
    
    
    
    
    NSLog(@"%@",moreDic);
    
    self.allDics=moreDic;
    
    
    
    
}
#define  mark 智能选择
- (IBAction)autoSelect:(UIButton *)sender {
    
    
    isSmartSelect=!isSmartSelect;
    
    
    
    
    if (isSmartSelect) {
        
        
        
        [sender setTitle:@"取消已选" forState:UIControlStateNormal];
        
        
        [SelectedArray removeAllObjects];
        
        
        
        
        for (NSArray *array in [_allDics allValues]) {
            
            
            NSMutableArray *temp =[array mutableCopy];
            
            [temp removeObjectAtIndex:0];
            
            
            
            [SelectedArray addObjectsFromArray:temp];
            
            
            
            
            
            
        }
        
        
        [self.tableView reloadData];
        
        
    }else
    {
    
    
    
    
        [sender setTitle:@"智能选择" forState:UIControlStateNormal];
        
        
        [SelectedArray removeAllObjects];

        
        [self.tableView reloadData];
    
    
    }
    
    
    
    
    
    
}
- (IBAction)deleteSelectedImages:(UIButton *)sender {
    
    
    
    
    NSMutableArray *temps=[NSMutableArray array];
    
    
    
    for (int i=0; i<[EZAppHelper shareAppHelper].selectedArray.count; i++) {
        
        
        
        
        EZPhotoObject *photo=[EZAppHelper shareAppHelper].selectedArray[i];
        
        
        [temps addObject:photo.asset];
        
        
        
    }
    
    [[PHPhotoLibrary sharedPhotoLibrary]performChanges:^{
        
        
        [PHAssetChangeRequest deleteAssets:temps];
        
        
    } completionHandler:^(BOOL success, NSError *error) {
        
        
        if (success) {
            
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            
            
            
                [AllSimialrPhotos removeObjectsInArray:SelectedArray];
                
                
                [SelectedArray removeAllObjects];
                
                
                [self compareAllImages:AllSimialrPhotos];
                

                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                
                
                
                
                  [self.tableView reloadData];
                    
                    
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                    
                });
                
            
            });
            
            
            
            
            
            
          
            

            
        }
        
        
        
    }];

    
    
}

- (IBAction)backToLast:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}






@end
