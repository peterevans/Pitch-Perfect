//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Peter Evans on 3/4/15.
//  Copyright (c) 2015 Peter Evans. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    // create instances of each button in the Main View COntroller
    @IBOutlet weak var tapToRecordLabel: UILabel!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    // create variables to hold an instance of both the AVAudioRecorder and the recorded audio file itself
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        // each time the main view appears the Record buttoin is viewable and the Stop button is hidden
        recordButton.enabled = true
        stopButton.hidden = true
    }

    @IBAction func recordButtonPressed(sender: UIButton) {
        
        // when the Record button is pressed, the Stop button appears, the label "recording appears, and the Record button and tap to record label disappear
        tapToRecordLabel.hidden = true
        stopButton.hidden = false
        recordingLabel.hidden = false
        recordButton.enabled = false
        
        // create constant to hold the path to the recorded audio file
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        // create a constant to the recorded audio file itself. The file is named based on the date and time at which it was recorded to avoid duplicates
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        //Setup audio session
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        // Initialize and prepare the recorder
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.record()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        
        //first test to see if the recording completed, if so, create a RecordAudio() Class object and set the properites. When this is complete, preform the segue to the RecordedAudio View Controller
        if (flag) {
            recordedAudio = RecordedAudio()
            recordedAudio.filePathUrl = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent
        
            self.performSegueWithIdentifier("stopRecordingSegue", sender: recordedAudio)
        }
        else {
            println("Recording was not successfull")
            recordButton.enabled = true
            stopButton.hidden = true
        }
    }
    
    // the prepareForSegue function used to pass the recordedAudio to PlaySoundsViewController
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecordingSegue") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    @IBAction func stopButtonPressed(sender: UIButton) {
        tapToRecordLabel.hidden = false
        recordingLabel.hidden = true
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    
}

