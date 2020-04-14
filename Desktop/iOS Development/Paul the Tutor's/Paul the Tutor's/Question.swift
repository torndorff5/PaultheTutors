//
//  Question.swift
// 
//
//  Created by codeslinger on 9/17/19.

import Foundation


class Question {
    let text : String
    let answer : String
    init(text: String, correctAnswer: String){
        self.text = text
        self.answer = correctAnswer
    }
}
