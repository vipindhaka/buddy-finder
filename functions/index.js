const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.onCreateConversation = functions.region('asia-south1'). firestore.
document("allConversations/{conversationID}").
onCreate(async (snapshot,context) => {
    
const data=snapshot.data();
const conversationID=context.params.conversationID;
if(data){
    
var members=data.members;
for( var index=0; index<members.length; index++){
    
var currentuserID=members[index];

var value=Math.abs(members.length-index-1);

var remainingUserIDs=members[value];
if(remainingUserIDs){
     try {
        const doc = await admin.firestore().collection("users")
            .doc(remainingUserIDs).get();
        var userData = doc.data();
        if (userData) {
            await admin.firestore().collection("users")
                .doc(currentuserID).collection("conversations").doc(remainingUserIDs)
                .create({
                    "conversationID": conversationID,
                    "name": userData.name,
                    
                });
        }
        //return null;
    } catch (e) {
        return null;
    }
}
}
}
return null;
});

exports.onConversationUpdated=functions.region('asia-south1').firestore.document("allConversations/{chatId}/chats/{chatMessage}").onCreate(async (snapshot,context)=>{
const data=snapshot.data();
const chatId=context.params.chatId;
if(data){
    const convodoc=await admin.firestore().collection('allConversations').doc(chatId).get();
    var convoData=convodoc.data();
    var members=convoData.members;
    for(var index=0;index<members.length;index++){
        var currentuserID=members[index];
        var value=Math.abs(members.length-index-1);
        var remainingUserIDs=members[value];
        if(remainingUserIDs){
            try {
               const doc = await admin.firestore().collection("users")
                   .doc(remainingUserIDs).get();
               var userData = doc.data();
               if(remainingUserIDs!=data.senderId){  
                   var usertoken=userData.token;
                   const message ={
                       body:'You have a new message',
                       token:usertoken
                   }
                   admin.messaging.send(message);
               }
           
               if (userData) {
                   await admin.firestore().collection("users")
                       .doc(currentuserID).collection("conversations").doc(remainingUserIDs)
                       .update({
                           'lastMessage':data.message,
                           'timestamp':data.timestamp,
                           
                           'senderId':data.senderId
                       
                           
                       });
               }
           
               
           } catch (e) {
               return null;
           }
       }
    }
}
});
