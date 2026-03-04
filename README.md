# un-isolate (SwiftUI + SwiftData)

un-isolate is a local-first iOS MVP designed to reduce undergraduate social isolation by helping students discover organizations, import schedules, and commit to events that fit free time windows.

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

## Full iOS app project files included

This repo now includes a committed Xcode project you can open directly:

- `uni-solate.xcodeproj` (ready to open)
- `Config/Info.plist`
- `UnIsolate/Resources/Assets.xcassets` (AccentColor + AppIcon set placeholders)
- `UnIsolate/Resources/Preview Content/Preview Assets.xcassets`

Also included for regeneration:

- `project.yml` (XcodeGen spec)
- `scripts/bootstrap_xcode_project.sh`

## Run in Xcode (fastest path)

1. Open `uni-solate.xcodeproj` in Xcode.
2. Select an iOS simulator (e.g. iPhone 15) and run.

## Regenerate project (optional)

1. Install XcodeGen once:
   ```bash
   brew install xcodegen
   ```
2. From repo root, run:
   ```bash
   ./scripts/bootstrap_xcode_project.sh
   ```

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
