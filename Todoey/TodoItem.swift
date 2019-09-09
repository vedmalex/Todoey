//
//  model.swift
//  Todoey
//
//  Created by Алексей Ведмеденко on 05/09/2019.
//  Copyright © 2019 Алексей Ведмеденко. All rights reserved.
//

import Foundation

class TodoItem: Codable {
    var title: String = ""
    var done: Bool = false
    init(_ _title: String?, done: Bool = false){
        if let title = _title {
            self.title = title
        }
        if done {
            self.done = done
        }
    }
}
