# Embedded Form Flutter

Embedded Form using flutter and web view.

## Before running the application

Before running this example we need to install the necessary software 
to run this example.

1. [Install Flutter](https://flutter.dev/docs/get-started/install)

   Follow the instructions from the **flutter official documentation**,
   depending on your operating system. To ensure that flutter is 
   correctly install run the following command `flutter doctor`.
   
   Don't worry if the log show's that there's some software left to 
   install.

1. [Install Android Studio](https://developer.android.com/studio/install)

   After installing Android Studio, **following the official documentation**, 
   we need to link flutter and Android Studio with the command from below, 
   so they can work both together.

    ```bash
    flutter config --android-studio-dir <path where you install android studio>
    ```

1. Update Google Chrome

   Then, we need to update Google Chrome to the most recent version, so
   the Embedded Form example can be displayed with no issues, we recommend
   this link to download the APK, [Google Chrome APK v93-0-4577][source],
   however you can do your research and install the most recent Internet
   Browser that you want.

   To install the APK, you need to have an emulator already running,
   drag and drop the APK that you download to the emulator, wait to be
   installed, and when it's finished, close the emulator and *cold boot run* 
   the emulator, so the changes can be reflected.

   [source]: https://www.apkmirror.com/apk/google-inc/chrome/chrome-93-0-4577-62-release/google-chrome-fast-secure-93-0-4577-62-6-android-apk-download/download/?forcebaseapk

1. Run Flutter Doctor

   After installing flutter and android studio, run again `flutter doctor`, 
   and successfully it should be everything ok.

## Deploy the Backend 

To use this Flutter example we made a [backend with flask][backend with flask] 
that can be deployed to Heroku with one button.

[backend with flask]: https://github.com/lyra/flask-embedded-form-examples

* Create an [Heroku account](https://signup.heroku.com/)

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/lyra/flask-embedded-form-examples)

> **This backend was created as a form of example, and guidance, do not feel 
> arraigned to this sample, you can build your own backend to obtain the 
> same result.**

To create your own service, you need two important endpoints to add on 
your project, `/get-form-token` and `/get-embedded`.

**`/get-form-token`**, is a POST method, and it can receive receive either 
form data, or a json body, example as the below, to generate the form token, it's only response, 
is the form token

```json
{
    "amount": 990,
    "currency": "COP",
    "email": "sample@example.com",
    "orderId": "myOrderId-65180",
    "formAction": "PAYMENT"
}
```

**`/get-embedded`**, is a GET method, and return the embedded form, it 
should receive the form token as an url parameter.
`https://backend.example.com/get-embedded?form-token=FORM-TOKEN`

## Run the application

1. Clone the repository

    ```bash
    git clone https://github.com/lyra/flutter-integration-examples
    ```

1. Install the dependencies

    ```bash
    cd flutter-integration-examples
    flutter pub get # to install flutter dependencies
    ```

After following the steps from above, run the main function of the
application and it should start to compile and later on, it shows on your
emulator. Inside the application, you can set the URL for the backend, keep
in mind that the URL should be save as `backend.example.com`, and not
`https://backend.example.com`. Save your changes and now you can use
the example.
