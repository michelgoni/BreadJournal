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
    struct State {
        var journalEntry: Entry
        var ingredients: IdentifiedArrayOf<Ingredient> = []
    }
    enum Action {}
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            }
        }
    }
}

struct JournalDetailView: View {

    let store: StoreOf<BreadFormFeature>
  
    var body: some View {
        WithViewStore(self.store, observe: {$0}) { viewStore in
            NavigationStack {
                VStack {
                    Form {
                        Section(header: Text("Fecha")) {
                            Text(viewStore.journalEntry.entryDate.convertToMonthYearFormat())
                        }
                        Section(header: Text("Ingredientes")) {
                            ForEach(viewStore.$ingredients) {
                                TextField("Ingredient", text: $0.ingredient)
                            }
            
                        }
                        
                        
                        Section(header: Text("Foto")) {
                            Image(uiImage: viewStore.journalEntry.breadPicture ?? UIImage())
                        }
                        
                        Group {
                            Section(header: Text("Hora último refresco mada madre")) {
                                Text(viewStore.journalEntry.lastSourdoughFeedTime.toHourMinuteString())
                            }
                            Section(header: Text("Hora comiezo prefermento")) {
                                Text(viewStore.journalEntry.prefermentStartingTime.toHourMinuteString())
                            }
                            Section(header: Text("Hora comiezo autólisis")) {
                                Text(viewStore.journalEntry.autolysisStartingTime.toHourMinuteString())
                            }
                            Section(header: Text("Hora comiezo fermentación en bloque")) {
                                Text(viewStore.journalEntry.bulkFermentationStartingTime.toHourMinuteString())
                            }

                            Section(header: Text("Pliegues")) {
                                Text(viewStore.journalEntry.folds)
                            }
                            Section(header: Text("Hora formado del pan")) {
                                Text(viewStore.journalEntry.breadFormingTime.toHourMinuteString())
                            }
                            Section(header: Text("Hora segunda fermentación")) {
                                Text(viewStore.journalEntry.secondFermentarionStartingTime.toHourMinuteString())
                            }
                            Group {
                                Section(header: Text("¿Se ha usado frigorífico?")) {
                                   Text(viewStore.journalEntry.isFridgeUsed.elementUsedTitle)
                                }
                                
                                if viewStore.journalEntry.isFridgeUsed {
                                    Section(header: Text("Tiempo total en el frigo")) {
                                        Text(viewStore.journalEntry.fridgeTotalTime)
                                    }
                                }
                                Section(header: Text("Tiempo de horneado")) {
                                    Text(viewStore.journalEntry.bakingTime)
                                }
                                Section(header: Text("¿Plancha de acero?")) {
                                    Text(viewStore.journalEntry.isSteelPlateUsed.elementUsedTitle)
                                }
                            }
                            Section(header: Text("Corteza")) {
                                StarRatingView(rating: viewStore.$journalEntry.crustRating)
                            }
                            Section(header: Text("Miga")) {
                                StarRatingView(rating: viewStore.$journalEntry.crumbRating)
                            }
                            Section(header: Text("Subida")) {
                                StarRatingView(rating: viewStore.$journalEntry.bloomRating)
                            }
                            Section(header: Text("Greñado")) {
                                StarRatingView(rating: viewStore.$journalEntry.scoreRating)
                            }
                            Section(header: Text("Sabor")) {
                                StarRatingView(rating: viewStore.$journalEntry.tasteRating)
                            }
                            Section(header: Text("Evaluation")) {
                                StarRatingView(rating: viewStore.$journalEntry.evaluation)
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
                    .navigationTitle(viewStore.journalEntry.name)
            }
          
            }
        }
    }
}

#Preview {
    JournalDetailView(
        store:
            Store(initialState: BreadFormFeature.State(
                journalEntry: .mock
            ),
                  reducer: {
                      BreadFormFeature()
                  }
            )
    )
}
