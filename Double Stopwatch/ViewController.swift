//
//  ViewController.swift
//  Double Stopwatch v2
//
//  Created by Jeremiah Mullane on 8/16/18.
//  Copyright © 2018 Jeremiah Mullane. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // Outlets for Timer A labels
    @IBOutlet weak var labelMillisecsA: UILabel!
    @IBOutlet weak var labelSecsA: UILabel!
    @IBOutlet weak var labelMinsA: UILabel!
    @IBOutlet weak var labelHrsA: UILabel!
    
    // Outlets for Timer A buttons
    @IBOutlet weak var buttonLapResetA: UIButton!
    @IBOutlet weak var buttonStartStopA: UIButton!
    
    // Timer A variables
    weak var timerA: Timer?
    var startTimeA: Double = 0
    var timeA: Double = 0
    var elapsedA: Double = 0
    var lapSumA: Double = 0
    var runningA: Bool = false
    
    
    // Outlets for Timer B labels
    @IBOutlet weak var labelMillisecsB: UILabel!
    @IBOutlet weak var labelSecsB: UILabel!
    @IBOutlet weak var labelMinsB: UILabel!
    @IBOutlet weak var labelHrsB: UILabel!
    
    // Outlets for Timer B buttons
    @IBOutlet weak var buttonLapResetB: UIButton!
    @IBOutlet weak var buttonStartStopB: UIButton!
    
    //Outlet for Timer B Lap Table
    @IBOutlet weak var LapTableViewB: UITableView!
    
    // Timer B variables
    weak var timerB: Timer?
    var startTimeB: Double = 0
    var timeB: Double = 0
    var elapsedB: Double = 0
    var lapSumB: Double = 0
    var runningB: Bool = false
    
    //TEST VARIABLES FOR TABLEVIEW
    var lapBdata : [Double] = []
    
    //----------------------------------
    // Standard inherited view functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //TESTING TABLEVIEW
        LapTableViewB.delegate = self
        LapTableViewB.dataSource = self
        for _ in 0...5 {
            lapBdata.append(0.0)
        }
        
        buttonLapResetA.isEnabled = false
        buttonLapResetB.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lapBdata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        cell = tableView.dequeueReusableCell(withIdentifier: "cellB", for: indexPath)
        cell.textLabel?.text = String(lapBdata[indexPath.row])
        cell.textLabel?.textColor = UIColor.white
        cell.backgroundColor = UIColor.black
        return cell
    }
    //----------------------------------
    
    
    //TimerA Functions------------------
    
    // When TimerA Start/Stop Button is clicked
    @IBAction func clickStartStopA(_ sender: Any) {
        //If Timer is running, stop it, then update buttons
        if runningA {
            stopTimerA()
            buttonStartStopA.setTitle("Start", for: .normal)
            buttonStartStopA.setTitleColor(UIColor.green, for: .normal)
            buttonLapResetA.setTitle("Reset", for: .normal)
        }
        //If Timer is not running, start it, then update buttons
        else {
            startTimerA()
            buttonStartStopA.setTitle("Stop", for: .normal)
            buttonStartStopA.setTitleColor(UIColor.red, for: .normal)
            buttonLapResetA.setTitle("Lap", for: .normal)
            buttonLapResetA.setTitleColor(UIColor.white, for: .normal)
            buttonLapResetA.isEnabled = true
        }
    }
    
    // When TimerA Lap/Reset Button is clicked
    @IBAction func clickLapResetA(_ sender: Any) {
        //If Timer is running, save lap time
        if runningA {
            lapTimerA()
        }
        //If Timer is not running, reset timer  and reset buttons
        else {
            resetTimerA()
            buttonLapResetA.setTitle("Lap", for: .normal)
            buttonLapResetA.setTitleColor(UIColor.lightGray, for: .normal)
            buttonLapResetA.isEnabled = false
        }
    }
    
    //Start TimerA, set running status to true
    func startTimerA() {
        startTimeA = Date().timeIntervalSinceReferenceDate - elapsedA
        timerA = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateCounterA), userInfo: nil, repeats: true)
        runningA = true
    }
    
    //Stop TimerA, set running status to false
    func stopTimerA() {
        elapsedA = Date().timeIntervalSinceReferenceDate - startTimeA
        timerA?.invalidate()
        runningA = false
    }
    
    //Reset TimerA and all variables
    func resetTimerA() {
        timerA?.invalidate()
        startTimeA = 0
        timeA = 0
        elapsedA = 0
        lapSumA = 0
        
        labelHrsA.text = "00"
        labelMinsA.text = "00"
        labelSecsA.text = "00"
        labelMillisecsA.text = "00"
        runningA = false
    }
    
    //Insert future TimerA lap function here
    func lapTimerA() {
        var laptimeA = Date().timeIntervalSinceReferenceDate - startTimeA - lapSumA
        lapSumA += laptimeA
        
        let hours = Int(laptimeA / 3600.0)
        laptimeA -= (TimeInterval(hours) * 3600)
        
        let minutes = Int(laptimeA / 60.0)
        laptimeA -= (TimeInterval(minutes) * 60)
        
        let seconds = Int(laptimeA)
        laptimeA -= TimeInterval(seconds)
        
        let milliseconds = Int(laptimeA * 100)
        
        let lapStringA = String(format: "%02d:%02d:%02d.%02d", hours, minutes, seconds, milliseconds)
        
        print("Lap Time A " + lapStringA)
    }
    
    //update TimerA counter display
    @objc func updateCounterA() {
        timeA = Date().timeIntervalSinceReferenceDate - startTimeA
        
        let hours = Int(timeA / 3600.0)
        timeA -= (TimeInterval(hours) * 3600)
        
        let minutes = Int(timeA / 60.0)
        timeA -= (TimeInterval(minutes) * 60)
        
        let seconds = Int(timeA)
        timeA -= TimeInterval(seconds)
        
        let milliseconds = Int(timeA * 100)
        
        let strHrs = String(format: "%02d", hours)
        let strMins = String(format: "%02d", minutes)
        let strSecs = String(format: "%02d", seconds)
        let strMillisecs = String(format: "%02d", milliseconds)
        
        labelHrsA.text = strHrs
        labelMinsA.text = strMins
        labelSecsA.text = strSecs
        labelMillisecsA.text = strMillisecs
    }
    
    
    //TimerB Functions------------------

    // When TimerB Start/Stop Button is clicked
    @IBAction func clickStartStopB(_ sender: Any) {
        //If Timer is running, stop it, then update buttons
        if runningB {
            stopTimerB()
            buttonStartStopB.setTitle("Start", for: .normal)
            buttonStartStopB.setTitleColor(UIColor.green, for: .normal)
            buttonLapResetB.setTitle("Reset", for: .normal)
        }
            //If Timer is not running, start it, then update buttons
        else {
            startTimerB()
            buttonStartStopB.setTitle("Stop", for: .normal)
            buttonStartStopB.setTitleColor(UIColor.red, for: .normal)
            buttonLapResetB.setTitle("Lap", for: .normal)
            buttonLapResetB.setTitleColor(UIColor.white, for: .normal)
            buttonLapResetB.isEnabled = true
        }
    }
    
    // When TimerB Lap/Reset Button is clicked
    @IBAction func clickLapResetB(_ sender: Any) {
        //If Timer is running, save lap time
        if runningB {
            lapTimerB()
        }
            //If Timer is not running, reset timer  and reset buttons
        else {
            resetTimerB()
            buttonLapResetB.setTitle("Lap", for: .normal)
            buttonLapResetB.setTitleColor(UIColor.lightGray, for: .normal)
            buttonLapResetB.isEnabled = false
        }
    }
    
    //Start TimerB, set running status to true
    func startTimerB() {
        startTimeB = Date().timeIntervalSinceReferenceDate - elapsedB
        timerB = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateCounterB), userInfo: nil, repeats: true)
        runningB = true
    }
    
    //Stop TimerB, set running status to false
    func stopTimerB() {
        elapsedB = Date().timeIntervalSinceReferenceDate - startTimeB
        timerB?.invalidate()
        runningB = false
    }
    
    //Reset TimerB and all variables
    func resetTimerB() {
        timerB?.invalidate()
        startTimeB = 0
        timeB = 0
        elapsedB = 0
        lapSumB = 0
        runningB = false
        
        labelHrsB.text = "00"
        labelMinsB.text = "00"
        labelSecsB.text = "00"
        labelMillisecsB.text = "00"
    }
    
    //Insert future TimerB lap function here
    func lapTimerB() {
        var laptimeB = Date().timeIntervalSinceReferenceDate - startTimeB - lapSumB
        lapSumB += laptimeB
        
        let hours = Int(laptimeB / 3600.0)
        laptimeB -= (TimeInterval(hours) * 3600)
        
        let minutes = Int(laptimeB / 60.0)
        laptimeB -= (TimeInterval(minutes) * 60)
        
        let seconds = Int(laptimeB)
        laptimeB -= TimeInterval(seconds)
        
        let milliseconds = Int(laptimeB * 100)
        
        let lapStringB = String(format: "%02d:%02d:%02d.%02d", hours, minutes, seconds, milliseconds)
        
        print("Lap Time B " + lapStringB)
    }
    
    //update TimerB counter display
    @objc func updateCounterB() {
        timeB = Date().timeIntervalSinceReferenceDate - startTimeB
        
        let hours = Int(timeB / 3600.0)
        timeB -= (TimeInterval(hours) * 3600)
        
        let minutes = Int(timeB / 60.0)
        timeB -= (TimeInterval(minutes) * 60)
        
        let seconds = Int(timeB)
        timeB -= TimeInterval(seconds)
        
        let milliseconds = Int(timeB * 100)
        
        let strHrs = String(format: "%02d", hours)
        let strMins = String(format: "%02d", minutes)
        let strSecs = String(format: "%02d", seconds)
        let strMillisecs = String(format: "%02d", milliseconds)
        
        labelHrsB.text = strHrs
        labelMinsB.text = strMins
        labelSecsB.text = strSecs
        labelMillisecsB.text = strMillisecs
    }
    
    
}

