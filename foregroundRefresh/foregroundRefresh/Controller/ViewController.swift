//
//  ViewController.swift
//  foregroundRefresh
//
//  Created by Ashfak Ahamed Alauddeen on 09/06/24.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var timerStatusLabel: UILabel!
    @IBOutlet weak var timerButton: UIButton!
    @IBOutlet weak var timerReset: UIButton!
    
    var networkHelper = NetworkHelper()
    var timerModel: TimerModel?
    var isTimerOn: String = "false"
    var timer: Timer?
    var seconds = 0
    var start: Double = 0
    var end: Double = 216000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkHelper.delegate = self
        networkHelper.callGetObjects()
        timerButton.setTitle("Start", for: .normal)
        timerReset.setTitle("Reset", for: .normal)
        timerButton.tintColor = .green
        timerReset.tintColor = .orange
        self.timerModel?.data.isTimerRunning = "false"
        self.timerModel?.data.status = "Reset"
    }
    
    @IBAction func timerButtonTapped(_ sender: Any) {
        
        if isTimerOn == "false"{
            isTimerOn = "true"
            self.timerModel?.data.status = "Started"
            timerButton.setTitle("Stop", for: .normal)
            timerButton.tintColor = .red
            self.timer?.invalidate()
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer(_:)), userInfo: timerLabel, repeats: true)
        }else{
            self.timer?.invalidate()
            isTimerOn = "false"
            self.timerModel?.data.status = "Stopped"
            timerButton.setTitle("Start", for: .normal)
            timerButton.tintColor = .green
        }
        self.timerModel?.data.isTimerRunning = isTimerOn
        if let timerModel = self.timerModel{
            networkHelper.makePutRequest(timerModel)
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
        self.timerModel?.data.status = "reset"
        self.timerModel?.data.isTimerRunning = "false"
        if let timerModel = self.timerModel{
            networkHelper.makePutRequest(timerModel)
        }
        timerLabel.text = "00h : 00m : 00s"
        seconds = 0
    }
    
}

extension ViewController: TimerDelegate{
    
    func getTimerModel(from timerModel: TimerModel) {
        self.timerModel = timerModel
        DispatchQueue.main.async {
            print("\(timerModel)")
        }
    }
    
}

