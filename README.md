**Parking Map Interface for iOS**
_________________________________
*Project Overview*

This project is a single-page iOS application that features a full-screen map interface for displaying and interacting with parking zones. Users can select a zone by moving a pin on the map, view detailed information about the selected zone, and start a parking session within the app.
_________________________________

*Features*

Full-Screen Map Interface: The app uses MapKit to display a full-screen map with interactive zones.

Polygon Zone Drawing: Parking zones are drawn as polygons on the map using data from a JSON file. Each zone is color-coded based on whether parking is allowed.

Interactive Map Pin: A draggable pin is placed at the center of the map. The pin updates its location based on user interaction and displays zone-specific information.

Dynamic Zone Selection: The app detects the current zone based on the pin’s location and updates the map and UI accordingly.

Parking Status Management: Users can start and end a parking session with a button that updates in response to the selected zone's status.

Real-Time Zone Updates (Optional Enhancement): The app could include features like real-time updates for parking availability, a history log of parking sessions, geofencing notifications, or a heatmap of popular parking areas.

________________________________

*Getting Started*



Prerequisites

Xcode: Version 13.0 or later.

iOS SDK: The app is built for iOS 14.0+.

Installation

Clone the Repository:

bash

Copy code

git clone https://github.com/kseniia-pskn/parking

cd parking-map-interface-ios

Open the Project:

Open the .xcodeproj file in Xcode.

Run the App:

Select a simulator or a connected device, then click Run in Xcode to build and launch the app.
__________________________________

*Project Structure*

ViewModel

MapViewVM.swift: Contains the ViewModel logic for handling map data, managing selected zones, and providing data to the ViewController.

ViewController

MapViewController.swift: Manages the main user interface, handling map interactions, UI updates, and user input.

Data


JSONLoader.swift: Handles loading and parsing JSON data into the app.

LocationData.swift: Defines the data model for location data, including parking zones.

Helpers


Consts.swift: Contains constants used throughout the project for colors, strings, and other values.

AppDelegate.swift & SceneDelegate.swift: Standard iOS application lifecycle management.

CustomAnnotation


CustomAnnotation.swift: Defines the custom annotation used for the map pin.

CustomAnnotationView.swift: Customizes the appearance of the map pin.

Assets


Contains icons, images, and other resources used by the app.

Tests


ParkingTests


JSONLoaderTests.swift: Unit tests for JSON loading and parsing.

ParkingUITests


ParkingUITests.swift: UI tests for validating the user interface and interactions.

JSON Data


The application uses a JSON file (data.json) to simulate the response from a backend system. This file contains polygon data for defining 
the parking zones.


Testing


Unit Tests: Test cases for data loading and parsing can be found in the ParkingTests folder.

UI Tests: Automated UI tests are provided to verify that the app's user interface behaves as expected.


To run tests:


Open the Xcode project.
Press Cmd+U to run all tests.
_________________________________

*Optional Enhancements*



Here are some ideas to enhance the project further:


Real-Time Parking Availability: Implement real-time updates for parking availability with color-coded indicators.

Parking History Log: Add a history log to track past parking sessions.

Geofencing Notification: Notify users when they enter or exit a parking zone.

Heatmap of Popular Parking Areas: Display a heatmap showing the popularity of different parking zones.
