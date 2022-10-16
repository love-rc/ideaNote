//
//  noteRow.swift
//  ideaNote
//
//  Created by kwh on 2022/10/12.
//

import SwiftUI

struct noteRow: View {
    @EnvironmentObject var viewModel: ViewModel
    var itemId: UUID
    var item: NoteItem? {
        return viewModel.getItemById(itemId: itemId)
    }
    
    var body: some View {
        HStack {
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text(item?.writeTime ?? "")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    Text(item?.title ?? "")
                        .font(.system(size: 17))
                        .foregroundColor(.black)
                    Text(item?.content ?? "")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .lineLimit(1)
                        .multilineTextAlignment(.leading)
                }
            }
            
            // 点击编辑
            .onTapGesture {
                self.viewModel.isAdd = false
                self.viewModel.showEditNoteView = true
            }
            
            Spacer()
            
            // 更多操作
            Button {
                viewModel.showActionSheet = true
            } label: {
                Image(systemName: "ellipsis")
                    .foregroundColor(.gray)
                    .font(.system(size: 23))
            }
        }
        // 编辑笔记
       .sheet(isPresented: $viewModel.showEditNoteView){
           NewNoteView(noteItem: self.item ?? NoteItem(writeTime: "", title: "", content: ""))
       }
        
        // 删除笔记
       .actionSheet(isPresented: self.$viewModel.showActionSheet) {
           ActionSheet(title: Text("你确定要删除此项？"), message: nil, buttons: [
            .destructive(Text("删除"), action: {
                self.viewModel.deleteItem(itemId: itemId)
            }),
            .cancel(Text("取消"))
           ])
               
       }
        
    }
    
}

struct noteRow_Previews: PreviewProvider {
    static var previews: some View {
        noteRow(itemId: ViewModel().noteModels[0].id).environmentObject(ViewModel())
    }
}
