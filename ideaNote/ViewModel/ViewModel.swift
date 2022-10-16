//
//  ViewModel.swift
//  ideaNote
//
//  Created by kwh on 2022/10/16.
//

import Foundation
import SwiftUI
import Combine

class ViewModel: ObservableObject {
    
    //数据模型
    @Published var noteModels = [NoteItem]()
    
    //笔记参数
    @Published var writeTime: String = ""
    @Published var title: String = ""
    @Published var content: String = ""
    @Published var searchText = ""

    //判断是否正在搜索
    @Published var isSearching:Bool = false
    
    //判断是否是新增
    @Published var isAdd:Bool = true
    
    //打开新建笔记弹窗
    @Published var showNewNoteView:Bool = false
    
    //打开编辑笔记弹窗
    @Published var showEditNoteView:Bool = false
    
    //打开删除确认弹窗
    @Published var showActionSheet:Bool = false
    
    //提示信息
    @Published var showToast = false
    @Published var showToastMessage: String = "提示信息"
    
    // 初始化
    init() {
        loadItems()
        saveItems()
    }
    
    // 获取设备上的文档目录路径
    func documentsDirector() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
   // 获取plist数据文件的路径
    func dataFilePath() -> URL {
        documentsDirector().appendingPathComponent("ideaNote.plist")
    }
    
    // 将文件写入本地存储
    func saveItems() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(noteModels)
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
        } catch {
            print("Error write items to file")
        }
    }
    
    // 从本地存储加载数据
    func loadItems() {
        let path = dataFilePath()
        
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            do {
                noteModels = try decoder.decode([NoteItem].self, from: data)
            } catch {
                print("error reading items")
            }
        }
    }
    
    // 创建笔记
    func addItem(writeTime: String, title: String, content: String){
        let newItem = NoteItem(writeTime: writeTime,title: title, content: content)
        noteModels.append(newItem)
        saveItems()
    }
    
    // 获得数据项ID
    func getItemById(itemId: UUID) -> NoteItem? {
        return noteModels.first(where: { $0.id == itemId}) ?? nil
    }
    
    // 删除笔记
    func deleteItem(itemId: UUID) {
        noteModels.removeAll(where:  { $0.id == itemId})
        saveItems()
    }
    
    // 编辑笔记
    func editItem(item: NoteItem) {
        if let id = noteModels.firstIndex(where: { $0.id == item.id}) {
            noteModels[id] = item
            saveItems()
        }
    }
    
    // 搜索
    func searchContent() {
        let query = searchText.lowercased()
        DispatchQueue.global(qos: .background).async {
            let filter = self.noteModels.filter{ $0.content.lowercased().contains(query) }
            DispatchQueue.main.async {
                self.noteModels = filter
            }
        }
    }
    
    // 获取当前时间
    func getCurrentTime() -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "YYYY.MM.dd"
        return dateformatter.string(from: Date())
    }
    
    func isNull(text: String) -> Bool {
        if text == "" {
            return true
        }
        return false
    }
    
}

