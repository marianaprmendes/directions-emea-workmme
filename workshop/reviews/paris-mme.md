---
reviewed_with: Claude Code (Claude Opus 5.5)
reviewed_files: [workshop/AmuseYou/RentalOperations/src/BookingMgt.Codeunit.al, workshop/AmuseYou/RentalOperations/src/AvailabilityMgt.Codeunit.al, workshop/AmuseYou/RentalOperations/src/WeatherApiClient.Codeunit.al, workshop/AmuseYou/RentalOperations/src/BookingList.Page.al, workshop/AmuseYou/RentalOperations/src/RentalUpgrade.Codeunit.al, workshop/AmuseYou/BookingCore/src/BookingStatus.Enum.al, workshop/AmuseYou/BookingCore.Test/src/BookingTests.Codeunit.al, workshop/AmuseYou/RentalOperations.Test/src/UnitTests/AvailabilityTests.Codeunit.al, workshop/AmuseYou/RentalOperations.Test/src/UnitTests/BookingMgtTests.Codeunit.al, workshop/AmuseYou/Integration.Test/src/EndToEndBookingTests.Codeunit.al]
bcquality_commit: 8e20c29
outcome: completed
blockers_found: 0
blockers: 0
---

# BCQuality Review: paris-mme

Five skills dispatched (style, testing, performance, security, upgrade); all completed. 0 blocker, 19 major, 17 minor, 1 info.

## Blockers

None.

## Findings

