

//
//  ChatControllerHanlers.swift
//  FirebaseChat
//
//  Created by Denny Mathew on 01/10/17.
//  Copyright © 2017 Cabot. All rights reserved.
//

import Foundation
import UIKit

//MARK:- Handlers
extension ChatViewController {
    
    func observeMessages() {
        
        guard let toId = user?.id else {
            return
        }
        
        FirebaseHandler.observePartnerMessages(with: toId) { (message) in
            self.messages.append(message)
            self.messages.sort(by: { (message1, message2) -> Bool in
                return Int(message2.timeStamp!) > Int(message1.timeStamp!)
            })
            
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
                let lastIndex = IndexPath(item: self.messages.count - 1, section: 0)
                self.collectionView?.scrollToItem(at: lastIndex, at: .bottom, animated: true)
            }
        }
    }
    
    func handleUploadTap() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        if let editedImage  = info[Keys.editedImageFromPicker] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[Keys.originalImageFromPicker] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            uploadImageToFirebaseStorage(selectedImage)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func uploadImageToFirebaseStorage(_ image: UIImage) {
        print("Uploading...")
        
        FirebaseHandler.uploadChatImage(image) { (imageUrl, error) in
            if let url = imageUrl {
                self.handleImageChat(url, image: image)
            } else {
                DLog("Error in uploading image!")
            }
        }
    }
    
    func handleImageChat(_ imageUrl: String, image: UIImage) {
        let properties: [String: Any] = [Keys.imageUrl: imageUrl, Keys.height: image.size.height, Keys.width: image.size.width]
        sendMessage(with: properties)
    }
    
    func handleTextChat() {
        if !(inputTextField.text?.elementsEqual(""))! {
            let properties: [String: Any] = [Keys.text: inputTextField.text!]
            sendMessage(with: properties)
        }
    }
    
    func sendMessage(with properties: [String: Any]) {
        
        guard let toId = user?.id else {
            return
        }
        
        FirebaseHandler.sendChatMessage(toId, properties: properties) { (success) in
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
                self.inputTextField.text = ""
            }
        }
    }
    
    func performZoomInForStartingImageView(_ imageView: UIImageView) {
        print("Zooming In...")
        
        self.startingImageView = imageView
        self.startingImageView?.isHidden = true
        startingFrame = imageView.superview?.convert(imageView.frame, to: nil)
        
        let zoomInImageView = UIImageView(frame: startingFrame!)
        zoomInImageView.image = imageView.image
        zoomInImageView.isUserInteractionEnabled = true
        zoomInImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
        
        if let keyWindow = UIApplication.shared.keyWindow {
            
            self.imageBackground = UIView(frame: keyWindow.frame)
            self.imageBackground?.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.imageBackground?.alpha = 0
            keyWindow.addSubview(imageBackground!)
            keyWindow.addSubview(zoomInImageView)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                let height = (self.startingFrame?.height)! / (self.startingFrame?.width)! * keyWindow.frame.width
                self.imageBackground?.alpha = 0.9
                self.inputContainerView.alpha = 0
                zoomInImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                zoomInImageView.center = keyWindow.center
            }, completion: { (completed) in
            })
        }
    }
    
    func handleZoomOut(_ tapRecognizer: UITapGestureRecognizer) {
        if let zoomOutImageView = tapRecognizer.view as? UIImageView {
            zoomOutImageView.layer.cornerRadius = 16
            zoomOutImageView.layer.masksToBounds = true
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                zoomOutImageView.frame = self.startingFrame!
                self.imageBackground?.alpha = 0
                self.inputContainerView.alpha = 1.0
            }, completion: { (completed) in
                self.imageBackground?.removeFromSuperview()
                zoomOutImageView.removeFromSuperview()
                self.startingImageView?.isHidden = false
            })
        }
    }
}
