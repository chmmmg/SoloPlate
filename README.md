# SoloPlate

SoloPlate is a small iOS app for a person who cooks one meal at a time. It helps the user record food at home, notice what should be used first, and choose a quick recipe using the recorded food.

## Domain context

The primary stakeholder often prepares dinner for one person. Corn and sweet potatoes were sometimes left unused because deciding how to prepare them felt inconvenient. SoloPlate connects a simple fridge list with short recipes so the next step is easier to see.

The app does not decide whether food is safe. Dates and quantities come from the user. The user still checks the real food before cooking.

## Main flow

1. Open **My Fridge** and check recorded food.
2. Use **Add Food** to enter a name, quantity, unit and date.
3. Open **Tonight's Picks** to see recipes for one person that take 15 minutes or less.
4. Open **Recipe Detail** to read the ingredients and steps.
5. Select **Meal Prepared** only after cooking. SoloPlate rechecks every quantity before updating the fridge.

The app starts with a few sample records so the recommendation flow can be demonstrated straight away.

## Architecture

The project uses a simple MVVM structure with a Use Case layer:

```text
SwiftUI Views
    |
SoloPlateViewModel
    |
Use Cases
    |
Domain Models and Repository Protocols
    |
In-memory fridge and bundled JSON recipes
```

The three main Use Cases are:

- `RegisterFridgeItemUseCase`
- `RecommendTonightMealsUseCase`
- `RecordPreparedMealUseCase`

The prepared-meal Use Case calculates every change first. It only replaces the fridge data after all ingredients pass the quantity check. This prevents a half-finished inventory update.

## Project folders

- `Domain`: food, recipe and suggestion types
- `Repositories`: operations needed by the domain logic
- `UseCases`: the three business operations and their errors
- `Data`: in-memory fridge storage and eight local JSON recipes
- `ViewModels`: state and actions shared by the four screens
- `Views`: the SwiftUI screens
- `Documentation.docc`: in-project architecture and domain overview
- `SoloPlateTests`: scenario-based unit tests
- `Documentation`: report source and supporting notes
- `output/pdf`: submission-ready PDF drafts

## Setup

1. Open `SoloPlate.xcodeproj` in Xcode 26 or a compatible version.
2. Choose an iPhone Simulator.
3. Select the `SoloPlate` scheme.
4. Press Run.

No account, API key or internet connection is needed.

## Tests

In Xcode, select **Product > Test** or press `Command-U`. The tests cover valid fridge entry, invalid values, recommendation rules, the 15-minute boundary, missing stock, and atomic inventory updates.

## Current MVP limits

- Fridge changes are kept in memory and reset when the app closes.
- Recipe matching uses exact food names and units.
- The recipe catalogue contains eight local recipes.
- There is no camera scanning, login, cloud sync or external recipe service.
