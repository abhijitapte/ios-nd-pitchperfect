//
//  RecordSoundViewController.swift
//  PitchPerfect
//
//  Created by Abhijit Apte on 04/03/21.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {
	@IBOutlet weak var recordButton: UIButton!
	@IBOutlet weak var stopRecordingButton: UIButton!
	@IBOutlet weak var recordingLabel: UILabel!
	var audioRecorder: AVAudioRecorder!

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		stopRecordingButton.isEnabled = false
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		print("view will appear")
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		print("view did appear")
	}
	
	@IBAction func record(_ sender: Any) {
		recordingLabel.text = "Recording in progress"
		stopRecordingButton.isEnabled = true
		recordButton.isEnabled = false
//		print("record pressed")
		
		
		let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
		let recordingName = "recordedVoice.wav"
		let pathArray = [dirPath, recordingName]
		let filePath = URL(string: pathArray.joined(separator: "/"))
		
		let session = AVAudioSession.sharedInstance()
		try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
		
		try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
		audioRecorder.isMeteringEnabled = true
		audioRecorder.prepareToRecord()
		audioRecorder.record()
		audioRecorder.delegate = self
	}
	

	@IBAction func stopRecord(_ sender: Any) {
//		print("stop record pressed")
		stopRecordingButton.isEnabled = false
		recordButton.isEnabled = true
		recordingLabel.text = "Tap to record"
		
		audioRecorder.stop()
		let audioSession = AVAudioSession.sharedInstance()
		try! audioSession.setActive(false)
	}
	
	func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder,
									 successfully flag: Bool)
	{
		if flag {
			performSegue(withIdentifier: "stopRecording", sender: recorder.url)
			print(recorder.url.absoluteURL)
			
		} else {
			print("recording failed!")
		}
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "stopRecording" {
			let playSoundVC = segue.destination as! PlaySoundsViewController
			let recordedURL = sender as! URL
			playSoundVC.recordedAudioURL = recordedURL
		}
	}
}

