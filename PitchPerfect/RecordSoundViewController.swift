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

	struct Alerts {
		static let DismissAlert = "Dismiss"
		static let RecordingFailedError = "Recording Failed Error"
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		stopRecordingButton.isEnabled = false
	}

	func configureUI(isRecording: Bool) {
		recordingLabel.text = isRecording ? "Recording in progress" : "Tap to record"
		stopRecordingButton.isEnabled = isRecording
		recordButton.isEnabled = !isRecording
	}

	@IBAction func record(_ sender: Any) {
		configureUI(isRecording: true)
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
		configureUI(isRecording: false)
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
			showAlert(Alerts.RecordingFailedError, message: nil)
		}
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "stopRecording" {
			let playSoundVC = segue.destination as! PlaySoundsViewController
			let recordedURL = sender as! URL
			playSoundVC.recordedAudioURL = recordedURL
		}
	}
	
	func showAlert(_ title: String, message: String?) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: Alerts.DismissAlert, style: .default, handler: nil))
		self.present(alert, animated: true, completion: nil)
	}
}

