/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const { setGlobalOptions } = require("firebase-functions");
const { onRequest } = require("firebase-functions/https");
const logger = require("firebase-functions/logger");

// For cost control, you can set the maximum number of containers that can be
// running at the same time. This helps mitigate the impact of unexpected
// traffic spikes by instead downgrading performance. This limit is a
// per-function limit. You can override the limit for each function using the
// `maxInstances` option in the function's options, e.g.
// `onRequest({ maxInstances: 5 }, (req, res) => { ... })`.
// NOTE: setGlobalOptions does not apply to functions using the v1 API. V1
// functions should each use functions.runWith({ maxInstances: 10 }) instead.
// In the v1 API, each function can only serve one request per container, so
// this will be the maximum concurrent request count.
setGlobalOptions({ maxInstances: 10 });

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });




const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendMessageNotification = functions.firestore
  .document('messages/{messageId}')
  .onCreate(async (snap, context) => {
    const message = snap.data();

    const receiverToken = message.receiverToken; // store this in your Firestore
    const payload = {
      notification: {
        title: "New Message",
        body: message.text,
      },
      data: {
        messageId: context.params.messageId,
      },
    };

    await admin.messaging().sendToDevice(receiverToken, payload);
  });



  


// const functions = require("firebase-functions");
// const admin = require("firebase-admin");

// admin.initializeApp();

// // Trigger when a new message is added
// exports.markMessageReceived = functions.firestore
//   .document("chatsBeta/{chatId}/messages/{msgId}")
//   .onCreate(async (snap, context) => {
//     const message = snap.data();

//     if (!message.toId) return null;

//     try {
//       // Fetch recipient's push token
//       const userDoc = await admin
//         .firestore()
//         .collection("usersBeta")
//         .doc(message.toId)
//         .get();

//       const userData = userDoc.data();
//       const pushToken = userData ? userData.push_token : null;

//       if (!pushToken) return null;

//       // Send FCM notification
//       const payload = {
//         token: pushToken,
//         notification: {
//           title: "New message",
//           body: message.msg
//         },
//         data: {
//           msgId: context.params.msgId,
//           fromId: message.fromId,
//           type: "chat_message"
//         }
//       };

//       await admin.messaging().send(payload);

//       // Update receivedAt
//       await snap.ref.update({
//         receivedAt: admin.firestore.FieldValue.serverTimestamp()
//       });

//       console.log(`Message ${context.params.msgId} marked as received.`);
//     } catch (error) {
//       console.error("Error sending FCM / updating receivedAt:", error);
//     }

//     return null;
//   });







