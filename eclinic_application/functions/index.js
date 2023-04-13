const functions = require("firebase-functions");
const admin = require('firebase-admin');

admin.initializeApp(functions.config().firebase);

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

exports.appointmentreminder = functions.pubsub.schedule('0 5 * * *').onRun(async (context) => {
    functions.logger.info("Hello logs", { structuredData: true });


    //get the faculty collection Refrence
    const facultyRef = await admin.firestore().collection('faculty');

    //make a loop on faculty collection to get the appointments 
    const facultySnapshot = await admin.firestore().collection('faculty').get().then((querySnapshot) => {
        querySnapshot.forEach((doc) => {//loop on the faculty members
            // functions.logger.info("before calling appointment collection", { structuredData: true });
            //faculty doc id
            //    functions.logger.info(doc.id);

            //get the appointment ref that are booked
            const appontmentRef = facultyRef.doc(doc.id).collection('appointment').where("Booked", '==', true);
            //chek if it has this collection
            appontmentRef.get().then(async (sub) => {
                if (sub.docs.length > 0) {//check if appointment doc exsist
                    functions.logger.info('subcollection exists');
                    var numOfBookedAppointments = 0;
                    sub.forEach(async (subDoc) => {//loop on booked appointments only

                        //today date
                        var today = new Date();

                        //appointment start date and time
                        var appointmentDate = new Date(subDoc.data().starttime.toDate());


                        // To calculate the time difference of two dates
                        var Difference_In_Time = (appointmentDate.getTime() - today.getTime()) / 1000;
                        Difference_In_Time /= (60 * 60);
                        //get the time in hours
                        Diff_in_hours = Math.abs(Math.round(Difference_In_Time));

                        //if the appointment will start in the comming 24h then we will send a notification to the dr and students
                        if (Diff_in_hours <= 24 && Diff_in_hours > 0) {
                            // count the numder of appointments a faculty have to send it later
                            numOfBookedAppointments = numOfBookedAppointments + 1;

                            //now we will send to the student the reminders
                            //first we will get the faculty member name
                            facultyName = doc.data().firstname + " " + doc.data().lastname;

                            //now we will get the appointment time
                            let appointmantTime = subDoc.data().starttime.toDate().getTime();
                            let appointmantTimeAfter3 = new Date(appointmantTime + 3 * 60 * 60 * 1000);// add 3h bcz it on UTC time not saudi time

                            //this is the time I will send it to the student
                            let StartTimeForAppointment = appointmantTimeAfter3.toLocaleTimeString('default', {
                                hour: '2-digit',
                                minute: '2-digit',
                            });

                            // Notification details.
                            const payload = {
                                notification: {
                                    title: 'Consultation appointment',
                                    body: `Tomorrow at ${StartTimeForAppointment}.`,
                                    //icon: follower.photoURL
                                }
                            };
                            var groupData = subDoc.data().group;
                            functions.logger.info("Student group ID");
                            functions.logger.info(groupData.id, { structuredData: true });

                            groupData.get().then(async (oneGroup) => {
                                functions.logger.info("get the group");
                                var studentsRefArray = oneGroup.data().students;
                                functions.logger.info("students");
                                functions.logger.info(studentsRefArray);
                                for (let i = 0; i < studentsRefArray.length; i++) {
                                    var oneS = studentsRefArray[i].ref.get().then(async (oneStudent) => {
                                        var token = oneStudent.data().token;
                                        functions.logger.info("token");
                                        functions.logger.info(token);
                                        if (token != null || token != "") {
                                            // functions.logger.info("in  if(token != null)");
                                            const response = await admin.messaging().sendToDevice(token, payload);
                                        }
                                    });
                                }

                            });

                        }

                    })// end of loop on booked appointments
                    //here we will send the reminder for the faculty!!!!!!!!
                    if (numOfBookedAppointments > 0) {
                        const payload = {
                            notification: {
                                title: 'Consultation appointment',
                                body: `You have ${numOfBookedAppointments} appointment(s) tomorrow.`,

                            }
                        };
                        if (doc.data().token != null || doc.data().token != "") {
                            // functions.logger.info("in  if(token != null)");
                            const response = await admin.messaging().sendToDevice(doc.data().token, payload);
                        }

                    }
                }//ENF OF check if appointment doc exsist 
            });



            //functions.logger.info("after calling appointment collection", { structuredData: true });

        });//end of the loop

    });
    functions.logger.info("END of the", { structuredData: true });

});

