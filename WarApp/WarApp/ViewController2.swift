//
//  ViewController.swift
//  WarApp
//
//  Created by Nima on 1/28/19.
//  Copyright © 2019 Nima. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController2: UIViewController {

    var randomNum = 0
    var timer: Timer!
    var help: Timer!
    var helpNum = 10
    var yellowScore = 0
    var blueScore = 0
    var check = 0
    var start = 0
    var helpPoint = 0
    var win = 0
    var pas = [0, 0]
    
    @IBOutlet weak var wordButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var blueImageView: UIImageView!
    @IBOutlet weak var yellowImageView: UIImageView!
    @IBOutlet weak var blueScoreLabel: UILabel!
    @IBOutlet weak var yellowScoreLabel: UILabel!
    var gamesData: [Substring]!
    
    var customView: UIView!
    
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
        
        if yellowScore > blueScore{
            winColor = UIColor.yellow
        }
        if blueScore > yellowScore {
            winColor = UIColor.blue
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
    
    @IBAction func wordChange(_ sender: Any) {
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
                if pas[1] == 0 {
                    yellowScore += 1
                    yellowScore -= helpPoint
                    helpPoint = 0
                    yellowScoreLabel.text = String(yellowScore)
                }
                if pas[0] == 0 {
                    timer.invalidate()
                    timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(blueImageFunc), userInfo: nil, repeats: true)
                }else {
                    self.wordChange(1)
                }
            
            }else {
                check = 0
                
                if pas[0] == 0 {
                    blueScore += 1
                    blueScore -= helpPoint
                    helpPoint = 0
                    blueScoreLabel.text = String(blueScore)
                    
                }
                if (pas[1] == 0){
                    timer.invalidate()
                    timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(yellowImageFunc), userInfo: nil,          repeats: true)
                }else {
                    self.wordChange(1)
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
            if win == 1 {
                loadCustomView()
            }
            self.wordChange(1)
        }
        
        blueImageView.frame = frame
    }
    
    @objc func yellowImageFunc() {
        let frame = CGRect(x: yellowImageView.frame.origin.x, y: yellowImageView.frame.origin.y, width: yellowImageView.frame.width-1, height: yellowImageView.frame.height)
        
        if frame.width <= 1 {
            helpPoint += 1
            pas[1] = 1
            win += 1
            if win == 1 {
                loadCustomView()
            }
            self.wordChange(1)
        }
        
        yellowImageView.frame = frame
    }
}

