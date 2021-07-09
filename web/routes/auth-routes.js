const router = require("express").Router();
const passport = require("passport");
const mysql = require("mysql");
const config = require("../config/dbConfig");
const { user } = require("../config/dbConfig");
const con = mysql.createConnection(config)
//show login page
// router.get("/login", (req, res) => {
//     res.render("Login.ejs", { user: req.user });
// });

//login using Google
router.get("/google", passport.authenticate("google", { scope: ["profile", "email"] }));

//if login success, redirect here
router.get("/google/redirect", passport.authenticate("google"), (req, res) => {
    console.log(req.user.email)
    var sql = ("select * from user where email = ?")
    con.query(sql, [req.user.email], function (err, result) {
        if (err) {
            return done(err)
        }
        else {

            // console.log(result.length)
            if (result.length == 1) {
                if (result[0].role == 3) {
                    res.redirect('/check')
                } else {

                    res.redirect("/mapping");
                }
                // console.log(result)
                console.log(result)

            }
            else {
                res.redirect("/")
            }
        }

    });


});

//log out
router.get("/logout", (req, res) => {
    req.logOut();
    res.redirect("/");
})

module.exports = router;