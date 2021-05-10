//
//  ViewController.swift
//  TurkUI
//
//  Created by yusufbasol on 6.05.2019.
//  Copyright © 2019 com.yusufbasol. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var ResimAlani: UIImageView!
    @IBOutlet weak var FotografSec: UIButton!
    @IBOutlet weak var FotografCek: UIButton!
    
    var labelTest : String = " "
    var labelTest2 : String = " "
    var labelTest3 : String = " "
    var labelTarif : String = " "
    var labelOran : Int = 0
    var labelAd : String = " "
    
    @IBAction func fotografSec(_ sender: UIButton) {
        let libraryPhoto = UIImagePickerController()
        libraryPhoto.delegate = self
        libraryPhoto.sourceType = .photoLibrary
        self.present(libraryPhoto, animated: true, completion: nil)
    }
    
    @IBAction func fotografCek(_ sender: UIButton) {
        let libraryPhoto = UIImagePickerController()
        libraryPhoto.delegate = self
        libraryPhoto.sourceType = .camera
        self.present(libraryPhoto, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let getImageFromLibrary = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            ResimAlani.image = getImageFromLibrary
            
            guard let ciimage = CIImage(image: getImageFromLibrary) else {
                fatalError("Resim dönüştürülemedi!")
            }
            let start = NSDate()
            tespitEt(image: ciimage)
            let finish = NSDate()
            let executionTime = finish.timeIntervalSince(start as Date)
            print("\n\n\n\n\n")
            print("Tespit et fonksiyonun çalışma süresi: \(executionTime)")
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    func tespitEt(image: CIImage){
        
        guard let model = try? VNCoreMLModel(for: kerasToCoreML_v4().model) else {
            fatalError("Model yüklenemedi!")
        }
        
        let istek = VNCoreMLRequest(model: model) { (istek, error) in
            guard let sonuclar = istek.results as? [VNClassificationObservation] else {
                fatalError("Modelde bir sıkıntı var!")
            }
            
            print(sonuclar,"")
            let ilk3sonuc = sonuclar.prefix(3)
            print(ilk3sonuc)
            
            let ilkSonuc = sonuclar[0]
            let ikinciSonuc = sonuclar[1]
            let ucuncuSonuc = sonuclar[2]
            
            
            let ilkFloat = String(format: "%.4f", ilkSonuc.confidence*100)
            let ikinciFloat = String(format: "%.4f", ikinciSonuc.confidence*100)
            let ucuncuFloat = String(format: "%.4f", ucuncuSonuc.confidence*100)
            
            
            //self.navigationItem.title = "Tahmin"
            self.labelTest = "\(ilkSonuc.identifier.capitalized) %\(ilkFloat)"
            self.labelTest2 = "\(ikinciSonuc.identifier.capitalized) %\(ikinciFloat)"
            self.labelTest3 = "\(ucuncuSonuc.identifier.capitalized) %\(ucuncuFloat)"
            
            self.labelTarif = "\(ilkSonuc.identifier.capitalized)"
            self.labelOran = Int(ilkSonuc.confidence*100)
            self.labelAd = "\(ilkSonuc.identifier.capitalized)"
            
        }
        
        let denetle = VNImageRequestHandler(ciImage: image)
        
        do {
            try denetle.perform([istek])
        }
        catch {
            print(error)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! SecondViewController
        destinationVC.TrasferImage = ResimAlani.image
        destinationVC.Label = labelTest
        destinationVC.Label2 = labelTest2
        destinationVC.Label3 = labelTest3
        destinationVC.labelTariff = labelTarif
        destinationVC.labelOrann = labelOran
        destinationVC.labelAdd = labelAd
        
    }
    

}

