# un-isolate (SwiftUI + SwiftData)

un-isolate is a local-first iOS MVP designed to reduce undergraduate social isolation by helping students discover organizations, import their schedules, and commit to events that fit free time windows.

## What is implemented

- SwiftData local models: `UserProfile`, `BusyBlock`, `Organization`, `Event`, `Attendance`
- First-launch onboarding flow with:
  - Welcome
  - School + `.edu` email
  - ICS schedule import + preview
  - Interest chips
  - Lifestyle signals (steps/sleep + nearby schools toggle)
  - Isolation survey
  - Finish screen
- Free-time window engine (08:00–22:00 over 7 days)
- Isolation risk scoring (0–100) with labels + drivers
- Recommendation scoring and ranking with schedule-fit + reasons
- Seed dataset (36 upcoming events in next 14 days across NC State, UNC, Duke)
- 5 tabs: Dashboard, Plan, Discover, Directory, Profile
- Persistent "I'm going" and buddy intent with haptics

## Run in Xcode

1. Create a new **iOS App** project in Xcode named `un-isolate` (SwiftUI + SwiftData).
2. Replace generated files with this repository's `UnIsolate` folder contents.
3. Ensure deployment target is **iOS 17.0+** and Swift is **5.9+**.
4. Add an `AccentColor` asset (soft coral/red) in `Assets.xcassets`.
5. Build and run in the iOS simulator.

## Testing ICS import in Simulator

1. Create a local `.ics` file on your Mac:

   ```ics
   BEGIN:VCALENDAR
   BEGIN:VEVENT
   SUMMARY:Study Group
   DTSTART:20261101T170000
   DTEND:20261101T183000
   END:VEVENT
   END:VCALENDAR
   ```

2. Launch un-isolate and walk through onboarding.
3. Tap **Import .ics File** on the import step.
4. Select your file in the document picker.
5. Confirm the message `Imported X schedule items.` and preview rows appear.
