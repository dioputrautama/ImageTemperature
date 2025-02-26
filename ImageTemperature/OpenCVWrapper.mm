//
//  OpenCVWrapper.m
//  ImageTemperature
//
//  Created by Dio Putra Utama on 26/02/25.
//

#import "OpenCVWrapper.h"
#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>

@implementation OpenCVWrapper

+ (UIImage *)normalizeImageOrientation:(UIImage *)image {
    if (image.imageOrientation == UIImageOrientationUp) {
        return image;
    }

    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return normalizedImage;
}

+ (UIImage *)adjustTemperature:(UIImage *)image temperature:(int)temperature {

    UIImage *normalizedImage = [self normalizeImageOrientation:image];

    cv::Mat mat;

    UIImageToMat(normalizedImage, mat);

    std::vector<cv::Mat> channels;
    cv::split(mat, channels);

    // BGR: Blue (0), Green (1), Red (2)
    if (temperature < 0) {
        // Warm transition: First yellow (increase R & G), then red
        channels[2] += temperature; // Increase Red
        channels[1] += temperature * 0.5; // Increase Green (Yellow effect)
        channels[0] -= temperature * 0.3; // Reduce Blue slightly
    } else {
        // Cool transition: First light blue (increase B & G), then deep blue
        channels[0] += abs(temperature); // Increase Blue
        channels[1] += abs(temperature) * 0.5; // Increase Green (Light blue effect)
        channels[2] -= abs(temperature) * 0.3; // Reduce Red slightly
    }

    cv::merge(channels, mat);

    return MatToUIImage(mat);
}

@end


