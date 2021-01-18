//
//  ViewController.swift
//  DownloadImage
//
//  Created by Nero on 1/12/21.
//  Copyright © 2021 NHK. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var successLabel: UILabel!
    var listImage: [ImageBO] = []
    var dispatchGroup = DispatchGroup()
    var dispatchSemaphore = DispatchSemaphore(value: 1)
    var dispatchSemaphore2 = DispatchSemaphore(value: 2)
    var isCancel = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        BaseRequest.shared.request(path: "photos", successCompletion: { [weak self] (response: [ImageBO]) in
            self?.listImage = response
            print("Get link successs")
        })
    }
    
    func showSuccessLabel() {
        successLabel.isHidden = false
        print("Download success")
        perform(#selector(hideSuccessLabel), with: self, afterDelay: 5)
    }
    
    @objc func hideSuccessLabel() {
        successLabel.isHidden = true
    }
    
    @IBAction func downloadWithDispatchGroupAction(_ sender: Any) {
        var count = 0
        for image in listImage[0..<10] {
            
            dispatchGroup.enter()
            BaseRequest.shared.downloadImage(from: image.url) { [weak self] _ in
                self?.dispatchGroup.leave()
                count += 1
                print(count)
            }
        }
        dispatchGroup.notify(queue: .main) {
            self.showSuccessLabel()
        }
    }
    
    
    @IBAction func downloadWithDispatchSemaphore(_ sender: Any) {
        var count = 0
        DispatchQueue.global().async {
            for image in self.listImage[0..<10] {
                if self.isCancel {
                    self.isCancel = false
                    return
                }
                self.dispatchSemaphore.wait()
                BaseRequest.shared.downloadImage(from: image.url) { [weak self] _ in
                    self?.dispatchSemaphore.signal()
                    count += 1
                    print(count)
                }
            }
            self.dispatchSemaphore.wait()
            self.showSuccessLabel()
            self.dispatchSemaphore.signal()
        }
    }
    
    @IBAction func downloadTwoConcurent(_ sender: Any) {
        var count = 0
        DispatchQueue.global().async {
            for image in self.listImage[0..<10] {
                if self.isCancel {
                    self.isCancel = false
                    return
                }
                self.dispatchSemaphore2.wait()
                BaseRequest.shared.downloadImage(from: image.url) { [weak self] _ in
                    self?.dispatchSemaphore2.signal()
                    count += 1
                    print(count)
                }
            }
        }
        
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        isCancel = true
    }
}

