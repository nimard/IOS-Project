//
//  ViewController.swift
//  WarApp
//
//  Created by Nima on 1/28/19.
//  Copyright © 2019 Nima. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController4: UIViewController {
    
    var timer: Timer!
    var help: Timer!
    var helpNum = 10
    var yellowScore = 0
    var blueScore = 0
    var greenScore = 0
    var check = 0
    var start = 0
    var gamesData: [Substring]!
    var randomNum = 0
    var helpPoint = 0
    var pas = [0, 0, 0]
    var customView: UIView!
    var win = 0
    
    @IBOutlet weak var wordButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var blueImageView: UIImageView!
    @IBOutlet weak var yellowImageView: UIImageView!
    @IBOutlet weak var greenImageView: UIImageView!
    @IBOutlet weak var blueScoreLabel: UILabel!
    @IBOutlet weak var yellowScoreLabel: UILabel!
    @IBOutlet weak var greenScoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var contents: String!
        if let filepath = Bundle.main.path(forResource: "words", ofType: "txt") {
            do {
                contents = try String(contentsOfFile: filepath)
            } catch {
                // contents could not be loaded
            }
        } else {
            // example.txt not found!
        }
        
        gamesData = Array(contents.split(separator: "\n"))
    }
    
    
    private func loadCustomView(){
        let customViewFrame = CGRect(x: 0, y: 150, width: view.frame.width, height: view.frame.height)
        var winColor = UIColor.black
        
        if yellowScore > blueScore && yellowScore > greenScore{
            winColor = UIColor.yellow
        }
        if blueScore > yellowScore && blueScore > greenScore{
            winColor = UIColor.blue
        }
        if greenScore > yellowScore && blueScore < greenScore{
            winColor = UIColor.green
        }
        customView = UIView(frame: customViewFrame)
        
        view.addSubview(customView)
        
        customView.isHidden = false
        
        let winButtonFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        let winButton = UIButton(frame: winButtonFrame)
        
        winButton.backgroundColor = winColor
        
        winButton.addTarget(self, action: #selector(backTo), for: .touchUpInside)
        customView.addSubview(winButton)
        
    }
    
    @objc func backTo (){
    }
    
    @IBAction func nextWordFunc(_ sender: Any) {
        if helpNum < 0 {
            helpButton.titleLabel?.textColor = UIColor.red
            helpNum = 10
            randomNum = Int.random(in: 10..<7000)
        wordButton.setTitle(String(gamesData[randomNum]), for: .normal)
            helpPoint += 1
        }
    }
    
    @IBAction func changeWord(_ sender: Any) {
        helpNum = 10
        helpButton.titleLabel?.textColor = UIColor.red
        
        randomNum = Int.random(in: 10..<7000)
        wordButton.setTitle(String(gamesData[randomNum]), for: .normal)
        
        if start == 0 {
            timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(blueImageFunc), userInfo: nil, repeats: true)
            
            help = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(helpFunc), userInfo: nil, repeats: true)
            
            start = 1
            check = 1
        } else {
            if check == 0 {
                check = 1
                if pas[2] == 0 {
                    greenScore += 1
                    greenScore -= helpPoint
                    helpPoint = 0
                    greenScoreLabel.text = String(greenScore)
                }
                if pas[0] == 0 {
                    timer.invalidate()
                    timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(blueImageFunc), userInfo: nil, repeats: true)
                }else {
                    self.changeWord(1)
                }
                
            }else if check == 1{
                check = 2
                if pas[0] == 0 {
                    blueScore += 1
                    blueScore -= helpPoint
                    helpPoint = 0
                    blueScoreLabel.text = String(blueScore)
                }
                if pas[1] == 0 {
                    timer.invalidate()
                    timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(yellowImageFunc), userInfo: nil,          repeats: true)
                }else {
                    self.changeWord(1)
                }
            }else {
                check = 0
                if pas[1] == 0 {
                    yellowScore += 1
                    yellowScore -= helpPoint
                    helpPoint = 0
                    yellowScoreLabel.text = String(yellowScore)
                }
                if pas[2] == 0 {
                    timer.invalidate()
                    timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(greenImageFunc), userInfo: nil,          repeats: true)
                }else {
                    self.changeWord(1)
                }
            }
        }
    }
    
    @objc func helpFunc() {
        helpNum -= 1
        if helpNum < 0 {
            helpButton.titleLabel?.textColor = UIColor.green
        }
    }
    
    @objc func blueImageFunc() {
        let frame = CGRect(x: blueImageView.frame.origin.x, y: blueImageView.frame.origin.y, width: blueImageView.frame.width-1, height: blueImageView.frame.height)
        if frame.width <= 1 {
            helpPoint += 1
            pas[0] = 1
            win += 1
            if win == 2 {
                loadCustomView()
            }
            self.changeWord(1)
        }
        blueImageView.frame = frame
    }
    
    @objc func yellowImageFunc() {
        let frame = CGRect(x: yellowImageView.frame.origin.x, y: yellowImageView.frame.origin.y, width: yellowImageView.frame.width-1, height: yellowImageView.frame.height)
        if frame.width <= 1 {
            helpPoint += 1
            pas[1] = 1
            win += 1
            if win == 2 {
                loadCustomView()
            }
            self.changeWord(1)
        }
        yellowImageView.frame = frame
    }
    
    @objc func greenImageFunc() {
        let frame = CGRect(x: greenImageView.frame.origin.x, y: greenImageView.frame.origin.y, width: greenImageView.frame.width-1, height: greenImageView.frame.height)
        if frame.width <= 1 {
            helpPoint += 1
            pas[2] = 1
            win += 1
            if win == 2 {
                loadCustomView()
            }
            self.changeWord(1)
        }
        greenImageView.frame = frame
    }
    
}