// updated
exports.gpAndEndofsemesterreminder = functions.pubsub.schedule('0 21 * * *').onRun(async (context) => {
    functions.logger.info("Hello logs", { structuredData: true });
    //response.send("Hello Firebase");
    const StudentsSnapshot = await admin.firestore().collection('studentgroup').get().then((querySnapshot) => {
        querySnapshot.forEach(async (doc) => { //doc os the group
            functions.logger.info(doc.id);
            var today = new Date();
            var GPdate = new Date(doc.data().Projectcompletiondate.toDate());
            functions.logger.info(today);
            functions.logger.info(GPdate);
            if (today.getDay() === GPdate.getDay() && today.getMonth() === GPdate.getMonth() && today.getFullYear() === GPdate.getFullYear()) {
                if (doc.data().uploadgp == false) {
                    functions.logger.info("in if", { structuredData: true });
                    const payload = {
                        notification: {
                            title: 'GP upload reminder',
                            body: `This is a reminder to upload you GP document in the GP library!`,
                            //icon: follower.photoURL
                        }
                    };
                    var studentsRefArray = doc.data().students;

                    for (let i = 0; i < studentsRefArray.length; i++) {
                        var oneS = studentsRefArray[i]['ref'].get().then(async (oneStudentDoc) => {
                            var token = oneStudentDoc.data().token
                            functions.logger.info('token');
                            functions.logger.info(token);
                            if (token != null) {
                                // functions.logger.info("in  if(token != null)");
                                const response = await admin.messaging().sendToDevice(token, payload);
                            }

                        });
                    }

                }

            }

        })
    })
    //sending notification to notify faculty about semester ending

    const SemesterSnapshot = await admin.firestore().collection('semester').get().then((querySnapshot) => {
        querySnapshot.forEach(async (doc) => {
            var today = new Date();
            var endDate = doc.data().enddate;
            if (endDate != null) {
                endDate = new Date(endDate.toDate());
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


        // if the faculty member changed the department all the appointments will be chanced
        const departmentRef = await admin.firestore().collection('department');

        var newDepartmentSnap = await departmentRef.doc(newValue.department.id).get();
        var newDepartmentname = newDepartmentSnap.data().departmentname;
        functions.logger.info(newValue.department.id);


        var preDepartmentSnap = await departmentRef.doc(previousValue.department.id).get();
        var preDepartmentname = preDepartmentSnap.data().departmentname;
        const departmentIsUpdated = newDepartmentname !== preDepartmentname;
        functions.logger.info("departmentIsUpdated");
        functions.logger.info(departmentIsUpdated);


        const semesterIsUpdated = newsemestername !== presemestername;
        // functions.logger.info("semesterIsUpdated");
        // functions.logger.info(semesterIsUpdated);

        if (semesterIsUpdated === true || departmentIsUpdated === true) {
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

                                functions.logger.info("your appointment with ", Fname, "date", startdate.getDate(), "/", startdate.getMonth(), "/", startdate.getFullYear(), "time", StartTimeForAppointment, "-", endTimeForAppointment);
                                var month = startdate.getMonth() + 1;
                                const payload = {
                                    notification: {
                                        title: 'Appointment cancelation',
                                        body: `your appointment with ${Fname} on ${startdate.getDate()}/${month}/${startdate.getFullYear()} at ${StartTimeForAppointment} - ${endTimeForAppointment} has been canceled `,
                                        //icon: follower.photoURL
                                    }
                                };
                                //store the appointment refrence

                                var appointmentRef = doc.ref;
                                var groupData = doc.data().group;
                                functions.logger.info("Student group ID");
                                functions.logger.info(groupData.id, { structuredData: true });

                                groupData.get().then(async (oneGroup) => {
                                    functions.logger.info("get the group");
                                    var studentsRefArray = oneGroup.data().students;
                                    for (let i = 0; i < studentsRefArray.length; i++) {
                                        var oneS = studentsRefArray[i].ref.get().then(async (oneStudent) => {
                                            var token = oneStudent.data().token;
                                            functions.logger.info("token");
                                            functions.logger.info(token);
                                            if (token != null) {
                                                // functions.logger.info("in  if(token != null)");
                                                const response = await admin.messaging().sendToDevice(token, payload);
                                            }

                                        });
                                    }
                                    //delete the appointment from the array
                                    const gRef = await admin.firestore().collection('studentgroup').doc(groupData.id);
                                    gRef.update({ "appointments": admin.firestore.FieldValue.arrayRemove(appointmentRef) })
                                });
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
                                        body: `${Fname}'s meeting method has changed for the upcoming appointments; please check it on the application.`,
                                        //icon: follower.photoURL
                                    }

                                };

                                var groupData = doc.data().group;
                                functions.logger.info("Student group ID");
                                functions.logger.info(groupData.id, { structuredData: true });

                                groupData.get().then(async (oneGroup) => {
                                    functions.logger.info("get the group");
                                    var studentsRefArray = oneGroup.data().students;
                                    functions.logger.info("students");
                                    functions.logger.info(studentsRefArray);
                                    for (let i = 0; i < studentsRefArray.length; i++) {
                                        var oneS = studentsRefArray[i].ref.get().then(async (oneStudent) => {
                                            var token = oneStudent.data().token;
                                            functions.logger.info("token");
                                            functions.logger.info(token);
                                            if (token != null) {
                                                // functions.logger.info("in  if(token != null)");
                                                const response = await admin.messaging().sendToDevice(token, payload);
                                            }
                                        });
                                    }

                                });
                            }
                        }
                    })
                })


        }



    });



