//
//  TooPoopToGoWidget.swift
//  TooPoopToGoWidget
//
//  Created by Christian Catenacci on 03/06/24.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        //questo è il place holder mentre carica
        SimpleEntry(date: Date(), emoji: "😀")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        //questo è il widget aggiornato in quel momento
        let entry = SimpleEntry(date: Date(), emoji: "😀")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        //determina ogni quando updetarlo
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, emoji: "😀")
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    //la data serve sempre per fargli capire quando aggiornare
    let date: Date
    let emoji: String
}

struct TooPoopToGoWidgetEntryView : View {
    var entry: Provider.Entry
    // UI
    var body: some View {
        ZStack {
            Image("Background")
                .resizable()
                .frame(width: 200, height: 200)
            
            VStack{
                HStack{
                    Text("Remember to")
                        .foregroundStyle(.white)
                        .bold()
                        .font(.system(size: 20))
                        .padding(.top, 35)
                    
                    Spacer()
                }.padding(.leading, 33)
                HStack{
                    Text("Poop!")
                        .foregroundStyle(.white)
                        .bold()
                        .font(.system(size: 20))
                    
                    Spacer()
                }.padding(.leading, 33)
               
                Spacer()
            }
           
            VStack{
                
                Spacer()
                HStack{
                    
                    Text("Drop it now!")
                        .foregroundStyle(.black)
                        .bold()
                        .font(.system(size: 16))
                    
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 7)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 1000))
                
            }.padding(.bottom, 32)
            
                
        }.ignoresSafeArea(edges: .all)
    }
}

struct TooPoopToGoWidget: Widget {
    let kind: String = "TooPoopToGoWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                TooPoopToGoWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                TooPoopToGoWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemSmall]) // This line restricts the widget to small size only
    }
}

#Preview(as: .systemSmall) {
    TooPoopToGoWidget()
} timeline: {
    SimpleEntry(date: .now, emoji: "😀")
    SimpleEntry(date: .now, emoji: "🤩")
}
