//
//  ViewController.swift
//  MLImageRecognition
//
//  Created by Andrew  on 3/20/23.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    var chosenImage = CIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }
    
    @IBAction func changeButtonClicked(_ sender: Any) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
        if let ciImage = CIImage(image: imageView.image!) {
            chosenImage = ciImage
        }
        
        recognizeImage(image: chosenImage)
    }
    
    func recognizeImage(image: CIImage) {
        
        if let model = try? VNCoreMLModel(for: MobileNetV2().model) {
            
            let request = VNCoreMLRequest(model: model) { vnrequest, error in
                if let results = vnrequest.results as? [VNClassificationObservation] {
                    
                    if results.count > 0 {
                        let topResult = results.first
                        
                        DispatchQueue.main.async {
                            //code
                            let confidenceLevel = (topResult?.confidence ?? 0) * 100
                            
                            
                            self.resultLabel.text = "\(confidenceLevel)% it's \(topResult?.identifier)"
                        }
                    }
                    
                    
                }
            }
            
        }
        
    }
}

