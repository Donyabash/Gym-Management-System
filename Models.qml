import QtQuick 2.12

Item {



    // Popular Classes Model
    property var popularClassesModel: [
        { name: "CrossFit Pro", capacity: 88, count: "44/50 slots", color: colors.colorPrimary },
        { name: "Yoga & Stretching", capacity: 64, count: "32/50 slots", color: colors.colorSuccess },
        { name: "Pilates Advanced", capacity: 92, count: "23/25 slots", color: colors.colorPurple },
        { name: "Spinning Cardio", capacity: 45, count: "18/40 slots", color: colors.colorWarning },
    ]

    // Recent Notifications Model
    property var notificationsModel: [
        { id: 1, title: "New Membership Registration", desc: "Sara Mohammadi subscribed to VIP Plan", time: "10 mins ago", type: "success" },
        { id: 2, title: "Capacity Alert", desc: "CrossFit Morning class is 90% full", time: "45 mins ago", type: "warning" },
        { id: 3, title: "Payment Received", desc: "$150 invoice paid via credit card", time: "2 hours ago", type: "info" }
    ]

    // Membership Tiers Model
    property var membershipTiersModel: [
        { title: "VIP Members", count: "320 members", percentage: 65, color: "#8b5cf6" },
        { title: "Standard Members", count: "980 members", percentage: 80, color: "#0284c7" },
        { title: "Corporate / Guest", count: "182 members", percentage: 40, color: "#10b981" }
    ]

    // Stats Model
    property var statsModel: [
        { title: "Total Members", value: "1,482", change: "+12% this month", isPositive: true, icon: "👥", color: colors.colorPrimary },
        { title: "Active Classes", value: "38", change: "+4 new today", isPositive: true, icon: "🏋️", color: colors.colorPurple },
        { title: "Monthly Revenue", value: "$24,500", change: "+8.4%", isPositive: true, icon: "💰", color: colors.colorSuccess },
        { title: "Pending Inquiries", value: "6", change: "-2 urgent", isPositive: false, icon: "📌", color: colors.colorWarning },

    ]


    // Weekly Traffic Data Model
    property var weeklyTrafficModel: [
        { day: "Sat", count: 120 },
        { day: "Sun", count: 150 },
        { day: "Mon", count: 190 },
        { day: "Tue", count: 170 },
        { day: "Wed", count: 210 },
        { day: "Thu", count: 240 },
        { day: "Fri", count: 95 }
    ]




}
