const express = require("express");

const path = require("path");
const bcrypt = require("bcryptjs");
const mysql = require("mysql");
const config = require("./config/dbConfig.js");
const multer = require("multer");
const bodyParser = require("body-parser");
const app = express();
const con = mysql.createConnection(config);
const passportSetup = require("./config/passport-setup");
const passport = require("passport");
const authRoutes = require("./routes/auth-routes");
const profile = require("./routes/profile-routes")
const pageRoute = require('./routes/pagerout');
const compression = require('compression');
const blogRoute = require('./routes/manageuserroute');
// const helmet = require('helmet');
const cookieParser = require('cookie-parser');

app.use(bodyParser.urlencoded({ extended: true })); //when you post service
app.use(bodyParser.json());
app.use(passport.initialize());
app.use(compression());

// app.use(helmet());      //for header protection
app.use(express.static(path.join(__dirname, 'public')));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use("/style", express.static(path.join(__dirname, '/public/styles')));
app.use(passport.session());
app.use("/auth", authRoutes);
app.use(pageRoute);
app.use(blogRoute);
app.use("/profile", profile);
app.set('view engine', 'ejs');

// app.engine('html', require('ejs').renderFile);

app.use("/image", express.static(path.join(__dirname, 'image')));

app.post("/signUp", function(req, res) {

    const username = req.body.username;
    const email = req.body.email;
    const tel = req.body.tel;
    const role = req.body.role

    const sql = "INSERT INTO user(name, email, role,tel) VALUES(?,?,?,?)";
    con.query(sql, [username, email, role, tel], function(err, result, fields) {
        if (err) {
            console.error(err.message);
            res.status(503).send("Database error");
            return;
        }

        // get inserted rows
        const numrows = result.affectedRows;
        if (numrows != 1) {
            console.error("can not insert data");
            res.status(503).send("Database error");
        } else {
            res.send("Registered");
        }
    });

});

//-------------------------- Register ------------------------
app.post("/register", function(req, res) {
    const username = req.body.username;
    const name = req.body.name;
    const lastname = req.body.lastname;
    const password = req.body.password;
    const role = req.body.role;
    const id_card = req.body.id_card;
    const email = req.body.email;
    const tell = req.body.tell;

    //checked existing username
    let sql = "SELECT driver_id FROM driver WHERE username=?";
    con.query(sql, [username], function(err, result, fields) {
        if (err) {
            console.error(err.message);
            res.status(500).send("Database server error");
            return;
        }

        const numrows = result.length;
        //if repeated username
        if (numrows > 0) {
            res.status(400).send("Sorry, this username exists");
        } else {
            bcrypt.hash(password, 10, function(err, hash) {
                //return hashed password, 60 characters
                sql = "INSERT INTO driver(username,name,lastname,password,role,id_card,email,tell) VALUES (?,?,?,?,?,?,?,?)";
                con.query(sql, [username, name, lastname, hash, role, id_card, email, tell], function(err, result, fields) {
                    if (err) {
                        console.error(err.message);
                        res.status(500).send("Database server error");
                        return;
                    }

                    const numrows = result.affectedRows;
                    if (numrows != 1) {
                        res.status(500).send("Insert failed");
                    } else {
                        res.send("Register done");
                    }
                });
            });
        }
    });
});

app.post("/loginmoblie", function(req, res) {
    const username = req.body.username;
    const password = req.body.password;

    const sql = "SELECT * FROM driver LEFT JOIN car_match on driver.driver_id = car_match.driver_id WHERE driver.username = ? AND DATE(car_match.date) = CURDATE()";
    con.query(sql, [username], function(err, result, fields) {
        if (err) {
            res.status(500).send("เซิร์ฟเวอร์ไม่ตอบสนอง");
        } else {
            const numrows = result.length;
            if (numrows != 1) {

                res.status(401).send("เข้าสู่ระบบไม่สำเร็จ");
            } else {
                bcrypt.compare(password, result[0].password, function(err, resp) {
                    if (err) {
                        res.status(503).send("การรับรองเซิร์ฟเวอร์ผิดพลาด");
                    } else if (resp == true) {
                        res.send(result)
                    } else {
                        //wrong password
                        res.status(403).send("รหัสไม่ถูกต้อง");
                    }
                });
            }
        }
    });
});



