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
    var heightView:CGFloat = 200
    
    @IBOutlet weak var viewImg: UIView!
    @IBOutlet weak var imgSow: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let width = self.view.frame.width
        viewImg.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        imgSow.image = myImg
    }
    

}
