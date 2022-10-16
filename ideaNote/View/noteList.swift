//
//  noteList.swift
//  ideaNote
//
//  Created by kwh on 2022/10/12.
//

import SwiftUI

struct noteList: View {
    @EnvironmentObject var viewModel: ViewModel
    var body: some View {
        List {
            ForEach(viewModel.noteModels){ noteItem in
                noteRow(itemId: noteItem.id)
            }
        }
        .listStyle(InsetListStyle())
    }
}

struct noteList_Previews: PreviewProvider {
    static var previews: some View {
        noteList().environmentObject(ViewModel())
    }
}
