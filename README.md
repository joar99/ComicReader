# ComicReader

## Overview
This application is built using Swift and SwiftUI for users to explore and manage their favorite comics. It uses an external API to fetch comic data and uses CoreData for persistence.

1. **Architecture**:
   - **MVVM Pattern**: It follows the Model-View-ViewModel pattern to ensure a clear separation of concerns and create a testable and scalable solution.
   - **Unidirectional Data Flow**: To ensure a predictable flow of state, it implements a top-down data flow approach where state flows from parent to child without two way bindings.

2. **Data Handling**:
   - **API Integration**: Comics are fetched from an external API leveraging Swift Concurrency.
   - **Core Data**: Core Data is used to persist data of users favorite comics.

3. **State Management**:
   - **View Models**: Two view models manage the state for the comics and user favorites respectively. They communicate using Combine to ensure synchronization of favorite status.

### Unidirectional Data Flow
The application follows a unidirectional data flow approach:
- **State Management**: The application state is managed centrally in the view models and flows down to the views.
- **Data Flow**: Data flows from the view models to the views in a single direction, ensuring that the state is predictable and easy to debug.

### ComicsViewModel
Handles fetching comics from the API and managing the list of comics.

### CoreComicViewModel
Manages comics stored in Core Data and responds to favorite status changes.

## 3rd party dependencies
This project leverages SwiftSoup v/2.7.2 to parse HTML content.

