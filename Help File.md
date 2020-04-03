# VU Keeplive

[Overview](#overview") |
[Keyboard Shortcuts](#shortcuts") |
[Centricity](#centricity) |
[Connectcare](#connectcare) |
[Synapse](#centricity) |
[PatientKeeper](#patientkeeper)

## Overview<a href="overview"></a>

## Keyboard Shortcuts to Memorize<a href="shortcuts"></a>

Remember Hyper is code for holding down capslock.

- Hyper-v or Escape (for VU Centricity)
- Hyper-b (for BS Connectcare)
- Hyper-h (for HCA PatientKeeper)
- Hyper-l (for initiate office start logins)
- Hyper-n (for NCCN)
- Hyper-s (for show Search options)
- Hyper-g (for Google search selected text)
- Hyper-x (for Synapse Xrays)

### Updates<a href="updates"></a>

Each time the app is run, it checks for and auto-update to new versions. It also will indicate to you any changes that were implemented.

The main purpose of this so application is to facilitate efficiency of patient care within the office. Currently, we all are fighting against multi-step two-factor authentication, timed auto-logouts, pop ups, and repetitively entering demographics to lookup patient data. This represents a significant is time sink. How about the idea of logging into each system once and it remains active until the end of the office and instantly activating applications by a hot key? How about automatic transfer of demographic data from Centricity to Connectcare or PatientKeeper or the vice versa? The process of looking up historic data becomes effort free. I also included a few more perks. CDs of patient images autoload and if you eject with the viewer app still running, the viewer is auto-closed instead of locking up. Clicks add up and I am on a mission to speed you up. If you have any ideas let me know. FYI, I have made the decision to not do auto logins.

I think it is useful to understand how this program is working in order to understand that it is not 100% reliable. If it is failing in a specific function consistently, this will help in troubleshooting the fix. Where applicable, this program works by checking available window titles, buttons, checkboxes, etc. unfortunately most of the VU helper interactions are within Citrix served apps. You can think of this as the app (like Connectcare) running on a remote server and being presented to you as a graphic representation of the window where mouse movements, clicks and keypresses are relayed to the remote server application. From the perspective of Vu helper I have significantly less window data over which to recognize and natively control. Most of VU helpers control of Citrix app interactions are based on image recognition and forced mouse movement/clicks. Something as simple as an application update or user change of a personalized theme can easily break image recognition and functionality. A good example of this is that Connectcare must have the default theme in order to function correctly.

Once logged in to outside EMRs like BS Connectcare and/or HCA PatientKeeper, the VU helper will stay out of your way as determined by mouse and keyboard activity and when it’s determined you are inactive it will interact every 3 minutes with the outside EMRS to prevent times logouts. If you active for too long, every 8 minutes VU helper will beep to warn you to allow forced interaction to prevent logouts.

Many applications have built in hotkeys. In order that I don’t interfere with these, VU Helper uses it’d own special Hyper-key. It is extending the functionality of the caps-lock key. Native caps lock toggle functionality is maintained, but combinations like hyper-v (for VU) takes you to VU Centricity. A comprehensive list follows. Go ahead and memorize these.

In my opinion, the best feature of VU Helper is linking patient lookup between the 3 EMRs we use.

To set the stage, let’s assume we have a patients chart open in Centricity and we want to search in Connectcare. The patients demographics are available in the Centricity banner. Hyper-s brings up the search menu. Pressing C identifies you wish to search in Connectcare. VU helper takes over and quickly copies the demographics and parses it into last name, first name, and date of birth. It switches to connectcare, navigates to the search screen, drops in demographic data, hits search, selects the first patient, and navigates you to the results tab. I have no idea how many clicks and keypresses this saves but easily 50! The reverse also works from Connectcare or Patient keeper to Centricity.

## Centricity<a id="centricity"></a>

Login to Centricity is simplified with auto-insertion of username, and after you enter password the correct location of care if auto-populated, focus is then switched to the "Log In" button allowing for hitting "Return" for confirmation/login.

No matter which application is active, the escape key always takes you to Centricity and if available, the currently open patient update

Within Centricity itself escape functions in a smart multifunctional manner.

1. Centricity Update is showing, escape takes you to Patients Chart tab and Documents list to review patient's historical data. Natively In this situation escape minimizes the update however underlying Centricity app does not always show and may not be on the chart/documents tab. This is used to quickly review historic data. (Saves 3 or 4 clicks).
2. Centricity Chart tab is active with Update already open/available. Escape takes you back to update. Essentially this toggles back to #1. (Saves 1 to 2 clicks).
3. Chart is active but no update open/available (like after signing update). Escape takes you Chart Documents tab and Summary list ready to pick the next patient. (Saves 1 to 2 clicks).
4. A scanned document is active. Escape takes you back to open update if available. (Saves 2 clicks).

Other Centricity benefits

- auto population of login screen VU location.
- Auto check of sign update’s “Sign clinical list changes”

Specific to Hyper-b for BS Connectcare.

- Auto accepts terms on login
- Auto clicks OK to close/bypass the sign-in message.
- Auto closes pop up “Workspace Limit Reached” to allow opening up another new patient
- Auto declares you as consulting provider when adding a patient to your list.

## HCA PatientKeeper<a name="patientkeeper"></a><a name="patientkeeper"></a>

Specific to hyper-h for HCA PatientKeeper

- auto check of remember this computer

Specific to Hyper-x for Synapse Xrays

- Auto close monitor warnings
- Auto saving of image markup
- Auto accept Warning : Monitor Calibration Needed

Specific to Hyper

A couple of extra perks.

Print screen button normally places a copy of the entire screen on the clipboard. I changed it so that it allows you to highlight and scrape a portion of the screen to the clipboard. Personally, I use this to drop in NCCN guidelines into the text of a note and carry it over from visit to visit.

The Insert button isn't used very often. Check it out on the keyboard next to the Delete button. It's native functionality, when triggered, is to allow you to type text, and any text after the cursor is typed over. Not very useful, IMO. When running VU Keeplive application, this button is reprogrammed to Append selected text to clipboard. An example would be text in a forwards document PDF where you want to copy multiple parts. Highlight one and hit Insert, highlight another and hit it again, etc. When you paste the serially copied elements are then cumulatively pasted from the clipboard.

The Pause button will temporarily disable VU helper. The icon changes to red indicating the app is paused. This is useful if something weird is happening and not allowing you to accomplish what you want. The app is reenabled by hitting pause again.

Lastly, on a rare basis VU helper can hang. If so holding escape for 2 seconds will restart it fresh.
