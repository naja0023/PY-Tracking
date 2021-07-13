const router = require('express').Router();
const path = require("path");
router.get("/", (req, res) => {
    res.render('login') 

})

router.get("/mapping", (req, res) => {
    res.render('index') 

})
router.get("/register", (req, res) => {
    res.render('register') 

})

router.get("/check", (req, res) => {
    res.render('checkpage') 

})

router.get("/admin", (req, res) => {
    res.render('admin') 

})

router.get("/profile", (req, res) => {
    res.render('profile') 

})

router.get("/driver", (req, res) => {
    res.render('driver') 

})

module.exports = router;