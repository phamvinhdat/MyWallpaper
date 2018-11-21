//
//  ImageViewController.swift
//  MyWallpaper
//
//  Created by pham vinh dat on 11/21/18.
//  Copyright © 2018 pham vinh dat. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    var myImg = #imageLiteral(resourceName: "400x200")
    var isFull = false
    
    @IBOutlet weak var viewImg: UIView!
    @IBOutlet weak var imgSow: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgSow.image = myImg
    }
    
    @IBAction func btnSaveImg(_ sender: Any) {
        UIImageWriteToSavedPhotosAlbum(myImg, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    @IBAction func btnFullScreen(_ sender: Any) {
        let btn = sender as! UIButton
        if !isFull{
            self.imgSow.contentMode = .center
            btn.setImage(#imageLiteral(resourceName: "icons8-normal_screen"), for: .normal)
        }else{
            self.imgSow.contentMode = .scaleAspectFit
            btn.setImage(#imageLiteral(resourceName: "icons8-full_screen"), for: .normal)
        }
        isFull = !isFull
    }
    
    @IBAction func btnShare(_ sender: Any) {
        //tham khao tren mang
        // set up activity view controller
        let imageToShare = [ imgSow! ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook , ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
}
