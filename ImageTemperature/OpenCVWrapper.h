//
//  OpenCVWrapper.h
//  ImageTemperature
//
//  Created by Dio Putra Utama on 26/02/25.
//


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OpenCVWrapper : NSObject

+ (UIImage *)adjustTemperature:(UIImage *)image temperature:(int)temperature;

@end

NS_ASSUME_NONNULL_END
