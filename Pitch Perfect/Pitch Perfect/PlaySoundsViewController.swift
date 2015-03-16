//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Peter Evans on 3/5/15.
//  Copyright (c) 2015 Peter Evans. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioPlayer:AVAudioPlayer!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    var receivedAudio:RecordedAudio!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func slowButtonPressed(sender: UIButton) {
        
        // slowButtonPressed Action reduces the play rate of the recorded audio file and plays it
        playAudio(0.5)
    }

    @IBAction func fastButtonPressed(sender: UIButton) {
        
        // fastButtonPressed Action increases the play rate of the recorded audio file and plays it
        playAudio(2.0)
    }
    
    @IBAction func chipmunkButtonPressed(sender: UIButton) {
        
        // chipmunkButtonPressed Action raises the pitch level of the recorded audio files and plays the result
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func darthVaderButtonPressed(sender: UIButton) {
        
        // darthVaderButtonPressed Action lowers the pitch level of the recorded audio files and plays the result
        playAudioWithVariablePitch(-1000)
    }
    
    func playAudio(rate:float_t) {
        audioEngine.stop()
        audioPlayer.stop()
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0
        audioPlayer.play()
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        
        // playAudioWithVariablePitch function takes a float as an input, sets the pitch to the inout float and plays the result
        
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        // to use the AVAudioUnitTimePitch class, we first need to create an AVAudioPlayerNode instance and attach this node to the current instance of AVAudioEngine
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        // the pitch propery of AVAudioTimePitch is then sent to the input value and attached to the current instance of AVAudioEngine
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        // connect the current instance of AVAudioEngine to the output speakers
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    @IBAction func reverbButtonPressed(sender: UIButton) {
        
        // reverbButtonPressed Action plays the recorded audio file with added reverb effects. 
        
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        // to use the AVAudioUnitReverb class, we first need to create an AVAudioPlayerNode instance and attach this node to the current instance of AVAudioEngine
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        // the AVAudioUnitReverb class requires the loadFactoryPreset value to be set. As an example loadFactoryPreset is set to "Catherdral", which has a value of "8" based on the switch statement
        var changeReverbEffect = AVAudioUnitReverb()
        changeReverbEffect.loadFactoryPreset(AVAudioUnitReverbPreset(rawValue: 8)!)
        
        // the wetDryMix property is set ot a value between 0 and 100 to blend the amount of wet and dry mix in the audio file
        changeReverbEffect.wetDryMix = 90
        audioEngine.attachNode(changeReverbEffect)
        
        // connect the current instance of AVAudioEngine to the output speakers
        audioEngine.connect(audioPlayerNode, to: changeReverbEffect, format: nil)
        audioEngine.connect(changeReverbEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    
    @IBAction func stopButtonPressed(sender: AnyObject) {
        audioPlayer.stop()
        audioEngine.stop()
    }
}
