//
//  ContentView.swift
//  BreadJournal
//
//  Created by Michel Goñi on 3/1/24.
//

import ComposableArchitecture
import SwiftUI

@Reducer

struct BreadJournalReducer {
    
    struct State {
        var journalEntries: IdentifiedArrayOf<Entry> = []
        
    }
    
    
    enum Action {
        
        
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
                
                
            }
        }
    }
}
 

struct BreadJournalListView: View {
    
    private  var columns: [GridItem] {
        switch UIScreen.main.bounds.width {
        case _ where UIScreen.main.bounds.width > 400:
            return [GridItem(.flexible()), GridItem(.flexible())]
        default:
            return [GridItem(.flexible())]
        }
    }
    
    private var entries = Entry.all
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(
                    columns: columns,
                    spacing: 16) {
                        ForEach(entries) { entry in
                            JournalEntryView.init(entry: entry)
                        }
                    }
                    .padding(.all, 46)
            }
            .navigationTitle("Title goes here")
            .toolbar {
                ToolbarItemGroup(placement: .primaryAction) {
                    Button {
                        
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.black)
                            .font(
                                .system(
                                    size: 40,
                                    weight: .light)
                            )
                    }
                    .padding(.top, 48)
                    Spacer()
                    Button {
                        print("Filter tapped!")
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle.fill")
                            .foregroundColor(.black)
                            .font(
                                .system(
                                    size: 40,
                                    weight: .light)
                            )
                    }
                    .padding(.top, 48)
                }
            }
            
        }
        
        
        
    }
    
    
           

      

//    var body: some View {
//        ScrollView {
//            LazyVGrid(
//                columns: columns,
//                spacing: 16) {
//                    ForEach(entries) { entry in
//                        JournalEntryView.init(entry: entry)
//                    }
//                }
//                .padding(.all, 16)
//                .toolbar {
//                    ToolbarItemGroup(placement: .primaryAction) {
//                        Button {
//                            
//                        } label: {
//                            Image(systemName: "plus.circle.fill")
//                                .foregroundColor(.black)
//                                .font(
//                                    .system(
//                                        size: 40,
//                                        weight: .light)
//                                )
//                        }
//                        .padding(.top, 48)
//                        Spacer()
//                        Button {
//                            print("Filter tapped!")
//                        } label: {
//                            Image(systemName: "line.3.horizontal.decrease.circle.fill")
//                                .foregroundColor(.black)
//                                .font(
//                                    .system(
//                                        size: 40,
//                                        weight: .light)
//                                )
//                        }
//                        .padding(.top, 48)
//                    }
//                }
//        }
//    }
}

#Preview {
    BreadJournalListView()
}