- major · high · workshop/AmuseYou/RentalOperations/src/WeatherApiClient.Codeunit.al:15, 37 · API key (ApiKeyTok) is concatenated into a plain Text URL and sent with HttpClient.Get in GetWeatherForecast and CheckSevereWeather; compose with SecretStrSubstNo, set via HttpRequestMessage.SetSecretRequestUri and send with HttpClient.Send · microsoft/knowledge/security/secrettext-with-httpclient.md
- major · high · workshop/AmuseYou/RentalOperations/src/AvailabilityMgt.Codeunit.al:62 · UpdateMaintenanceStatus calls Commit() inside the Equipment loop, once per blocked row, with no progress marker; the operation can no longer roll back atomically · microsoft/knowledge/performance/avoid-commit-inside-loops.md
- major · high · workshop/AmuseYou/RentalOperations/src/AvailabilityMgt.Codeunit.al:59 · UpdateMaintenanceStatus reads and locks every Equipment row with FindSet(true), then tests "Last Maintenance Date" in AL; move the predicate into SetFilter before the find · microsoft/knowledge/performance/apply-filters-before-iterating.md
- major · high · workshop/AmuseYou/RentalOperations/src/BookingMgt.Codeunit.al:65 · ProcessDailyBookings loops only to assign a constant Status and Modify(); replace with Booking.ModifyAll(Status, BookingStatus::InProgress, false) · microsoft/knowledge/performance/prefer-modifyall-over-per-row-modify.md
- major · medium · workshop/AmuseYou/RentalOperations/src/AvailabilityMgt.Codeunit.al:60 · UpdateMaintenanceStatus sets the constant Blocked := true per row; once the date test is a filter, use Equipment.ModifyAll(Blocked, true, false) · microsoft/knowledge/performance/prefer-modifyall-over-per-row-modify.md
- major · high · workshop/AmuseYou/RentalOperations/src/BookingMgt.Codeunit.al:65 · ProcessDailyBookings reads with FindSet() (no update lock) and then calls Modify() on every row, leaving a deadlock window; use FindSet(true) or remove the loop · microsoft/knowledge/performance/findset-true-applies-updlock-on-read.md
- major · high · workshop/AmuseYou/RentalOperations/src/AvailabilityMgt.Codeunit.al:75 · GetTotalRevenue loops over completed bookings to add "Total Amount"; use Booking.CalcSums("Total Amount") · microsoft/knowledge/performance/calcsums-instead-of-calcfields-in-loop.md
- major · high · workshop/AmuseYou/RentalOperations/src/BookingMgt.Codeunit.al:50 · CalculateBookingAmount calls Equipment.Get without SetLoadFields and reads only "Daily Rental Rate"; add Equipment.SetLoadFields("Daily Rental Rate") before the Get · custom/knowledge/performance/setloadfields-on-every-partial-read.md
- major · high · workshop/AmuseYou/RentalOperations/src/AvailabilityMgt.Codeunit.al:13, 75 · IsEquipmentAvailable (Equipment.Get, reads 3 of 8 fields) and GetTotalRevenue (Booking.FindSet, reads only "Total Amount") read without SetLoadFields · custom/knowledge/performance/setloadfields-on-every-partial-read.md
- major · high · workshop/AmuseYou/RentalOperations/src/RentalUpgrade.Codeunit.al:9 · OnUpgradePerCompany implements the data work inline (SetRange + ModifyAll) instead of calling a named local procedure · microsoft/knowledge/upgrade/triggers-call-helpers-not-implementations.md
- major · high · workshop/AmuseYou/Integration.Test/src/EndToEndBookingTests.Codeunit.al:96 · TestConcurrentBookingPrevention only checks GetLastErrorText() <> '' after asserterror; any error passes the test. Use Assert.ExpectedError · microsoft/knowledge/testing/asserterror-needs-expectederror-and-code.md
- major · high · workshop/AmuseYou/BookingCore.Test/src/BookingTests.Codeunit.al:19, 39 · Hardcoded primary-key fixture values ('BOOK001', 'BOOK002') collide across repeated or parallel runs; generate with LibraryUtility · microsoft/knowledge/testing/use-generateguid-for-unique-test-fixture-values.md
- major · high · workshop/AmuseYou/RentalOperations.Test/src/UnitTests/AvailabilityTests.Codeunit.al:21, 39, 40, 57, 58, 59, 61 · Hardcoded primary-key fixture values ('AVAIL001', 'AVAIL002', 'BOUNCE001'..'BOUNCE003', 'BOOK001' used by two tests); generate with LibraryUtility · microsoft/knowledge/testing/use-generateguid-for-unique-test-fixture-values.md
- major · high · workshop/AmuseYou/RentalOperations.Test/src/UnitTests/BookingMgtTests.Codeunit.al:21, 25, 47 · Hardcoded primary-key fixture values ('CALC001', 'BOOK001', 'CANCEL001'); generate with LibraryUtility · microsoft/knowledge/testing/use-generateguid-for-unique-test-fixture-values.md
- major · high · workshop/AmuseYou/Integration.Test/src/EndToEndBookingTests.Codeunit.al:25, 33, 75, 79, 89 · Hardcoded primary-key fixture values ('E2E001', 'E2EBOOK001', 'CONCURRENT001', 'FIRST001', 'SECOND001'); generate with LibraryUtility · microsoft/knowledge/testing/use-generateguid-for-unique-test-fixture-values.md
- major · medium · workshop/AmuseYou/BookingCore.Test/src/BookingTests.Codeunit.al:18, 52 · Fixtures hand-rolled with Init/Insert; Equipment No. assigned directly and parent Equipment never created, bypassing the TableRelation; use a library codeunit · microsoft/knowledge/testing/use-library-codeunits-for-test-fixtures.md
- major · medium · workshop/AmuseYou/RentalOperations.Test/src/UnitTests/AvailabilityTests.Codeunit.al:72, 83 · CreateTestEquipment and CreateTestBooking hand-roll records and assign the foreign key without Validate; move into a shared library codeunit · microsoft/knowledge/testing/use-library-codeunits-for-test-fixtures.md
- major · medium · workshop/AmuseYou/RentalOperations.Test/src/UnitTests/BookingMgtTests.Codeunit.al:60, 70 · Fixtures hand-rolled; CreateTestBooking points at Equipment 'TEST001', which is never created; use a library codeunit · microsoft/knowledge/testing/use-library-codeunits-for-test-fixtures.md
- major · medium · workshop/AmuseYou/Integration.Test/src/EndToEndBookingTests.Codeunit.al:107 · CreateTestEquipment hand-rolls Equipment and duplicates the helper in other test apps; centralize in a library codeunit · microsoft/knowledge/testing/use-library-codeunits-for-test-fixtures.md
- minor · high · workshop/AmuseYou/RentalOperations/src/WeatherApiClient.Codeunit.al:6 · Weather API key is hard-coded as a Locked Label, ships in the app and cannot be rotated; store it in IsolatedStorage and read as SecretText · microsoft/knowledge/security/secrets-isolated-storage.md
- minor · high · workshop/AmuseYou/RentalOperations/src/RentalUpgrade.Codeunit.al:9 · Upgrade step has no HasUpgradeTag/SetUpgradeTag guard, so it reruns on every upgrade and overwrites Locations left blank on purpose · microsoft/knowledge/upgrade/use-upgrade-tags-not-version-checks.md
- minor · high · workshop/AmuseYou/RentalOperations/src/BookingMgt.Codeunit.al:13, 16 · Error() called with hard-coded text literals instead of Err Labels; not translatable · microsoft/knowledge/style/error-passes-parameters-directly-not-strsubstno.md
- minor · high · workshop/AmuseYou/RentalOperations/src/BookingList.Page.al:80 · Message() called with a hard-coded literal instead of a Msg Label · microsoft/knowledge/style/error-passes-parameters-directly-not-strsubstno.md
- minor · medium · workshop/AmuseYou/RentalOperations/src/BookingMgt.Codeunit.al:88 · Public GetBooking returns nothing and only opens the Booking Card; the Get prefix misleads callers (rename is a breaking change) · agent finding
- minor · medium · workshop/AmuseYou/BookingCore/src/BookingStatus.Enum.al:3 · XML doc summary names a nonexistent 'Active' value, omits Completed/Cancelled, and contains unescaped < and > · agent finding
- minor · medium · workshop/AmuseYou/Integration.Test/src/EndToEndBookingTests.Codeunit.al:27, 31, 45, 56 · TestCompleteBookingWorkflow has four [WHEN] blocks with per-step assertions; split it, or assert only the final state · microsoft/knowledge/testing/test-one-when-per-test.md
- minor · medium · workshop/AmuseYou/BookingCore.Test/src/BookingTests.Codeunit.al:20, 54 · Bookings reference Equipment ('BOUNCE001', 'TEST001') the test never creates · microsoft/knowledge/testing/test-data-must-be-random-and-complete.md
- minor · medium · workshop/AmuseYou/RentalOperations.Test/src/UnitTests/BookingMgtTests.Codeunit.al:72 · CreateTestBooking references Equipment 'TEST001', which the test never creates · microsoft/knowledge/testing/test-data-must-be-random-and-complete.md
- minor · high · workshop/AmuseYou/BookingCore.Test/src/BookingTests.Codeunit.al:5 · No [FEATURE] tag and no [SCENARIO] comments (tests at lines 13, 34) · microsoft/knowledge/testing/test-feature-scenario-tags.md
- minor · high · workshop/AmuseYou/RentalOperations.Test/src/UnitTests/AvailabilityTests.Codeunit.al:6 · No [FEATURE] tag and no [SCENARIO] comments (tests at lines 14, 31, 50) · microsoft/knowledge/testing/test-feature-scenario-tags.md
- minor · high · workshop/AmuseYou/RentalOperations.Test/src/UnitTests/BookingMgtTests.Codeunit.al:6 · No [FEATURE] tag and no [SCENARIO] comments (tests at lines 14, 40) · microsoft/knowledge/testing/test-feature-scenario-tags.md
- minor · high · workshop/AmuseYou/Integration.Test/src/EndToEndBookingTests.Codeunit.al:6 · No [FEATURE] tag naming the functional area · microsoft/knowledge/testing/test-feature-scenario-tags.md
- minor · medium · workshop/AmuseYou/RentalOperations.Test/src/UnitTests/AvailabilityTests.Codeunit.al:61 · CreateTestBooking(Equipment1, ...) passes a Record Equipment to a var Record Booking parameter; the test app does not compile (underlying impact higher than minor; promote to a rule before it can gate) · agent finding
- minor · medium · workshop/AmuseYou/BookingCore.Test/src/BookingTests.Codeunit.al:46 · Booking.Get reads only Status without SetLoadFields (test code; rule has no test exception) · custom/knowledge/performance/setloadfields-on-every-partial-read.md
- minor · medium · workshop/AmuseYou/RentalOperations.Test/src/UnitTests/BookingMgtTests.Codeunit.al:35, 54 · Booking.Get reads only "Total Amount" / Status without SetLoadFields (test code; rule has no test exception) · custom/knowledge/performance/setloadfields-on-every-partial-read.md
- minor · medium · workshop/AmuseYou/Integration.Test/src/EndToEndBookingTests.Codeunit.al:41 · Booking.Get (lines 41, 49, 60) reads only "Total Amount" and Status without SetLoadFields (test code; rule has no test exception) · custom/knowledge/performance/setloadfields-on-every-partial-read.md
- info · medium · workshop/AmuseYou/RentalOperations/src/BookingList.Page.al:22, 26, 30, 42 · Tooltips are the mechanical "Specifies the <field name>." form and add nothing beyond the caption · microsoft/knowledge/style/tooltip-required-on-page-fields.md

Suppressed: microsoft/knowledge/performance/use-setloadfields-for-partial-records.md (layer-precedence, displaced by custom/knowledge/performance/setloadfields-on-every-partial-read.md).

## Verdicts

Not triaged yet.
