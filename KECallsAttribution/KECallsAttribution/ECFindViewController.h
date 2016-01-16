//
//  ECFindViewController.h
//  KECallsAttribution
//
//  Created by 赵 进喜 on 14-10-20.
//  Copyright (c) 2014年 K.BLOCK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface ECFindViewController : UIViewController<MKMapViewDelegate,UIActionSheetDelegate,CLLocationManagerDelegate>
{

    NSString *latitude;
    
    NSString *longtitude;

    NSString *address;
    
    MKCircle *mCircle;
    
    
    CLLocation *myLocation;


}
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextField *addressField;
@property(strong,nonatomic)CLLocationManager *locationManager;
- (IBAction)backButtonPressed:(UIButton *)sender;
- (IBAction)getLocation:(UIButton *)sender;
- (IBAction)hideKeyboard:(UITapGestureRecognizer *)sender;
- (IBAction)chooseMap:(UIButton *)sender;

@end
