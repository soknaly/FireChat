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

##Screenshots

<img src="https://github.com/soknaly/FireChat/blob/master/Screenshots/screenshot_1.PNG" width="250" height="445"/>
<img src="https://github.com/soknaly/FireChat/blob/master/Screenshots/screenshot_2.PNG" width="250" height="445"/>
<img src="https://github.com/soknaly/FireChat/blob/master/Screenshots/screenshot_3.PNG" width="250" height="445"/>
<img src="https://github.com/soknaly/FireChat/blob/master/Screenshots/screenshot_4.PNG" width="250" height="445"/>
<img src="https://github.com/soknaly/FireChat/blob/master/Screenshots/screenshot_5.PNG" width="250" height="445"/>

##Get Started
Before get started, please download this UI-Only Project into your computer with following ways:

- [Download this project](https://github.com/soknaly/FireChat/archive/starter.zip)

or

- Using git 

```bash
git clone -b starter https://github.com/soknaly/FireChat.git
```
- After you have project in your computer, you can learn more about Firebase [here](https://firebase.google.com/docs/ios/setup)

##Presentation File
You can download and check presentation slide [here](https://drive.google.com/open?id=1goZB-wtC_48YUAsd614TmU8u-WunfDKeT1BmDhjtWLQ). 

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
