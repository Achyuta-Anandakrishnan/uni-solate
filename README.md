# CampusPulse (SwiftUI + SwiftData)

CampusPulse is a local-first iOS MVP focused on reducing student isolation by recommending schedule-fit campus events and making organizations easy to find.

## Project Structure

- `CampusPulse/CampusPulseApp.swift`
- `CampusPulse/Models/*`
- `CampusPulse/Services/*`
- `CampusPulse/UI/Theme/*`
- `CampusPulse/UI/Components/*`
- `CampusPulse/UI/Onboarding/*`
- `CampusPulse/UI/Tabs/*`
- `CampusPulse/UI/Detail/*`

## Run in Xcode

1. Create a new **iOS App** project in Xcode named `CampusPulse` (SwiftUI + SwiftData).
2. Replace generated files with this repository's `CampusPulse` folder contents.
3. Ensure deployment target is **iOS 17.0+** and Swift is **5.9+**.
4. Add an `AccentColor` asset (soft coral/red) in `Assets.xcassets`.
5. Build and run in simulator.

## Testing ICS import in Simulator

1. Create a local `.ics` file on your Mac, for example:
   ```ics
   BEGIN:VCALENDAR
   BEGIN:VEVENT
   SUMMARY:Study Group
   DTSTART:20261101T170000
   DTEND:20261101T183000
   END:VEVENT
   END:VCALENDAR
   ```
2. Run onboarding and open **Import .ics File**.
3. Select the file via Files picker.
4. Confirm message: `Imported X schedule items.` and preview lines.

## Notes

- Seed service inserts 36 events over the next 14 days across NC State, UNC, and Duke.
- Recommendation engine blends schedule fit, interest overlap, promoted flags, and risk-driven adjustments.