app.delete("/deleteuser", (req, res) => {
    const { id } = req.body;
    console.log(req.body)
    const sql = "DELETE FROM user WHERE Id =?"
    con.query(sql, [id], (err, result) => {
        if (err) {
            console.log(err);
            res.status(503).send("Server error");
        } else {
            res.status(200).send("Delete successed");
        }
    });
});



app.post("/addcar", (req, res) => {
    const { License_plate, seat } = req.body;
    const sql = "INSERT INTO `car`(`License_plate`, `seat`) VALUES (?,?)"
    con.query(sql, [License_plate, seat], (err, result) => {
        if (err) {
            console.log(err);
            res.status(503).send("Server error");
        } else {
            res.status(200).send("addsuccessed");
        }
    });
});

app.post("/addcarmatch", (req, res) => {
    const { driver_id, car_id, date } = req.body;
    const sql = "INSERT INTO `car_match`(`driver_id`, `car_id`, `date`) VALUES (?,?,?)"
    con.query(sql, [driver_id, car_id, date], (err, result) => {
        if (err) {
            console.log(err);
            res.status(503).send("Server error");
        } else {
            res.status(200).send("addsuccessed");
        }
    });
});

app.post("/updatecar", (req, res) => {
    const { License_plate, seat, car_id } = req.body;
    const sql = "UPDATE car SET License_plate=?,seat=? WHERE car_id = ?"
    con.query(sql, [License_plate, seat, car_id], (err, result) => {
        if (err) {
            console.log(err);
            res.status(503).send("Server error");
        } else {
            res.status(200).send("updatecarsuccessed");
        }
    });
});


app.post("/updatecarmatch", (req, res) => {
    const { driver_id, car_id, date, carmatch } = req.body;
    const sql = "UPDATE car_match SET driver_id=?,car_id=?,date=? WHERE carmatch=?"
    con.query(sql, [driver_id, car_id, date, carmatch], (err, result) => {
        if (err) {
            console.log(err);
            res.status(503).send("Server error");
        } else {
            res.status(200).send("updatesuccessed");
        }
    });
});


app.delete("/deletecar", (req, res) => {
    const { car_id } = req.body;
    const sql = "DELETE FROM car WHERE car_id = ?"
    con.query(sql, [car_id], (err, result) => {
        if (err) {
            console.log(err);
            res.status(503).send("Server error");
        } else {
            res.status(200).send("Deletesuccessed");
        }
    });
});

app.delete("/deletecarmatch", (req, res) => {
    const { carmatch } = req.body;
    const sql = "DELETE FROM car_match WHERE carmatch = ?"
    con.query(sql, [carmatch], (err, result) => {
        if (err) {
            console.log(err);
            res.status(503).send("Server error");
        } else {
            res.status(200).send("Deletecarmatchsuccessed");
        }
    });
});

app.post("/addlocation", (req, res) => {
    const { carmatch, lat, lng } = req.body;
    console.log(req.body)
    const sql = "INSERT INTO location(carmatch, lat, lng) VALUES (?,?,?)"
    con.query(sql, [carmatch, lat, lng], (err, result) => {
        if (err) {
            console.log(err);
            res.status(503).send("Server error");
        } else {
            res.status(200).send("addlocationsuccessed");
        }
    });
});


app.post("/selectcarmatch", (req, res) => {
    const { driver_id, date } = req.body;
    const sql = "SELECT * FROM car_match WHERE driver_id=?  AND date = ?"
    con.query(sql, [driver_id, date], (err, result) => {
        if (err) {
            console.log(err);
            res.status(503).send("Server error");
        } else {
            res.json(result);
        }
    });
});

const PORT = 35000
app.listen(PORT, function() {
    console.log("Server is running at " + PORT);

});