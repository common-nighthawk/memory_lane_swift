//
//  ViewController.swift
//  camerataker
//
//  Created by Apprentice on 6/14/14.
//  Copyright (c) 2014 Skippers. All rights reserved.
//  

import UIKit
import CoreLocation

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate , UITextFieldDelegate, CLLocationManagerDelegate {
    
    // init location manager and set coordinates to 0
    let locationManager = CLLocationManager()
    var myLong = 0.0
    var myLat = 0.0
    var answerLat = ""
    var answerLong = ""
    
    // after the view loads, start getting location
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    // standard
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // tag textfield and image with variable names
   
    @IBOutlet var imageView : UIImageView = nil
    @IBOutlet var textMem : UITextField
    
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        self.view.endEditing(true)
    }
    
    // textfield delegate removes keyboard when return is hit
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // opens the camera when you git the "Take Photo" button until "Use Photo" is confirmed
    // the the camera closes
    @IBAction func takePhoto(sender : UIButton) {
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.Camera
        image.allowsEditing = false
        self.presentViewController(image, animated: true, completion: nil)
    }
    
    // saves the photo to the variable
//    var imgAsString = ""
//    var img3 = ""
    var myImageData = ""
    
    func imagePickerController(image: UIImagePickerController, didFinishPickingMediaWithInfo info: NSDictionary){
        
        //println(image)
        //println(info)
        var chosenImage: UIImage = info[UIImagePickerControllerOriginalImage] as UIImage
        self.imageView.image = chosenImage
        self.dismissModalViewControllerAnimated(true)
        
        //START TRYING TO POST OUR IMAGE
        var imageData: NSData = UIImageJPEGRepresentation(chosenImage, 0.1)
        myImageData = "\(imageData)"
        
//        for char in "\(imageData)" {
//            if char != " " {
//                imgAsString += char
//            }
//        }
//        
//        println(imgAsString)
//        var img2 = imgAsString.substringFromIndex(1)
//        img3 = img2.substringToIndex(countElements(img2) - 1)
//        //THIS IS A
//        println(img3)
       
    }
    
    // sets the actual long and lat values to the variables and convert to strings with 6 deceimal places
    var once = 1
    func locationManager(manager:CLLocationManager!, didUpdateLocations locations:AnyObject[]) {
        if once == 1 {
            myLat = locations[0].coordinate.latitude
            myLong = locations[0].coordinate.longitude

            var counterlat = 0
            var counterlong = 0
            
            for x in "\(myLat)" {
                if x == "." { counterlat = 1 }
                if counterlat < 8 { answerLat += x }
                counterlat += 1
            }
            for x in "\(myLong)" {
                if x == "." { counterlong = 1 }
                if counterlong < 8 { answerLong += x }
                counterlong += 1
            }
        }
        once += 1
    }
    
    // submit memory button
    @IBAction func btnCaptureMem(sender : UIButton) {
        // println("Button was clicked")
        var myText = textMem.text
        self.view.endEditing(true)
        textMem.text = ""
        
        
        var url = "http://whispering-earth-2684.herokuapp.com/memories"
        
        let manager = AFHTTPRequestOperationManager()
        let params = ["text":myText, "latitude":answerLat, "longitude":answerLong]
        
        manager.POST(url, parameters: params,
            constructingBodyWithBlock: {
                [weak self](formData) -> Void in
                formData.appendPartWithFileData(UIImageJPEGRepresentation(self?.imageView?.image, 0.9), name: "image", fileName: "picture.jpg", mimeType: "image/jpeg")
            },
            success: {(operation, response) -> Void in
                let alert = UIAlertView()
                alert.title = "Memory Created!"
                alert.message = "You have shared a memory for the world to experience."
                alert.addButtonWithTitle("the world ♥ you")
                alert.show()
                alert.delegate = nil
            },
            failure: {(operation, response) -> Void in println(response)})

        imageView.image = nil
        
    
    }
}

