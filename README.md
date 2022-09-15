# 2022 All Scientists’ Meeting - R Shiny Workshop - Example Apps

### Team led by [Gabe De La Rosa](https://www.gabrieldelarosa.com/), [Francisco J Guerrero](https://github.com/guerrero-fj) & [Nick J Lyon](https://njlyon0.github.io/)

Hello! This folder contains several example apps aimed at showcasing various components of a Shiny app. The scripts contained in this folder are described below so please check out the (short) summary and then feel free to adapt or modify each of these apps as needed!

## Example App Explanations

- **basic_app.R** - This demonstrates a fundamental app without reactivity that displays some text

- **reactive_app.R** - This app is skeletal but does display reactivity at its most fundamental level

- **overview_app.R** - This app showcases a helpful and informative "overview" tab that would normally be the landing page of a larger app

- **reactive_app_v2.R** - This app shows reactivity (similarly to the "reactive_app.R" script) but does so in a more nuanced fashion with more moving parts

-   **ui_elements.R** - This app shows several typical user interface (UI) widgets and how inputs in each of them are received by the server of the app. Seeing how these widgets "talk" to the server may help you to write your own server as you can better anticipate how the UI and server interact

- **layout_[...].R** - These scripts show the same app with three different visual layouts. "layout_server.R" is used by all three apps in an effort to demonstrate that the UI layout is relatively distinct from the internal workings of a given app. The three layout options are as follows: 
    - "layout_sidebar_ui.R" - An app with a sidebar versus a main panel
    - "layout_tabs_ui.R" - An app with content separated into tabs
    - "layout_fluidrow_ui.R" - An app with all content arranged via manually set rows and columns (the most customizable and least inherently structured way of laying out a Shiny app)

## Workshop Abstract:

Shiny applications are a powerful way to let users explore scientific
data in a curated environment. Shiny is a flexible platform that allows
users to create both intricate apps and simple interfaces for sharing
data with collaborators. After this workshop, attendees will be able to
(1) define the fundamental structure of a Shiny app, (2) implement
different user interface elements, (3) write and format useful labels
and headers, and (4) learn to partition Shiny app components to create
clean, concise, and easy-to-navigate apps. Workshop participants follow
a guided coding session to create a demo shiny app, with an emphasis on
creating an app to share and interact with scientific data. We will
leverage pre-written “example apps” to facilitate attendees writing
their own apps. Please bring a laptop computer. There will also be time
set aside throughout the workshop to discuss issues and share best
practices so whether you’re a veteran Shiny user or have neer heard of
it, we welcome your participation.
