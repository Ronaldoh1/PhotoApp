//
//  ApplyFiltersViewController.swift
//  PhotoApp
//
//  Created by Hernandez, Ronald on 2/10/20.
//  Copyright © 2020 Ronaldoh1. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class ApplyFiltersViewController: UIViewController {
    
    @IBOutlet weak var applyFiltersButton: UIButton!
    
    @IBOutlet weak var photoSelected: UIImageView!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true

        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let navController = segue.destination as? UINavigationController, let photoVC = navController.viewControllers.first as? PhotoSelectionViewController else {
            fatalError()
        }
        
        photoVC.selectedPhoto.subscribe(onNext: { [weak self] photo in
            
            self?.updateUI(with: photo)
        
        }).disposed(by: disposeBag)
    }
    
    private func updateUI(with image: UIImage) {
        
        self.photoSelected.image = image
        self.applyFiltersButton.isHidden = false
    }
    
    @IBAction func applyFilter(_ sender: Any) {
        guard let sourceImage = self.photoSelected.image else {
            return
        }
        
        FilterService().applyFilter(to: sourceImage)
            .subscribe(onNext: { filteredImage in
                DispatchQueue.main.async {
                    self.photoSelected.image = filteredImage
                }
            }).disposed(by: disposeBag)
    }
    
}
