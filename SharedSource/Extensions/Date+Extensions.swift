import Foundation

extension Date {
    
    /// Returns a key unique to today e.g. "3_28_17"
    static func todayKey(suffix: String = "") -> String {
        return Date().dayKey() + suffix
    }
    
    /// Returns a key unique to today e.g. "3_28_17"
    func dayKey() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        let s = dateFormatter.string(from: self).replacingOccurrences(of: "/", with: "_")
        return s
    }
    
    func dateString(_ format: String = "yyyy-MM-dd") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    static func parse(_ string: String, format: String = "yyyy-MM-dd") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.default
        dateFormatter.dateFormat = format
        
        let date = dateFormatter.date(from: string)!
        return date
    }
    
    static func from(year: Int, month: Int, day: Int) -> Date {
        let gregorianCalendar = NSCalendar(calendarIdentifier: .gregorian)!
        
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        
        let date = gregorianCalendar.date(from: dateComponents)!
        return date
    }
    
    func daysTo(date: Date) -> Int {
        return Date.daysBetween(start: self, end: date)
    }
    
    func daysFrom(date: Date) -> Int {
        return Date.daysBetween(start: date, end: self)
    }
    
    static func daysBetween(start: Date, end: Date) -> Int {
        let calendar = Calendar.current
        
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: start)
        let date2 = calendar.startOfDay(for: end)
        
        let a = calendar.dateComponents([.day], from: date1, to: date2)
        return abs(a.value(for: .day)!)
    }

    func usDateString() -> String {
        return dateString("MM/dd/yyyy")
    }
}
