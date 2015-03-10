//
//  main.swift
//  xrecord
//
//  Created by Patrick Meenan on 12/10/15.
//  Copyright (c) 2015 WPO Foundation. All rights reserved.
//

import Foundation
import AVFoundation

let cli = CommandLine()

let list = BoolOption(shortFlag: "l", longFlag: "list",
    helpMessage: "List available capture devices.")
let name = StringOption(shortFlag: "n", longFlag: "name", required: false,
    helpMessage: "Device Name.")
let id = StringOption(shortFlag: "i", longFlag: "id", required: false,
    helpMessage: "Device ID.")
let outFile = StringOption(shortFlag: "o", longFlag: "out", required: false,
    helpMessage: "Output File.")
let force = BoolOption(shortFlag: "f", longFlag: "force",
    helpMessage: "Overwrite existing files.")
let qt = BoolOption(shortFlag: "q", longFlag: "quicktime",
    helpMessage: "Start QuickTime in the background (necessary for iOS recording.")
let time = IntOption(shortFlag: "t", longFlag: "time", required: false,
    helpMessage: "Recording time in seconds (records until stopped if not specified).")
let help = BoolOption(shortFlag: "h", longFlag: "help",
    helpMessage: "Prints a help message.")
let verbosity = CounterOption(shortFlag: "v", longFlag: "verbose",
    helpMessage: "Print verbose messages. Specify multiple times to increase verbosity.")

cli.addOptions(list, name, id, outFile, force, qt, time, help, verbosity)
let (success, error) = cli.parse()
if !success {
    println(error!)
    cli.printUsage()
    exit(EX_USAGE)
}

// Check to make sure a sane combination of options were specified
var ok = true
if !list.value {
    if name.value == nil && id.value == nil {
        ok = false
    }
    if outFile.value == nil {
        ok = false
    }
}
if !ok {
    cli.printUsage()
    exit(EX_USAGE)
}

// See if we need to launch quicktime in the background
if qt.value {
    XRecord_Bridge.startQuickTime()
}

let capture = Capture()
if list.value {
    println("Available capture devices:")
    capture.listDevices()
    exit(0)
}

// Set up the input device
if id.value != nil {
    if !capture.setDeviceById(id.value) {
        println("Device not found")
        exit(1)
    }
}
if name.value != nil {
    if !capture.setDeviceByName(name.value) {
        println("Device not found")
        exit(1)
    }
}

// See if a video file already exists in the given location
if outFile.value != nil && NSFileManager.defaultManager().fileExistsAtPath(outFile.value!) {
    if force.value {
        var error:NSError?
        NSFileManager.defaultManager().removeItemAtPath(outFile.value!, error: &error)
        if (error != nil) {
            println("Error overwriting existing file (\(error)).")
            exit(2)
        }
    } else {
        println("The output file already exists, please use a different file: \(outFile.value!)")
        exit(2)
    }
}


XRecord_Bridge.installSignalHandler()

capture.start(outFile.value)
let start = NSDate()
if time.value != nil && time.value > 0 {
    println("Recording for \(time.value) seconds.  Hit ctrl-C to stop.")
    sleep(UInt32(time.value!))
} else {
    println("Recording started.  Hit ctrl-C to stop.")
    sleep(10)
}

// Loop until we get a ctrl-C or the time limit expires
var done = false
do {
    usleep(100)
    if XRecord_Bridge.didSignal() {
        done = true
    } else if time.value != nil && time.value > 0 {
        let now = NSDate()
        let elapsed: Double = now.timeIntervalSinceDate(start)
        if elapsed >= Double(time.value!) {
            done = true
        }
    }
} while !done

capture.stop()
println("Done")
