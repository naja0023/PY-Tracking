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
const helmet = require('helmet');
const cookieParser = require('cookie-parser');

app.use(bodyParser.urlencoded({ extended: true })); //when you post service
app.use(bodyParser.json());
app.use(passport.initialize());
app.use(compression());
app.use(helmet());      //for header protection
app.use(express.static(path.join(__dirname, 'public')));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use(passport.session());
app.use("/auth", authRoutes);
app.use(pageRoute);
app.use("/profile", profile);
app.set('view engine', 'ejs');

// app.engine('html', require('ejs').renderFile);

app.use("/image", express.static(path.join(__dirname, 'image')));

app.post("/signUp", function (req, res) {
    
    const username = req.body.username;
    const email = req.body.email;
    const tel = req.body.tel;
    const role = req.body.role

    const sql = "INSERT INTO user(name, email, role,tel) VALUES(?,?,?,?)";
    con.query(sql, [username, email,role, tel], function (err, result, fields) {
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
        }
        else {
            res.send("Registered");
        }
    });

});


app.post("/login", function (req, res) {
    const username = req.body.username;
    const password = req.body.password;

    const sql = "SELECT password, role FROM login WHERE username=?";
    con.query(sql, [username], function (err, result, fields) {
        if (err) {
            res.status(500).send("เซิร์ฟเวอร์ไม่ตอบสนอง");
        }
        else {
            const numrows = result.length;
            if (numrows != 1) {

                res.status(401).send("เข้าสู่ระบบไม่สำเร็จ");
            }
            else {
                bcrypt.compare(password, result[0].password, function (err, resp) {
                    if (err) {
                        res.status(503).send("การรับรองเซิร์ฟเวอร์ผิดพลาด");
                    }
                    else if (resp == true) {

                        if (result[0].role == 1) {

                            res.send("/admin");
                        }
                        else if (result[0].role == 2) {

                            res.send("/");
                        } else {
                            res.send("/Loginforhospital");
                        }
                    }
                    else {
                        //wrong password
                        res.status(403).send("รหัสไม่ถูกต้อง");
                    }
                });
            }
        }
    });
});

app.post("/getuser", function (req, res) {

    const sql = "SELECT * FROM user";
    con.query(sql,  function (err, result, fields) {
        if (err) {
            console.error(err.message);
            res.status(503).send("Database error");
            return;
        }else{
            res.json(result)
        }

    });

});

app.put("/updateuser", (req, res) => {
    const { name, tel,email, id,role } = req.body;
    console.log(req.body)
    const sql = "UPDATE user SET name = ?, email = ?,tel =?,role =? WHERE Id = ?"
    con.query(sql, [name, email, tel,role, id], (err, result) => {
        if (err) {
            console.log(err);
            res.status(503).send("Server error");
        } else {
            res.status(200).send("Update successed");
        }
    });
});

app.delete("/deleteuser", (req, res) => {
    const { id } = req.body;
    console.log(req.body)
    const sql = "DELETE FROM user WHERE Id =?"
    con.query(sql, [ id], (err, result) => {
        if (err) {
            console.log(err);
            res.status(503).send("Server error");
        } else {
            res.status(200).send("Delete successed");
        }
    });
});



const PORT = 35000
app.listen(PORT, function () {
    console.log("Server is running at " + PORT);

});