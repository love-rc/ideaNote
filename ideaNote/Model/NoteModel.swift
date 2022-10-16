//
//  NoteModel.swift
//  ideaNote
//
//  Created by kwh on 2022/10/12.
//

import Foundation
import SwiftUI

class NoteItem: Identifiable,Codable {
    var id = UUID()
    var writeTime: String
    var title: String
    var content: String
    
    init(writeTime: String, title: String, content: String) {
        self.writeTime = writeTime
        self.title = title
        self.content = content
    }
}
