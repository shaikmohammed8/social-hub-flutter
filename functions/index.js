const functions = require("firebase-functions");

exports.onCreateFollwers = functions.firestore
    .document("/followers/{userId}/userFollowers/{followerId}")
    .onCreate((snapshot, context) => {
        const userId = context.params.userId;
        const followerId = context.params.followerId;

    });