//a Funtion to create appointments in the backend
exports.generatingAppointments = functions.https.onCall(async (data, context) => {
    // const functions = require("firebase-functions");
    functions.logger.log("generatingAppointments Is running");

    const uid = context.auth.uid;
    const facultySnap = await admin.firestore().collection('faculty').doc(uid).get();
    var availablehours = facultySnap.data().availablehours;
    //get the faculty semester start and end dates
    var startDate;
    var endDate;
    await facultySnap.data().semester.get().then((sem) => {
        functions.logger.log(sem.data().semestername);
        startDate = sem.data().startdate;
        endDate = sem.data().enddate;

    });
    // functions.logger.log(startDate);
    // functions.logger.log(endDate);
    // functions.logger.log("availablehours");
    // functions.logger.log(availablehours);

    for (var i = 0; i < availablehours.length; i++) {//loop on all the days
        functions.logger.log("for loop availablehours.length");
        var ArrayOfAllTheDayRanges = [];
        for (var j = 0; j < availablehours[i]['time'].length; j++) {//loop for one day and multi periods of time 
            // functions.logger.log("for loop availablehours[i][time].length");
            // functions.logger.log(availablehours[i]['time'].length);
            functions.logger.log(availablehours[i]['Day']);
            var startTimeAsString = availablehours[i]['time'][j]['startTime'];
            var endTimeAsString = availablehours[i]['time'][j]['endTime'];


            var StartArrayTemp = startTimeAsString.split(" ");
            var StartArray = StartArrayTemp[0].split(":");

            // get hours and minutes
            var Shours = parseInt(StartArray[0]);
            var Sminutes = parseInt(StartArray[1]);
            // get am/pm designation
            var designation = StartArrayTemp[1];
            if (Shours === 12 && designation === "AM") {
                Shours -= 12;
            }
            if (designation === "PM" && Shours < 12) {
                Shours += 12;
            }

            // functions.logger.log("Start hours");
            // functions.logger.log(Shours);

            var EndArrayTemp = endTimeAsString.split(" ");
            var EndArray = EndArrayTemp[0].split(":");

            // get hours and minutes
            var Ehours = parseInt(EndArray[0]);
            var Eminutes = parseInt(EndArray[1]);
            // get am/pm designation
            var designation = EndArrayTemp[1];
            if (Ehours === 12 && designation === "AM") {
                Ehours -= 12;
            }
            if (designation === "PM" && Ehours < 12) {
                Ehours += 12;
            }


            const now = new Date();
            var start = new Date(now.getFullYear(), now.getMonth(), now.getDate(), Shours, Sminutes);
            var end = new Date(now.getFullYear(), now.getMonth(), now.getDate(), Ehours, Eminutes);
            // functions.logger.log("start");
            // functions.logger.log(start);
            // functions.logger.log("end");
            // functions.logger.log(end);
            var Ranges = [];

            var current1 = start;
            var current2 = new Date(current1.getTime() + 25 * 60000); // 25 minutes in milliseconds
            // while (Ranges.length > 0) {
            //     Ranges.pop();
            // } //to remove all the array values in Ranges array
            // functions.logger.log("current1");
            // functions.logger.log(current1);
            while (current1 < end && current2 < end) {
                functions.logger.log("In while");
                ArrayOfAllTheDayRanges.push({ StartOfRange: current1, EndOfRange: current2 });//add the ranges for one day in this function
                current1 = new Date(current2.getTime() + 5 * 60000); // 5 minutes in milliseconds
                current2 = new Date(current1.getTime() + 25 * 60000); // 25 minutes in milliseconds
            }


            functions.logger.log("ArrayOfAllTheDayRanges");
            functions.logger.log(ArrayOfAllTheDayRanges);

        }//for one day

        OneDayGenerating(availablehours[i]['Day'], ArrayOfAllTheDayRanges, startDate.toDate(), endDate.toDate(), uid);

    }//for All days


});

