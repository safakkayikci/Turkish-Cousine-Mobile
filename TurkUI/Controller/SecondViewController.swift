//
//  SecondViewController.swift
//  TurkUI
//
//  Created by yusufbasol on 6.05.2019.
//  Copyright © 2019 com.yusufbasol. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet weak var imageFromVC: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    

    var TrasferImage: UIImage!
    var Label : String = ""
    var Label2 : String = ""
    var Label3 : String = ""
    
    var labelTariff : String = ""
    var labelOrann : Int = 0
    var labelAdd : String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageFromVC.image = TrasferImage
        label.text = Label
        label2.text = Label2
        label3.text = Label3
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tarifGoster" {
            let destVC = segue.destination as! ThirdViewController
            destVC.LabelTarif = labelTariff
            destVC.LabelOran = labelOrann
            destVC.LabelAd = labelAdd
            destVC.TrasferImagee = imageFromVC.image
            
        }
    }


}
