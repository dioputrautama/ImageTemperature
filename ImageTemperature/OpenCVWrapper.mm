//
//  OpenCVWrapper.m
//  ImageTemperature
//
//  Created by Dio Putra Utama on 26/02/25.
//

#import "OpenCVWrapper.h"
#import <opencv2/imgcodecs/ios.h>

@implementation OpenCVWrapper

+ (UIImage *)adjustTemperature:(UIImage *)image temperature:(int)temperature {
    cv::Mat mat;

    // Konversi UIImage ke OpenCV Mat
    UIImageToMat(image, mat);

    // Pisahkan channel warna (BGR)
    std::vector<cv::Mat> channels;
    cv::split(mat, channels);

    // Penyesuaian suhu warna
    if (temperature > 0) {
        channels[2] += temperature; // Tambah merah (R)
        channels[0] -= temperature; // Kurangi biru (B)
    } else {
        channels[2] -= abs(temperature); // Kurangi merah (R)
        channels[0] += abs(temperature); // Tambah biru (B)
    }

    // Gabungkan kembali channel warna
    cv::merge(channels, mat);

    // Konversi kembali ke UIImage
    return MatToUIImage(mat);
}

@end
