# Android Migration Documentation for MESS App

## Overview
This document provides comprehensive documentation for migrating the MESS iOS app to Android. The MESS app is a real-time messaging application with Direct Message (DM) and Broadcast chat functionalities. The Android version should maintain the same user experience, architecture, and features while adhering to Android design principles and Material You 3 theme.

## Server Information
- **Base URL**: `https://mess-backend-qseb.onrender.com`
- **Broadcast Socket Namespace**: `/` (default)
- **DM Socket Namespace**: `/DM`
- **Ping Endpoint**: `GET /` (returns server status and database state)

## Architecture Overview

### App Structure
The app follows a tab-based navigation with two main sections:
1. **DM (Direct Messages)**: Private conversations with individual users
2. **Broadcast**: Global chat room where all users can communicate

### Key Components
- **Landing Screen**: TabView with DM and Broadcast tabs
- **DM Section**: Chat list with connection management
- **Broadcast Section**: Global chat interface
- **Socket Managers**: Handle real-time communication using Socket.IO
- **Message Models**: Data structures for messages
- **UI Components**: Message bubbles, input fields, navigation elements

## Data Models

### Message
```kotlin
data class Message(
    val id: String,
    val message: String,
    val isSent: Boolean,
    val timeStamp: Date
)
```

### MessageArray (for Broadcast)
```kotlin
data class MessageArray(
    val id: String? = null,
    val message: String,
    val isSent: Boolean,
    val displayName: String
)
```

### StatusPing
```kotlin
data class StatusPing(
    val status: String,
    val databaseState: String
)
```

## Real-Time Communication

### Socket.IO Integration
The app uses Socket.IO for real-time messaging. Use the official Socket.IO Android client library.

#### Broadcast Socket Manager
- **Connection URL**: `https://mess-backend-qseb.onrender.com`
- **Events**:
  - `connect`: Connection established
  - `disconnect`: Connection lost
  - `recieve-new-message`: New broadcast message received
- **Emit Events**:
  - `send-message`: Send message with parameters:
    - `message`: String
    - `displayName`: String (device/platform name)
    - `IsSent`: Boolean (false for sent messages)
    - `uid`: String (device identifier)

#### DM Socket Manager
- **Connection URL**: `https://mess-backend-qseb.onrender.com/DM`
- **Events**: Similar to Broadcast
  - `connect`
  - `disconnect`
  - `recieve-new-message`
- **Emit Events**:
  - `send-message`: Send message with `message` parameter

### Webhooks for Notifications
For push notifications when the app is in background:
- Implement webhook endpoints on the server to receive real-time updates
- Use Firebase Cloud Messaging (FCM) or similar for Android push notifications
- Configure webhooks to trigger notifications for new messages in both DM and Broadcast

## User Interface Design

### Material You 3 Theme
- Use Material 3 components throughout the app
- Implement dynamic color theming based on user's wallpaper
- Use Material 3 color schemes:
  - Primary colors for app branding
  - Surface colors for backgrounds
  - On-surface colors for text

### Screen Layouts

#### Landing Screen
- Bottom navigation with two tabs:
  - DM tab (icon: message/chat icon)
  - Broadcast tab (icon: antenna/radio waves icon)
- Background color: Material surface color

#### DM Screen
- **iPad/Tablet**: Use Navigation Rail or Drawer for chat list
- **Phone**: Navigation Stack with back navigation
- **Chat List**:
  - Connection button to enter server URI
  - Static preview chat (for demo)
  - Dynamic user list (when connected)
- **Empty State**: Show placeholder when no chat is selected

#### Broadcast Screen
- Full-screen chat interface
- Username: Use device name/model as identifier
- Message list with display names
- Input field at bottom with send button

#### Chat Interface (Both DM and Broadcast)
- **Message List**:
  - ScrollView with message bubbles
  - Sent messages: Right-aligned, theme color background
  - Received messages: Left-aligned, gray background
  - Profile image for received messages (use default avatar)
  - Display name for broadcast messages
  - Tap to show/hide timestamp

- **Message Input**:
  - TextField with capsule background
  - Send button (paper plane icon)
  - Connection status indicator
  - Keyboard handling with safe area insets

### Message Bubble Design
- **Sent Messages**:
  - Right alignment
  - Theme color background (Material primary)
  - Rounded corners (30dp radius)

- **Received Messages**:
  - Left alignment
  - Gray background (Material surface variant)
  - Profile image (30x30dp, circular)
  - Rounded corners (30dp radius)

- **Broadcast Messages**:
  - Include display name above message
  - Gray text for display name

- **Timestamp**:
  - Hidden by default
  - Show on tap with fade animation
  - Format: HH:MM

## Implementation Guidelines

