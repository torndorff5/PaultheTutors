//
//  QuestionBank.swift
//
//
//  Created by codeslinger on 9/17/19.
//
//

import Foundation


class QuestionBank {
    var list = [Question]()

    init(questions: [Question]) {
        // Creating a quiz item and appending it to the list
        self.list = questions
    }
}
