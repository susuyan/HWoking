//
//  checkImage.h
//  PictureCheck
//
//  Created by 赵 锋 on 13-3-7.
//  Copyright (c) 2013年 赵 锋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface checkImage : NSObject

+(NSString *)imageSourcePath;

//1.将图片缩小到8x8的尺寸, 总共64个像素. 这一步的作用是去除各种图片尺寸和图片比例的差异, 只保留结构、明暗等基本信息.
+(UIImage *)imageToSize:(UIImage *)image toSize:(CGSize)size;

//2.将缩小后的图片, 转为64级灰度图片.
+(uint8_t *)convertTo64GreyImage:(UIImage *)image;

//3.计算图片中所有像素的灰度平均值

+(uint8_t)avgGreyPixel:(uint8_t *)data;

// 4.将每个像素的灰度与平均值进行比较, 如果大于或等于平均值记为1, 小于平均值记为0.

+(NSMutableArray *)compareGreyPixelToAvgPixel:(uint8_t *)imageData avg:(uint8_t)avgGrey;

//5.将上一步的比较结果, 组合在一起, 就构成了一个64位的二进制整数, 这就是这张图片的指纹.
+(NSMutableString *)compareWithGroup:(NSMutableArray *)arr;

//6.得到图片的指纹后, 就可以对比不同的图片的指纹, 计算出64位中有多少位是不一样的. 如果不相同的数据位数不超过5, 就说明两张图片很相似, 如果大于10, 说明它们是两张不同的图片.

+(int)compareToHamdDistance:(NSMutableString *)scoureImage current:(NSMutableString *)current;




//比较两张图片是否一样

+(BOOL)compareTwoImageFinger:(NSMutableString *)scoureImage current:(NSMutableString *)current;

@end
