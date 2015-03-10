//
//  capture.swift
//  xrecord
//
//  Created by Patrick Meenan on 2/26/15.
//  Copyright (c) 2015 WPO Foundation. All rights reserved.
//

import Foundation
import AVFoundation

class Capture: NSObject, AVCaptureFileOutputRecordingDelegate {

var session : AVCaptureSession!
var input : AVCaptureDeviceInput?
var output : AVCaptureMovieFileOutput!
var started : Bool = false
var finished : Bool = false

override init() {
    self.session = AVCaptureSession()
    self.session.sessionPreset = AVCaptureSessionPresetHigh

    // Enable screen capture devices in AV Foundation
    XRecord_Bridge.enableScreenCaptureDevices()
}
    
func listDevices() {
    var devices: NSArray = AVCaptureDevice.devices()
    for object:AnyObject in devices {
        let device = object as AVCaptureDevice
        let deviceID = device.uniqueID
        let deviceName = device.localizedName
        println("\(deviceID): \(deviceName)")
    }
}

func setDeviceByName(name: String!) -> Bool {
    var found : Bool = false
    var devices: NSArray = AVCaptureDevice.devices()
    for object:AnyObject in devices {
        let captureDevice = object as AVCaptureDevice
        if captureDevice.localizedName == name {
            var err : NSError? = nil
            self.input = AVCaptureDeviceInput(device: captureDevice, error: &err)
            if err == nil {
                found = true
            }
        }
    }
    return found
}
    
func setDeviceById(id: String!) -> Bool {
    var found : Bool = false
    var devices: NSArray = AVCaptureDevice.devices()
    for object:AnyObject in devices {
        let captureDevice = object as AVCaptureDevice
        if captureDevice.uniqueID == id {
            var err : NSError? = nil
            self.input = AVCaptureDeviceInput(device: captureDevice, error: &err)
            if err == nil {
                found = true
            }
        }
    }
    return found
}
    
func start(file: String!) -> Bool {
    var started : Bool = false
    if self.session.canAddInput(self.input) {
        self.session.addInput(self.input)
        self.output = AVCaptureMovieFileOutput()
        if self.session.canAddOutput(self.output) {
            self.session.addOutput(self.output)
            self.session.startRunning()
            self.output.startRecordingToOutputFileURL(NSURL.fileURLWithPath(file), recordingDelegate: self)
            started = true
        }
    }
    return started
}
    
func stop() {
    self.output.stopRecording()
    self.session.stopRunning()
}

func captureOutput(captureOutput: AVCaptureFileOutput!,
    didStartRecordingToOutputFileAtURL fileURL: NSURL!,
    fromConnections connections: [AnyObject]!) {
    NSLog("captureOutput Started callback");
    self.started = true
}
    
func captureOutput(captureOutput: AVCaptureFileOutput!,
    didFinishRecordingToOutputFileAtURL outputFileURL: NSURL!,
    fromConnections connections: [AnyObject]!,
    error: NSError!) {
    NSLog("captureOutput Finished callback")
    self.finished = true
}

} // class Capture