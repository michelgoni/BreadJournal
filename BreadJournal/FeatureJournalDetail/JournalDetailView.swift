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
    struct State {}
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
                        Section {
                            DatePicker("Fecha",
                                       selection: viewStore.$journalEntry.entryDate,
                                       displayedComponents: .date)
                        }
                        Section(header: Text("Ingredientes")) {
                            ForEach(viewStore.$ingredients) {
                                TextField("Ingredient", text: $0.ingredient)
                            }
                            Button("Añade ingrediente") {
                              viewStore.send(.addIngredientTapped(""))
                            }
                        }
                        
                        
                        Section(header: Text("Foto")) {
                            ImagePickerView(selectedImage: viewStore.$journalEntry.breadPicture)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        
                       

                        Group {
                            Section {
                                DatePicker(
                                    "Hora último refresco mada madre",
                                    selection: viewStore.$journalEntry.lastSourdoughFeedTime,
                                    displayedComponents: .hourAndMinute
                                )
                            }
                            Section {
                                DatePicker(
                                    "Hora comiezo prefermento",
                                    selection: viewStore.$journalEntry.prefermentStartingTime,
                                    displayedComponents: .hourAndMinute
                                )
                            }
                            Section {
                                DatePicker("Hora comiezo autólisis",
                                           selection: viewStore.$journalEntry.autolysisStartingTime,
                                           displayedComponents: .hourAndMinute)
                            }
                            Section {
                                DatePicker(
                                    "Hora comiezo fermentación en bloque",
                                    selection: viewStore.$journalEntry.bulkFermentationStartingTime,
                                    displayedComponents: .hourAndMinute
                                )
                            }
                            
                            Section {
                                TextField(
                                    "Pliegues",
                                    text: viewStore.$journalEntry.folds
                                )
                            }
        
                            Section {
                                DatePicker("Hora formado del pan",
                                           selection: viewStore.$journalEntry.breadFormingTime,
                                           displayedComponents: .hourAndMinute)
                            }
                            
                            Section {
                                DatePicker("Hora segunda fermentación",
                                           selection: viewStore.$journalEntry.secondFermentarionStartingTime,
                                           displayedComponents: .hourAndMinute)
                            }
                            Group {
                               
                                Toggle(isOn: viewStore.$journalEntry.isFridgeUsed) {
                                    Text("¿Se ha usado frigorífico?")
                                }
                                if viewStore.journalEntry.isFridgeUsed{
                                    Section {
                                        TextField("Tiempo total en el frigo", text: viewStore.$journalEntry.fridgeTotalTime)
                                    }
                                }
                                Section {
                                    TextField(
                                        "Tiempo de horneado",
                                        text: viewStore.$journalEntry.bakingTime
                                    )
                                    Toggle(
                                        isOn: viewStore.$journalEntry.isSteelPlateUsed
                                    ) {
                                        Text(
                                            "¿Plancha de acero?"
                                        )
                                    }
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
