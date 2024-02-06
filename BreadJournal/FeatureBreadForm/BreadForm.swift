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
    struct State: Equatable {
        var journalEntry: Entry
        var ingredients: IdentifiedArrayOf<Ingredient> = []
        
        init(journalEntry: Entry) {
            self.journalEntry = journalEntry
        }
    }
    
    enum Action: BindableAction, Equatable {
        case addIngredientTapped(String)
        case binding(BindingAction<State>)
    }
    @Dependency(\.uuid) var uuid
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addIngredientTapped(let ingredient):
                let ingredient = Ingredient(
                    id: self.uuid(),
                    ingredient: ingredient
                )
                state.ingredients.append(ingredient)
                return .none
            case .binding:
                return .none
            }
            
        }
    }
}

struct BreadFormView: View {
    @Bindable var store: StoreOf<BreadFormFeature>
    
    var body: some View {
        VStack {
            Form {
                Section("Nombre de la receta") {
                    TextField("",
                              text: $store.journalEntry.name)
                }
                
                Section {
                    DatePicker("Fecha",
                               selection: $store.journalEntry.entryDate,
                               displayedComponents: .date)
                }
                
                Section(header: Text("Foto")) {
                    ImagePickerView(selectedImage: $store.journalEntry.breadPicture)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                
                Section(header: Text("Ingredientes")) {
                    ForEach($store.ingredients) {
                        TextField("Ingredient", text: $0.ingredient)
                    }
                    Button("Añade ingrediente") {
                        store.send(.addIngredientTapped(""))
                    }
                }
                
                Group {
                    Section {
                        DatePicker(
                            "Hora último refresco mada madre",
                            selection: $store.journalEntry.lastSourdoughFeedTime,
                            displayedComponents: .hourAndMinute
                        )
                    }
                    Section {
                        DatePicker(
                            "Hora comiezo prefermento",
                            selection: $store.journalEntry.prefermentStartingTime,
                            displayedComponents: .hourAndMinute
                        )
                    }
                    Section {
                        DatePicker("Hora comiezo autólisis",
                                   selection: $store.journalEntry.autolysisStartingTime,
                                   displayedComponents: .hourAndMinute)
                    }
                    Section {
                        DatePicker(
                            "Hora comiezo fermentación en bloque",
                            selection: $store.journalEntry.bulkFermentationStartingTime,
                            displayedComponents: .hourAndMinute
                        )
                    }
                    
                    Section {
                        TextField(
                            "Pliegues",
                            text: $store.journalEntry.folds
                        )
                    }
                    
                    Section {
                        DatePicker("Hora formado del pan",
                                   selection: $store.journalEntry.breadFormingTime,
                                   displayedComponents: .hourAndMinute)
                    }
                    
                    Section {
                        DatePicker("Hora segunda fermentación",
                                   selection: $store.journalEntry.secondFermentarionStartingTime,
                                   displayedComponents: .hourAndMinute)
                    }
                    Group {
                        
                        Toggle(isOn: $store.journalEntry.isFridgeUsed) {
                            Text("¿Se ha usado frigorífico?")
                        }
                        if store.journalEntry.isFridgeUsed{
                            Section {
                                TextField("Tiempo total en el frigo", text: $store.journalEntry.fridgeTotalTime)
                            }
                        }
                        Section {
                            TextField(
                                "Tiempo de horneado",
                                text: $store.journalEntry.bakingTime
                            )
                            Toggle(
                                isOn: $store.journalEntry.isSteelPlateUsed
                            ) {
                                Text(
                                    "¿Plancha de acero?"
                                )
                            }
                        }
                        
                    }
                    Section(header: Text("Corteza")) {
                        StarRatingView(rating: $store.journalEntry.crustRating)
                    }
                    Section(header: Text("Miga")) {
                        StarRatingView(rating: $store.journalEntry.crumbRating)
                    }
                    Section(header: Text("Subida")) {
                        StarRatingView(rating: $store.journalEntry.bloomRating)
                    }
                    Section(header: Text("Greñado")) {
                        StarRatingView(rating: $store.journalEntry.scoreRating)
                    }
                    Section(header: Text("Sabor")) {
                        StarRatingView(rating: $store.journalEntry.tasteRating)
                    }
                    Section(header: Text("Evaluation")) {
                        StarRatingView(rating: $store.journalEntry.evaluation)
                    }
                }
                Spacer()
                Button(action: {
                    debugPrint("pressed send")
                }) {
                    Text("Enviar")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(minWidth: .zero,
                               maxWidth: .infinity)
                        .padding()
                        .background(.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
        }
        
    }
}

#Preview(body: {
    BreadFormView(store: Store(initialState: BreadFormFeature.State(journalEntry: .mock), reducer: {
        BreadFormFeature()
    }))
})
