//
//  FilterService.swift
//  PhotoApp
//
//  Created by Hernandez, Ronald on 2/14/20.
//  Copyright © 2020 Ronaldoh1. All rights reserved.
//

import Foundation
import UIKit
import CoreImage
import RxSwift

class FilterService {
    private var contex: CIContext
    
    
    init() {
        self.contex = CIContext()
    }
    
    
    func applyFilter(to inputImage: UIImage) -> Observable<UIImage> {
        return Observable<UIImage>.create { observer  in
            self.applyFilters(to: inputImage) { filteredImage in
                observer.onNext(filteredImage)
            }
            return Disposables.create()
        }
    }
    
    private func applyFilters(to inputImage: UIImage, completion: @escaping (UIImage) -> ()) {
        let filter = CIFilter(name: "CICMYKHalftone")
        filter?.setValue(5.0, forKey: kCIInputWidthKey)
        
        
        guard let sourceImage = CIImage(image: inputImage ) else { return }
        filter?.setValue(sourceImage, forKey: kCIInputImageKey)
        
        if let cgImage = self.contex.createCGImage(filter!.outputImage!, from: filter!.outputImage!.extent) {
            let processedImage = UIImage(cgImage: cgImage, scale: inputImage.scale, orientation: inputImage.imageOrientation)
            completion(processedImage)
        }
    }
}
