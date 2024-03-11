//
//  BreadForm.swift
//  BreadJournal
//
//  Created by Michel Goñi on 21/1/24.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct BreadFormFeature {
    @ObservableState
    struct State: Equatable, Sendable {
        var journalEntry: Entry
        
        init(journalEntry: Entry) {
            self.journalEntry = journalEntry
        }
    }
    
    enum Action: BindableAction, Equatable, Sendable {
        case addIngredientTapped(String)
        case binding(BindingAction<State>)
        case deleteIngredient(atOffset: IndexSet)
    }
    @Dependency(\.uuid) var uuid
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .addIngredientTapped(let ingredient):
                let ingredient = Ingredient(id: Ingredient.ID(self.uuid()),
                                            ingredient: ingredient)
                state.journalEntry.ingredients.append(ingredient)
                return .none
            case .binding:
                return .none
            case .deleteIngredient(let offSet):
                state.journalEntry.ingredients.remove(atOffsets: offSet)
                return .none
            }
            
        }
    }
}

struct BreadFormView: View {
    @Bindable var store: StoreOf<BreadFormFeature>
    
    var body: some View {
//        VStack {
//            Form {
//                Section("Nombre de la receta") {
//                    TextField("",
//                              text: $store.journalEntry.name)
//                }
//                
//                Section {
//                    DatePicker("Fecha",
//                               selection: $store.journalEntry.entryDate,
//                               displayedComponents: .date)
//                }
//                
//                Section(header: Text("Foto")) {
//                    ImagePickerView(selectedImage: $store.journalEntry.breadPicture)
//                        .frame(maxWidth: .infinity, alignment: .center)
//                }
//                
//                Section(header: Text("Ingredientes")) {
//                    ForEach($store.journalEntry.ingredients) {
//                        TextField("Ingredient", text: $0.ingredient)
//                    }
//                    .onDelete {
//                        store.send(.deleteIngredient(atOffset: $0))
//                    }
//                    
//                    Button("Añade ingrediente") {
//                        store.send(.addIngredientTapped(""))
//                    }
//                }
//                
//                Group {
//                    Section {
//                        Section("Tiempo refresco masa madre") {
//                            TextField("",
//                                      text: $store.journalEntry.name)
//                        }
//                    }
//                    Section {
//                        Section(header: Text("Tiempo refresco masa madre")) {
//                            Text(store.journalEntry.sourdoughFeedTime)
//                        }
//                        Section(header: Text("Temperatura refresco")) {
//                            Text(store.journalEntry.sourdoughFeedTemperature)
//                        }
//                    }
//                    Section {
//                        DatePicker("Hora comiezo autólisis",
//                                   selection: $store.journalEntry.autolysisStartingTime,
//                                   displayedComponents: .hourAndMinute)
//                    }
//                    Section {
//                        DatePicker(
//                            "Hora comiezo fermentación en bloque",
//                            selection: $store.journalEntry.bulkFermentationStartingTime,
//                            displayedComponents: .hourAndMinute
//                        )
//                    }
//                    
//                    Section {
//                        TextField(
//                            "Pliegues",
//                            text: $store.journalEntry.folds
//                        )
//                    }
//                    
//                    Section {
//                        DatePicker("Hora formado del pan",
//                                   selection: $store.journalEntry.breadFormingTime,
//                                   displayedComponents: .hourAndMinute)
//                    }
//                    
//                    Section {
//                        DatePicker("Hora segunda fermentación",
//                                   selection: $store.journalEntry.secondFermentarionStartingTime,
//                                   displayedComponents: .hourAndMinute)
//                    }
//                    Group {
//                        
//                        Toggle(isOn: $store.journalEntry.isFridgeUsed) {
//                            Text("¿Se ha usado frigorífico?")
//                        }
//                        if store.journalEntry.isFridgeUsed{
//                            Section {
//                                TextField("Tiempo total en el frigo", text: $store.journalEntry.fridgeTotalTime)
//                            }
//                        }
//                        Section {
//                            TextField(
//                                "Tiempo de horneado",
//                                text: $store.journalEntry.bakingTime
//                            )
//                            Toggle(
//                                isOn: $store.journalEntry.isSteelPlateUsed
//                            ) {
//                                Text(
//                                    "¿Plancha de acero?"
//                                )
//                            }
//                        }
//                        
//                    }
//                    Section(header: Text("Corteza")) {
//                        StarRatingView(rating: $store.journalEntry.crustRating)
//                    }
//                    Section(header: Text("Miga")) {
//                        StarRatingView(rating: $store.journalEntry.crumbRating)
//                    }
//                    Section(header: Text("Subida")) {
//                        StarRatingView(rating: $store.journalEntry.bloomRating)
//                    }
//                    Section(header: Text("Greñado")) {
//                        StarRatingView(rating: $store.journalEntry.scoreRating)
//                    }
//                    Section(header: Text("Sabor")) {
//                        StarRatingView(rating: $store.journalEntry.tasteRating)
//                    }
//                    Section(header: Text("Evaluation")) {
//                        StarRatingView(rating: $store.journalEntry.rating)
//                    }
//                }
//            }
//        }
        EmptyView()
    }
}

#Preview(body: {
    BreadFormView(store: Store(initialState: BreadFormFeature.State(journalEntry: .mock), reducer: {
        BreadFormFeature()
    }))
})
