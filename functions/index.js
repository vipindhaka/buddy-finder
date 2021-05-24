const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.onCreateConversation = functions.firestore.
document("allConversations/{conversationID}").
onCreate(async (snapshot,context) => {
    console.log("start");
const data=snapshot.data();
const conversationID=context.params.conversationID;
if(data){
    console.log("inside first if");
var members=data.members;
for( var index=0; index<members.length; index++){
    console.log("inside for");
var currentuserID=members[index];
console.log(index);
var value=Math.abs(members.length-index-1);
console.log(value);
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
