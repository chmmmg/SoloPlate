# ``SoloPlate``

A small fridge-to-meal iOS MVP for a person cooking one serving.

## Overview

SoloPlate helps the user record food, notice the item with the earliest date, and find a local recipe that can be prepared in 15 minutes or less.

The project separates the SwiftUI screens from the business rules. ``SoloPlateViewModel`` connects the screens to three Use Cases:

- ``RegisterFridgeItemUseCase`` validates and saves a fridge item.
- ``RecommendTonightMealsUseCase`` finds suitable one-person recipes.
- ``RecordPreparedMealUseCase`` checks every ingredient before updating the fridge.

The fridge repository is kept in memory for this MVP. Recipes are decoded from the bundled `recipes.json` file, so no account or internet connection is needed.

> Important: SoloPlate does not decide whether food is safe. The user must check the real food before cooking.

## Topics

### App state

- ``SoloPlateViewModel``

### Use Cases

- ``RegisterFridgeItemUseCase``
- ``RecommendTonightMealsUseCase``
- ``RecordPreparedMealUseCase``

### Domain models

- ``FridgeItem``
- ``SingleServeRecipe``
- ``MealSuggestion``
