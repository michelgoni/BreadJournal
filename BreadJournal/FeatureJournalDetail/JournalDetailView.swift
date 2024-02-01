//
//  JournalDetailView.swift
//  BreadJournal
//
//  Created by Michel Goñi on 27/1/24.
//

import ComposableArchitecture
import SwiftUI

@Reducer

struct JournalDetailViewFeature {
    @ObservableState
    struct State: Equatable {
        var journalEntry: Entry
        var ingredients: IdentifiedArrayOf<Ingredient> = []
    }
    enum Action: Equatable {}
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            }
        }
    }
}

struct JournalDetailView: View {
    
    @Bindable var store: StoreOf<JournalDetailViewFeature>
    
    var body: some View {
       
            NavigationStack {
                VStack {
                    Form {
                        Section(header: Text("Fecha")) {
                            Text(store.journalEntry.entryDate.convertToMonthYearFormat())
                        }
                        Section(header: Text("Ingredientes")) {
                            ForEach(store.ingredients) {
                                Text($0.ingredient)
                            }
                            
                        }
                        
                        Section(header: Text("Foto")) {
                            Image(uiImage: store.journalEntry.breadPicture ?? UIImage())
                        }
                        
                        Group {
                            Section(header: Text("Hora último refresco mada madre")) {
                                Text(store.journalEntry.lastSourdoughFeedTime.toHourMinuteString())
                            }
                            Section(header: Text("Hora comiezo prefermento")) {
                                Text(store.journalEntry.prefermentStartingTime.toHourMinuteString())
                            }
                            Section(header: Text("Hora comiezo autólisis")) {
                                Text(store.journalEntry.autolysisStartingTime.toHourMinuteString())
                            }
                            Section(header: Text("Hora comiezo fermentación en bloque")) {
                                Text(store.journalEntry.bulkFermentationStartingTime.toHourMinuteString())
                            }
                            
                            Section(header: Text("Pliegues")) {
                                Text(store.journalEntry.folds)
                            }
                            Section(header: Text("Hora formado del pan")) {
                                Text(store.journalEntry.breadFormingTime.toHourMinuteString())
                            }
                            Section(header: Text("Hora segunda fermentación")) {
                                Text(store.journalEntry.secondFermentarionStartingTime.toHourMinuteString())
                            }
                            Group {
                                Section(header: Text("¿Se ha usado frigorífico?")) {
                                    Text(store.journalEntry.isFridgeUsed.elementUsedTitle)
                                }
                                
                                if store.journalEntry.isFridgeUsed {
                                    Section(header: Text("Tiempo total en el frigo")) {
                                        Text(store.journalEntry.fridgeTotalTime)
                                    }
                                }
                                Section(header: Text("Tiempo de horneado")) {
                                    Text(store.journalEntry.bakingTime)
                                }
                                Section(header: Text("¿Plancha de acero?")) {
                                    Text(store.journalEntry.isSteelPlateUsed.elementUsedTitle)
                                }
                            }
                            Section(header: Text("Corteza")) {
                                StarRatingView(staticRating: store.journalEntry.crustRating)
                            }
                            Section(header: Text("Miga")) {
                                StarRatingView(staticRating: store.journalEntry.crumbRating)
                            }
                            Section(header: Text("Subida")) {
                                StarRatingView(staticRating: store.journalEntry.bloomRating)
                            }
                            Section(header: Text("Greñado")) {
                                StarRatingView(staticRating: store.journalEntry.scoreRating)
                            }
                            Section(header: Text("Sabor")) {
                                StarRatingView(staticRating: store.journalEntry.tasteRating)
                            }
                            Section(header: Text("Evaluation")) {
                                StarRatingView(staticRating: store.journalEntry.evaluation)
                            }
                        }
                        
                        Section {
                            Button("Delete") {
                                
                            }
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                        }
                        
                    }
                    .toolbar {
                        Button("Edit") {
                            
                        }
                    }
                    .navigationTitle(store.journalEntry.name)
                }
                
            
        }
    }
}

#Preview {
    JournalDetailView(
        store:
            Store(initialState: JournalDetailViewFeature.State(
                journalEntry: .mock
            ),
                  reducer: {
                      JournalDetailViewFeature()
                  }
            )
    )
}
