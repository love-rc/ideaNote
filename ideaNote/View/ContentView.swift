//
//  ContentView.swift
//  ideaNote
//
//  Created by kwh on 2022/10/12.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: ViewModel
        
    var body: some View {
        NavigationView {
            ZStack{
                if viewModel.isSearching == false && viewModel.noteModels.count == 0 {
                    noDataView()
                } else {
                    VStack {
                        searchBarView()
                        noteList()
                    }
                }
                if !viewModel.isSearching {
                    newBtnView()
                }
            }
            .navigationTitle("idea 笔记")
            .navigationBarTitleDisplayMode(.inline)
        }.sheet(isPresented: $viewModel.showNewNoteView) {
            NewNoteView(noteItem: NoteItem(writeTime: "", title: "", content: ""))
        }
        
    }
    
    // 缺省图
    func noDataView() -> some View {
        VStack(alignment: .center, spacing: 20) {
            Text("记录下这个世界")
                .font(.system(size: 17))
                .bold()
                .foregroundColor(.gray)
        }
    }
    
    // 新建笔记按钮
    func newBtnView() -> some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    self.viewModel.isAdd = true
                    self.viewModel.writeTime = viewModel.getCurrentTime()
                    self.viewModel.title = ""
                    self.viewModel.content = ""
                    self.viewModel.showNewNoteView = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 48))
                        .foregroundColor(.blue)
                }

            }
        }
        .padding(.bottom, 32)
        .padding(.trailing, 32)
    }
    
    // 搜索
    func searchBarView() -> some View {
        TextField("搜索内容",text: $viewModel.searchText)
            .padding(7)
            .padding(.horizontal, 25)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .overlay(
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .frame(minWidth: 0,maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 8)
                    
                    // 编辑时显示清除按钮
                    if viewModel.searchText != "" {
                        Button {
                            self.viewModel.searchText = ""
                            self.viewModel.loadItems()
                        } label: {
                            Image(systemName: "multiply.circle.fill")
                                .foregroundColor(.gray)
                                .padding(.trailing, 8)
                        }

                    }
                }
            )
            .padding(.horizontal, 10)
            .onChange(of: viewModel.searchText) { _ in
                if viewModel.searchText != "" {
                    self.viewModel.isSearching = true
                    self.viewModel.searchContent()
                } else {
                    viewModel.searchText = ""
                    self.viewModel.isSearching = false
                    self.viewModel.loadItems()
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ViewModel())
    }
}
