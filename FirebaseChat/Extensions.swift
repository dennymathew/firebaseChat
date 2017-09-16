//
//  File.swift
//  FirebaseChat
//
//  Created by Denny Mathew on 09/09/17.
//  Copyright © 2017 Cabot. All rights reserved.
//

import Foundation
import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(displayP3Red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}

extension UIImageView {
    func loadImageFromChache(with urlString: String) {
        
        let spinner = UIActivityIndicatorView()
        spinner.activityIndicatorViewStyle = .gray
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        /* Check Cache for Image */
        if let cacheimage = imageCache.object(forKey: urlString as NSString) {
            self.image = cacheimage
            spinner.removeFromSuperview()
            return
        }
        
        /* Otherwise Download the Image */
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error as Any)
                spinner.removeFromSuperview()
                return
            }
            
            if let downloadedImage = UIImage(data: data!) {
                imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                
                DispatchQueue.main.async {
                    self.image = downloadedImage
                    spinner.removeFromSuperview()
                }
            }
            
        }).resume()
    }
}

extension UIImage {
    
    func reducedSize() -> UIImage {
        
        var actualHeight = self.size.height
        var actualWidth = self.size.width
        let maxHeight: CGFloat = 300.0
        let maxWidth: CGFloat = 300.0
        var imgRatio = actualWidth/actualHeight
        let maxRatio = maxWidth/maxHeight
        let compressionQuality: CGFloat = 0.5 //50 percent compression
        
        if (actualHeight > maxHeight || actualWidth > maxWidth) {
            
            if(imgRatio < maxRatio) {
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            }
            
            else if(imgRatio > maxRatio) {
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            }
            
            else {
                actualHeight = maxHeight
                actualWidth = maxWidth
            }
        }
        
        let rect = CGRect(x: 0.0, y: 0.0, width: actualWidth, height: actualHeight)
        UIGraphicsBeginImageContext(rect.size)
        self.draw(in: rect)
        if let image = UIGraphicsGetImageFromCurrentImageContext() {
            let imageData = UIImageJPEGRepresentation(image, compressionQuality)
            UIGraphicsEndImageContext();
            return UIImage(data: imageData!)!
        }
        
        else {
            print("Failed to reduce image size!")
            return self
        }
    }
}
