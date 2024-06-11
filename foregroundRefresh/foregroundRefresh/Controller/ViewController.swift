//
//  ViewController.swift
//  foregroundRefresh
//
//  Created by Ashfak Ahamed Alauddeen on 09/06/24.
//

import UIKit


class ViewController: UIViewController {
    
    
    
    @IBOutlet var timerView: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var timerStatusLabel: UILabel!
    @IBOutlet weak var timerButton: UIButton!
    @IBOutlet weak var timerReset: UIButton!
    
    var isTimerOn: String = "false"
    var timer: Timer?
    var seconds = 0
    var start: Double = 0
    var end: Double = 216000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: Notification.Name("AppWillEnterForeground"), object: nil)
        timerButton.setTitle("Start", for: .normal)
        timerReset.setTitle("Reset", for: .normal)
        timerButton.tintColor = .green
        timerReset.tintColor = .orange
    }
    
    deinit {
            // Remove observer when the view controller is deallocated
        NotificationCenter.default.removeObserver(self, name: Notification.Name("AppWillEnterForeground"), object: nil)
    }
    
    @objc func refreshData() {
        // Implement your data refreshing logic here
        print("App is entering foreground - refresh data")
        self.timer?.invalidate()
        timerView.reloadInputViews()
        timerLabel.text = "00h : 00m : 00s"
        seconds = 0
        timerButton.setTitle("Start", for: .normal)
        timerReset.setTitle("Reset", for: .normal)
        timerButton.tintColor = .green
        timerReset.tintColor = .orange
    }
    
    @IBAction func timerButtonTapped(_ sender: Any) {
        
        if isTimerOn == "false"{
            isTimerOn = "true"
            timerButton.setTitle("Stop", for: .normal)
            timerButton.tintColor = .red
            self.timer?.invalidate()
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer(_:)), userInfo: timerLabel, repeats: true)
        }else{
            self.timer?.invalidate()
            isTimerOn = "false"
            timerButton.setTitle("Start", for: .normal)
            timerButton.tintColor = .green
        }
    }
    
    @objc func updateTimer(_ timer: Timer) {
    
        guard let label = timer.userInfo as? UILabel else { return }
        if start <= end {
            seconds += 1
            start += 1
            
        } else {
            self.timer?.invalidate()
            self.timer = nil
        }
           
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let secs = seconds % 60
        let formattedTime = String(format: "%02dh : %02dm : %02ds", hours, minutes, secs)
        label.text = formattedTime
    }
    
    
    @IBAction func resetButtonTapped(_ sender: Any) {
        self.timer?.invalidate()
        timerLabel.text = "00h : 00m : 00s"
        seconds = 0
    }
    
}

