const schedule = require('node-schedule');

module.exports = function(app, con, transporter) {

  // Change this when the server goes live. *****************
  var serverAddress = 'http://localhost:3000';

  // Default email to send verification requests.
  const serverEmail = 'sns424PG28@gmail.com';

  var module = {};
  // $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

  // This is assuming the publisher creates new categories

  // Takes id and a map of cid -> [sid ...]
  // Associates either a reader/message with those categories.
  module.associateCategory = function(id, categories, query, isMessage) {
    var lst = [];
    for (var cid in categories) {
      subcategories = categories[cid];

      var x = [];
      if (subcategories.length == 0) {
        lst.push([id, parseInt(cid), -1]);
      } else {
        subcategories.forEach((sid) => {
          lst.push([id, parseInt(cid), parseInt(sid)]);
        });
      }
    }

    if (isMessage) {
      lst.forEach((val) => {
        val.push(0);
      });
    }
    con.query(query, [lst], (err) => {
      if (err) console.log(err);
    });
  }

  // Takes a list of new categories and creates them.
  module.createCategory = function(newCategory) {
    // var lst = [];
    // newCategories.forEach((c) => {
    //   lst.push([c]);
    // });
    var val = { name: newCategory };
    const query = 'INSERT INTO CATEGORY SET ?';
    con.query(query, val, (err, res) => {
      if (err) console.log(err);
    });
  }

  // Takes a mapping of cid -> [new subcategories ...].
  // Associates the new subcategories with the current categories.
  module.createSubcategory = function(cid, newSub) {
    // var lst = [];
    // for (var cid in newSubs) {
    //   newSubs[cid].forEach((s) => {
    //     lst.push([parseInt(cid), s]);
    //   });
    // }

    var val = { cid: cid, name: newSub };

    const query = 'INSERT INTO SUBCATEGORY SET ?';
    con.query(query, val, (err) => {
      if (err) console.log(err);
    });
  }

  // Deletes all subscriptions associated with a reader with id rid.
  module.removeSubscriptions = function(rid) {
    const query = 'DELETE FROM SUBSCRIPTION WHERE rid=' + rid;
    con.query(query, (err) => {
      if (err) console.log(err);
    });
  }

  // Finds all the messages a reader can get ignoring location.
  module.sharesCategories = function(rid, callback) {
    const query = 'SELECT s.rid, s.cid, s.sid AS r_sid, m.sid AS m_sid, m.mid FROM SUBSCRIPTION s, MESSAGE_CATEGORY m \
                  WHERE s.rid=' + rid + ' \
                  AND s.cid=m.cid \
                  AND m.timed_out=0';
    con.query(query, (err1, rows) => {
      if (err1) console.log(err1);
      var mesLst = [];

      rows.forEach((row) => {
        // If reader is subscribe to whole category OR
        // message is associated with whole category OR
        // reader is subscribed to the same subcategory message is.
        if (row.r_sid == -1 || row.m_sid == -1 || row.r_sid == row.m_sid) {
          mesLst.push(row.mid);
        }
      });

      var uniqueMes = [...new Set(mesLst)];
      const getMessages = 'SELECT * FROM MESSAGES \
                            WHERE mid IN (?)';
      if (uniqueMes.length != 0) {
        con.query(getMessages, [uniqueMes], (err2, messages) => {
          if (err2) console.log(err2);
          callback(messages);
        });
      } else {
        callback([]);
      }
    });
  }

  // Finds all categories associated with a mapping of cid -> [sid ...].
  module.findMessagesWithCategories = function(categories, callback) {
    var catLst = [];
    var cats = convertToInt(categories);
    for (var k in categories) {
      catLst.push(k);
    }

    console.log(catLst)

    const query = 'SELECT * FROM MESSAGE_CATEGORY WHERE cid IN (?)';

    con.query(query, [catLst], (err, rows) => {
      if (err) console.log(err);
      var mesLst = [];

      console.log(rows);

      rows.forEach((m) => {
        if (cats[m.cid] == -1 || m.sid == -1 || cats[m.cid.toString()].includes(m.sid) || cats[m.cid.toString()].length == 0) {
          mesLst.push(m.mid);
        }
      });
      var uniqueMes = [...new Set(mesLst)]
      callback(uniqueMes);
    });
  }

  module.findMessagesWithTime = function(midLst, startDate, endDate, query, callback) {
    // var query = 'SELECT * FROM MESSAGES \
    //             WHERE mid IN (?)';
    // if (type === 'archived') {
    //   query = 'SELECT * FROM (SELECT * FROM TIMED_OUT_MESSAGES \
    //                           UNION \
    //                           SELECT * FROM ARCHIVED_MESSAGES) x \
    //                           WHERE x.mid IN (?)';
    // }
    console.log(query);
    console.log(midLst);
    if (midLst.length != 0) {
      con.query(query, [midLst], (err, rows) => {

        console.log(rows);
        if (err) console.log(err);
        mesLst = [];

        rows.forEach((m) => {
          if ((startDate <= m.end_time && endDate >= m.start_time) ||
              (m.start_time <= endDate && startDate <= m.endTime)) {
            mesLst.push(m);
          }
        });

        callback(mesLst);
      });
    } else {
      callback([])
    }
  }

  module.sendEntireInbox = function(rid, response) {
    const query = 'SELECT * FROM INBOX i, MESSAGES m , SUBSCRIPTION s \
                  WHERE i.mid=m.mid \
                  AND s.rid=i.rid \
                  AND i.rid=' + rid;

    con.query(query, (err, rows) => {
      if (err) console.log(err);

      response.send(rows);
    });

  }

  module.isNameTaken = function(name, callback) {
    const query = 'SELECT * FROM (SELECT name FROM READERS \
                    UNION SELECT name FROM PUBLISHERS \
                    UNION SELECT name FROM VERIFICATION) x \
                    WHERE x.name=' + '"' + name + '"';
    con.query(query, (err, rows) => {
      if (err) console.log(err);

      // name is not taken.
      if (rows[0] == undefined) {
        callback(false);
      } else {
        callback(true);
      }
    });
  }

  // Takes a map of strings and converts all their values to integers.
  function convertToInt(map) {
    var newMap = {};
    for (var k in map) {
      var newKey = parseInt(k);
      newMap[newKey] = [];

      map[k].forEach((v) => {
        newMap[newKey].push(parseInt(v));
      });
    }

    return newMap;
  }
  // $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

  // Converts the given date to utc. DO NOT INPUT A UTC DATE!
  module.convertToUtc = function(date) {
    date.setHours(date.getHours() + 5);
    return date;
  }

  // Changes the server address.
  // ** USE CAREFULLY -- CAN BREAK SERVER **
  module.changeServerAddress = function(addr) {
    if (addr != '') {
      serverAddress = addr;
      console.log('-----------------------------------------------------------');
      console.log('New server address: ' + serverAddress);
    }
  }

  // converts the date to a datetime.
  module.getDateTime = function(date) {

    var hour = date.getHours();
    hour = (hour < 10 ? "0" : "") + hour;

    var min  = date.getMinutes();
    min = (min < 10 ? "0" : "") + min;

    var sec  = date.getSeconds();
    sec = (sec < 10 ? "0" : "") + sec;

    var year = date.getFullYear();

    var month = date.getMonth() + 1;
    month = (month < 10 ? "0" : "") + month;

    var day  = date.getDate();
    day = (day < 10 ? "0" : "") + day;

    return year + "-" + month + "-" + day + " " + hour + ":" + min + ":" + sec;
  }

  // Given two coordinates passed in as associative arrays, will decide if they
  // are within the range (measured in kms).

  // Credit :
  // https://gist.github.com/moshmage/2ae02baa14d10bd6092424dcef5a1186#file-withinradius-js
  module.withinRange = function(coords1, coords2, range) {
    'use strict';

    let R = 6371;
    let deg2rad = (n) => { return Math.tan(n * (Math.PI/180)) };

    let dLat = deg2rad(coords2.lat - coords1.lat);
    let dLon = deg2rad(coords2.lon - coords1.lon);

    let a = Math.sin(dLat/2) * Math.sin(dLat/2) + Math.cos(deg2rad(coords1.lat)) *
    Math.cos(deg2rad(coords2.lat)) * Math.sin(dLon/2) * Math.sin(dLon/2);

    let c = 2 * Math.asin(Math.sqrt(a));
    let d = R * c;

    return (d <= range);
  }

  // Will take a readers id, and add all messages to his inbox that currenetly
  // aren't there and need to be.
  module.addToInbox = function(rid, mid) {

    const entry = { rid: rid, mid: mid };

    const query = 'INSERT IGNORE INTO INBOX SET ?';

    con.query(query, entry, (err ,res) => {
      if (err) console.log(err);
    });
    console.log('Reader: ' + rid + ' recieved message: ' + mid);
  }

  // Sends a verification email to the user.
  module.sendMail = function(sendTo, id, date) {

    const responseLink = '"' + serverAddress + '/verify?id=' + id + '"';

    const emailBody = '<p>You are being sent this email to verify your \
                        account. You have 30 minutes from the sent time of \
                        this email to verify. Click the link to verify \
                        your account!   \
                        <a href = ' + responseLink + '>Click Here!</a></p>'

    const mailOptions = {
      from: serverEmail,
      to: sendTo,
      subject: 'SNS Account Verification',
      html: emailBody
    };

    transporter.sendMail(mailOptions, (err, info) => {
      if (err) console.log(err);
      else console.log('Email sent: ' + info.response);
    });

    scheduleVerificationRemoval(date, id);
  }

  // Determines if the verification was made within the required 30 minutes.
  // Will verify the user if it was valid and return true. Otherwise
  // it will return false.
  // Takes response to notify user of results.
  module.verifyUser = function(id, timeNow, response) {
    const query = 'SELECT * FROM VERIFICATION WHERE vid=' + id;

    con.query(query, (err, rows) => {
      if (err) console.log(err);

      res = rows[0];
      if (res != undefined) {
        const verificationTime = new Date(res.verification_time);

        if (withinTime(timeNow, verificationTime)) {

          const newUser = { name: res.name, address: res.address,
                            email: res.email, password: res.password };

          var type = '';

          // They are a reader.
          if (res.role == 0) type = 'READERS';
          else type = 'PUBLISHERS';

          const delete_query = 'DELETE FROM VERIFICATION WHERE vid=' + id;
          const insert_query = 'INSERT INTO ' + type + ' SET ?';

          // Delete the user from the verification table.
          con.query(delete_query, (err, res) => {
            if (err) console.log(err);
          });

          // Insert new user into the correct table.
          con.query(insert_query, newUser, (err, res) => {
            if (err) console.log(err);
          });

          console.log('User with ID ' + id + ' has been entered into ' + type);

          response.send("Thanks! You are now verified.")
        } else {
          response.send("Sorry, you took more than 30 minutes to verify. \
                          Please try again.");
        }
      } else {
        response.send("Sorry, we could not find that user!");
      }
    });

  }

  // Removes a reader their inbox entries and archives them.
  module.archiveReader = function(reader, inbox) {

    var rid = reader.rid;

    const readerQuery = 'DELETE FROM READERS WHERE rid=' + rid;
    const inboxQuery = 'DELETE FROM INBOX WHERE rid=' + rid;

    // Delete from READERS.
    con.query(readerQuery, (err, res) => {
      if (err) console.log(err);
    });
    // Remove all entries from INBOX.
    con.query(inboxQuery, (err, res) => {
      if (err) console.log(err);
    });

    const archiveReaderQuery = 'INSERT INTO ARCHIVED_READERS SET ?';
    const archiveInboxQuery = 'INSERT INTO ARCHIVED_INBOX SET ?';

    // Insert into ARCHIVED_READERS.
    con.query(archiveReaderQuery, reader, (err, res) => {
      if (err) console.log(err);
    });

    // Insert all rows into ARCHIVED_INBOX.
    inbox.forEach((row) => {
      con.query(archiveInboxQuery, row, (err, res) => {
        if (err) console.log(err);
      });
    });
  }

  module.archivePublisher = function(pid) {
    const getPublisher = 'SELECT * FROM PUBLISHERS WHERE pid=' + pid;
    const getMessages = 'SELECT * FROM MESSAGES WHERE pid=' + pid + ' \
                         UNION \
                         SELECT * FROM TIMED_OUT_MESSAGES WHERE pid=' + pid;

    con.query(getPublisher, (err1, rows1) => {
      if (err1) console.log(err1);

      var p = rows1[0];
      if (p != undefined) {
        con.query(getMessages, (err2, rows2) => {
          if (err2) console.log(err2);

          var publisher = { pid: p.pid, name: p.name, address: p.address,
                            email: p.email, password: p.password };
          var mesLst = [];
          rows2.forEach((m) => {
            var mes = [ m.mid, m.content, m.pid, m.lat, m.lon,  m.mes_range,
                        m.start_time, m.end_time, m.title ];
            mesLst.push(mes);
          });

          const deletePublisher = 'DELETE FROM PUBLISHERS WHERE pid=' + pid;
          const deleteMessages = 'DELETE FROM MESSAGES WHERE pid=' + pid;
          const deleteTimedOutMessages = 'DELETE FROM TIMED_OUT_MESSAGES \
                                          WHERE pid=' + pid;
          // Execute all the queries.
          con.query(deletePublisher, (err) => {
            if (err) console.log(err);
            console.log('Publisher ' + pid + ' has been archived.');
          });
          con.query(deleteMessages, (err) => {
            if (err) console.log(err);
          });
          con.query(deleteTimedOutMessages, (err) => {
            if (err) console.log(err);
          });

          const archivePublisher = 'INSERT INTO ARCHIVED_PUBLISHERS SET ?';
          const archiveMessages = 'INSERT INTO ARCHIVED_MESSAGES \
                                  (mid, content, pid, lat, lon, mes_range, \
                                  start_time, end_time, title) VALUES ?';


          // Update all the messages status in MESSAGE_CATEGORY.
          mesLst.forEach((m) => {
            const update_categories = 'UPDATE MESSAGE_CATEGORY \
                                        SET timed_out=1 \
                                        WHERE mid=' + m[0];
            con.query(update_categories, (err) => {
              if (err) console.log(err);
            });
          });


          con.query(archivePublisher, publisher, (err) => {
            if (err) console.log(err);
          });
          con.query(archiveMessages, [mesLst], (err) => {
            if (err) console.log(err);
          });
        });
      }
    });
  }

  // Removed a message at a given time.
  module.scheduleMessageRemoval = function(endDate, id) {

    schedule.scheduleJob(endDate, function() {
      const query1 = 'SELECT * FROM MESSAGES WHERE mid=' + id;
      const query2 = 'DELETE FROM MESSAGES WHERE mid=' + id;

      con.query(query1, (err, rows) => {
        if (err) console.log(err);

        r = rows[0];
        if (r != undefined) {
          const newMessage = { mid: id, content: r.content, pid: r.pid,
                              lat: r.lat, lon: r.lon, mes_range: r.mes_range,
                              start_time: r.start_time, end_time: r.end_time,
                              title: r.title };
          const insert_query = 'INSERT INTO TIMED_OUT_MESSAGES SET ?';

          // Insert into timed out messages table.
          con.query(insert_query, newMessage, (err, res) => {
            if (err) console.log(err);
          });

          // Delete from messages table.
          con.query(query2, (err, res) => {
            if (err) console.log(err);
          });

          const update_categories = 'UPDATE MESSAGE_CATEGORY \
                                      SET timed_out=1 \
                                      WHERE mid=' + id;
          con.query(update_categories, (err) => {
            if (err) console.log(err);
          });

          console.log('Message: ' + id + ' has timed out.');
        }

      });
    });
  }

  // Images get type 0, audio files get type 1.
  module.insertMultimedia = function(mid, imageLst) {
    newLst = [];
    imageLst.forEach((m) => {
      newLst.push([mid, m, 0]);
    });

    // audioLst.forEach((a) => {
    //   newLst.push([mid, a, 1]);
    // });

    const q = 'INSERT INTO MESSAGE_MULTIMEDIA (mid, media, type) VALUES ?';
    newLst.forEach((r) => {
      con.query(q, [[r]], (err, rows) => {
        if (err) console.log(err);
      });
    });
    //
    // const query = 'INSERT INTO MESSAGE_MULTIMEDIA (mid, media, type) VALUES ?';
    // con.query(query, [newLst], (err, rows) => {
    //   if (err) console.log(err);
    //
    //   console.log('Multimedia added for message ' + mid);
    // });
  }

  // Removes a verification request from the verification table after
  // a certain amount of time (30 minutes).
  function scheduleVerificationRemoval(date, id) {
    const timeoutLength = 30;

    date.setMinutes(date.getMinutes() + timeoutLength);

    schedule.scheduleJob(date, function() {
      const query = 'DELETE FROM VERIFICATION WHERE vid=' + id;

      con.query(query, (err, res) => {
        if (err) console.log(err);
        else console.log('Removed inactive verification: ' + id);
      });
    });

  }

  // Returns false if the difference in time is greater than .5 hours (30 min).
  function withinTime(now, then) {
    var timeDif = Math.abs(now.getTime() - then.getTime()) / (1000 * 3600);

    return !(timeDif > 0.5);
  }

  return module;
};
