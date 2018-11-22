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
    @IBOutlet weak var btnFullScreen: UIButton!
    @IBOutlet weak var btnSaveImg: UIButton!
    @IBOutlet weak var btnShareImg: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBtn_viewDidLoad()
        imgSow.image = myImg
    }
    
    func setBtn_viewDidLoad(){
        btnShareImg.layer.cornerRadius = btnShareImg.frame.width/2
        btnSaveImg.layer.cornerRadius = btnSaveImg.frame.width/2
        btnFullScreen.layer.cornerRadius = btnFullScreen.frame.width/2
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
        let item = [self.myImg]
        let activityVC = UIActivityViewController(activityItems: item, applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
    }
}
