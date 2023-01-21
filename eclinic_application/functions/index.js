const functions = require("firebase-functions");
const admin = require('firebase-admin');

admin.initializeApp(functions.config().firebase);

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

exports.appointmentreminder = functions.pubsub.schedule('0 5 * * *').onRun(async (context) => {
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
                        if (Diff_in_hours <= 24 && Diff_in_hours > 0) {
                            // count the numder of appointments a faculty have to send it later
                            numOfBookedAppointments = numOfBookedAppointments + 1;

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
                                    title: 'Consultation appointment',
                                    body: `Tomorrow at ${StartTimeForAppointment}.`,
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
                    if (numOfBookedAppointments > 0) {
                        const payload = {
                            notification: {
                                title: 'Consultation appointment',
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

exports.gpAndEndonsemesterreminder = functions.pubsub.schedule('0 21 * * *').onRun(async (context) => {
    functions.logger.info("Hello logs", { structuredData: true });
    //response.send("Hello Firebase");
    const StudentsSnapshot = await admin.firestore().collection('student').get().then((querySnapshot) => {
        querySnapshot.forEach(async (doc) => {
            functions.logger.info(doc.id);
            var today = new Date();
            var gradDate = new Date(doc.data().graduationDate.toDate());
            functions.logger.info(today);
            functions.logger.info(gradDate);
            if (today.getDay() === gradDate.getDay() && today.getMonth() === gradDate.getMonth() && today.getFullYear() === gradDate.getFullYear()) {
                if (doc.data().uploadgp == false) {
                    functions.logger.info("in if", { structuredData: true });
                    const payload = {
                        notification: {
                            title: 'GP upload reminder',
                            body: `This is a reminder to upload you GP document in the GP library!`,
                            //icon: follower.photoURL
                        }
                    };
                    const response = await admin.messaging().sendToDevice(doc.data().token, payload);
                }

            }

        })
    })
    //sending notification to notify faculty about semester ending
    const SemesterSnapshot = await admin.firestore().collection('semester').get().then((querySnapshot) => {
        querySnapshot.forEach(async (doc) => {
            var today = new Date();
            var endDate = new Date(doc.data().enddate.toDate());
            if (today.getDay() === endDate.getDay() && today.getMonth() === endDate.getMonth() && today.getFullYear() === endDate.getFullYear()) {
                // functions.logger.info("doc.data().semestername");
                // functions.logger.info(doc.data().semestername);
                // check if their is faculty members
                if (doc.data().facultymembers != null) {
                    // functions.logger.info(doc.data().facultymembers);
                    // functions.logger.info(doc.data().facultymembers[0]['faculty']);

                    const payload = {
                        notification: {
                            title: 'Thank you for your effort',
                            body: `This semester has ended, but if you want to be a member of the help desk in the next semester, update the semester from your profile`,
                            //icon: follower.photoURL
                        }
                    };
                    var facultyRef = doc.data().facultymembers;

                    for (let i = 0; i < facultyRef.length; i++) {
                        var oneS = facultyRef[i]['faculty'].get().then(async (onefacultytDoc) => {
                            var token = onefacultytDoc.data().token
                            // functions.logger.info(token);
                            if (token != null) {
                                // functions.logger.info("in  if(token != null)");
                                const response = await admin.messaging().sendToDevice(token, payload);
                            }

                        });
                    }

                }

                //functions.logger.info("end of the loop");
            }
        })
    })



});



exports.updateFaculty = functions.firestore
    .document('faculty/{wildcard}')
    .onUpdate(async (change, context) => {
        // Get an object representing the document
        // e.g. {'name': 'Marie', 'age': 66}
        const semesterRef = await admin.firestore().collection('semester');
        const appointmentRef = await admin.firestore().collection('faculty').doc(context.params.wildcard).collection("appointment");
        functions.logger.info(context.params.wildcard);
        var today = new Date();

        const newValue = change.after.data();
        var newSemesterSnap = await semesterRef.doc(newValue.semester.id).get();
        var newsemestername = newSemesterSnap.data().semestername;


        const previousValue = change.before.data();
        var preSemesterSnap = await semesterRef.doc(previousValue.semester.id).get();
        var presemestername = preSemesterSnap.data().semestername;



        //return the name of the previous value
        functions.logger.info("previousValue");
        // (await semesterRef.doc(doc.id).get()).data()
        // previousValue.semester.get().then( (onesemesterDoc) => {
        //     functions.logger.info("onesemesterDoc");
        //     functions.logger.info(onesemesterDoc);
        //     presemestername = onesemesterDoc.data().semestername
        // });
        functions.logger.info(presemestername);


        // return the name of the new value
        functions.logger.info("newValue");
        functions.logger.info(newsemestername);


        const semesterIsUpdated = newsemestername !== presemestername;
        functions.logger.info("semesterIsUpdated");
        functions.logger.info(semesterIsUpdated);

        if (semesterIsUpdated === true) {
            functions.logger.info("in semesterIsUpdated change to ==");
            var facultyAppointmentSnap = await appointmentRef.get().then(
                (querySnapshot) => {
                    querySnapshot.forEach(async (doc) => {
                        // functions.logger.info(doc.data().Booked);
                        //check if the faculty have booked appointmments
                        if (doc.data().Booked === true) {
                            var startdate = new Date(doc.data().starttime.toDate());
                            // if the appointments in the future we will send a notification to the students
                            if (today < startdate) {
                                //get the faculty name
                                const facultySnap = await admin.firestore().collection('faculty').doc(context.params.wildcard).get();
                                var Fname = facultySnap.data().firstname + " " + facultySnap.data().lastname;
                                functions.logger.info(Fname);
                                functions.logger.info("today < startdate");


                                //format the start time and date
                                let appointmantTime = doc.data().starttime.toDate().getTime();
                                let appointmantTimeAfter3 = new Date(appointmantTime + 3 * 60 * 60 * 1000);// add 3h bcz it on UTC time not saudi time
                                //this is the time I will send it to the student
                                let StartTimeForAppointment = appointmantTimeAfter3.toLocaleTimeString('default', {
                                    hour: '2-digit',
                                    minute: '2-digit',
                                });
                                //same for end 
                                let appointmantTimeend = doc.data().endtime.toDate().getTime();
                                let appointmantTimeAfter3end = new Date(appointmantTimeend + 3 * 60 * 60 * 1000);// add 3h bcz it on UTC time not saudi time
                                //this is the time I will send it to the student
                                let endTimeForAppointment = appointmantTimeAfter3end.toLocaleTimeString('default', {
                                    hour: '2-digit',
                                    minute: '2-digit',
                                });

                                functions.logger.info("your appointment with Dr.", Fname, "date", startdate.getDate(), "/", startdate.getMonth(), "/", startdate.getFullYear(), "time", StartTimeForAppointment, "-", endTimeForAppointment);
                                var month = startdate.getMonth() + 1;
                                const payload = {
                                    notification: {
                                        title: 'Appointment cancelation',
                                        body: `your appointment with Dr.${Fname} on ${startdate.getDate()}/${month}/${startdate.getFullYear()} at ${StartTimeForAppointment} - ${endTimeForAppointment} has been canceled `,
                                        //icon: follower.photoURL
                                    }
                                };
                                //store the appointment refrence
                                var appointmentRef = doc.ref;
                                functions.logger.info("appointmentRef");
                                functions.logger.info(appointmentRef);
                                var studentsRef = doc.data().student;
                                for (let i = 0; i < studentsRef.length; i++) {
                                    var oneS = studentsRef[i].get().then(async (oneStudentDoc) => {
                                        var token = oneStudentDoc.data().token
                                        functions.logger.info(token);
                                        const response = await admin.messaging().sendToDevice(token, payload);
                                        //delete the appointment from the students appointment array
                                        studentsRef[i].update({ "appointments": admin.firestore.FieldValue.arrayRemove(appointmentRef) })
                                    });
                                }
                            }
                        }

                        //delet all doc
                        await admin.firestore().collection('faculty').doc(context.params.wildcard).collection("appointment").doc(doc.id).delete();

                    })
                }
            );
        }


        //check if the meetting method has changed 
        var meettingInfo = newValue.mettingmethodinfo;
        functions.logger.info("meettingInfo");
        functions.logger.info(meettingInfo);

        const meetingMethodInfoIsUpdated = newValue.mettingmethodinfo != previousValue.mettingmethodinfo;
        if (meetingMethodInfoIsUpdated) {
            functions.logger.info("meetingMethodInfoIsUpdated");
            var facultyAppointmentSnap = await appointmentRef.get().then(
                (querySnapshot) => {
                    querySnapshot.forEach(async (doc) => {
                        if (doc.data().Booked === true) {
                            var today = new Date();
                            var appointmentDate = new Date(doc.data().starttime.toDate());
                            var Difference_In_Time = (appointmentDate.getTime() - today.getTime()) / 1000;
                            Difference_In_Time /= (60 * 60);
                            //get the time in hours
                            Diff_in_hours = Math.abs(Math.round(Difference_In_Time));
                            // functions.logger.info('Difference_In_Time hours');
                            functions.logger.info(Diff_in_hours);

                            //if the appointment will start in the comming 24h then we will send a notification to the dr and students
                            if (Diff_in_hours <= 24 && Diff_in_hours > 0) {

                                const facultySnap = await admin.firestore().collection('faculty').doc(context.params.wildcard).get();
                                var Fname = facultySnap.data().firstname + " " + facultySnap.data().lastname;
                                functions.logger.info(Fname);

                                const payload = {
                                    notification: {
                                        title: 'Meetting method',
                                        body: `Dr. ${Fname}'s meeting method has changed for her upcoming appointments; please check it from the application.`,
                                        //icon: follower.photoURL
                                    }

                                };

                                var studentsRef = doc.data().student;
                                for (let i = 0; i < studentsRef.length; i++) {
                                    var oneS = studentsRef[i].get().then(async (oneStudentDoc) => {
                                        var token = oneStudentDoc.data().token
                                        functions.logger.info(token);
                                        const response = await admin.messaging().sendToDevice(token, payload);
                                       
                                    });
                                }
                            }
                        }
                    })
                })


        }

    });


