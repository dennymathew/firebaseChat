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
            
            DispatchQueue.main.async {
                self.image = cacheimage
                spinner.removeFromSuperview()
            }
            
            return
        }
        
        /* Otherwise Download the Image */
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                DLog(error as Any)
                DispatchQueue.main.async {
                    spinner.removeFromSuperview()
                }
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
            DLog("Failed to reduce image size!")
            return self
        }
    }
}

extension String {
    func estimatedFrame() -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: self).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    //MARK:- First Character from String:- For Swift 3.0/Xcode 8.3
    func first() -> String {
        if self.characters.count > 0 {
            return "\(self.characters.first!)"
        }
        else { return "" }
    }
}

extension NSNumber {
    func toTimeString(_ format: String) -> String {
        let timeStampDate = Date(timeIntervalSince1970: self.doubleValue)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: timeStampDate)
    }
}

extension Date {
    func now() -> String {
        let time = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmm"
        return formatter.string(from: time)
    }
}
