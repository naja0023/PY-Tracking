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

module.exports = router;