async function OneDayGenerating(day, ArrayOfAllTheDayRanges, startDateT, endDateT, uid) {
    // return 1;
    let startTime = startDateT.getTime();
    let StartDate = new Date(startTime + 3 * 60 * 60 * 1000);// add 3h bcz it on UTC time not saudi time
    let endTime = endDateT.getTime();
    let EndDate = new Date(endTime + 3 * 60 * 60 * 1000);// add 3h bcz it on UTC time not saudi time
    //calculate the diff in days 
    const days = (Sdate, Edate) => {
        let difference = Edate.getTime() - Sdate.getTime();
        let TotalDays = Math.ceil(difference / (1000 * 3600 * 24));
        return TotalDays;
    }

    console.log(StartDate + " day ");
    console.log(EndDate + " day ");

    let diff = days(StartDate, EndDate)
    console.log(diff + " days ");

    var AllActualDatesWithRanges = [];

    for (var i = 0; i < diff; i++) {
        var newDate = new Date(StartDate.getFullYear(), StartDate.getMonth(), StartDate.getDate() + i);
        console.log(newDate + " date ");

        var dayname = newDate.toLocaleString('en-us', { weekday: 'short' });

        if ((dayname == 'Sun' && day == 'Sunday') ||
            (dayname == 'Mon' && day == 'Monday') ||
            (dayname == 'Tue' && day == 'Tuesday') ||
            (dayname == 'Wed' && day == 'Wednesday') ||
            (dayname == 'Thu' && day == 'Thursday')) {
            console.log(dayname + " dayname " + day + "day");
            for (var j = 0; j < ArrayOfAllTheDayRanges.length; j++) {
                console.log("inside for");
                var start = new Date(newDate.getFullYear(), newDate.getMonth(), newDate.getDate(), ArrayOfAllTheDayRanges[j].StartOfRange.getHours(),
                    ArrayOfAllTheDayRanges[j].StartOfRange.getMinutes());
                console.log("Start");
                console.log(start);
                var end = new Date(newDate.getFullYear(), newDate.getMonth(), newDate.getDate(), ArrayOfAllTheDayRanges[j].EndOfRange.getHours(),
                    ArrayOfAllTheDayRanges[j].EndOfRange.getMinutes());
                AllActualDatesWithRanges.push({ StartOfRange: start, EndOfRange: end });
            }// end of for loop of the ArrayOfAllTheDayRanges 
        }
    }// end of loop of all day semester
    const firestore = admin.firestore;

    for (var i = 0; i < AllActualDatesWithRanges.length; i++) {
        // -3hours to be in UTC time bafore adding to database
        let startTime = AllActualDatesWithRanges[i].StartOfRange.getTime();
        let StartDate = new Date(startTime - 3 * 60 * 60 * 1000);// - 3h 
        let endTime = AllActualDatesWithRanges[i].EndOfRange.getTime();
        let EndDate = new Date(endTime - 3 * 60 * 60 * 1000);// - 3h 


        var startTimestamp = firestore.Timestamp.fromDate(StartDate);
        var endTimestamp = firestore.Timestamp.fromDate(EndDate);
        console.log("startTimestamp");
        console.log(startTimestamp);

        console.log("uid");
        console.log(uid);
       await admin.firestore().collection('faculty').doc(uid).collection('appointment').doc().set({
        'starttime': startTimestamp, //Start timestamp
        'endtime': endTimestamp,
        'Booked':
            false, 
       })
    }
}
