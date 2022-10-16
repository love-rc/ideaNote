//
//  NewNoteView.swift
//  ideaNote
//
//  Created by kwh on 2022/10/12.
//

import SwiftUI

struct NewNoteView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    @State var noteItem: NoteItem
    
    // 关闭弹窗
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack{
                Divider()
                titleView()
                Divider()
                contentView()
            }
            .navigationTitle(viewModel.isAdd ? "新建笔记" : "编辑笔记")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(leading: closeBtnView(), trailing: saveBtnView())
                .toast(present: $viewModel.showToast, message: $viewModel.showToastMessage, alignment: .center)

        }
    }
    
    // 关闭
    func closeBtnView() -> some View {
        Button {
            self.presentationMode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "xmark.circle.fill")
                .font(.system(size: 17))
                .foregroundColor(.gray)
        }

    }
    
    // 完成
    
    func saveBtnView() -> some View {
        Button {
            if viewModel.isAdd {
                if viewModel.isNull(text: viewModel.title) {
                    viewModel.showToastMessage = "请输入标题"
                    viewModel.showToast = true
                }
                else if viewModel.isNull(text: viewModel.content) {
                    viewModel.showToastMessage = "请输入内容"
                    viewModel.showToast = true
                } else {
                    self.viewModel.addItem(writeTime: viewModel.getCurrentTime(), title: viewModel.title, content: viewModel.content)
                    self.presentationMode.wrappedValue.dismiss()
                }
            } else {
                if viewModel.isNull(text: noteItem.title) {
                    viewModel.showToastMessage = "请输入标题"
                    viewModel.showToast = true
                }
                else if viewModel.isNull(text: noteItem.content) {
                    viewModel.showToastMessage = "请输入内容"
                    viewModel.showToast = true
                } else {
                    self.viewModel.editItem(item: noteItem)
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        
        } label: {
            Text("完成")
                .font(.system(size: 17))
        }

    }
    
    // 标题输入框
    func titleView() -> some View {
        TextField("请输入标题", text: viewModel.isAdd ? $viewModel.title : $noteItem.title)
        .padding()
    }
    
    // 内容输入
    
    func contentView() -> some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: viewModel.isAdd ? $viewModel.content : $noteItem.content)
                .font(.system(size: 17))
                .padding()
            if viewModel.isAdd ? (viewModel.content.isEmpty) : (noteItem.content.isEmpty) {
                Text("请输入内容")
                    .foregroundColor(Color(UIColor.placeholderText))
                    .padding(20)
            }
        }
    }
    
}

struct NewNoteView_Previews: PreviewProvider {
    static var previews: some View {
        NewNoteView(noteItem: NoteItem(writeTime: "", title: "", content: "")).environmentObject(ViewModel())
    }
}
