//
//  DateInfoWidgetEntryView.swift
//  ClendarWidgetExtension
//
//  Created by Vinh Nguyen on 10/31/20.
//  Copyright © 2020 Vinh Nguyen. All rights reserved.
//

#if !targetEnvironment(macCatalyst)

	import SwiftDate
	import SwiftUI
	import WidgetKit

	struct DateInfoWidgetEntryView: View {
		@Environment(\.widgetFamily) var family

		let entry: WidgetEntry

		@ViewBuilder
		var body: some View {
			switch family {
			case .systemMedium:
				MediumCalendarWidgetView(entry: entry)

			case .systemLarge:
				LargeCalendarWidgetView(entry: entry)

			case .systemSmall:
				SmallCalendarWidgetView(entry: entry)

			@unknown default:
				SmallCalendarWidgetView(entry: entry)
			}
		}
	}

	// MARK: - Main Views

	struct SmallCalendarWidgetView: View {
		let entry: WidgetEntry

		var body: some View {
			VStack(alignment: .center) {
				Text(entry.date.toMonthString.localizedUppercase)
					.font(.system(size: 20, weight: .bold, design: .rounded))
					.foregroundColor(.gray)
				Text(entry.date.widgetDayString)
					.font(.system(size: 20, weight: .bold, design: .rounded))
					.foregroundColor(Color(.moianesD))
				Text(entry.date.toDateString)
					.font(.system(size: 45, weight: .bold, design: .rounded))
					.foregroundColor(Color(.appDark))
			}.padding(.all)
		}
	}

	struct MediumCalendarWidgetView: View {
		let entry: WidgetEntry

		var body: some View {
			HStack {
				SmallCalendarWidgetView(entry: entry)
				DividerView()
				EventsListWidgetView(entry: entry, minimizeContents: true)
			}
		}
	}

	struct LargeCalendarWidgetView: View {
		let entry: WidgetEntry

		var body: some View {
			HStack {
				SmallCalendarWidgetView(entry: entry)
				DividerView()
				VStack {
					TodayOverviewWidgetView(entry: entry)
					if entry.events.isEmpty == false {
						EventsListWidgetView(entry: entry)
					}
				}
			}
		}
	}

	// MARK: - Helper Views

	struct TodayOverviewWidgetView: View {
		let entry: WidgetEntry

		var body: some View {
			VStack(alignment: .center) {
				let events = entry.events
				let text = events.isEmpty
					? NSLocalizedString("🎉 No more events today,\nenjoy your day!\n", comment: "")
					: NSLocalizedString("Upcoming events", comment: "")

				Text(text)
					.font(.system(size: 20, weight: .bold, design: .rounded))
					.foregroundColor(.gray)
					.multilineTextAlignment(.center)
					.minimumScaleFactor(0.8)
			}.padding(.all)
		}
	}

	struct EventsListWidgetView: View {
		let entry: WidgetEntry
		var minimizeContents: Bool = false

		var body: some View {
			LazyVStack(alignment: .leading, spacing: 10) {
				Section(
					header:
					Text(entry.date.toFullDateString.localizedUppercase)
						.font(.system(size: 11, weight: .bold, design: .rounded))
						.foregroundColor(Color(.moianesB))
				) {
					let events = entry.events.prefix(minimizeContents ? 3 : 6)
					ForEach(events, id: \.self) { event in
						WidgetEventRow(event: event)
					}
				}
			}.padding(10)
		}
	}

	struct DividerView: View {
		var body: some View {
			Divider().background(Color(.placeholderText))
		}
	}

	// MARK: - Preview

	struct WidgetEntryView_Previews: PreviewProvider {
		static var previews: some View {
			DateInfoWidgetEntryView(entry: WidgetEntry(date: Date()))
				.preferredColorScheme(.dark)
				.previewContext(WidgetPreviewContext(family: .systemLarge))
				.environment(\.colorScheme, .dark)

			DateInfoWidgetEntryView(entry: WidgetEntry(date: Date()))
				.preferredColorScheme(.dark)
				.previewContext(WidgetPreviewContext(family: .systemLarge))
				.redacted(reason: .placeholder)
		}
	}

#endif
