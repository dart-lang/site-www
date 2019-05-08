This branch holds the redirects from https://dartlang.org -> https://dart.dev

They are hosted in the Firebase Hosting project indicated in `.firebaserc`.

To deploy these redirects:

1. Clone the present branch of this repo in a new location: `git clone -b redirects_from_dartlang --single-branch git@github.com:dart-lang/site-www.git`
1. Install the Firebase tools from https://www.npmjs.com/package/firebase-tools
1. Log out of Firebase: `firebase logout`
1. Log in to Firebase: `firebase login`
1. Deploy: `firebase deploy`
