# LystTest

Small app created as a take home project to create a filterable list of shoes.

The APIService for this project has been created using the new Swift Package Manager, it should clone automatically with this project.

The architecture is based on MVP which has the following layers:

Model - There are two main types of objects
Representables which are created by a Presenter and consumed by a View
NetworkModels which represent data received from the Network

View - The combination of the View and the View Controller. The view knows how to consume a representable and how it should appear on screen. It does not know anything about the Model or Presenter layers

Presenter - An object which receives NetworkModels from services and creates a single Representable object for the View to consume.

Ideally this architecture would be used with coordinators which construct each layer and tie them together. Without them I have had to initialise the APIService and presenter in the view layer which breaks the separation of concerns.

Had to omit tests, error handling and the gender filter due to time constraints. 
