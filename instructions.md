 I want to develop a mobile app called Wardrobe & Wash.

The major goal for the app is to ease management of clothes and planning their washing.

We are going to use flutter for this and I am going to describe the technical features, views, and background logic that I want you to set up.

So let’s start with the core features. The app will:
1. Register clothes
2. Note every day clothing with daily input
3. Register the use count of clothes
4. Plan washing based on the used clothes and their use count
5. Upkeep of wardrobe and management, deduction and adduction of clothes

Furthermore, we need a few views. I am going to tag views that need a navigation footer which will have three icons that will represent 3 views, a sun, wardrobe and a washing machine:
1. Wardrobe View (the home view - wardrobe icon) - The main place where all of the user’s clothes will be displayed in a 2 column infinite gallery. On top of the view will be a simple search bar, and at the bottom the mentioned footer. Also, above the footer, but in the lower right corner will be a button that will allow addition of new clothes.
2. Wash View (The washing machine view) It’s going to display a gallery of algorythmically proposed washes (do not implement that now, that’s complex!) or allow the user to add their custom wash by clicking a text button that’s centered horizontally and hovering just above the mentioned footer.
3. Wash details view - A view that’s going to display either when person wants to see their already added wash plan in the Wash View interface or add a new one with the Custom wash text button. It’s going to have an app bar with the title of the wash and a back button. The main content is going to display a list of picked clothes, each displaying a miniature photo of the piece of clothing and an X icon to remove the item from the list. On the bottom of the view will be two buttons, Add and Complete button. The Add button should display a drawer (an interface that’s sliding in from behind, making the background darker, and allowing to pick from the user’s used clothing)
4. Clothing View - A view that’s going to be displayed when the person wants to see the details of their piece of clothing in the Home view (wardrobe view). The view should display an app bar with the back button and the clothing name with the clothing photo displayed full width 1/3 of the remaining space, under the photo should be the name of the clothing, its tags, the worn count, and at the bottom of the view should be remove button and add for today button.
5. Add Clothing View - A view that’s identical to the Clothing View, but rather than displaying the content, it has input for the content, the layout shall be the same, but the photo should display a plus icon and allow for picking a photo on click, then an input for the Name, and possibility of adding tags for the clothing. Furthermore, at the bottom of the view, in the right bottom corner should be the Complete button.
6. Today View (The sun icon view) - A view that’s going to represent the sun icon from the footer, thus it should display the footer. What this view should display is only the clothing that have a today flag added based on the pieces of clothing that were tagged as used today in the Clothing View.

What we will need for the backend (I may possibly miss something though)

Data models:
- A piece of Clothing
  - Name
  - Photo
  - Tags
  - Worn count
  - picked today

Providers:
- Clothing Provider (CRUD)
  - getClothing
  - Add clothing
  - removeClothing
  - updateClothing
  - getAllClothing

Database pick - Hive

Set based categorisation for washes.

Today Set and Wash Set(s)

Also, for the views please base them not on statefull or statelesswidgets, based them on ConsumerWidgets and HookConsumerWidgets.

User riverpod and riverpod_gen for creating providers with code generation, use hooks for managing variable’s states, and use go_router for navigation between views.

IMPORTANT!!!!: BEFORE YOU CONTINUE, REHEARSE TO ME WHAT YOU NEED TO DO AND ASK QUESTIONS IF ANYTHING IS UNCLEAR.