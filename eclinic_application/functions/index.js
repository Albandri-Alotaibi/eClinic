const functions = require("firebase-functions");
const admin = require('firebase-admin');

admin.initializeApp(functions.config().firebase);

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

exports.helloWorld = functions.https.onRequest(async (request, response) => {
    functions.logger.info("Hello logs", { structuredData: true });
    //response.send("Hello Firebase");

    //get the faculty collection Refrence
    const facultyRef = await admin.firestore().collection('faculty');

    //make a loop on faculty collection to get the appointments 
    const facultySnapshot = await admin.firestore().collection('faculty').get().then((querySnapshot) => {
        querySnapshot.forEach((doc) => {//loop on the faculty members
            functions.logger.info("before calling appointment collection", { structuredData: true });
            //faculty doc id
            functions.logger.info(doc.id);

            //get the appointment ref that are booked
            const appontmentRef = facultyRef.doc(doc.id).collection('appointment').where("Booked", '==', true);
            //chek if it has this collection
            appontmentRef.get().then(async (sub) => {
                if (sub.docs.length > 0) {//check if appointment doc exsist
                    functions.logger.info('subcollection exists');
                    var numOfBookedAppointments = 0;
                    sub.forEach(async (subDoc) => {//loop on booked appointments only
                        // functions.logger.info('subDoc id for the booked appointment');
                        // functions.logger.info(subDoc.id);
                        // functions.logger.info('subDoc.data().starttime');
                        // functions.logger.info(subDoc.data().starttime);


                        //NOTE: I did not add a natify field bcz I will push notifications only once a day and the notifications that after this will be sended imedutly

                        //today date
                        var today = new Date();
                        // functions.logger.info('today');
                        // functions.logger.info(today);
                        // functions.logger.info('today.getTime()');
                        // functions.logger.info(today.getTime());

                        //appointment start date and time
                        var appointmentDate = new Date(subDoc.data().starttime.toDate());
                        // functions.logger.info('appointmentDate');
                        // functions.logger.info(appointmentDate);




                        // To calculate the time difference of two dates
                        var Difference_In_Time = (appointmentDate.getTime() - today.getTime()) / 1000;
                        Difference_In_Time /= (60 * 60);
                        //get the time in hours
                        Diff_in_hours = Math.abs(Math.round(Difference_In_Time));
                        // functions.logger.info('Difference_In_Time hours');
                        // functions.logger.info(Diff_in_hours);

                        //if the appointment will start in the comming 24h then we will send a notification to the dr and students
                        if (Diff_in_hours <= 24) {
                            // count the numder of appointments a faculty have to send it later
                            numOfBookedAppointments = numOfBookedAppointments+1;

                            //now we will send to the student the reminders
                            //first we will get the faculty member name
                            facultyName = doc.data().firstname + " " + doc.data().lastname;
                            // functions.logger.info('faculty Name');
                            // functions.logger.info(facultyName);

                            //now we will get the appointment time
                            let appointmantTime = subDoc.data().starttime.toDate().getTime();
                            let appointmantTimeAfter3 = new Date(appointmantTime + 3 * 60 * 60 * 1000);// add 3h bcz it on UTC time not saudi time

                            //this is the time I will send it to the student
                            let StartTimeForAppointment = appointmantTimeAfter3.toLocaleTimeString('default', {
                                hour: '2-digit',
                                minute: '2-digit',
                            });
                            // functions.logger.info('appointmant start Time');
                            // functions.logger.info(StartTimeForAppointment);//the time in saudi 
                            // Notification details.
                            const payload = {
                                notification: {
                                    title: 'Appointment reminder',
                                    body: `You have an appointment tomorrow with Dr.${facultyName} at ${StartTimeForAppointment}.`,
                                    //icon: follower.photoURL
                                }
                            };
                            var studentsRef = subDoc.data().student;
                            for (let i = 0; i < studentsRef.length; i++) {
                                var oneS = studentsRef[i].get().then(async (oneStudentDoc) => {
                                    var token = oneStudentDoc.data().token
                                    functions.logger.info(token);
                                    const response = await admin.messaging().sendToDevice(token, payload);
                                });
                            }

                            // tokens = "f2Fy3zYaR-OqtIsht7D3L3:APA91bHihw83eQLNqgFpIOLHcQ2XzCX7JOJLK9IyMrc8XHcssBaKoga3mMAWEMwEY_i5kxbgLiJuHHj-PdPESVtuqryHUWspyFsXUnJHWvHAWsnrw1n4IipbLUsAdbo2ESLiPs5y6nY9";
                            // Send notifications to tokens.
                            // const response = await admin.messaging().sendToDevice(tokens, payload);


                        }

                    })// end of loop on booked appointments
                    //here we will send the reminder for the faculty!!!!!!!!
                    if(numOfBookedAppointments>0){
                        const payload = {
                            notification: {
                                title: 'Appointment reminder',
                                body: `You have ${numOfBookedAppointments} appointment(s) tomorrow.`,
                                //icon: follower.photoURL
                            }
                        };
                        const response = await admin.messaging().sendToDevice(doc.data().token, payload);
                    }
                }//ENF OF check if appointment doc exsist 
            });



            functions.logger.info("after calling appointment collection", { structuredData: true });

        });//end of the loop
    });

});




