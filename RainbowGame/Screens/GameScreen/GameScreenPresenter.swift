//
//  GameLogic.swift
//  RainbowGame
//
//  Created by Victor on 12.11.2023.
//

import UIKit

final class GameScreenPresenter: GameScreenOutput {
    weak var view: GameScreenInput?
    
    var roundTime = 12
    var colorChangeTime = 1
    var remaningTime = 0
    var interColorTime = 0
    
    private var timer: Timer?
    private var previousColor: GameColor?
    private var randomColor: GameColor {
        var randomColor = GameColor.allCases.randomElement()!
        while randomColor == previousColor {
            randomColor = GameColor.allCases.randomElement()!
        }
        previousColor = randomColor
        return randomColor
    }
    
    func activate() {
        start()
    }
    
    private func start() {
        remaningTime = roundTime
        interColorTime = colorChangeTime
        view?.updateTitle("\(remaningTime)")
        updateColor()
        
        timer = Timer.scheduledTimer(
            withTimeInterval: 1.0,
            repeats: true,
            block: {
                [weak self] _ in
                
                self?.timerFired()
            }
        )
    }
    
    func timerFired() {
        if remaningTime <= 0 {
            timer?.invalidate()
            timer = nil
            return
        }
        remaningTime -= 1
        view?.updateTitle("\(remaningTime)")
        
        interColorTime -= 1
        if interColorTime <= 0 {
            updateColor()
            interColorTime = colorChangeTime
        }
    }
    
    private func updateColor() {
        let randomColor = self.randomColor
        let fakeColor = randomColor.fakeColor
        view?.updateWith(
            .init(
                color: .init(
                    text: randomColor.fakeColor.name,
                    textColor: .white,
                    frame: .init(color: randomColor.color),
                    didSelectHandler: {
                        print("123")
                    }
                )
            )
        )
    }
}

extension GameScreenPresenter {
    private enum GameColor: CaseIterable {
        case red, blue, yellow, green, purple
        
        var name: String {
            switch self {
            case .red:
                return "Красный"
            case .blue:
                 return "Синий"
            case .yellow:
                return "Желтый"
            case .green:
                return "Зеленый"
            case .purple:
                return "Фиолетовый"
            }
        }
        
        var fakeColor: Self {
            GameColor.allCases.filter { $0 != self }.randomElement()!
        }
        
        var color: UIColor {
            switch self {
            case .red:
                Colors.Cards.red
            case .blue:
                Colors.Cards.blue
            case .yellow:
                Colors.Cards.yellow
            case .green:
                Colors.Cards.green
            case .purple:
                Colors.Cards.purple
            }
        }
    }
}
