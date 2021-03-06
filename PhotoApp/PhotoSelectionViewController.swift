//
//  PhotoSelectionViewController.swift
//  PhotoApp
//
//  Created by Hernandez, Ronald on 2/10/20.
//  Copyright © 2020 Ronaldoh1. All rights reserved.
//

import Foundation
import RxSwift
import UIKit
import Photos

class PhotoSelectionViewController: UICollectionViewController {
    
    private var images = [PHAsset]()
    
    private var selectedPhotoSubject = PublishSubject<UIImage>()
    
    var selectedPhoto: Observable<UIImage> {
        return selectedPhotoSubject.asObservable()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pupulatePhotos()
    }
    
    private func pupulatePhotos() {
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            if status == .authorized {
                // access the pictures of photos.
                let assets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
                assets.enumerateObjects { (object, count, stop) in
                    self?.images.append(object)
                }
                self?.images.reverse() // need to add the images in reverse order because of the order they were added in.
                
                DispatchQueue.main.sync {
                    self?.collectionView.reloadData()
                }
            }
        }
    }
    
}

extension PhotoSelectionViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedAssset = self.images[indexPath.row]
        PHImageManager.default().requestImage(for: selectedAssset, targetSize: CGSize(width: 1000, height: 1000), contentMode: .aspectFit, options: nil) { [weak self](image, info) in
            guard let info = info else { return }
            let isDegradedIamge = info["PHImageResultIsDegradedKey"] as! Bool
            
            if isDegradedIamge {
                if let image = image {
                    self?.selectedPhotoSubject.onNext(image)
                    self?.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? PhotoCollectionViewCell else  {
            return UICollectionViewCell()
        }
        let asset = self.images[indexPath.row]
        
        let manager = PHImageManager.default()
        manager.requestImage(for: asset, targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFit, options: nil) { (image, _) in
            DispatchQueue.main.async {
                cell.photoImage.image = image
            }
        }
        return cell
    }
}
