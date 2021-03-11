//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Abhijit Apte on 05/03/21.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
	// MARK: Outlets

	@IBOutlet weak var snailButton: UIButton!
	@IBOutlet weak var chipmunkButton: UIButton!
	@IBOutlet weak var rabbitButton: UIButton!
	@IBOutlet weak var vaderButton: UIButton!
	@IBOutlet weak var echoButton: UIButton!
	@IBOutlet weak var reverbButton: UIButton!
	@IBOutlet weak var stopButton: UIButton!

	var recordedAudioURL:URL!
	var audioFile:AVAudioFile!
	var audioEngine:AVAudioEngine!
	var audioPlayerNode: AVAudioPlayerNode!
	var stopTimer: Timer!

	enum ButtonType: Int {
		case slow = 0, fast, chipmunk, vader, echo, reverb
	}
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		snailButton.imageView?.contentMode = .scaleAspectFit
		chipmunkButton.imageView?.contentMode = .scaleAspectFit
		rabbitButton.imageView?.contentMode = .scaleAspectFit
		vaderButton.imageView?.contentMode = .scaleAspectFit
		echoButton.imageView?.contentMode = .scaleAspectFit
		reverbButton.imageView?.contentMode = .scaleAspectFit
		stopButton.imageView?.contentMode = .scaleAspectFit
		setupAudio()
        // Do any additional setup after loading the view.
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		print("PlaySoundsViewController: \(recordedAudioURL.absoluteURL)")
		configureUI(.notPlaying)
	}
    
	// MARK: Actions

	@IBAction func playSoundForButton(_ sender: UIButton) {
		print("Play Sound Button Pressed")
		switch(ButtonType(rawValue: sender.tag)!) {
		case .slow:
			playSound(rate: 0.5)
		case .fast:
			playSound(rate: 1.5)
		case .chipmunk:
			playSound(pitch: 1000)
		case .vader:
			playSound(pitch: -1000)
		case .echo:
			playSound(echo: true)
		case .reverb:
			playSound(reverb: true)
		}
		
		configureUI(.playing)
	}

	@IBAction func stopButtonPressed(_ sender: AnyObject) {
		print("Stop Audio Button Pressed")
		stopAudio()
	}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
