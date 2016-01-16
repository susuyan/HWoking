//
//  checkImage.m
//  PictureCheck
//
//  Created by 赵 锋 on 13-3-7.
//  Copyright (c) 2013年 赵 锋. All rights reserved.
//

#import "checkImage.h"

@implementation checkImage

+(NSString *)imageSourcePath{
    
    NSString *path=[[NSBundle mainBundle] bundlePath];
    
    return path;
}
//1.将图片缩小到8x8的尺寸, 总共64个像素. 这一步的作用是去除各种图片尺寸和图片比例的差异, 只保留结构、明暗等基本信息.
+(UIImage *)imageToSize:(UIImage *)image toSize:(CGSize)size{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, size.width, size.width)];
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

//2.将缩小后的图片, 转为64级灰度图片.
+(uint8_t *)convertTo64GreyImage:(UIImage *)image{
    int kRed = 1;
    int kGreen = 2;
    int kBlue = 4;
    
    int colors = kGreen;
    int m_width = image.size.width;
    int m_height = image.size.height;
    
    uint32_t *rgbImage = (uint32_t *) malloc(m_width * m_height * sizeof(uint32_t));
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImage, m_width, m_height, 8, m_width * 4, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGContextSetShouldAntialias(context, NO);
    CGContextDrawImage(context, CGRectMake(0, 0, m_width, m_height), [image CGImage]);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    uint8_t *m_imageData = (uint8_t *) malloc(m_width * m_height);
    for(int y = 0; y < m_height; y++) {
        for(int x = 0; x < m_width; x++) {
            uint32_t rgbPixel=rgbImage[y*m_width+x];
            uint32_t sum=0,count=0;
            if (colors & kRed) {sum += (rgbPixel>>24)&255; count++;}
            if (colors & kGreen) {sum += (rgbPixel>>16)&255; count++;}
            if (colors & kBlue) {sum += (rgbPixel>>8)&255; count++;}
            m_imageData[y*m_width+x]=sum/count/4;
        }
    }
    free(rgbImage);
    return m_imageData;
}

//3.计算图片中所有像素的灰度平均值

+(uint8_t)avgGreyPixel:(uint8_t *)data{
    int sum = 0;
    for (int i = 0; i < 64; i++) {
        
        sum += data[i];
    }
    uint8_t avg = sum/64;
    return avg;
}

// 4.将每个像素的灰度与平均值进行比较, 如果大于或等于平均值记为1, 小于平均值记为0.

+(NSMutableArray *)compareGreyPixelToAvgPixel:(uint8_t *)imageData avg:(uint8_t)avgGrey{
    NSMutableArray *endArr=[[NSMutableArray alloc] init];
    for (int i=0; i<64; i++) {
        if (imageData[i]>=avgGrey) {
            
            int f=1;
            NSNumber *ff=[NSNumber numberWithInt:f];
            [endArr addObject:ff];
        }else{
            int f=0;
            NSNumber *ff=[NSNumber numberWithInt:f];
            [endArr addObject:ff];
        }
    }
    
    return endArr;
}

//5.将上一步的比较结果, 组合在一起, 就构成了一个64位的二进制整数, 这就是这张图片的指纹.
+(NSMutableString *)compareWithGroup:(NSMutableArray *)arr{
    NSMutableString *ms=[[NSMutableString alloc] initWithString:@""];
    
    for (NSNumber *i in arr) {
        int f=[i intValue];
        [ms appendFormat:@"%d",f];
    }
    
    return ms;
}

//6.得到图片的指纹后, 就可以对比不同的图片的指纹, 计算出64位中有多少位是不一样的. 如果不相同的数据位数不超过5, 就说明两张图片很相似, 如果大于10, 说明它们是两张不同的图片.

+(int)compareToHamdDistance:(NSMutableString *)scoureImage current:(NSMutableString *)current{
    int distance=0;
    
    for (int i=0; i<64; i++) {
        unichar s=[scoureImage characterAtIndex:i];
        unichar c=[current characterAtIndex:i];
        
        if (s!=c) {
            distance++;
        }
    }
 
    return distance;
}


+(BOOL)compareTwoImageFinger:(NSMutableString *)scoureImage current:(NSMutableString *)current
{



  int distance=[self compareToHamdDistance:scoureImage current:current];

    if (distance<=5) {
        return YES;
    }else
    {
    
        return NO;
    
    }


}


@end
