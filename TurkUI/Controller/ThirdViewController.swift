//
//  ThirdViewController.swift
//  TurkUI
//
//  Created by yusufbasol on 6.05.2019.
//  Copyright © 2019 com.yusufbasol. All rights reserved.
//

import UIKit

struct Food:Decodable {
    let turkMutfagi: String
    let description: String
    let yiyecekler:[Yiyecekler]
    
    private enum CodingKeys:String, CodingKey{
        case turkMutfagi = "TurkMutfagi"
        case description = "Description"
        case yiyecekler = "Yiyecekler"
    }
}

struct Yiyecekler:Decodable {
    let tarif: String
    let kalori: String
    let malzemeler: String
    let sure: String
    let kisi: String
    let seviye: String
    
    private enum CodingKeys: String, CodingKey{
        case tarif = "Tarif"
        case kalori = "Kalori"
        case malzemeler = "Malzemeler"
        case sure = "Sure"
        case kisi = "Kisi"
        case seviye = "Seviye"
    }
}


class ThirdViewController: UIViewController {
    
    private var food:Food?
    
    @IBOutlet weak var imageFromSecondVC: UIImageView!
    @IBOutlet weak var labelAd: UILabel!
    @IBOutlet weak var labelOran: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    var LabelTarif : String = ""
    var LabelOran : Int = 0
    var LabelAd : String = ""
    var TrasferImagee: UIImage!
    
    @IBOutlet weak var sure: UILabel!
    @IBOutlet weak var kisi: UILabel!
    @IBOutlet weak var seviye: UILabel!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.parseJSONFood()
        labelOran.text = "%\(LabelOran)"
        textView.text = LabelTarif
        labelAd.text = LabelAd
        imageFromSecondVC.image = TrasferImagee
        
        
        if (LabelOran < 70){
            textView.text = "Oran düşük olduğu için tarif gösterilemiyor."
            
        }
        else{
            let start = NSDate() // For exucution time
            
            let sonuc = self.parseJSONFood(tarifKaloriMalzemeler: textView.text!, time: sure.text!, people: kisi.text!, level: seviye.text!)
            textView.text = sonuc.0
            sure.text = sonuc.1
            kisi.text = sonuc.2
            seviye.text = sonuc.3
            
            let finish = NSDate()
            let executionTime = finish.timeIntervalSince(start as Date)
            print("JSON parse fonksiyonun çalışma süresi: \(executionTime)")
            
            
        }

    }
    
    func parseJSONFood(tarifKaloriMalzemeler : String, time: String, people: String, level: String) -> (String, String, String, String) {
        var tarifKaloriMalzeme = ""
        var kalori = ""
        var tarif = ""
        var malzemeler = ""
        var time = ""
        var people = ""
        var level = ""
        
        var map : [String : Int] = ["Aşure": 0, "Baklava": 1, "Biber Dolması": 2, "Börek": 3, "Çiğ Köfte":4, "Enginar":5, "Et Sote":6, "Gözleme":7, "Hamsi":8, "Hünkar Beğendi":9, "İçli Köfte":10, "Ispanak":11, "İzmir Köfte":12, "Karnıyarık":13, "Kebap":14, "Kısır":15, "Kuru Fasulye":16, "Lahmacun":17, "Mantı":18, "Mücver":19, "Pirinç Pilavı":20, "Simit":21, "Taze Fasulye":22, "Yaprak Sarma":23]
        let arrayNum = map["\(textView.text!)"]
        
        if let url = Bundle.main.url(forResource: "array", withExtension: "json"){
            
            do{
                let data = try Data(contentsOf: url)
                self.food = try
                    JSONDecoder().decode(Food.self, from: data)
                
                if let foods = self.food{
//                    print(foods.yiyecekler[arrayNum!].tarif)
//                    print(foods.yiyecekler[arrayNum!].kalori)
                    kalori = foods.yiyecekler[arrayNum!].kalori
                    tarif = foods.yiyecekler[arrayNum!].tarif
                    malzemeler = foods.yiyecekler[arrayNum!].malzemeler
                    tarifKaloriMalzeme = kalori + malzemeler + tarif
                    time = foods.yiyecekler[arrayNum!].sure
                    people = foods.yiyecekler[arrayNum!].kisi
                    level = foods.yiyecekler[arrayNum!].seviye
                    
                }
            }
            catch{
                print("Error: ", error.localizedDescription)
            }
        }
        return (tarifKaloriMalzeme, time, people, level)
    }
    

}
