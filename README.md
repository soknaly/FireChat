# FireChat
FireChat is an iOS Chat App work with Firebase. The purpose of creating this app is to use for my public code-lab session in Google Developer Group Phnom Penh's DevFest 2016. 

#Features
- Login and register with email and password
- Social authentication like Facebook, Google+
- Add Chat with your friend's email
- Send messages to friends in real-time 
- Send photo to friends in real-time
- Real-time user's typing indicator 
- Edit Profile
- Change password

##Get Started
Before get started, please download this UI-Only Project into your computer with following ways:

- [Download this project](https://github.com/soknaly/FireChat/archive/starter.zip)

or

- Using git 

```bash
git clone -b stater https://github.com/soknaly/FireChat.git
```
- After you have project in your computer, you can learn more about Firebase [here](https://firebase.google.com/docs/ios/setup)

##JSON Structure 
```

├── users
│   ├── chats
│   ├── displayName
│   ├── email
│   ├── online
│   └── photoURL
├── chats
│   └── userID
│       └── chatID
│           ├── lastMessage
│           ├── lastSenderID
│           ├── recipientID
│           └── timestamp
├── messages
│   └── chatID
│       └── messageID
│           ├── message
│           ├── senderID
│           └── timestamp
├── typing
│   └── userID

```

##LICENSE

MIT © [Sokna Ly](https://www.linkedin.com/in/soknaly)