### Dependencies
```gradle
dependencies {
    // Socket.IO
    implementation 'io.socket:socket.io-client:2.1.0'
    
    // Material 3
    implementation 'androidx.compose.material3:material3:1.1.2'
    
    // Compose BOM
    implementation platform('androidx.compose:compose-bom:2023.03.00')
    
    // Other essentials
    implementation 'androidx.activity:activity-compose:1.8.2'
    implementation 'androidx.lifecycle:lifecycle-viewmodel-compose:2.7.0'
}
```

### Key Classes Structure
```
app/
├── MainActivity.kt
├── ui/
│   ├── theme/
│   │   ├── Color.kt
│   │   ├── Theme.kt
│   │   └── Type.kt
│   ├── components/
│   │   ├── MessageBubble.kt
│   │   ├── BroadcastMessageBubble.kt
│   │   └── MessageInput.kt
│   └── screens/
│       ├── LandingScreen.kt
│       ├── DMContentScreen.kt
│       ├── BroadcastContentScreen.kt
│       └── ChatScreen.kt
├── data/
│   ├── models/
│   │   ├── Message.kt
│   │   └── MessageArray.kt
│   └── socket/
│       ├── BroadcastSocketManager.kt
│       └── DMSocketManager.kt
└── utils/
    ├── Constants.kt
    └── Extensions.kt
```

### Socket Management
```kotlin
class BroadcastSocketManager(
    private val socketUrl: String,
    private val username: String,
    private val displayName: String = "Android"
) {
    private lateinit var socket: Socket
    
    fun connect() {
        val opts = IO.Options()
        opts.forceNew = true
        opts.query = "platformInfo=$username"
        
        socket = IO.socket(socketUrl, opts)
        socket.connect()
        
        socket.on(Socket.EVENT_CONNECT) {
            // Handle connection
        }
        
        socket.on("recieve-new-message") { args ->
            // Handle incoming message
            val message = parseMessage(args[0])
            // Update UI
        }
    }
    
    fun sendMessage(message: String) {
        socket.emit("send-message", JSONObject().apply {
            put("message", message)
            put("displayName", displayName)
            put("IsSent", false)
            put("uid", username)
        })
    }
}
```

### Compose UI Example
```kotlin
@Composable
fun MessageBubble(message: Message) {
    val alignment = if (message.isSent) Alignment.End else Alignment.Start
    val backgroundColor = if (message.isSent) 
        MaterialTheme.colorScheme.primary 
        else MaterialTheme.colorScheme.surfaceVariant
    
    Column(
        modifier = Modifier.fillMaxWidth(),
        horizontalAlignment = alignment
    ) {
        Row(
            verticalAlignment = Alignment.Bottom,
            modifier = Modifier.widthIn(max = 300.dp)
        ) {
            if (!message.isSent) {
                // Profile image
                Image(
                    painter = painterResource(R.drawable.default_avatar),
                    contentDescription = null,
                    modifier = Modifier
                        .size(30.dp)
                        .clip(CircleShape)
                )
            }
            
            Text(
                text = message.message,
                modifier = Modifier
                    .background(
                        color = backgroundColor,
                        shape = RoundedCornerShape(30.dp)
                    )
                    .padding(16.dp)
            )
        }
    }
}
```

## User Experience Requirements

### Same as iOS
1. **Tab Navigation**: Bottom tabs for DM and Broadcast
2. **Message Display**: Right for sent, left for received
3. **Real-time Updates**: Instant message delivery via Socket.IO
4. **Connection Management**: Manual server connection with URI input
5. **Keyboard Handling**: Input field adjusts with keyboard
6. **Timestamp Display**: Tap message to show/hide time
7. **Device Identification**: Use device name as username

### Android-Specific Adaptations
1. **Material You 3**: Use dynamic theming and Material 3 components
2. **Navigation**: Use Navigation Component with bottom navigation
3. **Responsive Design**: Adapt layouts for different screen sizes
4. **Permissions**: Request necessary permissions for network access
5. **Background Processing**: Use WorkManager for background socket management
6. **Notifications**: Implement FCM for push notifications

## API Calls and Endpoints

### Server Ping
```kotlin
suspend fun pingServer(): StatusPing {
    val response = httpClient.get("https://mess-backend-qseb.onrender.com/")
    return response.body()
}
```

### Socket Events
- All real-time communication happens through Socket.IO events
- No REST API calls for messaging - everything is WebSocket-based

## Testing Guidelines
1. Test socket connections and disconnections
2. Verify message sending and receiving
3. Test UI on different screen sizes and orientations
4. Validate Material You 3 theming
5. Test push notifications for background messages

## Deployment Considerations
1. Configure app signing and build variants
2. Set up Firebase for notifications
3. Configure network security config for cleartext traffic if needed
4. Implement proper error handling and offline states
5. Add analytics and crash reporting

This documentation covers all aspects of the iOS app to ensure a faithful Android implementation with Material You 3 design and equivalent functionality.</content>
<parameter name="filePath">/Users/nigg/Documents/MESS/AndroidMigration.md