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
    var answerlat = ""
    var answerlong = ""
    
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
    
    // tag textfield, image, latitude, and longitude with variable names
   
    @IBOutlet var latitudeLabel : UILabel
    @IBOutlet var longitudeLabel : UILabel
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
    func imagePickerController(image: UIImagePickerController, didFinishPickingMediaWithInfo info: NSDictionary){
        //println(image)
        //println(info)
        var chosenImage: UIImage = info[UIImagePickerControllerOriginalImage] as UIImage
        self.imageView.image = chosenImage
        //println("pop")
        self.dismissModalViewControllerAnimated(true)
    }
    
    // sets the actual long and lat values to the variables and convert to strings with 6 deceimal places
    var once = 1
    func locationManager(manager:CLLocationManager!, didUpdateLocations locations:AnyObject[]) {
        if once == 1 {
            myLat = locations[0].coordinate.latitude
            myLong = locations[0].coordinate.longitude
            println(myLat)
            println(myLong)
            
            
            var counterlat = 0
            var counterlong = 0
            
            for x in "\(myLat)" {
                if x == "." { counterlat = 1 }
                if counterlat < 8 { answerlat += x }
                counterlat += 1
            }
            
            for x in "\(myLong)" {
                if x == "." { counterlong = 1 }
                if counterlong < 8 { answerlong += x }
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
        var myLat = answerlat
        var myLong = answerlong

        var postString = NSString(format: "text=\(myText)&latitude=\(answerlat)&longitude=\(answerlong)")
        var postData = postString.dataUsingEncoding(NSUTF8StringEncoding)
        var url = NSURL(string: "http://young-beach-6740.herokuapp.com/memories")
        
        // creating post request
        var request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.HTTPBody = postData
        request.setValue("text/xml", forHTTPHeaderField: "X-Requested-With")
        
        println(request.HTTPBody)
        
        var connection = NSURLConnection(request: request, delegate: self, startImmediately: false)
        
        connection.start()

        
        // self.tabBarController.selectedIndex = 0
        // INSET POP UP HERE THAT MEM WAS SAVED
        // AND MOVE USER TO HOME PAGE
        
    }
    
}

